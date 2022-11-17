import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:overvoice_project/views/voiceover.dart';

class FullCon extends StatefulWidget {
  const FullCon({super.key});

  @override
  State<FullCon> createState() => _FullConState();
}

class _FullConState extends State<FullCon> {
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
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFFF7200),
        child: Container(
          child: Column(children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.81,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Center(
                      child: Text(
                        "Full Conversation",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      height: 450,
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 20, left: 26, right: 26),
                      decoration: BoxDecoration(
                          color: Color(0xFFFF7200),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Full Conversation",
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "00:58 m",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: 100,
                        left: 10,
                        height: 340,
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
                SizedBox(
                  height: 55,
                ),
                SizedBox(
                  width: 250,
                  height: 44,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Color(0xFFFF7200),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => VoiceOver()));
                    },
                    child: const Text('Continue'),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
                  child: Center(
                    child:
                        Text("recording the full conversation from the start."),
                  ),
                )
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
