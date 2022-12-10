import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/database_query_controller.dart';
import '../controller/login_controller.dart';
import '../main.dart';
import '../model/constant_value.dart';
import '../model/listen_detail.dart';
import 'listen_page.dart';
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

  DatabaseQuery databaseQuery = DatabaseQuery();
  ConstantValue constantValue = ConstantValue();
  String? userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7200),
        elevation: 0,
        actions: [
          logoutAvatar(context),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: FutureBuilder<Widget>(
        // read data from database and waiting for data
        future: getData(context),
        builder: ((BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }

          // display loading text while waiting for data
          return Column(
            children: [
              SizedBox(
                height: constantValue.getScreenHeight(context) / 8,
              ),
              getUserSection(context),
              SizedBox(
                height: constantValue.getScreenHeight(context) / 29,
              ),
              SizedBox(
                height: constantValue.getScreenHeight(context) / 29,
              ),
              Text("กำลังโหลด...", style: GoogleFonts.prompt()),
            ],
          );
        }),
      ),
    );
  }

  // use for read data from database and waiting for data
  Future<Widget> getData(BuildContext context) async {
    List<ListenDetails> listenListSoloType = [];
    List<ListenDetails> listenListDuoType = [];

    // read data from database and collect in list
    listenListSoloType = await getHistoryData(1);
    listenListDuoType = await getHistoryData(2);

    Map<String, dynamic> userData =
        await databaseQuery.getUserInfoDocumentbyID(userEmail!);

    // return UI with data
    return Column(
      children: [
        SizedBox(
          height: constantValue.getScreenHeight(context) / 8,
        ),
        getUserSection(context),
        SizedBox(height: constantValue.getScreenHeight(context) / 29),
        userStaticSection(context, userData),
        SizedBox(height: constantValue.getScreenHeight(context) / 29),
        headerContent(),
        contentSection(listenListSoloType, listenListDuoType),
      ],
    );
  }

  // use for generate logout button function
  Widget logoutAvatar(BuildContext context) => ActionChip(
        avatar: const Icon(
          Icons.logout,
          color: Colors.grey,
        ),
        label: Text(
          "ลงชื่อออก",
          style: GoogleFonts.prompt(color: Colors.grey),
        ),
        onPressed: () {
          // logout and go to login page
          Provider.of<LoginController>(context, listen: false).logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPageRoute()),
          );
        },
        backgroundColor: Colors.white,
      );

  // use for constrol statistic section of user (can add another things in the future)
  Widget userStaticSection(
          BuildContext context, Map<String, dynamic> userData) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // create section UI with data
          buildStaticSection(
              text: 'บันทึกเสียงรวม', value: userData["recordAmount"]),
        ],
      );

  // use for generate UI statistic data of user with data
  Widget buildStaticSection({
    required String text,
    required int value,
  }) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
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
            const SizedBox(height: 2),
            Text(
              text,
              style:
                  GoogleFonts.prompt(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );

  // use for create header of content (can add or delete tabs here)
  Widget headerContent() => Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 43,
              color: const Color(0xFFFF7200),
              child: TabBar(
                controller: _tabController,
                labelStyle: GoogleFonts.prompt(
                    fontSize: 17, fontWeight: FontWeight.w600),
                unselectedLabelStyle: GoogleFonts.prompt(
                    fontSize: 15, fontWeight: FontWeight.w500),
                indicator: const BoxDecoration(color: Color(0xFFFF4700)),
                tabs: const [
                  Tab(
                    text: "ประวัติพากย์เดี่ยว",
                  ),
                  Tab(
                    text: "ประวัติพากย์คู่",
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  //use for control content section (add or delete here)
  Widget contentSection(
          List<ListenDetails> listenListSoloType,
          List<ListenDetails> listenListDuoType,) =>
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            // create content section UI
            displayAudioList(listenListSoloType, 1),
            displayAudioList(listenListDuoType, 2),
          ],
        ),
      );

  // use for generate content section UI with data
  displayAudioList(List<ListenDetails> listenList, int audioType,) {
    return Center(
      // if there is no history data
      child: listenList.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: constantValue.getScreenHeight(context) / 12,
                ),
                Image.asset("assets/image/Recordvoice.png"),
                SizedBox(height: constantValue.getScreenHeight(context) / 74),
                Text(
                  'พร้อมอัดเสียงครั้งเเรกของคุณหรือยัง?',
                  style: GoogleFonts.prompt(fontSize: 15),
                ),
                SizedBox(height: constantValue.getScreenHeight(context) / 74),
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
          // if user have history dubbing once
          : ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFFFAA66),
              ),
              itemCount: listenList.length,
              itemBuilder: (context, index) => ListTile(
                leading: SizedBox(
                    width: 53,
                    height: 53,
                    child: Container(
                      decoration: const BoxDecoration(boxShadow: [
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
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    displaySubtitleText(index, listenList, audioType),
                  ],
                ),
                trailing: TextButton(
                  style: TextButton.styleFrom(
                      fixedSize: const Size(10, 10),
                      backgroundColor: const Color(0xFFFF7200),
                      foregroundColor: Colors.white,
                      textStyle: GoogleFonts.prompt(fontSize: 15)),
                  onPressed: () async {
                    toListenPage(listenList, index, audioType);
                  },
                  child: const Text('เล่น'),
                ),
              ),
            ),
    );
  }

  // use for going to Listen page and sending audio data to it
  Future<void> toListenPage(
      List<ListenDetails> listenList, int index, int audioType) async {
    String docID = "";
    if (audioType == 1) {
      docID = docIDSolo[index];
    } else {
      docID = docIDDuo[index];
    }

    Map<String, dynamic> detailList =
        await databaseQuery.getAudioDocumentbyID(docID);
    // go to listen page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListenPage(detailList, listenList[index]),
      ),
    );
  }

  // use for generate subtitle text
  Widget displaySubtitleText(
      int index, List<ListenDetails> listenList, int audioType) {
    // if it is 2 character type audio
    if (audioType == 2) {
      if (listenList[index].userNameBuddy ==
          FirebaseAuth.instance.currentUser?.displayName) {
        return Text("คู่กับ ${listenList[index].userName}");
      }
      return Text("คู่กับ ${listenList[index].userNameBuddy}");
    } else {
      // if it is 1 character type audio
      return Text("ผลงานพากย์เดี่ยวของคุณ");
    }
  }

  // use for return name of audio from list
  String setTextByAudioType(int index, int audioType) {
    if (audioType == 1) {
      return audioNameSolo[index];
    } else {
      return audioNameDuo[index];
    }
  }

  // use for control data reading from database
  Future<List<ListenDetails>> getHistoryData(int type) async {
    List<ListenDetails> listenList = [];
    // for 1 character type audio
    if (type == 1) {
      audioNameSolo = [];
      docIDSolo = [];
      listenList = await queryAudioList("user_1", "user_2");
    } else {
      // for 2 character type audio
      audioNameDuo = [];
      docIDDuo = [];
      listenList = await queryAudioList("user_2", "user_1");
    }

    return listenList;
  }

  // use for read history data from database
  Future<List<ListenDetails>> queryAudioList(
      String userNumber, String userNumberBuddy) async {
    List<ListenDetails> listenList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('History')
        .where('status', isEqualTo: true)
        .where(userNumber, isEqualTo: userEmail)
        .get();

    String buddyName = "";
    await Future.forEach(querySnapshot.docs, (doc) async {
      Map<String, dynamic> audioData =
          await databaseQuery.getAudioDocumentbyID(doc["audioInfo"]);
      Map<String, dynamic> userData =
          await databaseQuery.getUserInfoDocumentbyID(doc[userNumber]);

      // get buddy data if it is 2 character type audio
      if (audioData["voiceoverAmount"] == "2") {
        Map<String, dynamic> user2Data =
            await databaseQuery.getUserInfoDocumentbyID(doc[userNumberBuddy]);
        buddyName = user2Data["username"];
      }
      // collect name and id of each audio
      if (userNumber == "user_1") {
        docIDSolo.add(doc["audioInfo"]);
        audioNameSolo.add(audioData["name"]);
      } else {
        docIDDuo.add(doc["audioInfo"]);
        audioNameDuo.add(audioData["name"]);
      }

      // collect basic data in list
      listenList.add(ListenDetails(
        userData["username"],
        buddyName,
        "",
        audioData["img"],
        doc["sound_1"],
        doc["sound_2"],
      ));
    });

    return listenList;
  }

  // use for generate user section UI
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
              height: constantValue.getScreenHeight(context) / 89,
            ),
            Text(
              user.displayName ?? "",
              style:
                  GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: constantValue.getScreenHeight(context) / 175,
            ),
            Text(
              user.email ?? "",
              style:
                  GoogleFonts.prompt(fontSize: 13, fontWeight: FontWeight.w500),
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
