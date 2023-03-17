import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../screens/user_profile.dart';
import 'firestore.dart';

class BuildFriends {
  static Future<List<Widget>> buildList(BuildContext context) async {
    List<Widget> reqWidgets = <Widget>[];
    List<String> friendList = <String>[];
    List<int> widgetOrder = <int>[];
    int indexToAdd = 0;

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
            int time = doc.get(FieldPath(['Time'])).toInt();
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

        if (friendList.isEmpty) {
          reqWidgets.add(const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
             child: Text('Click the Add Friends Button!')));
        }

        int i = 0;
        while (i < friendList.length) {
          int time = widgetOrder.elementAt(i) ~/ (1000 * 60 * 60);
          String name = friendList.elementAt(i++);
          reqWidgets.add(Row(
            children: [
              RichText(
                text: TextSpan(
                    text: '$i. $name',
                    style: const TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserProfile(friendList.elementAt(i - 1))));
                      }),
              ),
              const Spacer(),
              Text('$time hrs'),
            ],
          ));
        }
      });
    });
    return reqWidgets;
  }
}
