import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav3/services/firestore.dart';

class UserProfile extends StatelessWidget {
  final Firestore fs = Firestore();
  int code = 0;
  String name = '';
  String curr_name = '';
  List<dynamic> requests = <String>[];
  List<dynamic> friends = <String>[];

  UserProfile(int code, String name) {
    this.code = code;
    this.name = name;
  }

  Future<bool> createButton() async {
    final curr = FirebaseFirestore.instance
        .collection('id map')
        .doc(Firestore.getCurrentUser());
    await curr.get().then((DocumentSnapshot documentSnapshot) {
      curr_name = documentSnapshot.get(FieldPath(['name']));
      FirebaseFirestore.instance
          .collection('users')
          .doc(documentSnapshot.get(FieldPath(['name'])))
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        requests = documentSnapshot.get(FieldPath(['Friend Requests']));
        friends = documentSnapshot.get(FieldPath(['Friends List']));
      });
    });

    if (curr_name == name) {
      return false;
    }

    for (int i = 0; i < requests.length; i++) {
      if (requests.elementAt(i) == name) {
        return false;
      }
    }

    for (int i = 0; i < friends.length; i++) {
      if (friends.elementAt(i) == name) {
        return false;
      }
    }

    return true;
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
      body: FutureBuilder<bool>(
          future: createButton(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const Image(
                          image: NetworkImage(
                              'https://static.thenounproject.com/png/5034901-200.png')),
                      if (snapshot.data!)
                        ElevatedButton(
                            child: Text('Add Friend'),
                            onPressed: () => fs.sendRequest(code, name)),
                    ]),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
