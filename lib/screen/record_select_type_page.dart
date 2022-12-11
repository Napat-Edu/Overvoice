import 'package:flutter/material.dart';
import 'package:overvoice_project/model/constant_value.dart';
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
  ConstantValue constantValue = ConstantValue();

  @override
  Widget build(BuildContext context) {

    // core UI
    return Scaffold(
      appBar: AppBar(
        title: Text(
          detaillMap["name"],
          style: GoogleFonts.prompt(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF7200),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
        height: constantValue.getScreenHeight(context) / 1.6,
        width: double.infinity,
        child: Container(
            child: Column(children: <Widget>[
          SizedBox(
            height: constantValue.getScreenHeight(context) / 8.9,
          ),
          Container(
            child: Text(
              "เลือกรูปแบบการพากย์ของคุณ",
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.prompt(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          SizedBox(
            height: constantValue.getScreenHeight(context) / 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                // start new dubbing section type
                child: Column(children: [
                  RawMaterialButton(
                    onPressed: () {
                      toSelectCharacterPage(!isPairBuddyMode);
                    },
                    elevation: 2.0,
                    fillColor: const Color(0xFFFF7200),
                    child: const Icon(Icons.person,
                        size: 74.0, color: Colors.white),
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                  ),
                  SizedBox(
                    height: constantValue.getScreenHeight(context) / 48,
                  ),
                  SizedBox(
                    width: constantValue.getScreenWidth(context) / 3.4,
                    height: constantValue.getScreenHeight(context) / 22,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.prompt(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        toSelectCharacterPage(!isPairBuddyMode);
                      },
                      child: const Text('เริ่มพากย์ใหม่'),
                    ),
                  )
                ]),
              ),
              SizedBox(
                width: constantValue.getScreenWidth(context) / 10,
              ),
              Container(
                // pair buddy dubbing section type
                child: Column(children: [
                  RawMaterialButton(
                    onPressed: () {
                      toSelectCharacterPage(isPairBuddyMode);
                    },
                    elevation: 2.0,
                    fillColor: const Color(0xFFFF7200),
                    child: Icon(Icons.people, size: 74.0, color: Colors.white),
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                  ),
                  SizedBox(
                    height: constantValue.getScreenHeight(context) / 48,
                  ),
                  SizedBox(
                    width: constantValue.getScreenWidth(context) / 3.4,
                    height: constantValue.getScreenHeight(context) / 22,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.prompt(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        toSelectCharacterPage(isPairBuddyMode);
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

  // go to select character page
  toSelectCharacterPage(bool isPairBuddyMode) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                (SelectCharacter(detaillMap, docID, isPairBuddyMode))));
  }
}
