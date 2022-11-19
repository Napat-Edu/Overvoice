import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:overvoice_project/model/listen_detail.dart';

class Listen extends StatefulWidget {
  const Listen({super.key});

  @override
  State<Listen> createState() => _ListenState();
}

class _ListenState extends State<Listen> {
  List<ListenDetails> listenList = [
    ListenDetails("nwtkd", "2289", "87",
        "https://i.pinimg.com/736x/46/9c/6f/469c6f7badd2745729fc122782c19ff9.jpg"),
    ListenDetails("ksupaste", "2489", "43",
        "https://i.pinimg.com/736x/46/9c/6f/469c6f7badd2745729fc122782c19ff9.jpg"),
    ListenDetails("napatwrd", "1289", "45",
        "https://i.pinimg.com/736x/46/9c/6f/469c6f7badd2745729fc122782c19ff9.jpg"),
    ListenDetails("tnzgx", "923", "75",
        "https://i.pinimg.com/736x/46/9c/6f/469c6f7badd2745729fc122782c19ff9.jpg"),
    ListenDetails("atthaset", "756", "33",
        "https://i.pinimg.com/736x/46/9c/6f/469c6f7badd2745729fc122782c19ff9.jpg"),
    ListenDetails("ssx7ay", "234", "63",
        "https://i.pinimg.com/736x/46/9c/6f/469c6f7badd2745729fc122782c19ff9.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sword Art Online",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFF7200),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              child: SizedBox(
                width: double.infinity,
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: Image.network(
                    "https://static1.cbrimages.com/wordpress/wp-content/uploads/2021/04/Sword-Art-Online.jpg",
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.2),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
              ),
            ),
            Container(
                child: Column(
              children: <Widget>[
                Container(
                  color: Color(0xFFFF7200),
                  child: Container(
                    height: 40,
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Icon(
                        Icons.thumb_up_alt_sharp,
                        color: Colors.white,
                      )),
                      Expanded(
                          flex: 2,
                          child: Text(
                            "Recommended for you",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )),
                      SizedBox(
                        width: 180,
                      )
                    ]),
                  ),
                )
              ],
            )),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                          color: Color(0xFFFFAA66),
                        ),
                    itemCount: listenList.length,
                    itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: Color(0xFFFFAA66),
                            child: Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 26,
                                backgroundImage:
                                    NetworkImage(listenList[index].imgURL!),
                              ),
                            ),
                          ),
                          title: Text(
                            ' ${listenList[index].userName!}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.play_arrow),
                              Text(listenList[index].viewCount!),
                              SizedBox(width: 10),
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
                            onPressed: () {},
                            child: const Text('Play'),
                          ),
                        )))
          ],
        ),
      ),
    );
  }
}
