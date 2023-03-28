import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore.dart';

class UIFriendRequests extends StatelessWidget {
  UIFriendRequests({super.key});
  final Firestore fs = Firestore();

  Future<List<Widget>> buildList() async {
    List<Widget> reqWidgets = <Widget>[];
    final curr = FirebaseFirestore.instance
        .collection('id map')
        .doc(Firestore.getCurrentUser());

    await curr.get().then((DocumentSnapshot documentSnapshot) async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(await documentSnapshot.get(FieldPath(const ['name'])));
      await user.get().then((DocumentSnapshot documentSnapshot) async {
        for (int i = 0;
            i <
                await documentSnapshot
                    .get(FieldPath(const ['Friend Requests']))
                    .length;
            i++) {
          String friend = await documentSnapshot
              .get(FieldPath(const ['Friend Requests']))
              .elementAt(i);
          reqWidgets.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 320,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                  Text(friend, style: const TextStyle(fontWeight: FontWeight.bold),),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                        shape: const StadiumBorder()
                      ),
                      onPressed: () {
                        fs.acceptRequest(friend);
                      },
                      child: const Text('Accept')),
                    ],),
              ),
              
            ],
          ));
          reqWidgets.add(const Spacer());
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
        Stack(
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
      
      FutureBuilder<List<Widget>>(
          future: buildList(),
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
      ])
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