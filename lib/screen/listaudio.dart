import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overvoice_project/screen/Audiopage.dart';

class ListAudio extends StatefulWidget {
  const ListAudio({super.key});

  @override
  State<ListAudio> createState() => _ListAudioState();
}

class _ListAudioState extends State<ListAudio> {
  // getdata from collection
  Future getdata() async {
    QuerySnapshot datastore =
        await FirebaseFirestore.instance.collection("AudioInfo").get();
    return datastore.documents;
  }

// List song UI
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getdata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AudioPage(
                                song_name: snapshot.data[index].data["name"],
                                episode: snapshot.data[index].data["episode"],
                                voice_id: snapshot.data[index].data["voice_id"],
                                image_url: snapshot.data[index].data["img"],
                              ))),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapshot.data[index].data["name"],
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    elevation: 10.0,
                  ),
                );
              });
        }
      },
    );
  }
}
