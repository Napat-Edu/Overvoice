import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/login_controller.dart';
import '../main.dart';
import '../model/listen_detail.dart';
import 'listen_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  List<String> docID = [];
  List<String> audioName = [];
  final double profileHeight = 144;

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
          /*PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Edit"),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text("ลงชื่อออก"),
              ),
            ],
            onSelected: (item) => selectedItem(context, item),
          ),*/
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 120,),
          loadData(context),
          SizedBox(
            height: 30,
          ),
          //buildContent(),
          recLike(context),
          SizedBox(
            height: 30,
          ),
          buildMiddler(),
          buildBelow(),
          //LogoutAvatar(context),
        ],
      ),
    );
  }

  Widget LogoutAvatar(BuildContext context) => ActionChip(
        avatar: const Icon(
          Icons.logout,
          color: Colors.grey,
        ),
        label: const Text(
          "ลงชื่อออก",
          style: TextStyle(color: Colors.grey),
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

  Widget buildContent() => Container(
        //decoration: BoxDecoration(color: const Color(0xFFFF7200)),
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder<Widget>(
            future: getCaptionData(),
            builder: ((BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              }

              return const Center(
                child: Text("กำลังโหลด..."),
              );
            }),
          ),
        ),
      );
  Future<Widget> getCaptionData() async {
    var dataDoc = await queryData();

    return Future.delayed(const Duration(seconds: 0), () {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dataDoc!["caption"],
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Color.fromARGB(255, 152, 137, 137),
            ),
          ),
        ],
      );
    });
  }

  Future<Map<String, dynamic>?> queryData() async {
    var dataDoc = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    Map<String, dynamic>? fieldMap = dataDoc.data();
    return fieldMap;
  }

  Widget recLike(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildRecLike(text: 'บันทึกเสียงรวม', value: 0),
          /*VerticalDivider(
            color: Colors.black,
            thickness: 2,
          ),*/
          Image.asset("assets/image/LineRL.png"),
          Image.asset("assets/image/LineRL.png"),
          buildRecLike(text: 'ถูกใจทั้งหมด', value: 0),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      );

  Widget buildMiddler() => Container(
        decoration: BoxDecoration(color: Color.fromARGB(88, 255, 115, 0)),
        height: 40,
          margin: EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFFF4700),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text('       ประวัติพากย์       ',
                    style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFFF7200),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text('  บันทึกเสียงที่ถูกใจ  ',
                    style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        
      );

  Widget buildBelow() => Container(
        // decoration: BoxDecoration(color: Color.fromARGB(88, 255, 115, 0)),
        height: 300,
        child: FutureBuilder<Widget>(
          future: getHistoryList(),
          builder: ((BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }

            return const Center(
              child: Text("กำลังโหลด..."),
            );
          }),
        ),
      );

  Future<Widget> getHistoryList() async {
    
    List<ListenDetails> listenList = [];
    listenList = await getHistoryData();
    return Future.delayed(const Duration(seconds: 0), () {
      
      return listenList.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Image.asset("assets/image/Recordvoice.png"),
                SizedBox(height: 12),
                Text(
                  'พร้อมอัดเสียงครั้งเเรกของคุณหรือยัง',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFFF7200),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Text('เริ่มอัดเสียงแรกกันเถอะ',
                      style: TextStyle(fontSize: 18)),
                ),
              ],
            )
          : ListView.separated(
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
                      ' ${audioName[index]}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          size: 18,
                        ),
                        Text(' ${listenList[index].likeCount!}'),
                      ],
                    ),
                    trailing: TextButton(
                      style: TextButton.styleFrom(
                          fixedSize: const Size(10, 10),
                          backgroundColor: const Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16)),
                      onPressed: () async {
                        var dataDoc = await FirebaseFirestore.instance
                            .collection('AudioInfo')
                            .doc(docID[index])
                            .get();
                        Map<String, dynamic>? detailList = dataDoc.data();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListenPage(
                                    detailList!, listenList[index])));
                      },
                      child: const Text('Play'),
                    ),
                  ));
    });
  }

  Future<List<ListenDetails>> getHistoryData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('History')
        .where('status', isEqualTo: true)
        .where('user_1', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    List<ListenDetails> listenList = [];
    await Future.forEach(querySnapshot.docs, (doc) async {
      Map<String, dynamic> audioData = await getAudioInfo(doc["audioInfo"]);
      Map<String, dynamic> userData = await getUserInfo(doc["user_1"]);
      docID.add(doc["audioInfo"]);
      audioName.add(audioData["name"]);
      listenList.add(ListenDetails(
        userData["username"],
        doc["likeCount"],
        audioData["img"],
        doc["sound_1"],
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

  Widget loadData(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      final user = FirebaseAuth.instance.currentUser;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFFFAA66),
              radius: 54,
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: Image.network(user!.photoURL ?? "").image,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              user.displayName ?? "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              user.email ?? "",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: Text("กำลังโหลด..."),
      );
    }
  }

  selectedItem(BuildContext context, int item) async {
    switch (item) {
      case 0:
        break;
      case 1:
        Provider.of<LoginController>(context, listen: false).logout();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPageRoute()),
        );
        break;
    }
  }
}