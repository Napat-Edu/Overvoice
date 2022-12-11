import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:overvoice_project/controller/database_query_controller.dart';
import 'package:overvoice_project/model/user_detail.dart';

import '../main.dart';

class LoginController with ChangeNotifier {
  // object for login
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserDetails? userDetails;
  User? user;
  DatabaseQuery databaseQuery = DatabaseQuery();

  // google log-in function
  googleLogin(context) async {
    googleSignInAccount = await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleSignInAccount?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    await checkUserInfo();

    notifyListeners();

    toHomePage(context);
  }

  // logout function
  logout() async {
    googleSignInAccount = await _googleSignIn.signOut();
    // clear user data
    userDetails = null;
    // disconnect the database
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  // create starter info of the user to database
  checkUserInfo() async {
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    var userDoc = await databaseQuery.getUserInfoDocumentbyID(userEmail);
    // if the user is register for the first time
    if (userDoc.isEmpty == true) {
      // create starter user information
      CollectionReference createUser =
          FirebaseFirestore.instance.collection('UserInfo');
      createUser
          .doc(userEmail)
          .set({
            'likeAmount': 0,
            'recordAmount': 0,
            'photoURL': FirebaseAuth.instance.currentUser!.photoURL,
            'username': FirebaseAuth.instance.currentUser!.displayName,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }
  }

  // go to home page after login
  toHomePage(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
