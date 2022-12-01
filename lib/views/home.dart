import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/title_detail.dart';
import 'more.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
          child: Row(
            children: <Widget>[
              const Expanded(
                  flex: 9,
                  child: Text(
                    "ยินดีต้อนรับ",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                    iconSize: 30,
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Semantics(
                label: "้ค้นหาคลิปเสียง แล้วไปพากย์หรือฟังกันเถอะ",
                child: SizedBox(
                    width: screenWidth,
                    height: screenHeight / 4.75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                          "https://cdn6.aptoide.com/imgs/7/9/c/79ca6f8c8f874e89cf269e6f65deb456_fgraphic.jpg"),
                    )),
              ),
            ],
          ),
        ),
        Container(
            color: const Color(0xFFFF7200),
            child: Container(
              height: 40,
              child: Row(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                    )),
                SizedBox(width: screenWidth / 41.1),
                Expanded(
                    flex: 2,
                    child: Text(
                      "แนะนำ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
                SizedBox(width: screenWidth / 41.1),
                Expanded(
                    child: Text(
                  "ที่นิยม",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )),
                SizedBox(width: screenWidth / 20.55),
                Expanded(
                    flex: 2,
                    child: Text(
                      "กำลังมาแรง",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )),
              ]),
            )),
        Expanded(
          child: FutureBuilder<Widget>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }

                return const Text("กำลังโหลด...");
              }),
        ),
      ]),
    );
  }

  Future<Widget> getData() async {
    List<TitleDetails> mainTitleList = await getRecommendAudioInfo();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: Color(0xFFFFAA66),
      ),
      itemCount: mainTitleList.length,
      itemBuilder: (context, index) => ListTile(
        leading: SizedBox(
            width: 55,
            height: 55,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Color(0xFFFFAA66), blurRadius: 5)
              ]),
              child: Image.network(
                mainTitleList[index].imgURL!,
                fit: BoxFit.cover,
              ),
            )),
        title: Text(
          mainTitleList[index].titleName!,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          mainTitleList[index].episode!,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                    builder: (context) => More(mainTitleList[index].docID!)));
          },
          child: const Text('เข้าชม'),
        ),
      ),
    );
  }

  Future<List<TitleDetails>> getRecommendAudioInfo() async {
    List<TitleDetails> list = [];

    await FirebaseFirestore.instance
        .collection('AudioInfo')
        .limit(5)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        list.add(TitleDetails(doc["name"], doc["enName"], doc["episode"],
            doc["duration"], doc["img"], doc.id));
      });
    });

    return list;
  }
}
