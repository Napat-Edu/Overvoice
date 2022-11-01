import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';



class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
          Padding(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
          child: TextField(style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500),
            controller: null,
            decoration: InputDecoration(prefixIcon: Icon(Icons.search),iconColor: Color(0xFF4D331F),
            border: InputBorder.none,
            hintText: 'Search',
            fillColor: Color(0xFFFFAA66),
            filled: true,
            ),
          ),
          )
        ]));
  }
}
