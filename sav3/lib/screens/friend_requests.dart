import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore.dart';

class FriendRequests extends StatefulWidget {
  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  var trial;
  final Firestore fs = Firestore();
  var requests;

  Future<void> fetchList() async {
    final curr = FirebaseFirestore.instance
        .collection('id map')
        .doc(Firestore.getCurrentUser());
    await curr.get().then((DocumentSnapshot documentSnapshot) async {
      requests = await documentSnapshot.get(FieldPath(['Friend Requests']));
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchList();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          title: const Text('Friends'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            for (var i in requests)
              Row(children: [
                Text(i),
                ElevatedButton(
                    onPressed: () => print(i), child: Text('Accept')),
              ]),
          ]),
        ));
  }
}
