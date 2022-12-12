import 'package:flutter/material.dart';
import 'package:overvoice_project/controller/popup_controller.dart';
import 'package:overvoice_project/controller/recordButton_controller.dart';
import 'package:overvoice_project/controller/recordButton_controller_duo.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/constant_value.dart';

class Record extends StatefulWidget {
  Map<String, dynamic> detailList;
  String character;
  String docID;
  String characterimgURL;

  Record(this.detailList, this.character, this.characterimgURL, this.docID,
      {super.key});

  static int converIndex = 0;

  @override
  State<Record> createState() =>
      _RecordState(detailList, character, characterimgURL, docID);
}

class _RecordState extends State<Record> {
  Map<String, dynamic> detailList;
  String character;
  String characterimgURL;
  String docID;

  _RecordState(
    this.detailList,
    this.character,
    this.characterimgURL,
    this.docID,
  );

  late List conversationList = detailList["conversation"].split(",");
  bool isPlaying = false;
  bool checkButton =
      false; // for check status of button (ว่าปุ่มนี้กำลังกดอยู่หรือไม่ กันกดปุ่มทับกัน)
  List currentConverDuration = []; // list of conversation duration
  int timeTotal = 0;
  int checkTime = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  AudioPlayer audioPlayerAssist = AudioPlayer();
  AudioPlayer audioPlayerBGM = AudioPlayer();
  ConstantValue constantValue = ConstantValue();
  PopupControl popupControl = PopupControl();

  PlayerState playerState = PlayerState.stopped;
  bool isStarted = false;

  late String currentText = conversationList[0];
  late List displayConversationText = [];

  @override
  void initState() {
    super.initState();

    // Listen to states: playing, paused, stopped
    audioPlayerAssist.onPlayerStateChanged.listen((PlayerState s) {
      //print('Current player state: $s');
      if (!mounted) return;
      setState(() => playerState = s);
    });

    // Listen to audio duration
    audioPlayerAssist.onDurationChanged.listen((Duration d) {
      //print('Max duration: $d');
      if (!mounted) return;
      setState(() => duration = d);
    });

    // Listen to audio position
    audioPlayerAssist.onPositionChanged.listen((Duration p) {
      if (!mounted) return;
      setState(() => position = p);
      if (p.inSeconds >= this.timeTotal) {
        pause();
        audioPlayerAssist.seek(Duration(
            seconds:
                timeTotal - int.parse(this.currentConverDuration[checkTime])));
        audioPlayerBGM.seek(Duration(
            seconds:
                timeTotal - int.parse(this.currentConverDuration[checkTime])));
      }
    });

    // Listen to audio when it completed
    audioPlayerAssist.onPlayerComplete.listen((event) {
      isPlaying = false;
      if (!mounted) return;
      setState(() {
        position = duration;
      });
    });
  }

