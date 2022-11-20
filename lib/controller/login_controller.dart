import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:overvoice_project/model/user_detail.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginController with ChangeNotifier {
  //object
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserDetails? userDetails;
  User? user;

  //google log-in function
  googleLogin() async {
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
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  checkUserInfo() async {
    FirebaseFirestore.instance
    .collection('UserInfo')
    .doc(await FirebaseAuth.instance.currentUser!.email)
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists == false) {
        CollectionReference users = FirebaseFirestore.instance.collection('UserInfo');
        users
          .add({
            'caption': "ยังไม่มีคำอธิบายโปรไฟล์",
            'likeAmount': "0",
            'recordAmount': "0",
            'photoURL': FirebaseAuth.instance.currentUser!.photoURL,
            'username': FirebaseAuth.instance.currentUser!.displayName,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }
}
