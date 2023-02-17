import 'package:flutter/material.dart';
import 'package:sav3/auth.dart';
import 'package:sav3/screentime.dart';
import 'friends_list.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  Screentime st = new Screentime();

  @override
  Widget build(BuildContext context) {
    final Auth _auth = Auth();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Print Usage Time'),
              onPressed: () => st.getUsage(),),
            ElevatedButton(
              child: const Text('Sign Out'),
              onPressed: () => _auth.signOut(),),
            ElevatedButton(
              child: const Text('Friends'),
              onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FriendsList())))]
        ),),);
  }
}

