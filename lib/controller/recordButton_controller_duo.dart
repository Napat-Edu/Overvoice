import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overvoice_project/controller/database_query_controller.dart';
import 'package:overvoice_project/controller/popup_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_beep/flutter_beep.dart';

import '../screen/record_page.dart';

class RecordButtonDuo extends StatefulWidget {
  final ValueChanged<int> converIndexSetter;
  List conversationList;
  String character;
  String docID;
  late Function(List) onCountChanged; // intial function for push next page
  late Function(bool) onStatusChanged; // intial function for push next page
  RecordButtonDuo(this.conversationList, this.docID, this.character,
      this.onCountChanged, this.onStatusChanged,
      {required this.converIndexSetter, super.key});

  @override
  State<RecordButtonDuo> createState() => _RecordButtonDuoState(
      conversationList, docID, character, onCountChanged, onStatusChanged,
      converIndexSetter: converIndexSetter);
}

class _RecordButtonDuoState extends State<RecordButtonDuo> {
  int number = 0;

  int StageVoice = 0;
  bool status = false;
  String docID;

  late final Function(List) onCountChanged;
  late final Function(bool) onStatusChanged;
  late final recorder = SoundRecorder(docID);

  List conversationList;
  String character;
  PopupControl popupControl = PopupControl();

  final ValueChanged<int> converIndexSetter;

  _RecordButtonDuoState(this.conversationList, this.docID, this.character,
      this.onCountChanged, this.onStatusChanged,
      {required this.converIndexSetter});

  Object? get TimeCountDown => null;

  @override
  void initState() {
    super.initState();

    print("this is Record Duo button!");

    recorder.init();
  }

  @override
  void dispose() {
    recorder.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = recorder.isRecording;
    final onProgress = recorder.onProgress;
    final isPaused = recorder.isPaused;
    final isStopped = recorder.isStopped;
    final text;
    if (isPaused) {
      text = 'อ่านบทแล้ว พร้อมพากย์ต่อ';
    } else if (isRecording) {
      text = 'พากย์เลย';
    } else if (isStopped && StageVoice != 0) {
      text = 'เสร็จสิ้น';
    } else {
      text = 'เริ่มพากย์';
    }

    List<String> TimeCountDown = [];
    List<String> characterList = [];
    for (int i = 0; i < conversationList.length; i++) {
      TimeCountDown.add(
          conversationList[i].toString().split('(')[1].split(':')[0]);
      characterList
          .add(conversationList[i].toString().split(':')[1].split(')')[0]);
    }
    onCountChanged(TimeCountDown); // push time number in () to record_page

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print(characterList + TimeCountDown); // Debug
    return Container(
        child: Column(
      children: <Widget>[
        SizedBox(
          width: screenWidth / 1.4,
          height: screenHeight / 20,
          child: TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFFFF7200),
                textStyle:
                    GoogleFonts.prompt(fontSize: 19, fontWeight: FontWeight.w600)),
            onPressed: status || isStopped && StageVoice != 0
                ? null
                : () async {
                    if (StageVoice >= TimeCountDown.length) {
                      await recorder._stop(character);
                      popupControl.finishAlertDialog(context, 4);
                    } else if (TimeCountDown[StageVoice].isNotEmpty) {
                      if (StageVoice == 0) {
                        converIndexSetter(Record.converIndex);
                        await recorder._record();
                      } else {
                        await recorder._resume();
                        await null;
                      }
                      countdown(
                          int.parse(TimeCountDown[
                              StageVoice < TimeCountDown.length
                                  ? StageVoice++
                                  : StageVoice]),
                          TimeCountDown.length);
                      //print(TimeCountDown[StageVoice++]);
                    }
                    setState(() {});
                  },
            child: Text(
              StageVoice >= TimeCountDown.length
                  ? 'เสร็จสิ้น'
                  : character == characterList[StageVoice]
                      ? text
                      : 'บทของคู่คุณ',
            ),
          ),
        )
      ],
    ));
  }

  void countdown(int n, int m) {
    print(n);
    FlutterBeep.beep(false);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      status = false;
      print(timer.tick);
      n--;
      if (n == 0) {
        FlutterBeep.beep(false);
        timer.cancel();
        onStatusChanged(false);
        recorder._pause();

        // go for next conversation index in record_page
        if (Record.converIndex < conversationList.length - 1) {
          Record.converIndex++;
          converIndexSetter(Record.converIndex);
        }

        setState(() {});
      }
    });
    status = true;
  }
}

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecordingInitialised = false;
  String docID;
  SoundRecorder(this.docID);
  bool get isRecording => _audioRecorder!.isRecording;
  bool get isPaused => _audioRecorder!.isPaused;
  bool get isStopped => _audioRecorder!.isStopped;
  get onProgress => _audioRecorder!.onProgress;

  DatabaseQuery databaseQuery = DatabaseQuery();

  String voiceName =
      "${DateTime.now().toString().replaceAll(' ', '').replaceAll('.', '')}${FirebaseAuth.instance.currentUser!.email?.split('@')[0]}.aac";

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission is denied');
    }

    await _audioRecorder!.openRecorder(); // Conflict
    _isRecordingInitialised = true;
  }

  void dispose() {
    if (!_isRecordingInitialised) return;

    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _isRecordingInitialised = false;
  }

  Future _record() async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder
        ?.setSubscriptionDuration(const Duration(milliseconds: 50));
    await _audioRecorder!.startRecorder(toFile: voiceName);
  }

  Future _pause() async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder!.pauseRecorder();
  }

  Future _resume() async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder!.resumeRecorder();
  }

  Future _stop(character) async {
    if (!_isRecordingInitialised) return;
    final filepath = await _audioRecorder!.stopRecorder();
    final file = File(filepath!);
    //print('Record : $file');
    databaseQuery.uploadFile(file, voiceName, docID, character);
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else if (_audioRecorder!.isPaused) {
      await _resume();
    } else if (_audioRecorder!.isRecording) {
      await _pause();
    }
  }
}