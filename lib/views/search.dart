import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overvoice_project/model/title_detail.dart';

import 'more.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  static List<TitleDetails> mainTitleList = [];
  List<TitleDetails> displayList = [];

  Future<void> updateList(String value) async {
    mainTitleList = await getFilterAudioInfo();
    displayList = List.from(mainTitleList);
    setState(() {
      displayList = mainTitleList
          .where((element) =>
              element.titleName!.toLowerCase().contains(value.toLowerCase()) ||
              element.titleNameEng!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<List<TitleDetails>> getFilterAudioInfo() async {
    List<TitleDetails> list = [];

    await FirebaseFirestore.instance
        .collection('AudioInfo')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        list.add(TitleDetails(doc["name"], doc["enName"], doc["episode"],
            doc["duration"], doc["img"], doc.id));
      });
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        child: Column(children: <Widget>[
      Container(
        margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
        child: const Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Search",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: TextField(
          autofocus: true,
          onChanged: (value) => updateList(value),
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          controller: null,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            iconColor: Color(0xFF4D331F),
            border: InputBorder.none,
            hintText: 'Search',
            fillColor: Color(0xFFFFAA66),
            filled: true,
          ),
        ),
      ),
      SizedBox(
        height: screenHeight / 45,
      ),
      Expanded(
          child: displayList.isEmpty
              ? const Center(
                  child: Text(
                    "ขอโทษนะ ไม่พบเรื่องที่คุณตามหาเลย",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Color(0xFFFFAA66),
                  ),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: SizedBox(
                        width: 55,
                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(color: Color(0xFFFFAA66), blurRadius: 5)
                          ]),
                          child: Image.network(
                            displayList[index].imgURL!,
                            fit: BoxFit.cover,
                          ),
                        )),
                    title: Text(
                      displayList[index].titleName!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    subtitle: Text(
                      displayList[index].episode!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: TextButton(
                      style: TextButton.styleFrom(
                          fixedSize: const Size(10, 10),
                          backgroundColor: const Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    More(displayList[index].docID!)));
                      },
                      child: const Text('More'),
                    ),
                  ),
                ))
    ]));
  }
}
