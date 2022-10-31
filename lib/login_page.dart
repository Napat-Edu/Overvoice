import 'package:flutter/material.dart';
import 'package:overvoice_project/controller/login_controller.dart';
import 'package:overvoice_project/screen/audioinfo.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overvoice"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
    
      //body ui
      body: loginUI(),
    
    );
  }

  loginUI() {
    return Consumer<LoginController>(builder: (context, model, child) {

      //if already logged-in
      if(model.userDetails != null)
      {
        return Center(
          child: loggedInUI(model),
        );
      }
      else
      {
        return loginControllers(context);
      }
    });
  }

  loggedInUI(LoginController model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        AudioInfo(),
        
        // CircleAvatar(
        //   backgroundImage: Image.network(model.userDetails!.photoURL ?? "").image,
        //   radius: 50,
        // ),

        // Text(model.userDetails!.displayName ?? ""),
        // Text(model.userDetails!.email ?? ""),

        // //for log-out
        // ActionChip(
        //   avatar: const Icon(Icons.logout),
        //   label: const Text("Logout"),
        //   onPressed: ()
        //   {
        //     Provider.of<LoginController>(context, listen: false).logout();
        //   },
        // )
      ],
    );
  }

  loginControllers(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: SignInButton(
              Buttons.Google,
              onPressed: () {
                Provider.of<LoginController>(context, listen: false).googleLogin();
              },
            ),
          ),

        /*const SizedBox(height: 10,),

        GestureDetector(
            child: SignInButton(
              Buttons.Facebook,
              onPressed: () {
                Provider.of<LoginController>(context, listen: false).facebookLogin();
              },
            ),
          ),*/

        ],
      ),
    );

  }
}