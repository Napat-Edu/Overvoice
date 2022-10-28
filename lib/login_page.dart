import 'package:flutter/material.dart';
import 'package:overvoice_project/controller/login_controller.dart';
import 'package:provider/provider.dart';

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
        title: Text("Login App"),
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
        CircleAvatar(
          backgroundImage: Image.network(model.userDetails!.photoURL ?? "").image,
          radius: 50,
        ),

        Text(model.userDetails!.displayName ?? ""),
        Text(model.userDetails!.email ?? ""),

        //for log-out
        ActionChip(
          avatar: Icon(Icons.logout),
          label: Text("Logout"),
          onPressed: ()
          {
            Provider.of<LoginController>(context, listen: false).logout();
          },
        )
      ],
    );
  }

  loginControllers(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(),
          Image.asset(),
        ],
      ),
    );

  }
}