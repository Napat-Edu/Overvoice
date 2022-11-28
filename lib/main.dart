import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overvoice_project/login_page.dart';
import 'package:overvoice_project/nav.dart';
import 'package:provider/provider.dart';
import 'controller/login_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
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
        debugShowCheckedModeBanner: false,
        title: 'Overvoice',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<Widget>(
            future: checkUserStatus(),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              }

              return const Text("กำลังโหลด...");
            }),
      ),
    );
  }

  Future<Widget> checkUserStatus() async {
    bool internetStatus = await checkInternetStatus();
    if (internetStatus == true) {
      if (FirebaseAuth.instance.currentUser != null) {
        return const Navbar();
      } else {
        return const LoginPage();
      }
    }
    return const Center(
      child: Text(
          "คุณไม่ได้เชื่อมต่ออินเทอร์เน็ต\nโปรดเชื่อมต่อแล้วกลับมาอีกครั้งนะ"),
    );
  }

  Future<bool> checkInternetStatus() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Navbar(),
    );
  }
}

class LoginPageRoute extends StatelessWidget {
  const LoginPageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginPage(),
    );
  }
}
