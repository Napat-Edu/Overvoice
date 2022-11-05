import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:overvoice_project/screen/audioinfo.dart';
import 'package:overvoice_project/views/search.dart';
import 'package:provider/provider.dart';
import 'package:overvoice_project/views/search.dart';

import 'controller/login_controller.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  // ignore: prefer_final_fields
  List<Widget> _widgetOption = <Widget>[
    AudioInfo(),
    Search(),
    Consumer<LoginController>(builder: (context, model, child) {
      if(model.userDetails != null) {
        return Center(
          child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        CircleAvatar(
          backgroundImage: Image.network(model.userDetails!.photoURL ?? "").image,
          radius: 50,
        ),

        Text(model.userDetails!.displayName ?? ""),
        Text(model.userDetails!.email ?? ""),

        //for log-out
        ActionChip(
          avatar: const Icon(Icons.logout),
          label: const Text("Logout"),
          onPressed: ()
          {
            Provider.of<LoginController>(context, listen: false).logout();
          },
        )
      ],
    ),
        );
      }
      else {
        return Center(
          child: Text("Error"),
        );
      }
    }),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('OverVoice'),
      //   backgroundColor: Color(0xFFFF7200),
      // ),
      body: Center(child: _widgetOption.elementAt(_selectedIndex)),
      bottomNavigationBar: SizedBox(
        height: 65,
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Profile"),
          ],
          type: BottomNavigationBarType.fixed,
          iconSize: 35,
          selectedItemColor: Colors.white,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: Color(0xFFFF7200),
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
        ),
      ),
    );
  }
}