import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overvoice_project/screen/record_page.dart';
import 'package:overvoice_project/screen/record_select_type_page.dart';
import 'listen_select_list_page.dart';

class More extends StatefulWidget {
  String docID;
  More(this.docID, {super.key});

  @override
  State<More> createState() => _MoreState(docID);
}

class _MoreState extends State<More> {
  String docID;
  _MoreState(this.docID);
  
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
          future: getData(),
          builder: ((BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }

            return const Center(
              child: Text("Loading"),
            );
          }),
        ),
      ),
    );
  }

  Future<Widget> getData() async {
    Map<String, dynamic>? detailList = await queryData();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
              child: Image.network(detailList!["coverimg"],
                  color: Colors.black.withOpacity(0.3),
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.darken),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 40, right: 40),
            height: screenHeight / 1.6,
            child: Column(children: <Widget>[
              Container(
                child: Text(
                  detailList["name"],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: screenHeight / 100,
              ),
              Container(
                child: Text(
                  detailList['episode'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: screenHeight / 99,
              ),
              Container(
                child: Text(
                  "${detailList['voiceoverAmount']} ตัวละคร : ${detailList['character']}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: screenHeight / 50,
              ),
              Container(
                height: screenHeight / 4.5,
                child: Text(
                  "${detailList['detail']}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: screenHeight / 100,
              ),
              Container(
                child: Text(
                  "${detailList['duration']} m",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
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
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Listen(detailList, docID)));
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
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        if (detailList['voiceoverAmount'] == '1') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Record(
                                      detailList,
                                      detailList["character"],
                                      detailList["characterImage"],
                                      docID)));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Start(detailList, docID)));
                        }
                      },
                      child: const Text('ไปพากย์เสียง'),
                    ),
                  )
                ],
              )
            ]),
          )
        ],
      );
    });
  }

  Future<Map<String, dynamic>?> queryData() async {
    var dataDoc = await FirebaseFirestore.instance
        .collection('AudioInfo')
        .doc(docID)
        .get();
    Map<String, dynamic>? fieldMap = dataDoc.data();
    return fieldMap;
  }
}

class MoreDetail {
  String? name;
  String? episode;
  String? character;
  String? imgURL;
  String? detail;

  MoreDetail(this.name, this.episode, this.character, this.imgURL, this.detail);
}
