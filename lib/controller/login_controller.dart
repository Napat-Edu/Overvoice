import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:overvoice_project/model/user_detail.dart';

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

  logout() async {
    googleSignInAccount = await _googleSignIn.signOut();

    userDetails = null;
    notifyListeners();
  }
} 