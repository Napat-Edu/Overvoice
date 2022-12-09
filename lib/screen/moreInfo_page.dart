import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overvoice_project/screen/record_page.dart';
import 'package:overvoice_project/screen/record_select_type_page.dart';
import '../controller/database_query_controller.dart';
import 'listen_select_list_page.dart';

class MoreInfo extends StatefulWidget {
  String docID;
  MoreInfo(this.docID, {super.key});

  @override
  State<MoreInfo> createState() => _MoreInfoState(docID);
}

class _MoreInfoState extends State<MoreInfo> {
  String docID;
  _MoreInfoState(this.docID);

  DatabaseQuery databaseQuery = DatabaseQuery();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // core UI
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: FutureBuilder<Widget>(
          // generate UI and waiting for data rom database
          future: getData(),
          builder: ((BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }

            return Center(
              child: Text(
                "กำลังโหลด...",
                style: GoogleFonts.prompt(),
              ),
            );
          }),
        ),
      ),
    );
  }

  // use for read data from database and waiting for data
  Future<Widget> getData() async {
    // read data and collect in list
    Map<String, dynamic>? detailList =
        await databaseQuery.getAudioDocumentbyID(docID);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // return UI with data in list
    return Future.delayed(const Duration(seconds: 0), () {
      return Column(
        children: <Widget>[
          SizedBox(
            height: screenHeight / 35.6,
          ),
          Container(
            child: Container(
              width: double.infinity,
              height: screenHeight / 3.56,
              child: Image.network(detailList["coverimg"],
                  color: Colors.black.withOpacity(0.3),
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.darken),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 40, right: 40),
            height: screenHeight / 1.6,
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    // audio name
                    detailList["name"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                        fontSize: 21, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 100,
                ),
                Container(
                  child: Text(
                    // caption of audio episode
                    detailList['episode'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 99,
                ),
                Container(
                  // character of audio
                  child: Text(
                    "${detailList['voiceoverAmount']} ตัวละคร : ${detailList['character']}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 50,
                ),
                Container(
                  height: screenHeight / 4.5,
                  // description of audio
                  child: Text(
                    "${detailList['detail']}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 100,
                ),
                Container(
                  // duration time of audio
                  child: Text(
                    "${detailList['duration']} m",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.black45),
                  ),
                ),
                SizedBox(
                  height: screenHeight / 7,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: const Color(0xFFFF7200),
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.prompt(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          // go to select people list to listen dubbing voice
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ListenSelectList(detailList, docID)));
                        },
                        child: const Text('ไปฟังเสียง'),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth / 41,
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: const Color(0xFFFF7200),
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.prompt(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          toDubbingPage(detailList);
                        },
                        child: const Text('ไปพากย์เสียง'),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      );
    });
  }

  // use for going to dubbing page
  toDubbingPage(Map<String, dynamic>? detailList) {
    // for 1 character audio type
    if (detailList!['voiceoverAmount'] == '1') {
      // go to dubbing page
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Record(detailList, detailList["character"],
                  detailList["characterImage"], docID)));
    } else {
      // for 2 character audio type
      // go to select type of dubbing page
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectDuoRecordType(detailList, docID)));
    }
  }
}
