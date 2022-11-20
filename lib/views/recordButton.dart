import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_beep/flutter_beep.dart';

class RecordButton extends StatefulWidget {
  List conversationList;
  RecordButton(this.conversationList, {super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState(conversationList);
}

bool voiceStart = false;

class _RecordButtonState extends State<RecordButton> {
  int number = 0;

  int StageVoice = 0;
  bool status = false;

  final recorder = SoundRecorder();

  List conversationList;

  _RecordButtonState(this.conversationList);

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
      text = 'Reading';
    } else if (isRecording) {
      text = 'Show Time';
    } else if (isStopped && StageVoice != 0) {
      text = 'Finished';
    } else {
      text = 'START';
    }

    List<String> TimeCountDown = [];
    for (int i = 0; i < conversationList.length; i++) {
      TimeCountDown.add(
          conversationList[i].toString().split('(')[1].split(')')[0]);
    }

    return Container(
        child: Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: status || isStopped && StageVoice != 0
              ? null
              : () async {
                  if (StageVoice == TimeCountDown.length) {
                    await recorder._stop();
                  } else if (TimeCountDown[StageVoice].isNotEmpty) {
                    if (StageVoice == 0) {
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
          child: Text(StageVoice >= TimeCountDown.length ? 'Finish' : text),
        ),
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
        setState(() {});
      }
    });
    status = true;
  }
}

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecordingInitialised = false;
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

    print(voiceName);
    // String filePath = '${appDocDir.path}/audio.aac';
    // File file = File(filePath);

    await soundRef.putFile(file);
  }
}
