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
    currentUser = id.substring(0, 25);
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

    final idDoc =
        FirebaseFirestore.instance.collection('id map').doc(currentUser);
    await idDoc.set({'name': name});
  }

  Future<int> searchUsers(String name) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(name)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.get(FieldPath(['Friend Code']));
      } else {
        return -1;
      }
    });
  }

  Future<void> sendRequest(int code, String name) async {
    final outgoing = FirebaseFirestore.instance.collection('users').doc(name);
    List<dynamic> temp = [];
    await outgoing.get().then((DocumentSnapshot documentSnapshot) {
      temp = documentSnapshot.get(FieldPath(['Friend Requests']));
    });
    final curr =
        FirebaseFirestore.instance.collection('id map').doc(currentUser);
    curr.get().then((DocumentSnapshot documentSnapshot) {
      temp.add(documentSnapshot.get(FieldPath(['name'])));
    });
    await outgoing.update({'Friend Requests': temp});
    print(temp);
    outgoing.get().then((DocumentSnapshot documentSnapshot) {
      print(documentSnapshot.get(FieldPath(['Friend Requests'])));
    });
  }
}
