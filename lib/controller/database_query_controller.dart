import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<QuerySnapshot<Object>> getHistoryBuddyList(String docID, String character) async {
    return await FirebaseFirestore.instance
        .collection("History")
        .where("audioInfo", isEqualTo: docID)
        .where("characterInit", isNotEqualTo: character)
        .where("status", isEqualTo: false)
        .get();
  }
}
