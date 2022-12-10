import 'package:flutter/material.dart';
import 'package:overvoice_project/model/constant_value.dart';
import 'package:overvoice_project/model/title_detail.dart';
import '../controller/database_query_controller.dart';
import 'moreInfo_page.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  static List<TitleDetails> mainTitleList = [];
  List<TitleDetails> displayList = [];
  DatabaseQuery databaseQuery = DatabaseQuery();
  ConstantValue constantValue = ConstantValue();

  // use for update display list and set state of UI
  Future<void> updateList(String value) async {
    mainTitleList = await getFilterAudioInfo();
    displayList = List.from(mainTitleList);

    setState(() {
      displayList = mainTitleList
          .where((element) =>
              element.titleName!.toLowerCase().contains(value.toLowerCase()) ||
              element.titleNameEng!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      // check if user does not type anything yet
      if (value == "") {
        displayList = [];
      }
    });
  }

  // use for read audio data from database
  Future<List<TitleDetails>> getFilterAudioInfo() async {
    List<TitleDetails> list = [];

    var audioCollection = await databaseQuery.getAudioCollection();
    // add detail for each audio to list
    audioCollection.docs.forEach((doc) {
      list.add(TitleDetails(doc["name"], doc["enName"], doc["episode"],
          doc["duration"], doc["img"], doc.id));
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {

    // core UI
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ค้นหา',
          style: GoogleFonts.prompt(
              fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: TextField(
              autofocus: true,
              onChanged: (value) => updateList(value),
              style:
                  GoogleFonts.prompt(fontSize: 24, fontWeight: FontWeight.w500),
              controller: null,
              decoration: const InputDecoration(
                prefixIcon: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: Icon(Icons.search)), //Icon(Icons.search),
                border: InputBorder.none,
                hintText: ('คุณต้องการค้นหาอะไร'),
                fillColor: Color(0xFFFFAA66),
                filled: true,
              ),
            ),
          ),
          SizedBox(
            height: constantValue.getScreenHeight(context) / 200,
          ),
          Expanded(
            child: displayList.isEmpty
                ? Center(
                    child: Text(
                      "ขอโทษนะ ไม่พบเรื่องที่คุณตามหาเลย",
                      style: GoogleFonts.prompt(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) => const Divider(
                      color: Color(0xFFFFAA66),
                    ),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: SizedBox(
                          width: 53,
                          height: 53,
                          child: Container(
                            decoration: const BoxDecoration(boxShadow: [
                              BoxShadow(color: Color(0xFFFFAA66), blurRadius: 5)
                            ]),
                            child: Image.network(
                              displayList[index].imgURL!,
                              fit: BoxFit.cover,
                            ),
                          )),
                      title: Text(
                        displayList[index].titleName!,
                        style: GoogleFonts.prompt(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                      subtitle: Text(
                        displayList[index].episode!,
                        style: GoogleFonts.prompt(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      trailing: TextButton(
                        style: TextButton.styleFrom(
                            fixedSize: const Size(10, 10),
                            backgroundColor: const Color(0xFFFF7200),
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.prompt(fontSize: 15)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MoreInfo(displayList[index].docID!)));
                        },
                        child: const Text('เข้าชม'),
                      ),
                      onTap: () {
                        // go to audio info page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MoreInfo(displayList[index].docID!),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
