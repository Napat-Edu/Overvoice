import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';

class AudioPage extends StatefulWidget {
  const AudioPage(
      {super.key,
      required voice_id,
      required song_name,
      required episode,
      required image_url});

  String song_name, episode, voice_id, image_url;

  // AudioPage(
  //     {required this.song_name,
  //     required this.episode,
  //     required this.voice_id,
  //     required this.image_url});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  MusicPlayer musicPlayer;
  bool isplaying = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Initializing the Music Player and adding a single [PlaylistItem]
  Future<void> initPlatformState() async {
    musicPlayer = MusicPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("overvoice listening ..."),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Text(
            widget.song_name,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.song_name,
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          Card(
            child: Image.network(
              widget.image_url,
              height: 350.0,
            ),
            elevation: 10.0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.2,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 100.0,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isplaying = true;
                    });

                    musicPlayer.play(MusicItem(
                      trackName: '',
                      albumName: '',
                      artistName: '',
                      url: widget.voice_id,
                      coverUrl: '',
                      duration: Duration(seconds: 255),
                    ));
                  },
                  child: Icon(
                    Icons.play_arrow,
                    size: 50.0,
                    color: isplaying == true ? Colors.blue : Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isplaying = false;
                    });
                    musicPlayer.pause();
                  },
                  child: Icon(
                    Icons.stop,
                    size: 50.0,
                    color: isplaying == true ? Colors.black : Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                width: 100.0,
              ),
            ],
          )
        ],
      )),
    );
  }
}
