import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overvoice_project/controller/popup_controller.dart';
import 'package:overvoice_project/controller/recordButton_master_controller.dart';
import 'package:flutter_beep/flutter_beep.dart';
import '../model/constant_value.dart';
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
  String docID;
  late final Function(List) onCountChanged;
  late final Function(bool) onStatusChanged;
  late final recorder = SoundRecorder(docID);
  final ValueChanged<int> converIndexSetter;
  PopupControl popupControl = PopupControl();
  ConstantValue constantValue = ConstantValue();
  List conversationList;

  Object? get timeCountDown => null;

  _RecordButtonState(this.conversationList, this.docID, this.onCountChanged,
      this.onStatusChanged,
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

    final String text;
    if (isPaused) {
      text = 'อ่านบทแล้ว พร้อมพากย์ต่อ';
    } else if (isRecording) {
      text = 'กำลังพากย์อยู่';
    } else if (isStopped && stageVoice != 0) {
      text = 'เสร็จสิ้น';
    } else {
      text = 'เริ่มพากย์';
    }

    List<String> timeCountDown = [];
    for (int i = 0; i < conversationList.length; i++) {
      timeCountDown
          .add(conversationList[i].toString().split('(')[1].split(')')[0]);
    }
    onCountChanged(timeCountDown); // push time number in () to record_page

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
                    fontSize: 19, fontWeight: FontWeight.w600),
              ),
              onPressed: status || isStopped && stageVoice != 0
                  ? null
                  : () async {
                      if (stageVoice == timeCountDown.length) {
                        await recorder.stop();
                        popupControl.finishAlertDialog(context, 2);
                      } else if (timeCountDown[stageVoice].isNotEmpty) {
                        if (stageVoice == 0) {
                          converIndexSetter(Record.converIndex);
                          await recorder.record();
                        } else {
                          await recorder.resume();

                          await null;
                        }
                        countdown(
                            int.parse(timeCountDown[
                                stageVoice < timeCountDown.length
                                    ? stageVoice++
                                    : stageVoice]),
                            timeCountDown.length);
                      }
                      setState(() {});
                    },
              child: Text(
                stageVoice >= timeCountDown.length ? 'เสร็จสิ้น' : text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // countdown a time for dubbing
  countdown(int n, int m) async {
    FlutterBeep.beep(false);
    onStatusChanged(true); // check status of buttons
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
