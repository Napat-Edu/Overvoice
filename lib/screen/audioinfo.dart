import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AudioInfo extends StatelessWidget {
  AudioInfo();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('AudioInfo');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc("SAO01").get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Character: ${data['character']}""\n""Detail: ${data['detail']}");
        }

        return Text("loading");
      },
    );
  }
}

// class AudioInfo extends StatefulWidget {
//   @override
//   _AudioInfo createState() => _AudioInfo();
// }

// class _AudioInfo extends State<AudioInfo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("คุณกำลังฟัง"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection("AudioInfo").snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return ListView(
//             children: snapshot.data!.docs.map((document) {
//               return Container(
//                 child: ListTile(
//                   title: Text(document["character"]),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
