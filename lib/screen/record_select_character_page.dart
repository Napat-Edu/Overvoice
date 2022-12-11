import 'package:flutter/material.dart';
import 'package:overvoice_project/model/constant_value.dart';
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

  ConstantValue constantValue = ConstantValue();

  @override
  Widget build(BuildContext context) {

    // core UI
    return Scaffold(
      appBar: AppBar(
        title: Text(
          detaillMap["name"],
          style: GoogleFonts.prompt(fontWeight: FontWeight.w600),
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
        height: constantValue.getScreenHeight(context) / 1.6,
        width: double.infinity,
        child: Container(
            child: Column(children: <Widget>[
          SizedBox(
            height: constantValue.getScreenHeight(context) / 8.9,
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
            height: constantValue.getScreenHeight(context) / 30,
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
                    height: constantValue.getScreenHeight(context) / 49,
                  ),
                  SizedBox(
                    width: constantValue.getScreenWidth(context) / 3.4,
                    height: constantValue.getScreenHeight(context) / 22,
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
                width: constantValue.getScreenWidth(context) / 10,
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
                    height: constantValue.getScreenHeight(context) / 49,
                  ),
                  SizedBox(
                    width: constantValue.getScreenWidth(context) / 3.4,
                    height: constantValue.getScreenHeight(context) / 22,
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
