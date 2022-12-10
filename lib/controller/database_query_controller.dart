import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseQuery {
  // read user document from database
  Future<Map<String, dynamic>> getUserInfoDocumentbyID(String userDocID) async {
    var collection = FirebaseFirestore.instance.collection('UserInfo');
    var docSnapshot = await collection.doc(userDocID).get();
    return docSnapshot.data()!;
  }

  // read audio collection from database
  Future<QuerySnapshot<Map<String, dynamic>>> getAudioCollection() async {
    var collection =
        await FirebaseFirestore.instance.collection('AudioInfo').get();
    return collection;
  }

  // read audio document from database
  Future<Map<String, dynamic>> getAudioDocumentbyID(String docID) async {
    var dataDoc = await FirebaseFirestore.instance
        .collection('AudioInfo')
        .doc(docID)
        .get();
    Map<String, dynamic> fieldMap = dataDoc.data()!;
    return fieldMap;
  }

  // read history data from database with condition for get just people who can be user buddy
  Future<QuerySnapshot<Object>> getHistoryBuddyList(
      String docID, String character) async {
    return await FirebaseFirestore.instance
        .collection("History")
        .where("audioInfo", isEqualTo: docID)
        .where("characterInit", isNotEqualTo: character)
        .where("status", isEqualTo: false)
        .get();
  }

  // upload file to database and save history
  Future uploadFile(
      file, String voiceName, String docID, String character) async {
    final storageRef = FirebaseStorage.instance.ref();
    final soundRef = storageRef.child(voiceName);

    await soundRef.putFile(file);

    // checking that this audio dubbing is already completed or not
    bool isAudioComplete = true;
    if (character != "singleDub") {
      isAudioComplete = false;
    }

    // create if start a new dubbing
    // update if there is a pair dubbing case
    if (character != "pairDub") {
      await createHistory(voiceName, docID, character, isAudioComplete);
    } else {
      await updateBuddy(voiceName, docID);
    }

    // increse record amount of user by 1
    CollectionReference usersInfo =
        FirebaseFirestore.instance.collection('UserInfo');
    usersInfo.doc(FirebaseAuth.instance.currentUser!.email).update({
      "recordAmount": FieldValue.increment(1),
    });
  }

  // create new history document
  createHistory(
      String voiceName, String docID, String character, bool isAudioComplete) {
    CollectionReference usersHistory =
        FirebaseFirestore.instance.collection('History');
    usersHistory
        .doc()
        .set({
          'audioInfo': docID,
          'sound_1': voiceName,
          'sound_2': "",
          'status': isAudioComplete,
          'user_1': FirebaseAuth.instance.currentUser!.email,
          'user_2': "",
          'characterInit': character
        })
        .then((value) => print("History Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // update buddy for dubing audio
  updateBuddy(String voiceName, String hisID) async {
    CollectionReference usersHistory =
        FirebaseFirestore.instance.collection('History');
    usersHistory
        .doc(hisID)
        .update({
          "sound_2": voiceName,
          "status": true,
          "user_2": FirebaseAuth.instance.currentUser!.email,
        })
        .then((value) => print("History Updated"))
        .catchError((error) => print("Failed to update: $error"));
  }
}
