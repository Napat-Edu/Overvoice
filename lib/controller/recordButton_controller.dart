import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overvoice_project/controller/popup_controller.dart';
import 'package:overvoice_project/controller/recordButton_master_controller.dart';
import 'package:flutter_beep/flutter_beep.dart';

import '../screen/record_page.dart';

class RecordButton extends StatefulWidget {
  final ValueChanged<int> converIndexSetter;
  List conversationList;
  String docID;
  late Function(List) onCountChanged; // intial function for push next page
  late Function(bool) onStatusChanged; // intial function for push next page
  RecordButton(this.conversationList, this.docID, this.onCountChanged,
      this.onStatusChanged,
      {required this.converIndexSetter, super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState(
      conversationList, docID, onCountChanged, onStatusChanged,
      converIndexSetter: converIndexSetter);
}

class _RecordButtonState extends State<RecordButton> {
  int number = 0;

  int stageVoice = 0;
  bool status = false;
  late final Function(List) onCountChanged;
  late final Function(bool) onStatusChanged;
  String docID;

  late final recorder = SoundRecorder(docID);

  List conversationList;
  PopupControl popupControl = PopupControl();

  final ValueChanged<int> converIndexSetter;

  _RecordButtonState(this.conversationList, this.docID, this.onCountChanged,
      this.onStatusChanged,
      {required this.converIndexSetter});

  Object? get timeCountDown => null;

  @override
  void initState() {
    super.initState();

    print("this is Record button!");

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
      text = 'กำลังพากย์อยู่';
    } else if (isStopped && stageVoice != 0) {
      text = 'เสร็จสิ้น';
    } else {
      text = 'เริ่มพากย์';
    }

    List<String> TimeCountDown = [];
    for (int i = 0; i < conversationList.length; i++) {
      TimeCountDown.add(
          conversationList[i].toString().split('(')[1].split(')')[0]);
    }
    onCountChanged(TimeCountDown); // push time number in () to record_page
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
                foregroundColor: const Color(0xFFFF7200),
                textStyle: GoogleFonts.prompt(
                    fontSize: 19, fontWeight: FontWeight.w600)),
            onPressed: status || isStopped && stageVoice != 0
                ? null
                : () async {
                    if (stageVoice == TimeCountDown.length) {
                      await recorder.stop();
                      popupControl.finishAlertDialog(context, 2);
                    } else if (TimeCountDown[stageVoice].isNotEmpty) {
                      if (stageVoice == 0) {
                        converIndexSetter(Record.converIndex);
                        await recorder.record();
                      } else {
                        await recorder.resume();

                        await null;
                      }
                      countdown(
                          int.parse(TimeCountDown[
                              stageVoice < TimeCountDown.length
                                  ? stageVoice++
                                  : stageVoice]),
                          TimeCountDown.length);

                      //print(TimeCountDown[StageVoice++]);
                    }
                    setState(() {});
                  },
            child: Text(
              stageVoice >= TimeCountDown.length ? 'เสร็จสิ้น' : text,
            ),
          ),
        ),
      ],
    ));
  }

  void countdown(int n, int m) {
    FlutterBeep.beep(false);
    onStatusChanged(true); // check status of buttons
    Timer.periodic(const Duration(seconds: 1), (timer) {
      status = false;
      print(timer.tick);
      n--;
      if (n == 0) {
        FlutterBeep.beep(false);
        print('Cancel timer');
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
