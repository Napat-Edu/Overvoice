import 'package:flutter/material.dart';
import 'package:overvoice_project/views/more.dart';
import '../model/title_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<TitleDetails> main_title_list = [
    TitleDetails("Bleach", "23", "35",
        "https://www.empowerlife.co.th/uploads/product_20220225021518_s.jpg"),
    TitleDetails("Naruto", "34", "38",
        "https://www.empowerlife.co.th/uploads/product_20220225021518_s.jpg"),
    TitleDetails("Spy X Family", "29", "33",
        "https://www.empowerlife.co.th/uploads/product_20220225021518_s.jpg"),
    TitleDetails("One Piece", "13", "31",
        "https://www.empowerlife.co.th/uploads/product_20220225021518_s.jpg"),
    TitleDetails("Inazuma Eleven", "9", "32",
        "https://www.empowerlife.co.th/uploads/product_20220225021518_s.jpg"),
    TitleDetails("Sword Art Online", "11", "30",
        "https://www.empowerlife.co.th/uploads/product_20220225021518_s.jpg"),
    TitleDetails("Detective Conan", "13", "29",
        "https://www.empowerlife.co.th/uploads/product_20220225021518_s.jpg"),
    TitleDetails("Blue Lock", "14", "36",
        "https://www.empowerlife.co.th/uploads/product_20220225021518_s.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20, right: 15, left: 15),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 9,
                  child: Text(
                    "Good Morning",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                    iconSize: 30,
                  ))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
            color: Color(0xFFFF7200),
            child: Container(
              height: 32,
              child: Row(children: <Widget>[
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
                          color: Colors.white,),
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
            )),SizedBox(height: 10,),
        Expanded(
            child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Color(0xFFFFAA66),
          ),
          itemCount: main_title_list.length,
          itemBuilder: (context, index) => ListTile(
            leading: Image.network('${main_title_list[index].imgURL!}'),
            title: Text(
              main_title_list[index].titleName!,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            subtitle: Text(
              'Episode : ${main_title_list[index].episode!}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            trailing: TextButton(
              style: TextButton.styleFrom(
                  fixedSize: const Size(10, 10),
                  backgroundColor: Color(0xFFFF7200),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => More()));
              },
              child: const Text('More'),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => More()));
            },
          ),
        ))
      ]),
    );
  }
}
