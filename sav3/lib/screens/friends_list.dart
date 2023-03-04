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

    reqWidgets.add(
            // Figma Flutter Generator Group33Widget - GROUP
      Container(
      width: 61,
      height: 101,
      
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Container(
            width: 61,
            height: 101,
            decoration: BoxDecoration(
              borderRadius : BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              boxShadow : [BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0,4),
                  blurRadius: 4
              )],
              color : Color.fromRGBO(247, 247, 247, 1),
          )
          )
          ),Positioned(
            top: 57,
            left: 7,
            child: Text('Connor', textAlign: TextAlign.center, style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontFamily: 'Kulim Park',
            fontSize: 15,
            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
            fontWeight: FontWeight.bold,
            height: 1
          ),)
          ),Positioned(
            top: 0,
            left: 1,
            child: Text('1.', textAlign: TextAlign.left, style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontFamily: 'PT Sans Caption',
            fontSize: 15,
            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
            fontWeight: FontWeight.bold,
            height: 1
          ),)
          ),Positioned(
            top: 19,
            left: 14,
            child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color : Color.fromRGBO(42, 81, 53, 1),
          borderRadius : BorderRadius.all(Radius.elliptical(34, 34)),
      )
          )
          ),Positioned(
            top: 73,
            left: 10,
            child: Text('27%', textAlign: TextAlign.center, style: TextStyle(
            color: Color.fromRGBO(138, 201, 38, 1),
            fontFamily: 'PT Sans Caption',
            fontSize: 20,
            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
            fontWeight: FontWeight.bold,
            height: 1
          ),)
          ),Positioned(
            top: 0,
            left: 41,
            child: Text('98', textAlign: TextAlign.right, style: TextStyle(
            color: Color.fromRGBO(255, 122, 0, 1),
            fontFamily: 'PT Sans Caption',
            fontSize: 15,
            letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
            fontWeight: FontWeight.bold,
            height: 1
          ),)
          ),
        ]
      )
    )
    /*
      Container(
        width: 61,
        height: 101,
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
                Container(
                    width: 61,
                    height: 101,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                            BoxShadow(
                                color: Color(0x3f000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                            ),
                        ],
                        color: Color(0xfff7f7f7),
                    ),
                    child: Stack(
                        children:[
                            Positioned(
                                left: 7,
                                top: 57,
                                child: Text(
                                    "Connor",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                    ),
                                ),
                            ),
                            Positioned(
                                left: 1,
                                top: 0,
                                child: Text(
                                    "1.",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: "PT Sans Caption",
                                        fontWeight: FontWeight.w700,
                                    ),
                                ),
                            ),
                            Positioned(
                                left: 14,
                                top: 19,
                                child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff2a5135),
                                    ),
                                ),
                            ),
                            Positioned.fill(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                        "27%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xff8ac926),
                                            fontSize: 20,
                                            fontFamily: "PT Sans Caption",
                                            fontWeight: FontWeight.w700,
                                        ),
                                    ),
                                ),
                            ),
                            Positioned.fill(
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        "98",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Color(0xffff7a00),
                                            fontSize: 15,
                                            fontFamily: "PT Sans Caption",
                                            fontWeight: FontWeight.w700,
                                        ),
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
            ],
        ),
    )
    */
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

class FriendTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        width: 171,
        height: 103,
        child: Stack(
            children:[Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: 61,
                        height: 101,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                                BoxShadow(
                                    color: Color(0x3f000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                ),
                            ],
                            color: Color(0xfff7f7f7),
                        ),
                        child: Stack(
                            children:[
                                Positioned(
                                    left: 14,
                                    top: 19,
                                    child: Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                        ),
                                        child: FlutterLogo(size: 34),
                                    ),
                                ),
                                Positioned(
                                    left: 6,
                                    top: 10,
                                    child: Container(
                                        width: 50,
                                        height: 50,
                                        padding: const EdgeInsets.only(right: 20, bottom: 43, ),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                                Transform.rotate(
                                                    angle: -1.80,
                                                    child: Container(
                                                        width: double.infinity,
                                                        height: 41.62,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Color(0xffe8e8e8),
                                                        ),
                                                    ),
                                                ),
                                                SizedBox(height: 25),
                                                Transform.rotate(
                                                    angle: -1.80,
                                                    child: Container(
                                                        width: double.infinity,
                                                        height: 41.62,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Color(0xff8ac926),
                                                        ),
                                                    ),
                                                ),
                                                SizedBox(height: 25),
                                                Container(
                                                    width: 9,
                                                    height: 3,
                                                    color: Color(0xff8ac926),
                                                ),
                                                SizedBox(height: 25),
                                                Container(
                                                    width: 4,
                                                    height: 4,
                                                    color: Color(0xff8ac926),
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),
                ),
            ),
            Positioned(
                left: 0,
                top: 49,
                child: SizedBox(
                    width: 170,
                    height: 37,
                    child: Text(
                        "Connor",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                        ),
                    ),
                ),
            ),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                        width: 116,
                        height: 23,
                        child: Text(
                            "1.",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "PT Sans Caption",
                                fontWeight: FontWeight.w700,
                            ),
                        ),
                    ),
                ),
            ),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width: 86,
                        height: 30,
                        child: Text(
                            "27%",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff8ac926),
                                fontSize: 20,
                                fontFamily: "PT Sans Caption",
                                fontWeight: FontWeight.w700,
                            ),
                        ),
                    ),
                ),
            ),
            Positioned(
                left: 78,
                top: 0,
                child: SizedBox(
                    width: 35,
                    height: 23,
                    child: Text(
                        "98",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color(0xffff7a00),
                            fontSize: 15,
                            fontFamily: "PT Sans Caption",
                            fontWeight: FontWeight.w700,
                        ),
                    ),
                ),
            ),],
        ),
    )
    );
  }
}