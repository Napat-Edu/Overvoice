import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:overvoice_project/views/start.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Container(
              child: Container(
                child: Image.network(
                    "https://static.wikia.nocookie.net/swordartonline/images/3/32/Honeymoon_BD.png/revision/latest?cb=20130202031355",
                    color: Colors.black.withOpacity(0.3),
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.darken),
                width: double.infinity,
                height: 250,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 40, right: 40),
              height: 550,
              child: Column(children: <Widget>[
                Container(
                  child: Text(
                    "Sword Art Online",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  child: Text(
                    "Episode : 6",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Container(
                  child: Text(
                    "Character : Kirito & Asuna",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 150,
                  child: Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  child: Text(
                    "00:58 m",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 200,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Color(0xFFFF7200),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                        onPressed: () {},
                        child: const Text('Listen'),
                      ),
                    ),
                    SizedBox(
                      width: 55,
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Color(0xFFFF7200),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Start()));
                        },
                        child: const Text('Start'),
                      ),
                    )
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
