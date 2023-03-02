import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav3/screens/user_profile.dart';

import '../services/firestore.dart';
import 'add_friends.dart';
import 'friend_requests.dart';

class FriendsList extends StatefulWidget {
  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  final Firestore fs = Firestore();

  Future<List<Widget>> BuildList() async {
    List<Widget> reqWidgets = <Widget>[];
    reqWidgets.add(
      Row(children: [
        ElevatedButton(
          child: const Text('Add Friends'),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddFriends())),
        ),
        const Spacer(
          flex: 2,
        ),
        ElevatedButton(
          child: const Text('Friend Requests'),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => FriendRequests())),
        ),
      ]),
    );
    reqWidgets.add(Padding(padding: EdgeInsets.all(10.0),));
    final curr = FirebaseFirestore.instance
        .collection('id map')
        .doc(Firestore.getCurrentUser());

    await curr.get().then((DocumentSnapshot documentSnapshot) async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(await documentSnapshot.get(FieldPath(['name'])));
      await user.get().then((DocumentSnapshot documentSnapshot) async {
        for (int i = 0;
            i < await documentSnapshot.get(FieldPath(['Friends List'])).length;
            i++) {
          String friend = await documentSnapshot
              .get(FieldPath(['Friends List']))
              .elementAt(i);
          reqWidgets.add(Row(
            children: [
              Text(friend),
              Spacer(flex: 8),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfile(
                                documentSnapshot
                                    .get(FieldPath(['Friend Code'])),
                                friend)));
                  },
                  child: Text('Profile')),
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
        title: const Text('Friends'),
      ),
      body: FutureBuilder<List<Widget>>(
          future: BuildList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: snapshot.data!));
            } else {
              return Container();
            }
          }),
    );
  }
}
