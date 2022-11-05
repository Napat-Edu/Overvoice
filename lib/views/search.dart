import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overvoice_project/model/title_detail.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
  ];

  List<TitleDetails> display_list = List.from(main_title_list);

  void updateList(String value) {
    setState(() {
      display_list = main_title_list
          .where((element) =>
              element.titleName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 25, left: 15, right: 15),
        child: Column(children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Search",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4, right: 4, top: 16),
            child: TextField(
              onChanged: (value) => updateList(value),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              controller: null,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                iconColor: Color(0xFF4D331F),
                border: InputBorder.none,
                hintText: 'Search',
                fillColor: Color(0xFFFFAA66),
                filled: true,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: display_list.length == 0
                  ? Center(
                      child: Text(
                        "Your search did not match any documents.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    )
                  : ListView.builder(
                      itemCount: display_list.length,
                      itemBuilder: (context, index) => ListTile(
                            leading:
                                Image.network('${display_list[index].imgURL!}'),
                            title: Text(
                              display_list[index].titleName!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            subtitle: Text(
                              'Episode : ${display_list[index].episode!}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            trailing: TextButton(
                              style: TextButton.styleFrom(
                                  fixedSize: const Size(10, 10),
                                  backgroundColor: Color(0xFFFF7200),
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(fontSize: 16)),
                              onPressed: () {},
                              child: const Text('More'),
                            ),
                          )))
        ]));
  }
}
