import 'package:flutter/material.dart';
import 'package:overvoice_project/login_page.dart';
import 'package:provider/provider.dart';
import 'controller/login_controller.dart';
import 'recordButton.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    title: 'Overvoice',
    home: FirstRoute(),
  ));
}

// Homepage

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    String temp = DateTime.now().toString();
    temp = temp.replaceAll(' ', '');
    temp = temp.replaceAll('-', '');
    temp = temp.replaceAll(':', '');
    temp = temp.replaceAll('.', '');
    String name = 'Niwatchai';
    temp = temp + name;

    return Scaffold(
      appBar: AppBar(
        title: Text(temp),
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
          const RecordButton(),
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