import 'package:flutter/material.dart';
import 'package:overvoice_project/api/sound_recorder.dart';
import 'package:overvoice_project/login_page.dart';
import 'package:provider/provider.dart';
import 'controller/login_controller.dart';
import 'package:flutter_sound/flutter_sound.dart';

void main() {
  runApp(const MaterialApp(
    title: 'TestNaja',
    home: FirstRoute(),
  ));
}

// Homepage
class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text('Login Page'),
            // Within the `FirstRoute` widget
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondRoute()),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Record Voice'),
            onPressed: () {
              FlutterSoundRecorder? audioRecorder;
              if (audioRecorder!.isStopped) {
                audioRecorder.startRecorder(toFile: 'test.aac');
              } else {
                audioRecorder.stopRecorder();
              }
            },
          ),
        ],
      )),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginController(),
          child: const LoginPage(),
        )
      ],
      child: MaterialApp(
        title: 'Overvoice',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
      ),
    );
  }
}

/*
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          // Within the SecondRoute widget
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
  */