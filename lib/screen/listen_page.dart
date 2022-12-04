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

// enum PlayerStateA { stoppedA, playingA, pausedA }
// enum PlayerStateBGM { stoppedBGM, playingBGM, pausedBGM }

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

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // for the first voice
  AudioPlayer audioPlayerA = AudioPlayer();
  // PlayerStateA playerStateA = PlayerStateA.stoppedA;
  // get isPlayingA => playerStateA == PlayerStateA.playingA;
  
  // for the BGM
  AudioPlayer audioPlayerBGM = AudioPlayer();
  // PlayerStateBGM playerStateBGM = PlayerStateBGM.stoppedBGM;
  // get isPlayingBGM => playerStateBGM == PlayerStateBGM.playingBGM;

  PlayerState playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();

    // Listen to states: playing, paused, stopped
    audioPlayerA.onPlayerStateChanged.listen((PlayerState s) {
      print('Current player state: $s');
      if (!mounted) return;
      setState(() => playerState = s);
    });

    // Listen to audio duration
    audioPlayerA.onDurationChanged.listen((Duration d) {
      //print('Max duration: $d');
      if (!mounted) return;
      setState(() => duration = d);
    });

    // Listen to audio position
    audioPlayerA.onPositionChanged.listen((Duration p) {
      //print('Current position: $p');
      if (!mounted) return;
      setState(() => position = p);
    });

    // Listen when audio complete
    audioPlayerA.onPlayerComplete.listen((event) {
      isPlaying = false;
      if (!mounted) return;
      setState(() {
        position = duration;
      });
    });
  }

  @override
  void dispose() {
    audioPlayerA.dispose();
    audioPlayerBGM.dispose();
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
                  final currentPosition = Duration(seconds: value.toInt());
                  await audioPlayerA.seek(currentPosition);
                  await audioPlayerBGM.seek(currentPosition);
                },
                activeColor: Colors.orangeAccent,
                inactiveColor: Colors.white,
                label: 'แถบเวลาของเสียงพากย์',
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
                    if (isPlaying == false) {
                      final storageRef = await FirebaseStorage.instance.ref();
                      final soundRefA = await storageRef.child(
                          listenList.audioFileName!); // <-- your file name
                      final soundRefBGM = await storageRef
                          .child("helloworld2.aac"); // <-- your file name
                      final metaDataA = await soundRefA.getDownloadURL();
                      final metaDataBGM = await soundRefBGM.getDownloadURL();
                      log('data: ${metaDataA.toString()}');
                      log('data: ${metaDataBGM.toString()}');
                      String urlA = metaDataA.toString();
                      String urlBGM = metaDataBGM.toString();
                      await audioPlayerA.setSourceUrl(urlA);
                      await audioPlayerBGM.setSourceUrl(urlBGM);
                      isPlaying = true;
                      play(urlA, urlBGM);
                    } else {
                      isPlaying = false;
                      pause();
                    }
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

  Future play(String urlA, String urlBGM) async {
    audioPlayerA.resume();
    audioPlayerBGM.resume();
    // setState(() {
    //   playerStateA = PlayerStateA.playingA;
    // });
    // setState(() {
    //   playerStateBGM = PlayerStateBGM.playingBGM;
    // });
  }

  Future pause() async {
    await audioPlayerA.pause();
    // setState(() {
    //   playerStateA = PlayerStateA.pausedA;
    // });
    await audioPlayerBGM.pause();
    // setState(() {
    //   playerStateBGM = PlayerStateBGM.pausedBGM;
    // });
  }
}
