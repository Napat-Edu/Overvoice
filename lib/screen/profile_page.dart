import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/login_controller.dart';
import '../main.dart';
import '../model/listen_detail.dart';
import 'listen_page.dart';
import '../model/title_detail.dart';
import 'moreInfo_page.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

List<String> docIDSolo = [];
List<String> audioNameSolo = [];
List<String> docIDDuo = [];
List<String> audioNameDuo = [];

class _ProfilePage extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7200),
        elevation: 0,
        actions: [
          LogoutAvatar(context),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: FutureBuilder<Widget>(
        future: getData(context),
        builder: ((BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }

          return Column(
            children: [
              SizedBox(
                height: 110,
              ),
              getUserSection(context),
              SizedBox(
                height: 30,
              ),
              //Text("กำลังโหลด..."),
              SizedBox(
                height: 30,
              ),
              Text("กำลังโหลด...", style: GoogleFonts.prompt()),
            ],
          );
        }),
      ),
    );
  }

  Future<Widget> getData(BuildContext context) async {
    List<ListenDetails> listenListSoloType = [];
    List<ListenDetails> listenListDuoType = [];
    listenListSoloType = await getHistoryData(1);
    listenListDuoType = await getHistoryData(2);
    String? userEmail = FirebaseAuth.instance.currentUser!.email;
    Map<String, dynamic> userData = await getUserInfo(userEmail!);
    return Column(
      children: [
        SizedBox(
          height: 110,
        ),
        getUserSection(context),
        SizedBox(
          height: 25,
        ),
        recLike(context, userData),
        SizedBox(
          height: 30,
        ),
        buildMiddler(),
        buildBelow(listenListSoloType, listenListDuoType),
      ],
    );
  }

  Widget LogoutAvatar(BuildContext context) => ActionChip(
        avatar: const Icon(
          Icons.logout,
          color: Colors.grey,
        ),
        label: Text(
          "ลงชื่อออก",
          style: GoogleFonts.prompt(color: Colors.grey),
        ),
        onPressed: () {
          Provider.of<LoginController>(context, listen: false).logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPageRoute()),
          );
        },
        backgroundColor: Colors.white,
      );

  Future<Map<String, dynamic>?> queryData() async {
    var dataDoc = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    Map<String, dynamic>? fieldMap = dataDoc.data();
    return fieldMap;
  }

  // like count under profile
  Widget recLike(BuildContext context, Map<String, dynamic> userData) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildRecLike(text: 'บันทึกเสียงรวม', value: userData["recordAmount"]),
          // Image.asset("assets/image/LineRL.png"),
          // Image.asset("assets/image/LineRL.png"),
          // buildRecLike(text: 'ถูกใจทั้งหมด', value: userData["likeAmount"]),
        ],
      );

  Widget buildRecLike({
    required String text,
    required int value,
  }) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '$value',
              style:
                  GoogleFonts.prompt(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style:
                  GoogleFonts.prompt(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );

  Widget buildMiddler() => Container(
        child: Column(
          children: <Widget>[
            Container(
                height: 45,
                color: Color(0xFFFF7200),
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelStyle: GoogleFonts.prompt(
                        fontSize: 17, fontWeight: FontWeight.w600),
                    unselectedLabelStyle: GoogleFonts.prompt(
                        fontSize: 15, fontWeight: FontWeight.w500),
                    tabs: [
                      Tab(
                        text: "ประวัติพากย์เดี่ยว",
                      ),
                      Tab(
                        text: "ประวัติพากย์คู่",
                      ),
                    ])),
          ],
        ),
      );

  Widget buildBelow(List<ListenDetails> listenListSoloType,
          List<ListenDetails> listenListDuoType) =>
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            displayAudioList(listenListSoloType, 1),
            displayAudioList(listenListDuoType, 2),
          ],
        ),
      );

  displayAudioList(List<ListenDetails> listenList, int audioType) {
    return Center(
      //child: Text("ประวัติพากย์"),
      child: listenList.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Image.asset("assets/image/Recordvoice.png"),
                SizedBox(height: 12),
                Text(
                  'พร้อมอัดเสียงครั้งเเรกของคุณหรือยัง',
                  style: GoogleFonts.prompt(fontSize: 15),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFFF7200),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Text('เริ่มอัดเสียงแรกกันเถอะ',
                      style: GoogleFonts.prompt(fontSize: 17)),
                ),
              ],
            )
          : ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFFFAA66),
              ),
              itemCount: listenList.length,
              itemBuilder: (context, index) => ListTile(
                leading: SizedBox(
                    width: 55,
                    height: 55,
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(color: Color(0xFFFFAA66), blurRadius: 5)
                      ]),
                      child: Image.network(
                        listenList[index].imgURL!,
                        fit: BoxFit.cover,
                      ),
                    )),
                title: Text(
                  setTextByAudioType(index, audioType),
                  style: GoogleFonts.prompt(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                // like count under content
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Icon(
                    //   Icons.favorite,
                    //   size: 18,
                    // ),
                    // Text(' ${listenList[index].likeCount!}'),
                  ],
                ),
                trailing: TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: const Size(10, 10),
                      backgroundColor: const Color(0xFFFF7200),
                      foregroundColor: Colors.white,
                      textStyle: GoogleFonts.prompt(fontSize: 15)),
                  onPressed: () async {
                    var dataDoc = await FirebaseFirestore.instance
                        .collection('AudioInfo')
                        .doc(docIDSolo[index])
                        .get();
                    Map<String, dynamic>? detailList = dataDoc.data();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ListenPage(detailList!, listenList[index])));
                  },
                  child: const Text('เล่น'),
                ),
              ),
            ),
    );
  }

  String setTextByAudioType(int index, int audioType) {
    if (audioType == 1) {
      return audioNameSolo[index];
    } else {
      return audioNameDuo[index];
    }
  }

  Future<List<ListenDetails>> getHistoryData(int type) async {
    List<ListenDetails> listenList = [];
    if (type == 1) {
      audioNameSolo = [];
      docIDSolo = [];
      listenList = await queryAudioList("user_1");
    } else {
      audioNameDuo = [];
      docIDDuo = [];
      listenList = await queryAudioList("user_2");
    }

    return listenList;
  }

  Future<List<ListenDetails>> queryAudioList(String userNumber) async {
    List<ListenDetails> listenList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('History')
        .where('status', isEqualTo: true)
        .where(userNumber, isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    await Future.forEach(querySnapshot.docs, (doc) async {
      Map<String, dynamic> audioData = await getAudioInfo(doc["audioInfo"]);
      Map<String, dynamic> userData = await getUserInfo(doc[userNumber]);
      if (userNumber == "user_1") {
        docIDSolo.add(doc["audioInfo"]);
        audioNameSolo.add(audioData["name"]);
      } else {
        docIDDuo.add(doc["audioInfo"]);
        audioNameDuo.add(audioData["name"]);
      }
      listenList.add(ListenDetails(
        userData["username"],
        doc["likeCount"].toString(),
        audioData["img"],
        doc["sound_1"],
        doc["sound_2"],
      ));
    });

    return listenList;
  }

  getUserInfo(String userID) async {
    var collection = FirebaseFirestore.instance.collection('UserInfo');
    var docSnapshot = await collection.doc(userID).get();
    return docSnapshot.data();
  }

  getAudioInfo(String audioID) async {
    var collection = FirebaseFirestore.instance.collection('AudioInfo');
    var docSnapshot = await collection.doc(audioID).get();
    return docSnapshot.data();
  }

  Widget getUserSection(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      final user = FirebaseAuth.instance.currentUser;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Semantics(
              label: "รูปโปรไฟล์คุณ",
              child: CircleAvatar(
                backgroundColor: Color(0xFFFFAA66),
                radius: 52,
                child: Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: Image.network(user!.photoURL ?? "").image,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              user.displayName ?? "",
              style:
                  GoogleFonts.prompt(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              user.email ?? "",
              style:
                  GoogleFonts.prompt(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          "กำลังโหลด...",
          style: GoogleFonts.prompt(),
        ),
      );
    }
  }
}
