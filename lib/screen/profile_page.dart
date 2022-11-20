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
              backgroundColor: Color(0xFFFFAA66),
              radius: 54,child: Align(alignment: Alignment.center,child: CircleAvatar(radius: 50,backgroundImage: Image.network(user!.photoURL ?? "").image,),),
            ),

            SizedBox(height: 10,),

            Text(user.displayName ?? "",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text(user.email ?? "",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),

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
