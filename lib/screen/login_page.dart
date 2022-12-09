import 'package:flutter/material.dart';
import 'package:overvoice_project/controller/login_controller.dart';
import 'package:overvoice_project/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // core UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Overvoice",style: GoogleFonts.prompt(fontWeight: FontWeight.w600),),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFF7200),
      ),
      bottomNavigationBar: loginPageUI(context),
      backgroundColor: const Color(0xFFFF7200),
    );
  }

  // use for generate UI
  loginPageUI(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/image/Icon.png"),
            const Divider(
              thickness: 3,
              color: Color(0xFFFFAA66),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              child: SignInButton(
                Buttons.Google,
                text: "Log in with Google",
                onPressed: () {
                  // function login from LoginController
                  Provider.of<LoginController>(context, listen: false)
                      .googleLogin();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Divider(
              thickness: 3,
              color: Color(0xFFFFAA66),
            ),
          ],
        ),
      ),
    );
  }
}
