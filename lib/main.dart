import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overvoice_project/screen/login_page.dart';
import 'package:overvoice_project/nav.dart';
import 'package:overvoice_project/screen/noInternet_page.dart';
import 'package:provider/provider.dart';
import 'controller/login_controller.dart';
import 'package:google_fonts/google_fonts.dart';

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

              // loading screen, while waiting for user status checking
              return Material(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "กำลังโหลด...",
                      style: GoogleFonts.prompt(),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  // use for check that user already login and connect the internet or not
  Future<Widget> checkUserStatus() async {
    bool internetStatus = await checkInternetStatus();
    if (internetStatus == true) {
      if (FirebaseAuth.instance.currentUser != null) {
        // already login
        return const Navbar();
      } else {
        // doesn't login before
        return const LoginPage();
      }
    }

    // user does not connected the internet
    return const NoWifi();
  }

  // use for check internet connection of user
  Future<bool> checkInternetStatus() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }
}

// navigation path to our main screen
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Navbar(),
    );
  }
}

// navigation path to our login page
class LoginPageRoute extends StatelessWidget {
  const LoginPageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginPage(),
    );
  }
}
