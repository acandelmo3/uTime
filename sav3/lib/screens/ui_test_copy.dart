import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uTime/screens/user_profile.dart';
import 'package:uTime/services/auth.dart';
import '../services/firestore_copy.dart';
import '../services/screentime.dart';
import 'ui_friends_list.dart';
import 'ui_login_matrix.dart';
import 'ui_user_profile.dart';


class UITest extends StatelessWidget {
  UITest({super.key});
  double goal_test = -1.0;
  final FirestoreCopy fs = FirestoreCopy();

  Future<String> showTime() async {
    double result = await Screentime.getUsage();
    int hrs = ((result / (1000 * 60 * 60)) % 24).toInt();
    int mins = ((result / (1000 * 60) % 60)).toInt();
    String time = 'Screentime This Week:\n$hrs hrs $mins mins';
    fs.updateTime(result);
    return time;
  }

  String sampleLimit = "0";

  @override
  Widget build(BuildContext context) {
    final Auth _auth = Auth();

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
                    .doc(FirestoreCopy.getCurrentUser())
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
                  )
            ), 

            IconButton(onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UITest())),
                icon: const Icon(Icons.home, 
                  color: Color.fromARGB(255, 255, 225, 52),
                )
            ), 

            IconButton(onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UIFriendsList())),
                icon: const Icon(Icons.person,
                  color: Colors.white,
                )
            ), 
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

      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          
          Row(children: [
            /** 
            * Sign Out Button
            */
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                shape: const StadiumBorder()
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const UIMatrix()));
              },
              child: const Text('Sign Out', style: TextStyle(fontSize: 15))),
            ],
          ),

          /** 
           * Main Progress Circle
          */
            FutureBuilder(
              future: fs.getGoalPercent(),
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                if (snapshot.data != null) {
                  return ( 
                    Center( child: 
                    Stack( 
                      alignment: Alignment.center,
                      children: [
                      const Center(
                      child: SizedBox(
                        height: 270.0,
                        width: 270.0,
                        child:
                          CircularProgressIndicator( //interior white circle
                            backgroundColor: Colors.white,
                            color: const Color.fromARGB(255, 255, 225, 52),
                            value: 0.0,
                            strokeWidth: 5,
                          )
                        ),
                      ),

                      Center(
                      child: SizedBox(
                        height: 270.0,
                        width: 270.0,
                        child: 
                          CircularProgressIndicator( //exterior yellow circle
                            backgroundColor: Colors.transparent,
                            color: const Color.fromARGB(255, 255, 225, 52),
                            value: snapshot.data,
                            strokeWidth: 18,
                          )
                        ),
                      ),

                    
                    Center( 
                      child:
                      FutureBuilder(
                        future: showTime(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot1) {
                          if (snapshot1.data != null) {
                            return Text(snapshot1.data!, 
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 22,
                                )

                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    ]
                  )
                  )
                  );
                } else {
                  return Container();
                }
              },
            ),

            Container(height: 25,),
            Flexible(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(20.0),

                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Container(
                        width: 100,
                        height: 35,
                        decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: StadiumBorder()
                        ),

                        child: 
                        Align(
                          alignment: Alignment.center,

                          child: 
                            Text(
                              DateTime.now().toString().substring(5,10), 
                              style: const TextStyle(fontSize: 23, 
                                //color: Colors.white, 
                                color: Color.fromARGB(255, 75, 57, 233),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline), 
                              textAlign: TextAlign.center,
                            ),
                          )
                        ),

                      /** 
                      * Subtract from Limit Button
                      */
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                          shape: const StadiumBorder()
                        ),
                        onPressed: () async { 
                            fs.updateGoal(await fs.getGoal() - 1800000.0);
                        },
                        child: const Text('-30mins', 
                          style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold))
                        ),

                      /** 
                      * Add to Limit Button
                      */
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                          shape: const StadiumBorder()
                        ),
                        onPressed: () async { 
                            fs.updateGoal(await fs.getGoal() + 1800000.0);
                        },
                        child: const Text('+30mins', 
                          style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold))
                        ),
                      ],
                    ),

                    Container(padding: const EdgeInsets.fromLTRB(0, 25, 0, 0), child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          /** 
                          * Percent of Weekly Limit Text
                          */
                           Align(
                            alignment: Alignment.center,
                            child: 
                            FutureBuilder(
                              future: fs.getGoalPercent(),
                              builder: (BuildContext context, AsyncSnapshot<double> snapshot2) {
                                if (snapshot2.data != null) {
                                  return Text(
                                    (snapshot2.data! * 100).toInt().toString() + "% of Weekly Limit:",
                                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 75, 57, 233), fontWeight: FontWeight.bold), 
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return Container();
                                }
                              }
                              ),
                          ),

                          /** 
                          * Weekly Limit Text
                          */
                          Align(
                            alignment: Alignment.center,
                            child: 
                            FutureBuilder(
                              future: fs.getGoal(),
                              builder: (BuildContext context, AsyncSnapshot<double> snapshot2) {
                                if (snapshot2.data != null) {
                                  return Text( 
                                    ((snapshot2.data! / 3600000).toInt()).toString() + "hrs " + 
                                    ((snapshot2.data! / 60000 % 60).toInt()).toString() + "mins",
                                    
                                    style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 75, 57, 233), fontWeight: FontWeight.bold), 
                                    textAlign: TextAlign.center,
                                  );
                                } else {
                                  return Container();
                                }
                              }
                              ),
                            )
                        ]
                      ),
                      )
                    ],
                  )
              )
            )
            ],
          ),
        ),
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

