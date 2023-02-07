import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  String fName = '';
  String lName = '';

  void getData(String f, String l) {
    fName = f;
    lName = l;
    createUser(name: f + '-' + l);
  }

  Future createUser({required String name}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');

    final json = {
      'First Name': fName,
      'Last Name': lName,
    };

    await docUser.set(json);
  }
}
