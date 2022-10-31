import 'package:flutter/material.dart';
import 'package:overvoice_project/login_page.dart';
import 'package:provider/provider.dart';
import 'controller/login_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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