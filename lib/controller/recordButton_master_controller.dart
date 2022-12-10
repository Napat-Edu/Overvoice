import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overvoice_project/model/constant_value.dart';
import 'package:permission_handler/permission_handler.dart';
import 'database_query_controller.dart';

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
  ConstantValue constantValue = ConstantValue();

  String voiceName =
      "${DateTime.now().toString().replaceAll(' ', '').replaceAll('.', '')}${FirebaseAuth.instance.currentUser!.email?.split('@')[0]}.aac";

  // checking for microphone of user
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

  // start recording
  Future record() async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder
        ?.setSubscriptionDuration(const Duration(milliseconds: 50));
    await _audioRecorder!.startRecorder(toFile: voiceName);
  }

   // pause recording
  Future pause() async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder!.pauseRecorder();
  }

   // resume recording
  Future resume() async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder!.resumeRecorder();
  }

   // stop recording
  Future stop() async {
    if (!_isRecordingInitialised) return;
    final filepath = await _audioRecorder!.stopRecorder();
    final file = File(filepath!);
    //print('Record : $file');
    databaseQuery.uploadFile(file, voiceName, docID, "singleDub");
  }

  // stop recording duo type audio
  Future stopDuoType(character) async {
    if (!_isRecordingInitialised) return;
    final filepath = await _audioRecorder!.stopRecorder();
    final file = File(filepath!);
    //print('Record : $file');
    databaseQuery.uploadFile(file, voiceName, docID, character);
  }

  // toggle a record status by the state of audio record player
  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await record();
    } else if (_audioRecorder!.isPaused) {
      await resume();
    } else if (_audioRecorder!.isRecording) {
      await pause();
    }
  }
}
