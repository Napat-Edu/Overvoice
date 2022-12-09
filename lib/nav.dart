import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overvoice_project/screen/profile_page.dart';
import 'package:overvoice_project/screen/home_page.dart';
import 'package:overvoice_project/screen/search_page.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  // each page will get called by _selectedIndex (0-2)
  final List<Widget> _widgetOption = <Widget>[
    const Home(),
    const Search(),
    const ProfilePage(),
  ];

  // use for update a screen index from the user
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOption.elementAt(_selectedIndex)),
      bottomNavigationBar: SizedBox(
        height: 68,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Profile"),
          ],
          type: BottomNavigationBarType.fixed,
          iconSize: 35,
          unselectedFontSize: 12,
          selectedFontSize: 13,
          selectedItemColor: Colors.white,
          selectedLabelStyle: GoogleFonts.prompt(fontWeight: FontWeight.w600),
          backgroundColor: const Color(0xFFFF7200),
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
        ),
      ),
    );
  }
}
