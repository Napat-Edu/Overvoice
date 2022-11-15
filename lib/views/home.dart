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
    return Container(
      child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
          child: Row(
            children: <Widget>[
              const Expanded(
                  flex: 9,
                  child: Text(
                    "Good Morning",
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
              ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: Image.network(
                      "https://cdn6.aptoide.com/imgs/7/9/c/79ca6f8c8f874e89cf269e6f65deb456_fgraphic.jpg"))
            ],
          ),
        ),
        Container(
            color: const Color(0xFFFF7200),
            child: Container(
              height: 32,
              child: Row(children: const <Widget>[
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                    )),
                SizedBox(width: 10),
                Expanded(
                    flex: 2,
                    child: Text(
                      "Recommended",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
                SizedBox(width: 10),
                Expanded(
                    child: Text(
                  "Popular",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )),
                SizedBox(width: 20),
                Expanded(
                    flex: 2,
                    child: Text(
                      "Trending Now",
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

                return const Text("Loading");
              }),
        ),
      ]),
    );
  }

  Future<Widget> getData() async {
    List<TitleDetails> mainTitleList = await getRecommendAudioInfo();
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: Color(0xFFFFAA66),
      ),
      itemCount: mainTitleList.length,
      itemBuilder: (context, index) => ListTile(
        leading: Image.network(mainTitleList[index].imgURL!),
        title: Text(
          mainTitleList[index].titleName!,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          'Episode : ${mainTitleList[index].episode!}',
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
                context, MaterialPageRoute(builder: (context) => More(mainTitleList[index].docID!)));
          },
          child: const Text('More'),
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
        list.add(TitleDetails(
            doc["name"], doc["episode"], doc["duration"], doc["img"], doc.id));
      });
    });

    return list;
  }
}
