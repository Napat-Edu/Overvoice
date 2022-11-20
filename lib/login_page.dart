import 'package:flutter/material.dart';
import 'package:overvoice_project/controller/login_controller.dart';
import 'package:overvoice_project/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overvoice"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFF7200),
      ),
      bottomNavigationBar: loginPageUI(context),
      backgroundColor: const Color(0xFFFF7200),
    );
  }

  loginPageUI(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/Icon.png"),
            Divider(
              thickness: 3,
              color: Color(0xFFFFAA66),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              child: SignInButton(
                Buttons.Google,
                text: "Log in with Google",
                onPressed: () {
                  Provider.of<LoginController>(context, listen: false)
                      .googleLogin();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Divider(
              thickness: 3,
              color: Color(0xFFFFAA66),
            ),
          ],
        ),
      ),
    );
  }
}
