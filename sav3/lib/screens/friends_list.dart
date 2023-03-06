import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav3/screens/user_profile.dart';

import '../services/firestore.dart';
import 'add_friends.dart';
import 'friend_requests.dart';

class FriendsList extends StatefulWidget {
  @override
  State<FriendsList> createState() => _FriendsListState();
  //StatelessWidget createState() => FriendTest();
}

class _FriendsListState extends State<FriendsList> {
  final Firestore fs = Firestore();

  Future<List<Widget>> BuildList() async {
    List<Widget> reqWidgets = <Widget>[];
    List<String> friendList = <String>[];
    List<int> widgetOrder = <int>[];
    int indexToAdd = 0;

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

    reqWidgets.add(const Padding(
      padding: EdgeInsets.all(10.0),
    ));
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

          final friendDoc =
              FirebaseFirestore.instance.collection('users').doc(friend);
          await friendDoc.get().then((DocumentSnapshot doc) {
            int time = doc.get(FieldPath(['Time']));
            for (int j = 0; j < widgetOrder.length; j++) {
              if (time > widgetOrder.elementAt(j)) {
                indexToAdd = j;
                break;
              }
            }
            widgetOrder.insert(indexToAdd, time);
            friendList.insert(indexToAdd, friend);
            indexToAdd++;
          });    
        }

        for (int i = 0; i < friendList.length; i++) {
          if (i < 3) {
            reqWidgets.add(Container(
                    width: 61,
                    height: 101,
                    child: Stack(children: <Widget>[
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                              width: 61,
                              height: 101,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      offset: Offset(0, 4),
                                      blurRadius: 4)
                                ],
                                color: Color.fromRGBO(247, 247, 247, 1),
                              ))),
                      Positioned(
                          top: 57,
                          left: 7,
                          child: Text(
                            friendList.elementAt(i),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'Kulim Park',
                                fontSize: 15,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          )),
                      Positioned(
                          top: 0,
                          left: 1,
                          child: Text(
                            i.toString() + '. ',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontFamily: 'PT Sans Caption',
                                fontSize: 15,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          )),
                      Positioned(
                          top: 19,
                          left: 14,
                          child: Container(
                              width: 34,
                              height: 34,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(42, 81, 53, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.elliptical(34, 34)),
                              ))),
                      Positioned(
                          top: 73,
                          left: 10,
                          child: Text(
                            widgetOrder.elementAt(i).toString() + '%',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color.fromRGBO(138, 201, 38, 1),
                                fontFamily: 'PT Sans Caption',
                                fontSize: 20,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          )),
                      const Positioned(
                          top: 0,
                          left: 41,
                          child: Text(
                            '98',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 122, 0, 1),
                                fontFamily: 'PT Sans Caption',
                                fontSize: 15,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          )),
                    ])));
          } else {
            reqWidgets.add(Row(
            children: [
              Text(friendList.elementAt(i)),
              const Spacer(flex: 8),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfile(
                                friendList.elementAt(i))));
                  },
                  child: const Text('Profile')),
            ],
          ));
          }
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

/*
                  
*/
