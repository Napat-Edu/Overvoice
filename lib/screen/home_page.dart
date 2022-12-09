import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/title_detail.dart';
import 'moreInfo_page.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // initialize a tab bar to have 2 tabs
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Header
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'ยินดีต้อนรับ',
          style: GoogleFonts.prompt(
              fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Semantics(
                // Banner Image
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
          // Tab bar section
            height: 43,
            color: const Color(0xFFFF7200),
            child: TabBar(
                // using a tab bar by _tabController
                controller: _tabController,
                labelStyle: GoogleFonts.prompt(
                    fontSize: 17, fontWeight: FontWeight.w600),
                unselectedLabelStyle: GoogleFonts.prompt(
                    fontSize: 15, fontWeight: FontWeight.w500),
                indicator: const BoxDecoration(color: Color(0xFFFF4700)),
                // define a name of each tabs
                tabs: const [
                  Tab(
                    text: "แนะนำ",
                  ),
                  Tab(
                    text: "เป็นที่นิยม",
                  ),
                ])),
        Expanded(
          child: Container(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                // a content in each tab bars
                tabBarData(1),
                tabBarData(2),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // using for generate content in tab bar
  Widget tabBarData(int tabBarIndex) {
    return FutureBuilder<Widget>(
      future: getData(tabBarIndex),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }

        // return text loading while getData
        return Text(
          "กำลังโหลด...",
          style: GoogleFonts.prompt(),
          textAlign: TextAlign.center,
        );
      },
    );
  }

  // using for get data from database
  Future<Widget> getData(int index) async {
    List<TitleDetails> mainTitleList = [];

    if (index == 1) {
      // read news audio from database (Tab bar #1)
      mainTitleList = await getNewsAudio();
    } else if (index == 2) {
      // read popular audio from database (Tab bar #2)
      mainTitleList = await getTopHitAudio();
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // return UI with data that already read
    return ListView.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) => const Divider(
        color: Color(0xFFFFAA66),
      ),
      itemCount: mainTitleList.length,
      itemBuilder: (context, index) => ListTile(
        leading: SizedBox(
            width: 53,
            height: 53,
            child: Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(color: Color(0xFFFFAA66), blurRadius: 5)
              ]),
              child: Image.network(
                mainTitleList[index].imgURL!,
                fit: BoxFit.cover,
              ),
            )),
        title: Text(
          mainTitleList[index].titleName!,
          style: GoogleFonts.prompt(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17),
        ),
        subtitle: Text(
          mainTitleList[index].episode!,
          style: GoogleFonts.prompt(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        trailing: TextButton(
          style: TextButton.styleFrom(
              fixedSize: const Size(10, 10),
              backgroundColor: const Color(0xFFFF7200),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 15,
              )),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => More(mainTitleList[index].docID!),
                  fullscreenDialog: true,
                ));
          },
          child: Text('เข้าชม', style: GoogleFonts.prompt()),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => More(mainTitleList[index].docID!),
                fullscreenDialog: true,
              ));
        },
      ),
    );
  }

  // using for read news audio from database (firebase)
  Future<List<TitleDetails>> getNewsAudio() async {
    List<TitleDetails> list = [];

    // get the first 5 news audio from firebase
    await FirebaseFirestore.instance
        .collection('AudioInfo')
        .limit(5)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // collect in list (TitleDetails Model Type)
        list.add(TitleDetails(doc["name"], doc["enName"], doc["episode"],
            doc["duration"], doc["img"], doc.id));
      });
    });

    return list;
  }

  // using for read popular audio from database (firebase)
  Future<List<TitleDetails>> getTopHitAudio() async {
    var topHitMap = Map();

    // counting popularity for each audio and keep it in topHitMap
    await FirebaseFirestore.instance
        .collection("History")
        .get()
        .then((snapshot) {
      snapshot.docs.map((element) {
        if (!topHitMap.containsKey(element.data()['audioInfo'])) {
          topHitMap[element.data()['audioInfo']] = 1;
        } else {
          topHitMap[element.data()['audioInfo']] += 1;
        }
      }).toList();
    });

    List<TitleDetails> list = [];
    int dataCount = 0;
    var mostPopularKey = topHitMap.keys.first;
    int mostPopularCount = topHitMap.values.first;

    // finding the top 5 popular audio or less than 5 if there is no more audio
    while (topHitMap.isNotEmpty && dataCount != 5) {

      // find most popular for each loop by linear search
      topHitMap.forEach(
        (key, value) {
          if (value > mostPopularCount) {
            mostPopularKey = key;
            mostPopularCount = value;
          }
        },
      );

      // collect it in list of TitleDetails model type
      await FirebaseFirestore.instance
          .collection('AudioInfo')
          .doc(mostPopularKey)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          list.add(TitleDetails(
              documentSnapshot["name"],
              documentSnapshot["enName"],
              documentSnapshot["episode"],
              documentSnapshot["duration"],
              documentSnapshot["img"],
              documentSnapshot.id));
        }
      });

      // break the loop if there is just 1 audio left, to avoid the null map
      if (topHitMap.length == 1) {
        break;
      } else {
        // remove the current popular audio
        topHitMap.remove(mostPopularKey);
      }
      mostPopularKey = topHitMap.keys.first;
      mostPopularCount = topHitMap.values.first;
      dataCount++;
    }
    return list;
  }
}
