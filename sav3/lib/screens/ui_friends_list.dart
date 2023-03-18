import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav3/screens/user_profile.dart';

import '../services/firestore.dart';
import 'add_friends.dart';
import 'friend_requests.dart';
import 'ui_friend_requests.dart';
import 'ui_test.dart';
import 'ui_add_friends.dart';
import 'ui_user_profile.dart';

class UIFriendsList extends StatefulWidget {
  @override
  State<UIFriendsList> createState() => _UIFriendsListState();
  //StatelessWidget createState() => FriendTest();
}

class _UIFriendsListState extends State<UIFriendsList> {
  final Firestore fs = Firestore();

  
  
  Future<List<Widget>> BuildList() async {
    List<Widget> reqWidgets = <Widget>[];
    List<String> friendList = <String>[];
    List<int> widgetOrder = <int>[];
    int indexToAdd = 0;

    /*
    reqWidgets.add(
      Row(children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 75, 57, 233),
            shape: const StadiumBorder()
          ),
          child: const Text('Add Friends'),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddFriends())),
        ),
        const Spacer(
          flex: 2,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 75, 57, 233),
            shape: const StadiumBorder()
          ),
          child: const Text('Friend Requests'),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => FriendRequests())),
        ),
      ]),
    );
    */

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
          
          //if (i < 3) {
          if (i > 100) {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                  shape: const StadiumBorder()
                ),
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
        }});
      });
    //}
    return reqWidgets;
  
  }
  

  /*
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
                    //.get(FieldPath(['Friend Requests']))
                    .get(FieldPath(['Friends List']))
                    .length;
            i++) {
          String friend = await documentSnapshot
              //.get(FieldPath(['Friend Requests']))
              .get(FieldPath(['Friends List']))
              .elementAt(i);
          reqWidgets.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //alignment: Center,
                height: 50,
                width: 320,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
                //padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  Text(friend, style: TextStyle(fontWeight: FontWeight.bold),),
                  ]
                  )
                  
              ),
              
            ],
          ));
          reqWidgets.add(Spacer());
        }
      });
    });
    return reqWidgets;
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 79, 118, 176),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 57, 233),
        elevation: 0.0,
        title: const Text('uTime', style: TextStyle(fontFamily: 'roboto')),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 75, 57, 233),
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(onPressed: () async {
                FirebaseFirestore.instance
                    .collection('id map')
                    .doc(Firestore.getCurrentUser())
                    .get()
                    .then((DocumentSnapshot documentSnapshot) async {
                  String name = await documentSnapshot.get(FieldPath(['name']));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UIUserProfile(name)));
                });
              },
                  icon: const Icon(Icons.settings,
                    color: Colors.white,
                  )), 
            IconButton(onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UITest())),
                icon: const Icon(Icons.home, 
                  color: Colors.white,
                )), 
            IconButton(onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UIFriendsList())),
                icon: const Icon(Icons.person,
                  color: Color.fromARGB(255, 255, 225, 52),
                )), 
          ],
        )
      ),
      body: //FutureBuilder<List<Widget>>(
        Stack(children: [
          Container(
            child: Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    //color: const Color.fromARGB(255, 79, 118, 176),
                    color: const Color.fromARGB(255, 132, 173, 235),
                    height: 300,
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    //color: const Color.fromARGB(255, 132, 173, 235),
                    color: const Color.fromARGB(255, 190, 220, 255),
                    height: 180,
                  ),
                ),
                
              ],
            ),
          ),
          
        //reqWidgets.add(
        Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                shape: const StadiumBorder()
              ),
              child: const Text('Add Friends', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UIAddFriends())),
            ),
            //const Spacer(
            //  flex: 2,
            //),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                shape: const StadiumBorder()
              ),
              child: const Text('Friend Requests',  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UIFriendRequests())),
            ),
          ]),
          
    //);
        FutureBuilder<List<Widget>>(
          future: BuildList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: snapshot.data!));
            } else {
              return Container();
              /*
              return const Text('Add friends above!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 75, 57, 233),
                  fontSize: 22,
                )
              );
              */
            }
          }),
        //])
          ]
    )]
    )
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height / 2);
    //var firstStart = Offset(size.width / 5, size.height);
    //var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    var firstStart = Offset(size.width / 5, size.height - 100.0);
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), size.height);
    var secondEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldDelagate) {
    return oldDelagate != this;
  }
}