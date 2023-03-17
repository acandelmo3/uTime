import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uTime/screens/user_profile.dart';
import 'package:uTime/services/auth.dart';
import '../services/build_friends.dart';
import '../services/firestore.dart';
import '../services/screentime.dart';
import 'add_friends.dart';
import 'friends_list.dart';
import 'login_matrix.dart';

class UITest extends StatelessWidget {
  UITest({super.key});
  Screentime st = Screentime();

  Future<String> showTime() async {
    double result = await st.getUsage();
    int days = (result / (1000 * 60 * 60 * 24)).toInt();
    int hrs = ((result / (1000 * 60 * 60)) % 24).toInt();
    int mins = ((result / (1000 * 60) % 60)).toInt();
    String time = '$days days $hrs hrs $mins mins';
    return time;
  }

  @override
  Widget build(BuildContext context) {
    final Auth _auth = Auth();
    final Firestore fs = Firestore();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 190, 220, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 57, 233),
        elevation: 0.0,
        title: const Text('uTime', style: TextStyle(fontFamily: 'roboto')),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 75, 57, 233),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection('id map')
                        .doc(Firestore.getCurrentUser())
                        .get()
                        .then((DocumentSnapshot documentSnapshot) async {
                      String name =
                          await documentSnapshot.get(FieldPath(['name']));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfile(name)));
                    });
                  },
                  icon: const Icon(Icons.person)),
              IconButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UITest())),
                  icon: const Icon(Icons.refresh)),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CustomPaint(
            painter: BluePainter(),
            //child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
            //  children: [],
            //))
          ),
          Row(
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                      //backgroundColor: const Colors.white,
                      //foregroundColor: const Color.fromARGB(255, 75, 57, 233),
                      shape: const StadiumBorder()),
                  onPressed: () {
                    _auth.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Matrix()));
                  },
                  child:
                      const Text('Sign Out', style: TextStyle(fontSize: 15))),
              const Spacer(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                      //backgroundColor: const Colors.white,
                      //foregroundColor: const Color.fromARGB(255, 75, 57, 233),
                      shape: const StadiumBorder()),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddFriends())),
                  child: const Text('Add Friends',
                      style: TextStyle(fontSize: 15))),
            ],
          ),
          /*
            FutureBuilder(
              future: showTime(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.data != null) {
                  return Text(snapshot.data!);
                } else {
                  return Container();
                }
              },
            ),
          
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                //backgroundColor: const Colors.white,
                //foregroundColor: const Color.fromARGB(255, 75, 57, 233),
                shape: const StadiumBorder()
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const Matrix()));
              },
              child: const Text('Sign Out', style: TextStyle(fontSize: 15))),
          ElevatedButton(
              child: const Text('Friends'),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FriendsList()))),
          ElevatedButton(
              child: const Text('Profile'),
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection('id map')
                    .doc(Firestore.getCurrentUser())
                    .get()
                    .then((DocumentSnapshot documentSnapshot) async {
                  String name = await documentSnapshot.get(FieldPath(['name']));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfile(name)));
                });
              }), */
          FutureBuilder(
            future: fs.getGoalPercent(),
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (snapshot.data != null) {
                return (Center(
                    child: Stack(alignment: Alignment.center, children: [
                  Center(
                    //height: 200, children: [
                    //Stack(
                    //height: 200,
                    //Stack(
                    child: SizedBox(
                      height: 270.0,
                      width: 270.0,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: const Color.fromARGB(255, 255, 225, 52),
                        value: snapshot.data,
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                    ),
                  ),
                  Center(
                    //heightFactor: 13,
                    child: FutureBuilder(
                      future: showTime(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.data != null) {
                          return Text(
                            snapshot.data!,
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.75,
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ])));
                //);
              } else {
                return Container();
              }
            },
          ),
          Container(
            height: 25,
          ),
          Flexible(
            //alignment: Alignment.bottomCenter,
            child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: SizedBox(
                    height: 400,
                    width: 325,
                    child: Column(children: [
                      const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Friends',
                            textAlign: TextAlign.center,
                            textScaleFactor: 2,
                          )),
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
                    ]))),
            //Column(color: white)
          )
        ]),
      ),
    );
  }
}

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    //paint.color = const Color.fromARGB(255, 190, 220, 255);
    paint.color = const Color.fromARGB(255, 0, 28, 59);
    canvas.drawPath(mainBackground, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelagate) {
    return oldDelagate != this;
  }
}
