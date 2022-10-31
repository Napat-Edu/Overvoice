import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  int number = 0;
  FlutterSoundRecorder? _audioRecorder;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: number == 0 ? Text("Start Record") : Text("Stop record"),
        onPressed: () {
          setState(() {
            if (number == 0) {
              _audioRecorder!.startRecorder(toFile: 'audio.aac');
              number = 1;
            } else {
              _audioRecorder!.stopRecorder();
              number = 0;
            }
          });
        });
  }
}

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;

  Future _record() async {
    await _audioRecorder!.startRecorder(toFile: 'audio.aac');
  }

  Future _stop() async {
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
