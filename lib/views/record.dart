import 'package:flutter/material.dart';
import 'package:overvoice_project/views/recordButton.dart';

class Record extends StatefulWidget {
  Map<String, dynamic> detailList;
  String character;
  String docID;
  String characterimgURL;
  Record(this.detailList, this.character, this.characterimgURL, this.docID,
      {super.key});

  @override
  State<Record> createState() =>
      _RecordState(detailList, character, characterimgURL, docID);
}

class _RecordState extends State<Record> {
  Map<String, dynamic> detailList;
  String character;
  String characterimgURL;
  String docID;
  _RecordState(
      this.detailList, this.character, this.characterimgURL, this.docID);

  late List conversationList = detailList["conversation"].split(",");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          detailList["name"],
          style: TextStyle(fontWeight: FontWeight.bold),
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
        padding: EdgeInsets.only(top: 30, left: 20, right: 20),
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFFF7200),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 56,
              backgroundColor: Colors.white,
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(characterimgURL),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              character,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 300, // กรอบบท
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 20, left: 26, right: 26),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Conversation",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 60,
                    left: 10,
                    height: 200,
                    width: 330, // บท
                    child: Container(
                      height: 360,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFD4B2),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: ListView.builder(
                          itemCount: conversationList.length,
                          itemBuilder: (context, index) => ListTile(
                                title: Text(
                                  conversationList[index],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                    ))
              ],
            ),
            RecordButton(conversationList, docID),
          ],
        ),
      ),
    );
  }
}
