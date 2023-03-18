import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore.dart';

class UIFriendRequests extends StatefulWidget {
  @override
  State<UIFriendRequests> createState() => _UIFriendRequestsState();
}

class _UIFriendRequestsState extends State<UIFriendRequests> {
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
                    //.get(FieldPath(['Friends List']))
                    .length;
            i++) {
          String friend = await documentSnapshot
              .get(FieldPath(['Friend Requests']))
              //.get(FieldPath(['Friends List']))
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
                  //MainAxisAlignment
                  //Spacer(flex: 7),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                        shape: const StadiumBorder()
                      ),
                      onPressed: () {
                        fs.acceptRequest(friend);
                      },
                      child: Text('Accept')),
                    ],),
              ),
              // Text(friend, style: TextStyle(fontWeight: FontWeight.bold),),
              // Spacer(flex: 8),
              // ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color.fromARGB(255, 75, 57, 233),
              //       shape: const StadiumBorder()
              //     ),
              //     onPressed: () {
              //       fs.acceptRequest(friend);
              //     },
              //     child: Text('Accept')),
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
      backgroundColor: const Color.fromARGB(255, 79, 118, 176),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 57, 233),
        elevation: 0.0,
        title: const Text('uTime', style: TextStyle(fontFamily: 'roboto')),
        centerTitle: true,
      ),
      body: 
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
      
      FutureBuilder<List<Widget>>(
          future: BuildList(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: snapshot.data!),
              );
            } else {
              /*
              return const Text('No Friend Requests',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 75, 57, 233),
                  fontSize: 22,
                )
              );
              */
              return Container();
            }
          }),
      ])
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