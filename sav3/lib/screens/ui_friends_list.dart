import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uTime/screens/user_profile.dart';
import '../services/build_friends.dart';
import '../services/firestore.dart';
import 'ui_friend_requests.dart';
import 'ui_test_copy.dart';
import 'ui_add_friends.dart';
import 'ui_user_profile.dart';

class UIFriendsList extends StatefulWidget {
  @override
  State<UIFriendsList> createState() => _UIFriendsListState();
  //StatelessWidget createState() => FriendTest();
}

class _UIFriendsListState extends State<UIFriendsList> {
  final Firestore fs = Firestore();

  
  
  Future<List<Widget>> BuildList1() async {
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

        /**
         * Build Friends List Widgets
         */
        for (int i = 0; i < friendList.length; i++) {
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
        }});
      });
    return reqWidgets;
  
  }
  

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
      body:

      /**
       * Background Design
       */
        Stack(children: [
          Container(
            child: Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    color: const Color.fromARGB(255, 132, 173, 235),
                    height: 300,
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    color: const Color.fromARGB(255, 190, 220, 255),
                    height: 180,
                  ),
                ),
                
              ],
            ),
          ),
          
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
          
    
        FutureBuilder(
          future: BuildFriends.buildList(context),
          builder: (BuildContext context,
              AsyncSnapshot<List<Widget>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0),
                  child: Column(children: snapshot.data!));
            } else {
              return Container();
            }
          })
          
          ]
      )]
    )
    );
  }
}

///Background Designer Function
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height / 2);
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