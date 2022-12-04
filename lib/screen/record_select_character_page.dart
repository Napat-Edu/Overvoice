import 'package:flutter/material.dart';
import 'package:overvoice_project/screen/record_page.dart';

class Solo extends StatefulWidget {
  Map<String, dynamic> detaillMap;
  String docID;
  Solo(this.detaillMap, this.docID, {super.key});

  @override
  State<Solo> createState() => _SoloState(detaillMap, docID);
}

class _SoloState extends State<Solo> {
  Map<String, dynamic> detaillMap;
  String docID;
  _SoloState(this.detaillMap, this.docID);

  late final splitChar = detaillMap["character"].split(",");
  late final characterA = splitChar[0];
  late final characterB = splitChar[1];

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
        height: screenHeight / 1.6,
        width: double.infinity,
        child: Container(
            child: Column(children: <Widget>[
          SizedBox(
            height: screenHeight / 8.9,
          ),
          Container(
            child: Text(
              "เลือกตัวละครที่คุณต้องการพากย์",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ),
          SizedBox(
            height: screenHeight / 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Record(
                                  detaillMap,
                                  characterA,
                                  detaillMap["characterImageA"],
                                  docID)));
                    },
                    child: CircleAvatar(
                      radius: 54,
                      backgroundColor: Color(0xFFFFAA66),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(detaillMap["characterImageA"]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 49,
                  ),
                  SizedBox(
                    width: screenWidth / 3.4,
                    height: screenHeight / 20.5,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Record(
                                    detaillMap,
                                    characterA,
                                    detaillMap["characterImageA"],
                                    docID)));
                      },
                      child: Text(characterA),
                    ),
                  )
                ]),
              ),
              SizedBox(
                width: screenWidth / 10,
              ),
              Container(
                child: Column(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Record(
                                  detaillMap,
                                  characterB,
                                  detaillMap["characterImageB"],
                                  docID)));
                    },
                    child: CircleAvatar(
                      radius: 54,
                      backgroundColor: Color(0xFFFFAA66),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(detaillMap["characterImageB"]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 49,
                  ),
                  SizedBox(
                    width: screenWidth / 3.4,
                    height: screenHeight / 20.5,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Record(
                                    detaillMap,
                                    characterB,
                                    detaillMap["characterImageB"],
                                    docID)));
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
