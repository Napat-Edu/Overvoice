import 'package:flutter/material.dart';
import 'package:overvoice_project/screen/record_page.dart';
import 'package:overvoice_project/screen/record_select_buddy_page.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectCharacter extends StatefulWidget {
  Map<String, dynamic> detaillMap;
  String docID;
  bool isPairBuddyMode;

  SelectCharacter(this.detaillMap, this.docID, this.isPairBuddyMode,
      {super.key});

  @override
  State<SelectCharacter> createState() =>
      _SelectCharacterState(detaillMap, docID, isPairBuddyMode);
}

class _SelectCharacterState extends State<SelectCharacter> {
  Map<String, dynamic> detaillMap;
  String docID;
  bool isPairBuddyMode;
  _SelectCharacterState(this.detaillMap, this.docID, this.isPairBuddyMode);

  // seperate character name
  late final splitChar = detaillMap["character"].split(",");
  late final characterA = splitChar[0];
  late final characterB = splitChar[1];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // core UI
    return Scaffold(
      appBar: AppBar(
        title: Text(
          detaillMap["name"],
          style: GoogleFonts.prompt(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF7200),
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
              style:
                  GoogleFonts.prompt(fontWeight: FontWeight.w600, fontSize: 18),
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
                      checkAudioAmount(
                          characterA, detaillMap["characterImageA"]);
                    },
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Color(0xFFFFAA66),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 48,
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
                    height: screenHeight / 22,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.prompt(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        checkAudioAmount(
                            characterA, detaillMap["characterImageA"]);
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
                      checkAudioAmount(
                          characterB, detaillMap["characterImageB"]);
                    },
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Color(0xFFFFAA66),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 48,
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
                    height: screenHeight / 22,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.prompt(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        checkAudioAmount(
                            characterB, detaillMap["characterImageB"]);
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

  // use for check this audio to see that is 1 or 2 characer type
  checkAudioAmount(String character, String characterImageURL) {
    if (detaillMap["voiceoverAmount"] == "1" || isPairBuddyMode == false) {
      // 1 character
      toRecordPage(character, characterImageURL);
    } else {
      // 2 character
      toSelectBuddyPage(character);
    }
  }

  // go to record page
  toRecordPage(String character, String characterImageURL) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Record(detaillMap, character, characterImageURL, docID)));
  }

  // go to select buddy page
  toSelectBuddyPage(String character) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectBuddy(detaillMap, docID, character)));
  }
}
