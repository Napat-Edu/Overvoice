import 'package:flutter/material.dart';
import 'package:overvoice_project/screen/record_duo_page.dart';
import 'package:overvoice_project/screen/record_select_character_page.dart';
import 'package:google_fonts/google_fonts.dart';


class SelectDuoRecordType extends StatefulWidget {
  Map<String, dynamic> detaillMap;
  String docID;
  SelectDuoRecordType(this.detaillMap, this.docID, {super.key});

  @override
  State<SelectDuoRecordType> createState() =>
      _SelectDuoRecordTypeState(detaillMap, docID);
}

class _SelectDuoRecordTypeState extends State<SelectDuoRecordType> {
  Map<String, dynamic> detaillMap;
  String docID;
  _SelectDuoRecordTypeState(this.detaillMap, this.docID);

  bool isPairBuddyMode = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          detaillMap["name"],
          style: GoogleFonts.prompt(fontWeight: FontWeight.bold),
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
              "เลือกรูปแบบการพากย์ของคุณ",
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 19),
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
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  (SelectCharacter(detaillMap, docID, !isPairBuddyMode))));
                    },
                    elevation: 2.0,
                    fillColor: Color(0xFFFF7200),
                    child: Icon(Icons.person, size: 74.0, color: Colors.white),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                  SizedBox(
                    height: screenHeight / 48,
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
                          textStyle: GoogleFonts.prompt(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    (SelectCharacter(detaillMap, docID, !isPairBuddyMode))));
                      },
                      child: const Text('เริ่มพากย์ใหม่'),
                    ),
                  )
                ]),
              ),
              SizedBox(
                width: screenWidth / 10,
              ),
              Container(
                child: Column(children: [
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  (SelectCharacter(detaillMap, docID, isPairBuddyMode))));
                    },
                    elevation: 2.0,
                    fillColor: Color(0xFFFF7200),
                    child: Icon(Icons.people, size: 74.0, color: Colors.white),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                  SizedBox(
                    height: screenHeight / 48,
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
                          textStyle: GoogleFonts.prompt(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    (SelectCharacter(detaillMap, docID, isPairBuddyMode))));
                      },
                      child: const Text('จับคู่พากย์'),
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
