import 'package:flutter/material.dart';
import 'package:overvoice_project/screen/audioinfo.dart';
import 'package:overvoice_project/screen/profile_page.dart';

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
    const Text('Search'),
    const ProfilePage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OverVoice'),
        backgroundColor: const Color(0xFFFF7200),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: _widgetOption.elementAt(_selectedIndex)),
      bottomNavigationBar: SizedBox(
        height: 65,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Profile"),
          ],
          type: BottomNavigationBarType.fixed,
          iconSize: 35,
          selectedItemColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          backgroundColor: const Color(0xFFFF7200),
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
        ),
      ),
    );
  }
}
