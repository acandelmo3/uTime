import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../user.dart';

class Firestore {
  String fName = '';
  String lName = '';
  String token = '';
  static String currentUser = '';

  Firestore() {
    getCurrent();
  }
  Future<void> getCurrent() async {
    User? user = await FirebaseAuth.instance.currentUser;
    user!.getIdToken().then((result) {
      currentUser = result.substring(0, 25);
    });
  }

  void getData(String f, String l, String u) {
    fName = f;
    lName = l;
    token = u;
    createUser(name: f + ' ' + l);
  }

  Future createUser({required String name}) async {
    final user = AppUser(
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
          fromFirestore: AppUser.fromFirestore,
          toFirestore: (AppUser user, options) => user.toFirestore(),
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

  static String getCurrentUser() {
    return currentUser;
  }

  Future<void> sendRequest(int code, String name) async {
    final outgoing = FirebaseFirestore.instance.collection('users').doc(name);
    List<dynamic> temp = [];
    await outgoing.get().then((DocumentSnapshot documentSnapshot) {
      temp = documentSnapshot.get(FieldPath(['Friend Requests']));
    });
    final curr =
        FirebaseFirestore.instance.collection('id map').doc(currentUser);
    await curr.get().then((DocumentSnapshot documentSnapshot) async {
      temp.add(documentSnapshot.get(FieldPath(['name'])));
    });
    await outgoing.update({'Friend Requests': temp});
  }

  Future<void> acceptRequest(String name) async {
    List<dynamic> requests = <String>[];
    List<dynamic> friends = <String>[];
    final curr = FirebaseFirestore.instance
        .collection('id map')
        .doc(currentUser)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(documentSnapshot.get(FieldPath(['name'])));
      await user.get().then((DocumentSnapshot documentSnapshot) {
        requests = documentSnapshot.get(FieldPath(['Friend Requests']));
        friends = documentSnapshot.get(FieldPath(['Friends List']));
      });
      requests.remove(name);
      friends.add(name);
      await user.update({'Friend Requests': requests});
      await user.update({'Friends List': friends});
    });
  }
}
