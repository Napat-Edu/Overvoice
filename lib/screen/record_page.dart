import 'package:flutter/material.dart';
import 'package:overvoice_project/controller/recordButton_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';

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

  final audioPlayer = AudioPlayer();
  late List conversationList = detailList["conversation"].split(",");
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    // Listen to states: playing, paused, stopped
    audioPlayer.onDurationChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
        padding: EdgeInsets.only(top: screenHeight / 30, left: 20, right: 20),
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFFF7200),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: screenWidth / 7.3,
              backgroundColor: Colors.white,
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: screenWidth / 7.9,
                  backgroundImage: NetworkImage(characterimgURL),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight / 80,
            ),
            Text(
              character,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(
              height: screenHeight / 40,
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: screenHeight / 2.1, // กรอบบท
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      top: screenHeight / 44.5, left: 26, right: 26),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "บทพูด",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 49,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: screenHeight / 15,
                    left: screenWidth / 43,
                    height: screenHeight / 2.52,
                    width: screenWidth / 1.17, // บท
                    child: Container(
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
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                    ))
              ],
            ),
            SizedBox(
              height: screenHeight / 30,
            ),
            RecordButton(conversationList, docID),
            SizedBox(
              height: screenHeight / 50,
            ),
            SizedBox(
              width: screenWidth / 1.4,
              height: screenHeight / 20,
              child: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Color(0xFFFB8C00),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    final storageRef = await FirebaseStorage.instance.ref();
                    final soundRef = await storageRef.child(
                        "helloworld2.aac"); // <-- your file name // listenList.audioFileName!
                    final metaData = await soundRef.getDownloadURL();
                    log('data: ${metaData.toString()}');
                    String url = metaData.toString();

                    await audioPlayer.play(url);
                  }
                  //
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
                child: const Text('ฟังตัวอย่างการพากย์'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
