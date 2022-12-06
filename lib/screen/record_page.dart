import 'package:flutter/material.dart';
import 'package:overvoice_project/controller/recordButton_controller.dart';
import 'package:overvoice_project/controller/recordButton_controller_duo.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';

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

  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState playerState = PlayerState.stopped;
  bool isStarted = false;

  late String currentText = conversationList[0];

  @override
  void initState() {
    super.initState();

    // Listen to states: playing, paused, stopped
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      //print('Current player state: $s');
      if (!mounted) return;
      setState(() => playerState = s);
    });

    // Listen to audio duration
    audioPlayer.onDurationChanged.listen((Duration d) {
      //print('Max duration: $d');
      if (!mounted) return;
      setState(() => duration = d);
    });

    // Listen to audio position
    audioPlayer.onPositionChanged.listen((Duration p) {
      if (!mounted) return;
      setState(() => position = p);
      if (p.inSeconds >= this.timeTotal) {
        pause();
        audioPlayer.seek(Duration(
            seconds:
                timeTotal - int.parse(this.currentConverDuration[checkTime])));
      }
    });

    audioPlayer.onPlayerComplete.listen((event) {
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
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          detailList["name"],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF7200),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: screenHeight / 30, left: 20, right: 20),
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFFF7200),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: screenWidth / 7.3,
              backgroundColor: Colors.white,
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: screenWidth / 7.9,
                  backgroundImage: NetworkImage(characterimgURL),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 80,
            ),
            Text(
              character,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(
              height: screenHeight / 40,
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: screenHeight / 2.1, // กรอบบท
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      top: screenHeight / 44.5, left: 26, right: 26),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "บทที่ต้องทำการพากย์",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 49,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: screenHeight / 15,
                    left: screenWidth / 43,
                    height: screenHeight / 2.52,
                    width: screenWidth / 1.17, // บท
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFFFD4B2),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: displayConversation(),
                      //ConversationController(conversationList),
                    ))
              ],
            ),
            SizedBox(
              height: screenHeight / 30,
            ),
            // record button all-function here

            detailList["voiceoverAmount"] == 1
                ? RecordButtonDuo(conversationList, docID, character,
                    converIndexSetter: _converIndexSetter)
                : RecordButton(conversationList, docID, (a) => {setup(a)},
                    (status) => {checkStatus(status)},
                    converIndexSetter: _converIndexSetter),

            SizedBox(
              height: screenHeight / 50,
            ),
            SizedBox(
              width: screenWidth / 1.4,
              height: screenHeight / 20,
              child: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Color(0xFFFB8C00),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                onPressed: () async {
                  // condition for check button (ถ้าปุ่มถูกกดอยู่จะ return)
                  if (checkButton == true) {
                    return;
                  }
                  if (isPlaying == false) {
                    // -------------------- Old setup song --------------------
                    // final storageRef = await FirebaseStorage.instance.ref();
                    // final time = await RecordButton.TimeCountDown.instance();
                    // final soundRefA = await storageRef
                    //     .child(listenList.audioFileName!); // <-- your file name
                    // final soundRefBGM = await storageRef
                    //     .child("helloworld2.aac"); // <-- your file name
                    // final metaDataA = await soundRefA.getDownloadURL();
                    // final metaDataBGM = await soundRefBGM.getDownloadURL();
                    // String urlBGM =
                    //     "https://firebasestorage.googleapis.com/v0/b/overvoice.appspot.com/o/2022-11-2023%3A18%3A09286200omegyzr.aac?alt=media&token=ad617cec-18da-4286-856b-36564cb0776d";
                    // log('data: ${metaDataA.toString()}');
                    // log('data: ${metaDataBGM.toString()}');
                    // await audioPlayer.setSourceUrl(urlBGM);
                    // isPlaying = true;
                    play();
                  } else {
                    isPlaying = false;
                    pause();
                  }
                },
                child: const Text('ตัวช่วยสำหรับการพากย์'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future play() async {
    audioPlayer.resume();
  }

  Future pause() async {
    await audioPlayer.pause();
    isPlaying = false;
  }

  Future checkStatus(bool status) async {
    if (status == true) {
      checkButton = true;
    } else {
      print("Status is checked");
      await audioPlayer.seek(Duration(seconds: timeTotal));
      position = Duration(seconds: timeTotal);
      checkTime++;

      if (checkTime < this.currentConverDuration.length) {
        timeTotal += int.parse(this.currentConverDuration[checkTime]);
        print(
            "checktime: ${this.checkTime}, timetotal: ${this.timeTotal}, timelength: ${this.currentConverDuration.length}, position: ${this.position}");
      }

      checkButton = false;
    }
  }

  Future setup(List times) async {
    this.currentConverDuration = times;
    if (timeTotal == 0) {
      timeTotal = int.parse(this.currentConverDuration[0]);
      final storageRef = await FirebaseStorage.instance.ref();
      // final time = await RecordButton.TimeCountDown.instance();
      // final soundRefA = await storageRef
      //     .child(listenList.audioFileName!); // <-- your file name
      // final soundRefBGM =
      //     await storageRef.child("helloworld2.aac"); // <-- your file name
      // final metaDataA = await soundRefA.getDownloadURL();
      // final metaDataBGM = await soundRefBGM.getDownloadURL();
      String urlBGM =
          "https://firebasestorage.googleapis.com/v0/b/overvoice.appspot.com/o/2022-11-2023%3A18%3A09286200omegyzr.aac?alt=media&token=ad617cec-18da-4286-856b-36564cb0776d";
      // log('data: ${metaDataA.toString()}');
      // log('data: ${metaDataBGM.toString()}');
      await audioPlayer.setSourceUrl(urlBGM);
      print("Already Set!");
    }
  }

  Widget displayConversation() {
    if (isStarted == false) {
      int i;
      String fullConversation = "";
      for (i = 0; i < conversationList.length; i++) {
        fullConversation +=
            "ประโยคที่ ${i + 1} " + conversationList[i] + "\n\n";
      }
      currentText = fullConversation;
    }
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => ListTile(
              title: Text(
                currentText,
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
            ));
  }

  // use for change conversation text
  void _converIndexSetter(int converIndex) {
    isStarted = true;
    currentText = conversationList[converIndex];
    setState(() {});
  }
}
