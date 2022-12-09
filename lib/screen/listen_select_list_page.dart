import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overvoice_project/model/listen_detail.dart';
import 'listen_page.dart';
import 'package:google_fonts/google_fonts.dart';

class Listen extends StatefulWidget {
  Map<String, dynamic> detailList;
  String docID;
  Listen(this.detailList, this.docID, {super.key});

  @override
  State<Listen> createState() => _ListenState(detailList, docID);
}

class _ListenState extends State<Listen> {
  Map<String, dynamic> detailList;
  String docID;
  _ListenState(this.detailList, this.docID);

  List<ListenDetails> listenList = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          detailList["name"],
          style: GoogleFonts.prompt(fontWeight: FontWeight.w600),
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
                          flex: 4,
                          child: Text(
                            "เลือกฟังได้เลย",
                            style: GoogleFonts.prompt(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )),
                      SizedBox(
                        width: screenWidth / 3,
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

                  return Center(
                    child: Text(
                      "กำลังโหลด...",
                      style: GoogleFonts.prompt(),
                    ),
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
    listenList = await getHistoryList(docID, detailList);
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
                          // for 2 character
                          child:
                              getDuoProfileImage(detailList, listenList[index]),
                        ),
                      ),
                    ),
                    title: Text(
                      '${listenList[index].userName!}',
                      style: GoogleFonts.prompt(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    // like count under title
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          displaySubtitleText(detailList, index),
                          style: GoogleFonts.prompt(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black38),
                        )
                      ],
                    ),
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
                                builder: (context) =>
                                    ListenPage(detailList, listenList[index])));
                      },
                      child: const Text('เล่น'),
                    ),
                  ));
    });
  }

  Widget? getDuoProfileImage(
      Map<String, dynamic> detailList, ListenDetails listenList) {
    if (detailList["voiceoverAmount"] == "2") {
      return Align(
        alignment: Alignment.bottomRight,
        child: CircleAvatar(
          radius: 12,
          backgroundColor: const Color(0xFFFF9900),
          child: Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 11,
              backgroundImage: NetworkImage(listenList.imgURLBuddy!),
            ),
          ),
        ),
      );
    } else {
      return null;
    }
  }

  String displaySubtitleText(Map<String, dynamic> detailList, int index) {
    if (detailList["voiceoverAmount"] == "2") {
      return "พากย์คู่กับ ${listenList[index].userNameBuddy}";
    }
    return "ผลงานพากย์เดี่ยว";
  }

  Future<List<ListenDetails>> getHistoryList(
      String docID, Map<String, dynamic> detailList) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('History')
        .where('audioInfo', isEqualTo: docID)
        .where('status', isEqualTo: true)
        .get();

    List<ListenDetails> listenList = [];
    String buddyName = "";
    String buddyImage = "";
    await Future.forEach(querySnapshot.docs, (doc) async {
      Map<String, dynamic>? data = await getUserInfo(doc["user_1"]);
      if (detailList["voiceoverAmount"] == "2") {
        Map<String, dynamic>? user2Data = await getUserInfo(doc["user_2"]);
        buddyName = user2Data!["username"];
        buddyImage = user2Data["photoURL"];
      }
      listenList.add(ListenDetails(
        data!["username"],
        buddyName,
        buddyImage,
        data["photoURL"],
        doc["sound_1"],
        doc["sound_2"],
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
