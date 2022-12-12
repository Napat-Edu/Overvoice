import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overvoice_project/controller/popup_controller.dart';
import 'package:overvoice_project/controller/recordButton_controller.dart';
import 'package:overvoice_project/controller/recordButton_master_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:overvoice_project/model/constant_value.dart';
import '../screen/record_page.dart';
import 'dart:developer';

class RecordButtonDuoCoop extends StatefulWidget {
  final ValueChanged<int> converIndexSetter;
  List conversationList;
  String character;
  String hisID;
  String soundOver;
  late Function(List) onCountChanged; // intial function for push next page
  late Function(bool) onStatusChanged; // intial function for push next page
  RecordButtonDuoCoop(this.conversationList, this.hisID, this.character,
      this.soundOver, this.onCountChanged, this.onStatusChanged,
      {required this.converIndexSetter, super.key});

  @override
  State<RecordButtonDuoCoop> createState() => _RecordButtonDuoCoopState(
      conversationList,
      hisID,
      character,
      soundOver,
      onCountChanged,
      onStatusChanged,
      converIndexSetter: converIndexSetter);
}

class _RecordButtonDuoCoopState extends State<RecordButtonDuoCoop> {
  int number = 0;

  int stageVoice = 0;
  bool status = false;
  String hisID;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late final Function(List) onCountChanged;
  late final Function(bool) onStatusChanged;
  late final recorder = SoundRecorder(hisID);
  AudioPlayer audioPlayer = AudioPlayer();

  List conversationList;
  String character;
  String soundOver;
  PopupControl popupControl = PopupControl();
  ConstantValue constantValue = ConstantValue();

  final ValueChanged<int> converIndexSetter;

  _RecordButtonDuoCoopState(this.conversationList, this.hisID, this.character,
      this.soundOver, this.onCountChanged, this.onStatusChanged,
      {required this.converIndexSetter});

  Object? get timeCountDown => null;

  @override
  void initState() {
    super.initState();

    recorder.init();

    // Listen to audio position
    audioPlayer.onPositionChanged.listen((Duration p) {
      if (!mounted) return;
      setState(() => position = p);
    });

    audioPlayer.onPlayerComplete.listen((event) {
      if (!mounted) return;
      setState(() {
        position = duration;
      });
    });

    playPartner();
  }

  @override
  void dispose() {
    Record.converIndex = 0;
    recorder.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = recorder.isRecording;
    final onProgress = recorder.onProgress;
    final isPaused = recorder.isPaused;
    final isStopped = recorder.isStopped;
    final String text;

    if (isRecording) {
      status = true;
    }

    if (isPaused) {
      text = 'อ่านบทแล้ว พร้อมพากย์';
    } else if (isRecording) {
      text = 'พากย์เลย';
    } else if (isStopped && stageVoice != 0) {
      text = 'เสร็จสิ้น';
    } else {
      text = 'เริ่มพากย์';
    }

    List<String> timeCountDown = [];
    List<String> characterList = [];
    for (int i = 0; i < conversationList.length; i++) {
      timeCountDown
          .add(conversationList[i].toString().split('(')[1].split(':')[0]);
      characterList
          .add(conversationList[i].toString().split(':')[1].split(')')[0]);
    }
    onCountChanged(timeCountDown); // push time number in () to record_page

    print(characterList + timeCountDown); // Debug
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: constantValue.getScreenWidth(context) / 1.4,
            height: constantValue.getScreenHeight(context) / 20,
            child: TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFFFF7200),
                  textStyle: GoogleFonts.prompt(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              onPressed: recordButton(isStopped, timeCountDown),
              child: Text(
                stageVoice >= timeCountDown.length
                    ? 'เสร็จสิ้น'
                    : character == characterList[stageVoice]
                        ? text
                        : 'บทของคู่คุณ',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // countdown a time for dubbing
  void countdown(int n, int m) {
    FlutterBeep.playSysSound(28);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      status = true;
      print(timer.tick);
      n--;
      if (n == 0) {
        FlutterBeep.playSysSound(32);
        timer.cancel();
        onStatusChanged(false);
        recorder.pause();
        pause();

        // go for next conversation index in record_page
        if (Record.converIndex < conversationList.length - 1) {
          Record.converIndex++;
          converIndexSetter(Record.converIndex);
        }

        setState(() {
          status = false;
        });
      }
    });
  }

  Future play() async {
    await audioPlayer.resume();
  }

  Future pause() async {
    await audioPlayer.pause();
  }

  // play a voice from your buddy
  Future playPartner() async {
    final storageRef = FirebaseStorage.instance.ref();
    final soundRefBGM = storageRef.child(soundOver);
    final metaDataBGM = await soundRefBGM.getDownloadURL();
    log('data: ${metaDataBGM.toString()}');
    String urlBGM = metaDataBGM.toString();
    await audioPlayer.setSourceUrl(urlBGM);
  }

  // start the process of dubbing when hit the button
  recordButton(bool isStopped, List<String> timeCountDown) {
    return status || isStopped && stageVoice != 0
        ? null
        : () async {
            if (stageVoice >= timeCountDown.length) {
              await recorder.stop();
              popupControl.finishAlertDialog(context, 5);
            } else if (timeCountDown[stageVoice].isNotEmpty) {
              if (stageVoice == 0) {
                converIndexSetter(Record.converIndex);
                await play();
                await recorder.record();
                await audioPlayer.resume();
                playPartner();
              } else {
                await play();
                await recorder.resume();
                await null;
              }
              countdown(
                  int.parse(timeCountDown[stageVoice < timeCountDown.length
                      ? stageVoice++
                      : stageVoice]),
                  timeCountDown.length);
            }
            setState(() {});
          };
  }
}
