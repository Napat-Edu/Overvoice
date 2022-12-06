import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:audioplayers/audioplayers.dart';
import '../screen/record_page.dart';
import 'dart:developer';

class RecordButtonDuoCoop extends StatefulWidget {
  final ValueChanged<int> converIndexSetter;
  List conversationList;
  String character;
  String hisID;
  String soundOver;
  RecordButtonDuoCoop(
      this.conversationList, this.hisID, this.character, this.soundOver,
      {required this.converIndexSetter, super.key});

  @override
  State<RecordButtonDuoCoop> createState() =>
      _RecordButtonDuoCoopState(conversationList, hisID, character, soundOver,
          converIndexSetter: converIndexSetter);
}

bool voiceStart = false;

class _RecordButtonDuoCoopState extends State<RecordButtonDuoCoop> {
  int number = 0;

  int StageVoice = 0;
  bool status = false;
  String hisID;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late final recorder = SoundRecorder(hisID);
  AudioPlayer audioPlayer = AudioPlayer();

  List conversationList;
  String character;
  String soundOver;

  final ValueChanged<int> converIndexSetter;

  _RecordButtonDuoCoopState(
      this.conversationList, this.hisID, this.character, this.soundOver,
      {required this.converIndexSetter});

  Object? get TimeCountDown => null;

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
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            onPressed: status || (isStopped && StageVoice != 0)
                ? null
                : () async {
                    if (StageVoice >= TimeCountDown.length) {
                      await recorder._stop();
                    } else if (TimeCountDown[StageVoice].isNotEmpty) {
                      if (StageVoice == 0) {
                        converIndexSetter(Record.converIndex);
                        await recorder._record();
                        await audioPlayer.resume();
                        playPartner();
                      } else {
                        await recorder._resume();
                        await null;
                        playPartner();
                      }
                      print(StageVoice);
                      print(TimeCountDown.length);
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
    Timer.periodic(const Duration(seconds: 1), (timer) {
      status = false;
      print(timer.tick);
      n--;
      if (n == 0) {
        FlutterBeep.beep(false);
        timer.cancel();
        if (n >= m) {
          recorder._stop();
        } else {
          recorder._pause();
          pause();
        }

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

  Future play() async {
    await audioPlayer.resume();
  }

  Future pause() async {
    await audioPlayer.pause();
  }

  Future playPartner() async {
    final storageRef = await FirebaseStorage.instance.ref();
    // final soundRefA =
    //     await storageRef.child(listenList.audioFileName!); // <-- your file name
    final soundRefBGM = await storageRef.child(soundOver); // <-- your file name
    // final metaDataA = await soundRefA.getDownloadURL();
    final metaDataBGM = await soundRefBGM.getDownloadURL();
    // // log('data: ${metaDataA.toString()}');
    log('data: ${metaDataBGM.toString()}');
    // // String urlA = metaDataA.toString();
    String urlBGM = metaDataBGM.toString();
    // await audioPlayerA.setSourceUrl(urlA);
    await audioPlayer.setSourceUrl(urlBGM);
    // play(urlA, urlBGM);
    // String url =
    // "https://firebasestorage.googleapis.com/v0/b/overvoice.appspot.com/o/2022-11-2023%3A18%3A09286200omegyzr.aac?alt=media&token=ad617cec-18da-4286-856b-36564cb0776d";
    // await audioPlayer.setSourceUrl(url);
    play();
  }
}

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecordingInitialised = false;
  String hisID;
  SoundRecorder(this.hisID);
  bool get isRecording => _audioRecorder!.isRecording;
  bool get isPaused => _audioRecorder!.isPaused;
  bool get isStopped => _audioRecorder!.isStopped;
  get onProgress => _audioRecorder!.onProgress;
  AudioPlayer audioPlayer = AudioPlayer();

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
        .doc(hisID)
        .update({
          "sound_2": voiceName,
          "status": true,
          "user_2": FirebaseAuth.instance.currentUser!.email,
        })
        .then((value) => print("History Updated"))
        .catchError((error) => print("Failed to update: $error"));
    ;

    CollectionReference usersInfo =
        FirebaseFirestore.instance.collection('UserInfo');
    usersInfo.doc(FirebaseAuth.instance.currentUser!.email).update({
      "recordAmount": FieldValue.increment(1),
    });
  }
}