  @override
  void dispose() {
    Record.converIndex = 0;
    audioPlayerAssist.dispose();
    audioPlayerBGM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          detailList["name"],
          style: GoogleFonts.prompt(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF7200),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
          onPressed: () {
            popupControl.popCancelRecord(context);
          },
        ),
        actions: [
          Semantics(
            label: "ขั้นตอนการพากย์",
            child: IconButton(
              icon: const Icon(
                Icons.help_outline_rounded,
              ),
              onPressed: () {
                popupControl.howToDubDialog(context);
              },
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(
            top: constantValue.getScreenHeight(context) / 30,
            left: 20,
            right: 20),
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFFF7200),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 52,
              backgroundColor: Colors.white,
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(characterimgURL),
                ),
              ),
            ),
            SizedBox(
              height: constantValue.getScreenHeight(context) / 80,
            ),
            Text(
              character,
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(
              height: constantValue.getScreenHeight(context) / 40,
            ),
            Stack(
              children: <Widget>[
                Container(
                  height:
                      constantValue.getScreenHeight(context) / 2.1, // กรอบบท
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      top: constantValue.getScreenHeight(context) / 44.5,
                      left: 26,
                      right: 26),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "บทที่ต้องทำการพากย์",
                          style: GoogleFonts.prompt(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constantValue.getScreenHeight(context) / 49,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: constantValue.getScreenHeight(context) / 15,
                    left: constantValue.getScreenWidth(context) / 43,
                    height: constantValue.getScreenHeight(context) / 2.52,
                    width: constantValue.getScreenWidth(context) / 1.17, // บท
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFFFD4B2),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: displayConversation(detailList),
                      //ConversationController(conversationList),
                    ))
              ],
            ),
            SizedBox(
              height: constantValue.getScreenHeight(context) / 30,
            ),
            // record button all-function here

            checkAudioType(),

            SizedBox(
              height: constantValue.getScreenHeight(context) / 50,
            ),
            SizedBox(
              width: constantValue.getScreenWidth(context) / 1.4,
              height: constantValue.getScreenHeight(context) / 20,
              child: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Color(0xFFFF9900),
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.prompt(
                        fontSize: 19, fontWeight: FontWeight.w600)),
                onPressed: () async {
                  // condition for check button (ถ้าปุ่มถูกกดอยู่จะ return)
                  if (checkButton == true) {
                    return;
                  }
                  if (isPlaying == false) {
                    play();
                  } else {
                    isPlaying = false;
                    pause();
                  }
                },
                child: const Text('ตัวอย่างการพากย์'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // play & resume audio
  Future play() async {
    audioPlayerAssist.resume();
    audioPlayerBGM.resume();
  }

  // pause audio
  Future pause() async {
    await audioPlayerAssist.pause();
    await audioPlayerBGM.pause();
    isPlaying = false;
  }

  Widget checkAudioType() {
    if (detailList["voiceoverAmount"] == "1") {
      return RecordButton(conversationList, docID, (a) => {setup(a)},
          (status) => {checkStatus(status)},
          converIndexSetter: _converIndexSetter);
    } else {
      return RecordButtonDuo(conversationList, docID, character,
          (a) => {setup(a)}, (status) => {checkStatus(status)},
          converIndexSetter: _converIndexSetter);
    }
  }

  // use for check status of button
  Future checkStatus(bool status) async {
    if (status == true) {
      checkButton = true;
    } else {
      print("Status is checked");
      await audioPlayerAssist.seek(Duration(seconds: timeTotal));
      await audioPlayerBGM.seek(Duration(seconds: timeTotal));

      position = Duration(seconds: timeTotal);

      //condition for avoid out of bound case

      if (checkTime < this.currentConverDuration.length - 1) {
        checkTime++;
      }

      if (checkTime < this.currentConverDuration.length) {
        timeTotal += int.parse(this.currentConverDuration[checkTime]);
        print(
            "checktime: ${this.checkTime}, timetotal: ${this.timeTotal}, timelength: ${this.currentConverDuration.length}, position: ${this.position}");
      }

      checkButton = false;
    }
  }

  // set up audio before user start
  Future setup(List times) async {
    this.currentConverDuration = times;

    if (timeTotal == 0) {
      timeTotal = int.parse(this.currentConverDuration[0]);

      final storageRef = await FirebaseStorage.instance.ref();
      String urlAssist =
          await getAudioURL(storageRef, detailList["assistanceVoiceName"]);
      String urlBGM = await getAudioURL(storageRef, detailList["bgmName"]);

      await audioPlayerAssist.setSourceUrl(urlAssist);
      await audioPlayerBGM.setSourceUrl(urlBGM);
      print("Everything Set!");
    }
  }

  // get url of audio by name of it
  getAudioURL(final storageRef, String audioName) async {
    final soundRef = await storageRef.child(audioName);
    final metaData = await soundRef.getDownloadURL();
    String url = metaData.toString();
    log('data: ${metaData.toString()}');
    return url;
  }

  // use for generate display conversation
  Widget displayConversation(Map<String, dynamic> detailList) {
    if (isStarted == false) {
      int i;
      String fullConversation = "";
      // replace a duration text for more information
      for (i = 0; i < conversationList.length; i++) {
        final conversationWithDetail;
        if (detailList["voiceoverAmount"] == "1") {
          conversationWithDetail =
              conversationList[i].replaceAllMapped(RegExp(r'\((.*?)\)'), (m) {
            return '(มีเวลาพากย์ ${m[1]} วินาที)';
          });
        } else {
          conversationWithDetail =
              conversationList[i].replaceAllMapped(RegExp(r'\((.*?)\:'), (m) {
            return '(มีเวลาพากย์ ${m[1]} วินาที:';
          });
        }
        displayConversationText.add(conversationWithDetail);
        fullConversation +=
            "ประโยคที่ ${i + 1} " + conversationWithDetail + "\n\n";
      }
      currentText = fullConversation;
    }
    // return a conversation text
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => ListTile(
              title: Text(
                currentText,
                style: GoogleFonts.prompt(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ));
  }

  // use for change conversation text
  void _converIndexSetter(int converIndex) {
    isStarted = true;
    currentText = displayConversationText[converIndex];
    setState(() {});
  }
}
