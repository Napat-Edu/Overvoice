// currently not used
import 'package:flutter/material.dart';
class VoiceOver extends StatefulWidget {
  const VoiceOver({super.key});

  @override
  State<VoiceOver> createState() => _VoiceOverState();
}

class _VoiceOverState extends State<VoiceOver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sword Art Online",
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
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFFF7200),
        child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            "Prepare for recording your voice!",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 56,
            backgroundColor: Colors.white,
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage(
                    "https://i.pinimg.com/736x/c7/d9/b7/c7d9b73d08e64c9068262a665bd20f55.jpg"),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "Kirito",
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          SizedBox(
            height: 510,
          ),
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
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Record()));
              },
              child: const Text('Record Full Conversation'),
            ),
          ),
        ]),
      ),
    );
  }
}
