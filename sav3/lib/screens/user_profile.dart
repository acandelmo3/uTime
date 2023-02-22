import 'package:flutter/material.dart';
import 'package:sav3/services/firestore.dart';

class UserProfile extends StatelessWidget {
  final Firestore fs = Firestore();
  int code = 0;
  String name = '';

  UserProfile(int code, String name) {
    this.code = code;
    this.name = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Text(name + '\'s Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),),
              Image(image: NetworkImage('https://static.thenounproject.com/png/5034901-200.png')),
              ElevatedButton(child: Text('Add Friend'),
                onPressed: () => fs.sendRequest(code, name)),
            ]),
      ),
    );
  }
}
