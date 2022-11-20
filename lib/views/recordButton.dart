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

    final text;
    if (isRecording && voiceStart) {
      text = 'Pause';
    } else if (!voiceStart) {
      text = 'START';
    } else {
      text = 'Resume';
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
            // Start , Pause , Resume
            child: Text(text),
            onPressed: () async {
              final isRecording = await recorder.toggleRecording();
              setState(() {});
            }),
        ElevatedButton(
          // Stop
          child: voiceStart ? Text('STOP') : Text('Waiting'),
          onPressed: voiceStart
              ? () async {
                  final isRecording = await recorder._stop();
                  setState(() {});
                }
              : null,
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() async {
              if (TimeCountDown[StageVoice].isNotEmpty) {
                await countdown(int.parse(TimeCountDown[StageVoice++]));
                //print(TimeCountDown[StageVoice++]);
              } else {
                StageVoice = 0;
              }
            });
          },
          child: Text('Test'),
        ),
      ],
    ));
  }

  Future countdown(int n) {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      print(timer.tick);
      n--;
      if (n == 0) {
        FlutterBeep.beep(false);
        print('Cancel timer');
        timer.cancel();
      }
    });
    return recorder.toggleRecording();
  }
}

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecordingInitialised = false;
  bool get isRecording => _audioRecorder!.isRecording;
  String voiceName =
      "${DateTime.now().toString().replaceAll(' ', '')}${FirebaseAuth.instance.currentUser!.email?.split('@')[0]}.aac";

  get onProgress => _audioRecorder!.onProgress;

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

    //await soundRef.putFile(file);
  }
}
