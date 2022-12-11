import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overvoice_project/model/constant_value.dart';
import 'package:overvoice_project/model/listen_detail.dart';
import 'package:overvoice_project/screen/record_duo_page.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/database_query_controller.dart';

class SelectBuddy extends StatefulWidget {
  Map<String, dynamic> detailList;
  String docID;
  String character;
  SelectBuddy(this.detailList, this.docID, this.character, {super.key});

  @override
  State<SelectBuddy> createState() =>
      _SelectBuddyState(detailList, docID, character);
}

class _SelectBuddyState extends State<SelectBuddy> {
  Map<String, dynamic> detailList;
  String docID;
  String character;
  _SelectBuddyState(this.detailList, this.docID, this.character);

  List<ListenDetails> listenList = [];
  List<String> hisID = [];
  DatabaseQuery databaseQuery = DatabaseQuery();
  ConstantValue constantValue = ConstantValue();

  @override
  Widget build(BuildContext context) {

    // core UI
    return Scaffold(
      appBar: AppBar(
        title: Text(
          detailList["name"],
          style: GoogleFonts.prompt(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF7200),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(5),
              child: SizedBox(
                width: constantValue.getScreenWidth(context),
                height: constantValue.getScreenHeight(context) / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: Image.network(
                    detailList["coverimg"],
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.2),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Color(0xFFFF7200),
                    child: Container(
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          const Expanded(
                              child: Icon(
                            Icons.thumb_up_alt_sharp,
                            color: Colors.white,
                          )),
                          Expanded(
                              flex: 4,
                              child: Text(
                                "คุณอยากจับคู่กับใครล่ะ",
                                style: GoogleFonts.prompt(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )),
                          SizedBox(
                            width: constantValue.getScreenWidth(context) / 3,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constantValue.getScreenHeight(context) / 200,
            ),
            Expanded(
              child: FutureBuilder<Widget>(
                future: getDataUI(docID),
                builder:
                    ((BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  }

                  return const Center(
                    child: Text("กำลังโหลด..."),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  // generate UI and waiting for data
  Future<Widget> getDataUI(String docID) async {
    listenList = await getBuddyList(docID, character);
    return Future.delayed(const Duration(seconds: 0), () {
      return listenList.isEmpty
          ? Center(
              child: Text(
                "ยังไม่เคยมีใครพากย์เลย\nคุณคงต้องเป็นคนแรกแล้วล่ะ",
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(
                    fontSize: 17, fontWeight: FontWeight.w600),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => const Divider(
                    color: Color(0xFFFFAA66),
                  ),
              itemCount: listenList.length,
              itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      radius: 27,
                      backgroundColor: Color(0xFFFFAA66),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(listenList[index].imgURL!),
                        ),
                      ),
                    ),
                    title: Text(
                      listenList[index].userName!,
                      style: GoogleFonts.prompt(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    // change like count under title to buddy acount name
                    trailing: TextButton(
                      style: TextButton.styleFrom(
                          fixedSize: const Size(10, 10),
                          backgroundColor: const Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.prompt(fontSize: 15)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordDuo(
                                    detailList,
                                    character,
                                    listenList[index],
                                    docID,
                                    hisID[index])));
                      },
                      child: const Text('เล่น'),
                    ),
                  ));
    });
  }

  // use for read data from history to get list of buddy that can pair up with
  Future<List<ListenDetails>> getBuddyList(
      String docID, String character) async {
    String yourID = FirebaseAuth.instance.currentUser!.email!;
    QuerySnapshot querySnapshot =
        await databaseQuery.getHistoryBuddyList(docID, character);

    List<ListenDetails> listenList = [];
    await Future.forEach(querySnapshot.docs, (doc) async {
      if (doc["user_1"] != yourID) {
        hisID.add(doc.id);
        Map<String, dynamic>? data =
            await databaseQuery.getUserInfoDocumentbyID(doc["user_1"]);
        listenList.add(ListenDetails(
          data["username"],
          "คุณ",
          "",
          data["photoURL"],
          doc["sound_1"],
          doc["sound_2"],
        ));
      }
    });

    return listenList;
  }
}
