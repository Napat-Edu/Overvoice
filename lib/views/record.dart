import 'package:flutter/material.dart';

class Record extends StatefulWidget {
  Map<String, dynamic> detailList;
  String character;
  String characterimgURL;
  Record(this.detailList, this.character, this.characterimgURL, {super.key});

  @override
  State<Record> createState() => _RecordState(detailList, character, characterimgURL);
}

class _RecordState extends State<Record> {
  Map<String, dynamic> detailList;
  String character;
  String characterimgURL;
  _RecordState(this.detailList, this.character, this.characterimgURL);

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
                  backgroundImage: NetworkImage(
                      characterimgURL),
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
                  height: 450,
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
                    height: 380,
                    width: 352,
                    child: Container(
                      height: 360,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFD4B2),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                    ))
              ],
            ),
            SizedBox(height: 80,),
            SizedBox(
              width: 300,
              height: 44,
              child: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFFFF7200),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                onPressed: () {
                  //voiceover
                },
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
