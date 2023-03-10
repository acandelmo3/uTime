import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sav3/screens/user_profile.dart';
import 'package:sav3/services/auth.dart';
import '../services/firestore.dart';
import '../services/screentime.dart';
import 'friends_list.dart';
import 'login_matrix.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  Firestore fs = new Firestore();

  Future<String> showTime() async {
    String time = '';

    Screentime st = Screentime();
    st.getUsage();

    final curr = FirebaseFirestore.instance
        .collection('id map')
        .doc(Firestore.getCurrentUser());

    await curr.get().then((DocumentSnapshot documentSnapshot) async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(await documentSnapshot.get(FieldPath(['name'])));

      await user.get().then((DocumentSnapshot documentSnapshot) async {
        int result = documentSnapshot.get(FieldPath(['Time']));

        time = 'Screentime This Week: ' +
            ((result / (1000 * 60 * 60)) % 24).toInt().toString() +
            " hr " +
            ((result / (1000 * 60) % 60)).toInt().toString() +
            " min";
      });
    });
    return time;
  }

  @override
  Widget build(BuildContext context) {
    final Auth _auth = Auth();
    final Firestore fs = Firestore();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
              child: const Text('Sign Out'),
              onPressed: () {
                _auth.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Matrix()));
              }),
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
              }),
            FutureBuilder(
              future: st.getPercent(),
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                if (snapshot.data != null) {
                  //return Text(snapshot.data!);
                  return CircularProgressIndicator(
                    backgroundColor: Colors.grey[300], 
                    color: Colors.blue, 
                    value: st.getCurrentPercent());
                } else {
                  return Container();
                  //return;
                }
              },
            ),
              
              // CircularProgressIndicator(
              //   backgroundColor: Colors.grey[300], 
              //   color: Colors.blue, 
              //   value: st.getCurrentPercent())
        ]),
        //child: CircularProgressIndicator(backgroundColor: Colors.grey[300], color: Colors.blue)
      ),
    );
  }
}
