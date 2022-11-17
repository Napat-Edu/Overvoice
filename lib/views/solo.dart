import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:overvoice_project/views/fullcon.dart';

class Solo extends StatefulWidget {
  Map<String, dynamic> detaillMap;
  Solo(this.detaillMap, {super.key});

  @override
  State<Solo> createState() => _SoloState(detaillMap);
}

class _SoloState extends State<Solo> {
  Map<String, dynamic> detaillMap;
  _SoloState(this.detaillMap);

  late final splitChar = detaillMap["character"].split(",");
  late final characterA = splitChar[0];
  late final characterB = splitChar[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          detaillMap["name"],
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
        padding: EdgeInsets.only(top: 40, left: 40, right: 40),
        height: 550,
        width: double.infinity,
        child: Container(
            child: Column(children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Container(
            child: Text(
              "Choose your character!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FullCon()));
                    },
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: Color(0xFFFFAA66),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 52,
                          backgroundImage: NetworkImage(
                              "https://i.pinimg.com/736x/c7/d9/b7/c7d9b73d08e64c9068262a665bd20f55.jpg"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  SizedBox(
                    width: 104,
                    height: 40,
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
                            MaterialPageRoute(builder: (context) => FullCon()));
                      },
                      child: Text(characterA),
                    ),
                  )
                ]),
              ),
              SizedBox(
                width: 50,
              ),
              Container(
                child: Column(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FullCon()));
                    },
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: Color(0xFFFFAA66),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 52,
                          backgroundImage: NetworkImage(
                              "https://i.pinimg.com/736x/47/4d/7e/474d7ec9389263bee0fd2ef328717aeb.jpg"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  SizedBox(
                    width: 104,
                    height: 40,
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
                            MaterialPageRoute(builder: (context) => FullCon()));
                      },
                      child: Text(characterB),
                    ),
                  )
                ]),
              )
            ],
          )
        ])),
      ),
    );
  }
}
