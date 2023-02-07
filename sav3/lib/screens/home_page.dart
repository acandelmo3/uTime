import 'package:flutter/material.dart';
import 'package:sav3/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        child: ElevatedButton(
          child: const Text('Sign Out'),
          onPressed: () => _auth.signOut(),),),);
  }
}

