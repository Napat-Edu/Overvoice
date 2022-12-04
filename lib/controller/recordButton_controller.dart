import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_beep/flutter_beep.dart';

import '../screen/record_page.dart';

class RecordButton extends StatefulWidget {
  final ValueChanged<int> converIndexSetter;
  List conversationList;
  String docID;
  RecordButton(this.conversationList, this.docID, {required this.converIndexSetter, super.key});

  @override
  State<RecordButton> createState() =>
      _RecordButtonState(conversationList, docID, converIndexSetter: converIndexSetter);
}

bool voiceStart = false;

class _RecordButtonState extends State<RecordButton> {
  int number = 0;

  int StageVoice = 0;
  bool status = false;
  String docID;

  late final recorder = SoundRecorder(docID);

  List conversationList;

  final ValueChanged<int> converIndexSetter;

  _RecordButtonState(this.conversationList, this.docID, {required this.converIndexSetter});

  Object? get TimeCountDown => null;

  @override
  void initState() {
    super.initState();

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
    for (int i = 0; i < conversationList.length; i++) {
      TimeCountDown.add(
          conversationList[i].toString().split('(')[1].split(')')[0]);
    }
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            onPressed: status || isStopped && StageVoice != 0
                ? null
                : () async {
                    if (StageVoice == TimeCountDown.length) {
                      await recorder._stop();
                    } else if (TimeCountDown[StageVoice].isNotEmpty) {
                      if (StageVoice == 0) {
                        converIndexSetter(Record.converIndex);
                        await recorder._record();
                      } else {
                        await recorder._resume();
                        await null;
                      }
                      countdown(int.parse(TimeCountDown[StageVoice++]),
                          TimeCountDown.length);

                      //print(TimeCountDown[StageVoice++]);
                    }
                    setState(() {});
                  },
            child: Text(
              StageVoice >= TimeCountDown.length ? 'เสร็จสิ้น' : text,
            ),
          ),
        )
      ],
    ));
  }

  void countdown(int n, int m) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      status = false;
      print(timer.tick);
      n--;
      if (n == 0) {
        FlutterBeep.beep(false);
        print('Cancel timer');
        timer.cancel();
        if (n >= m) {
          recorder._stop();
        } else {
          recorder._pause();
        }

        // go for next conversation index in record_page
        Record.converIndex++;
        converIndexSetter(Record.converIndex);

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
    voiceStart = true;
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

  Future _stop() async {
    if (!_isRecordingInitialised) return;
    final filepath = await _audioRecorder!.stopRecorder();
    final file = File(filepath!);
    voiceStart = false;
    //print('Record : $file');
    _uploadFile(file);
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

  Future _uploadFile(file) async {
    // Directory appDocDir = await getApplicationDocumentsDirectory();

    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    final soundRef = storageRef.child(voiceName);
    // String filePath = '${appDocDir.path}/audio.aac';
    // File file = File(filePath);

    await soundRef.putFile(file);

    CollectionReference usersHistory =
        FirebaseFirestore.instance.collection('History');
    usersHistory
        .doc()
        .set({
          'audioInfo': docID,
          'likeCount': 0,
          'sound_1': voiceName,
          'sound_2': "",
          'status': true,
          'user_1': FirebaseAuth.instance.currentUser!.email,
          'user_2': "",
        })
        .then((value) => print("History Added"))
        .catchError((error) => print("Failed to add user: $error"));

    CollectionReference usersInfo =
        FirebaseFirestore.instance.collection('UserInfo');
    usersInfo.doc(FirebaseAuth.instance.currentUser!.email).update({
      "recordAmount": FieldValue.increment(1),
    });
  }
}
