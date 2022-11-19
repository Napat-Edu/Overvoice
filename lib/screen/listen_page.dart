import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer';

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

  String titleName, episode, duration, imgURL;

  ListenPage({
    super.key,
    required this.titleName,
    required this.episode,
    required this.duration,
    required this.imgURL,
  });

  @override
  State<ListenPage> createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
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
    return Scaffold(
      backgroundColor: const Color(0xFFFF7200),
      appBar: AppBar(
        title: Text(widget.titleName),
        backgroundColor: const Color(0xFFFF7200),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CircleAvatar(
                backgroundImage: Image.network(
                        "https://static.wikia.nocookie.net/versusprofiles/images/b/bc/Jotaro_Part_3.png/revision/latest?cb=20191027201937")
                    .image,
                radius: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "โจทาโร่",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 300,
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
                      final soundRef = await storageRef
                          .child("helloworld2.aac"); // <-- your file name
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
