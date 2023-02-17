import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  String fName = '';
  String lName = '';
  String token = '';

  void getData(String f, String l, String u) {
    fName = f;
    lName = l;
    token = u;
    createUser(name: f + ' ' + l);
  }

  Future createUser({required String name}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(name);

    final json = {'First Name': fName, 'Last Name': lName, 'token': token};

    await docUser.set(json);
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
    
  }
}
