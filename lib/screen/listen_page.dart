import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer';

import 'package:overvoice_project/model/listen_detail.dart';

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
  // log('data: $metadata');

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
    super.dispose();
  }

// body: Center(
//           child: Text(widget.titleName),
//         ),

  @override
  Widget build(BuildContext context) {
    late List conversationList = detailList["conversation"].split(",");

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
                    backgroundImage: NetworkImage(detailList["coverimg"]),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "พากย์เสียงโดย ${listenList.userName!}",
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
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);

                  // Play audio if was pa
                  await audioPlayer.resume();
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
                radius: 30,
                child: IconButton(
                  icon: Icon(
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
                ),
              ),
            ],
          )),
    );
  }
}
