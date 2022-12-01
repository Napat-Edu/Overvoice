import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer';
import 'package:overvoice_project/model/listen_detail.dart';
import 'package:overvoice_project/screen/noInternet_page.dart';

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(':');
}

class ListenPage extends StatefulWidget {
  // const ListenPage({super.key, required titleName});

  Map<String, dynamic> detailList;
  ListenDetails listenList;

  ListenPage(this.detailList, this.listenList, {super.key});

  @override
  State<ListenPage> createState() => _ListenPageState(detailList, listenList);
}

class _ListenPageState extends State<ListenPage> {
  Map<String, dynamic> detailList;
  ListenDetails listenList;
  _ListenPageState(this.detailList, this.listenList);

  final audioPlayer = AudioPlayer();
  final audioPlayer2 = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen to states: playing, paused, stopped
    audioPlayer.onDurationChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    // Listen to states: playing, paused, stopped
    audioPlayer2.onDurationChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    // Listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // Listen to audio position
    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioPlayer2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late List conversationList = detailList["conversation"].split(",");
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
                    backgroundImage: NetworkImage(detailList["coverimg"]),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight / 80,
              ),
              Text(
                "พากย์เสียงโดย ${listenList.userName!}",
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
                    height: screenHeight / 2.4, // กรอบบท
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
                            "บทที่ทำการพากย์",
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
                      height: screenHeight / 3,
                      width: screenWidth / 1.17, // บท
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
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )),
                      ))
                ],
              ),
              SizedBox(
                height: screenHeight / 300,
              ),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                  await audioPlayer2.seek(position);

                  // Play audio if was pa
                  await audioPlayer.resume();
                  await audioPlayer2.resume();
                },
                activeColor: Colors.orangeAccent,
                inactiveColor: Colors.white,
                label: 'Set volume value',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTime(position),
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      formatTime(duration - position),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: screenWidth / 16,
                child: IconButton(
                  icon: Icon(
                    size: screenWidth / 13,
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.orange,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      final storageRef = await FirebaseStorage.instance.ref();
                      final soundRef = await storageRef.child(
                          listenList.audioFileName!); // <-- your file name
                      final soundRef2 = await storageRef
                          .child("helloworld2.aac"); // <-- your file name
                      final metaData = await soundRef.getDownloadURL();
                      final metaData2 = await soundRef2.getDownloadURL();
                      log('data: ${metaData.toString()}');
                      log('data: ${metaData2.toString()}');
                      String url = metaData.toString();
                      String url2 = metaData2.toString();
                      await audioPlayer.play(url);
                      await audioPlayer2.play(url2);
                    }
                    //
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                ),
              ),
              SizedBox(
                height: screenHeight / 30,
              ),
              // SizedBox(
              //   width: screenWidth / 1.4,
              //   height: screenHeight / 20,
              //   child: TextButton(
              //     style: TextButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(5)),
              //         backgroundColor: Colors.white,
              //         foregroundColor: Color(0xFFFF7200),
              //         textStyle: const TextStyle(
              //             fontSize: 20, fontWeight: FontWeight.w600)),
              //     onPressed: () {},
              //     child: const Text('Continue'),
              //   ),
              // ),
            ],
          )),
    );
  }
}
