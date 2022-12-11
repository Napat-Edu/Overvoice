import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overvoice_project/controller/popup_controller.dart';
import 'package:overvoice_project/controller/recordButton_master_controller.dart';
import 'package:flutter_beep/flutter_beep.dart';
import '../model/constant_value.dart';
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
  String character;
  late final Function(List) onCountChanged;
  late final Function(bool) onStatusChanged;
  late final recorder = SoundRecorder(docID);
  final ValueChanged<int> converIndexSetter;
  List conversationList;
  PopupControl popupControl = PopupControl();
  ConstantValue constantValue = ConstantValue();
  Object? get timeCountDown => null;

  _RecordButtonDuoState(this.conversationList, this.docID, this.character,
      this.onCountChanged, this.onStatusChanged,
      {required this.converIndexSetter});

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
                foregroundColor: const Color(0xFFFF7200),
                textStyle: GoogleFonts.prompt(
                    fontSize: 19, fontWeight: FontWeight.w600)),
            onPressed: status || isStopped && StageVoice != 0
                ? null
                : () async {
                    if (StageVoice >= timeCountDown.length) {
                      await recorder.stopDuoType(character);
                      popupControl.finishAlertDialog(context, 4);
                    } else if (timeCountDown[StageVoice].isNotEmpty) {
                      if (StageVoice == 0) {
                        converIndexSetter(Record.converIndex);
                        await recorder.record();
                      } else {
                        await recorder.resume();
                        await null;
                      }
                      countdown(
                          int.parse(timeCountDown[
                              StageVoice < timeCountDown.length
                                  ? StageVoice++
                                  : StageVoice]),
                          timeCountDown.length);
                      //print(TimeCountDown[StageVoice++]);
                    }
                    setState(() {});
                  },
            child: Text(
              StageVoice >= timeCountDown.length
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

  // countdown a time for dubbing
  void countdown(int n, int m) {
    FlutterBeep.beep(false);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      status = false;
      print(timer.tick);
      n--;
      if (n == 0) {
        FlutterBeep.beep(false);
        timer.cancel();
        onStatusChanged(false);
        recorder.pause();

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
