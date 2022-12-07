import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overvoice_project/model/listen_detail.dart';
import 'package:overvoice_project/screen/record_duo_page.dart';
import 'listen_page.dart';
import 'package:google_fonts/google_fonts.dart';


class SelectBuddy extends StatefulWidget {
  Map<String, dynamic> detailList;
  String docID;
  String character;
  SelectBuddy(this.detailList, this.docID, this.character, {super.key});

  @override
  State<SelectBuddy> createState() => _SelectBuddyState(detailList, docID, character);
}

class _SelectBuddyState extends State<SelectBuddy> {
  Map<String, dynamic> detailList;
  String docID;
  String character;
  _SelectBuddyState(this.detailList, this.docID, this.character);

  List<ListenDetails> listenList = [];
  List<String> hisID = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          detailList["name"],
          style: GoogleFonts.prompt(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF7200),
        leading: IconButton(
          icon: Icon(
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
              margin: EdgeInsets.all(5),
              child: SizedBox(
                width: screenWidth,
                height: screenHeight / 4,
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
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Icon(
                        Icons.thumb_up_alt_sharp,
                        color: Colors.white,
                      )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            "แนะนำสำหรับคุณ",
                            style: GoogleFonts.prompt(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )),
                      SizedBox(
                        width: 180,
                      )
                    ]),
                  ),
                )
              ],
            )),
            SizedBox(
              height: screenHeight / 200,
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

  Future<Widget> getDataUI(String docID) async {
    listenList = await getHistoryList(docID, character);
    return Future.delayed(const Duration(seconds: 0), () {
      return listenList.isEmpty
          ? Center(
              child: Text(
                "ยังไม่เคยมีใครพากย์เลย\nคุณคงต้องเป็นคนแรกแล้วล่ะ",
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.w700),
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
                      radius: 28,
                      backgroundColor: Color(0xFFFFAA66),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 26,
                          backgroundImage:
                              NetworkImage(listenList[index].imgURL!),
                        ),
                      ),
                    ),
                    title: Text(
                      ' ${listenList[index].userName!}',
                      style: GoogleFonts.prompt(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    // change like count under title to buddy acount name
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //   Icons.favorite,
                        //   size: 18,
                        // ),
                        // Text(' ${listenList[index].likeCount!}'),
                      ],
                    ),
                    trailing: TextButton(
                      style: TextButton.styleFrom(
                          fixedSize: const Size(10, 10),
                          backgroundColor: const Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.prompt(fontSize: 16)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RecordDuo(detailList, character, listenList[index], docID, hisID[index])));
                      },
                      child: const Text('เล่น'),
                    ),
                  ));
    });
  }

  Future<List<ListenDetails>> getHistoryList(String docID, String character) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("History")
        .where("audioInfo", isEqualTo: docID)
        .where("status", isEqualTo: false)
        .where("characterInit", isNotEqualTo: character)
        .get();

    List<ListenDetails> listenList = [];
    await Future.forEach(querySnapshot.docs, (doc) async {
      hisID.add(doc.id);
      Map<String, dynamic>? data = await getUserInfo(doc["user_1"]);
      listenList.add(ListenDetails(
        data!["username"],
        doc["likeCount"].toString(),
        data["photoURL"],
        doc["sound_1"],
      ));
    });

    return listenList;
  }

  getUserInfo(String userDocID) async {
    var collection = FirebaseFirestore.instance.collection('UserInfo');
    var docSnapshot = await collection.doc(userDocID).get();
    return docSnapshot.data();
  }
}
