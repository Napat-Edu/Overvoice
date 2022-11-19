import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/login_controller.dart';
import '../main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7200),
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Edit"),
              ),
              PopupMenuItem<int>(
                value: 0,
                child: Text("Logout"),
              ),
            ],
            onSelected: (item) => SelectedItem(context, item),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildCoverImage(),
          buildCoverImage2(),
          loadData(context),
          buildContent(),
          recLike(context),
          buildMiddler(),
          buildBelow(),
          //LogoutAvatar(context),
        ],
      ),
    );
  }

  Widget buildCoverImage() => Container(
        decoration: BoxDecoration(color: const Color(0xFFFF7200)),
        height: 90,
      );

  Widget buildCoverImage2() => Container(
        decoration: BoxDecoration(color: Colors.white10),
        height: 30,
      );

  Widget LogoutAvatar(BuildContext context) => ActionChip(
        avatar: const Icon(Icons.logout),
        label: const Text("Logout"),
        onPressed: () {
          Provider.of<LoginController>(context, listen: false).logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPageRoute()),
          );
        },
      );

  Widget buildContent() => Container(
        //decoration: BoxDecoration(color: const Color(0xFFFF7200)),
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Positioned(
                right: 100,
                child: Icon(Icons.edit, size: 15),
              ),*/
              //Icon(Icons.edit, size: 15),
              Text(
                'Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has beenthe industry has standard dummy text ever since the 1500s.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: Color.fromARGB(255, 152, 137, 137),
                ),
              ),
            ],
          ),
        ),
      );

  Widget recLike(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildRecLike(text: 'recordings', value: 0),
          /*VerticalDivider(
            color: Colors.black,
            thickness: 2,
          ),*/
          Image.asset("assets/image/LineRL.png"),
          Image.asset("assets/image/LineRL.png"),
          buildRecLike(text: 'likes', value: 0),
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
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );

  Widget buildMiddler() => Container(
        //decoration: BoxDecoration(color: Color.fromARGB(88, 255, 115, 0)),
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
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
                child: Text('          Records          ',
                    style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFFF7200),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Text('         Favorites         ',
                    style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      );

  Widget buildBelow() => Container(
        //decoration: BoxDecoration(color: Color.fromARGB(88, 255, 115, 0)),
        height: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/image/Recordvoice.png"),
            SizedBox(height: 12),
            Text(
              'Create your first performance!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFFF7200),
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: Text('Start Record', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      );

  Widget loadData(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      final user = FirebaseAuth.instance.currentUser;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              backgroundImage: Image.network(user!.photoURL ?? "").image,
              radius: profileHeight / 2,
            ),

            Text(user.displayName ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  fontWeight: FontWeight.normal,
                )),
            Text(user.email ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.4,
                  fontWeight: FontWeight.normal,
                )),

            //for log-out------------------------------------------------------
            /*ActionChip(
              avatar: const Icon(Icons.logout),
              label: const Text("Logout"),
              onPressed: () {
                Provider.of<LoginController>(context, listen: false).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPageRoute()),
                );
              },
            ),*/
          ],
        ),
      );
    } else {
      return const Center(
        child: Text("Loading"),
      );
    }
  }

  SelectedItem(BuildContext context, int item) {
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
