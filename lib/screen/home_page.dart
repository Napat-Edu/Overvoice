import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/title_detail.dart';
import 'moreInfo_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
          child: Row(
            children: const <Widget>[
              Expanded(
                  flex: 9,
                  child: Text(
                    "ยินดีต้อนรับ",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Semantics(
                label: "้ลองค้นหาคลิปเสียง แล้วไปพากย์หรือฟังกันเถอะ",
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
            height: 45,
            color: Color(0xFFFF7200),
            child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(
                    text: "แนะนำ",
                  ),
                  Tab(
                    text: "เป็นที่นิยม",
                  ),
                  Tab(
                    text: "กำลังมาแรง",
                  )
                ])),
        Expanded(
            child: Container(
                child:
                    TabBarView(controller: _tabController, children: <Widget>[
          FutureBuilder<Widget>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }

                return const Text(
                  "กำลังโหลด...",
                  textAlign: TextAlign.center,
                );
              }),
          Center(
            child: Text("เป็นที่นิยม"),
          ),
          Center(
            child: Text("กำลังมาแรง"),
          ),
        ])))
      ]),
    );
  }

  Future<Widget> getData() async {
    List<TitleDetails> mainTitleList = await getRecommendAudioInfo();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView.separated(
      padding: EdgeInsets.zero,
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
                  builder: (context) => More(mainTitleList[index].docID!),
                  fullscreenDialog: true,
                ));
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
        .limit(6)
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

// Container(
//               height: 40,
//               child: Row(children: <Widget>[
//                 Expanded(
//                     flex: 1,
//                     child: Icon(
//                       Icons.menu,
//                       color: Colors.white,
//                     )),
//                 SizedBox(width: screenWidth / 41.1),
//                 Expanded(
//                     flex: 1,
//                     child: Text(
//                       "แนะนำ",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     )),
//                 SizedBox(width: screenWidth / 41.1),
//                 Expanded(
//                   flex: 1,
//                     child: Text(
//                   "ที่นิยม",
//                   style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white),
//                 )),
//                 SizedBox(width: screenWidth / 41.1),
//                 Expanded(
//                     flex: 1,
//                     child: Text(
//                       "กำลังมาแรง",
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white),
//                     )),
//               ]),
//             )