import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore.dart';

class FriendRequests extends StatefulWidget {
  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  final Firestore fs = Firestore();

  Future<List<Widget>> BuildList() async {
    List<Widget> reqWidgets = <Widget>[];
    final curr = FirebaseFirestore.instance
        .collection('id map')
        .doc(Firestore.getCurrentUser());

    await curr.get().then((DocumentSnapshot documentSnapshot) async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(await documentSnapshot.get(FieldPath(['name'])));
      await user.get().then((DocumentSnapshot documentSnapshot) async {
        for (int i = 0;
            i <
                await documentSnapshot
                    .get(FieldPath(['Friend Requests']))
                    .length;
            i++) {
          String friend = await documentSnapshot
              .get(FieldPath(['Friend Requests']))
              .elementAt(i);
          reqWidgets.add(Row(
            children: [
              Text(friend),
              Spacer(flex: 8),
              ElevatedButton(
                  onPressed: () {
                    fs.acceptRequest(friend);
                  },
                  child: Text('Accept')),
            ],
          ));
          reqWidgets.add(Spacer());
        }
      });
    });
    return reqWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: const Text('Friend Requests'),
      ),
      body: FutureBuilder<List<Widget>>(
          future: BuildList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: snapshot.data!),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
