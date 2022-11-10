import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/login_controller.dart';
import '../main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadData(context),
    );
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
              backgroundImage: Image.network(user!.photoURL ?? "").image,
              radius: 50,
            ),

            Text(user.displayName ?? ""),
            Text(user.email ?? ""),

            //for log-out
            ActionChip(
              avatar: const Icon(Icons.logout),
              label: const Text("Logout"),
              onPressed: () {
                Provider.of<LoginController>(context, listen: false).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPageRoute()),
                );
              },
            )
          ],
        ),
      );
    } else {
      return const Center(
        child: Text("Loading"),
      );
    }
  }
}
