import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user.dart';

class Firestore {
  String fName = '';
  String lName = '';
  String token = '';
  static String currentUser = '';

  static void submitCurrent(String id) {
    currentUser = id;
  }

  void getData(String f, String l, String u) {
    fName = f;
    lName = l;
    token = u;
    createUser(name: f + ' ' + l);
  }

  Future createUser({required String name}) async {
    final user = User(
      fName: fName,
      lName: lName,
      pfp: '',
      code: 0,
      requests: [],
      friends: [],
    );

    final docUser = FirebaseFirestore.instance
        .collection('users')
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, options) => user.toFirestore(),
        )
        .doc(name);
    await docUser.set(user);
  }

  Future<String> searchUsers(String name) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(name)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.get(FieldPath(['token']));
      } else {
        return 'NotFound';
      }
    });
  }

  void sendRequest(String token, String name) {
    final outgoing = FirebaseFirestore.instance.collection('users').doc(name);
    outgoing.update({
      'Friend Requests':
          outgoing.get().then((DocumentSnapshot documentSnapshot) {
        documentSnapshot.get(FieldPath(['Friend Requests'])).add(currentUser);
      })
    });
  }
}
