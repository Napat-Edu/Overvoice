import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninController with ChangeNotifier
{
  //object
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;

  //login function
  login() async {
    googleSignInAccount = await _googleSignIn.signIn();

    notifyListeners();
  }

  //logout function
  logout() async {
    //clear value before logout
    googleSignInAccount = await _googleSignIn.signOut();

    notifyListeners();
  }
}