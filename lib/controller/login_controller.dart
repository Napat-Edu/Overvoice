import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:overvoice_project/model/user_detail.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginController with ChangeNotifier
{
  //object
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserDetails? userDetails;

  //google log-in function
  googleLogin() async {
    googleSignInAccount= await _googleSignIn.signIn();

    //insert values to user details
    // ignore: unnecessary_new
    userDetails= new UserDetails(
      displayName: googleSignInAccount!.displayName,
      email: googleSignInAccount!.email,
      photoURL: googleSignInAccount!.photoUrl,
    );

    notifyListeners();
  }

  //facebook log-in function
  /*
  facebookLogin() async {
    var result = await FacebookAuth.i.login(
      permissions: ["public_profile", "email"],
    );

    //check status of login
    if(result.status == LoginStatus.success) {
      final requestData = await FacebookAuth.i.getUserData(
        fields: "email, name, picture",
      );

    userDetails = UserDetails(
      displayName:  requestData["name"],
      email:  requestData["email"],
      photoURL:  requestData["picture"]["data"]["url"] ?? " ",
    );
    notifyListeners();

    }
  }
  */

  logout() async {
    googleSignInAccount = await _googleSignIn.signOut();
    //await FacebookAuth.i.logOut();
    userDetails = null;
    notifyListeners();
  }
} 