import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_beep/flutter_beep.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

bool voiceStart = false;

class _RecordButtonState extends State<RecordButton> {
  int number = 0;
  final recorder = SoundRecorder();

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
          onPressed: () {
            countdown(2);
          },
          child: Text('Test'),
        ),
      ],
    ));
  }

  void countdown(int n) {
    // int number = n;
    // final timer =
    //     Timer(Duration(seconds: number), () => print('Timer finished'));
    Timer.periodic(const Duration(seconds: 1), (timer) {
      print(timer.tick);
      n--;
      if (n == 0) {
        FlutterBeep.beep(false);
        print('Cancel timer');
        timer.cancel();
      }
    });
  }
}

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecordingInitialised = false;
  bool get isRecording => _audioRecorder!.isRecording;
  String fileName = "Test01.aac";

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
    await _audioRecorder!.startRecorder(toFile: fileName);
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

    final soundRef = storageRef.child(fileName);

    // String filePath = '${appDocDir.path}/audio.aac';
    // File file = File(filePath);

    //await soundRef.putFile(file);
  }
}
