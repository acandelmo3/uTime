import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uTime/services/firestore.dart';
import '../services/firestore.dart';
import 'ui_friends_list.dart';
import 'ui_home.dart';

class UIUserProfile extends StatelessWidget {
  final Firestore fs = Firestore();
  int code = 0;
  String name = '';
  String curr_name = '';
  String pfp = 'defaultRef.png';
  List<dynamic> requests = <String>[];
  List<dynamic> friends = <String>[];

  UIUserProfile(this.name, {super.key});

  Future<String> createButton() async {
    final curr = FirebaseFirestore.instance
        .collection('id map')
        .doc(Firestore.getCurrentUser());
    await curr.get().then((DocumentSnapshot documentSnapshot) async {
      curr_name = documentSnapshot.get(FieldPath(const ['name']));
      final user = FirebaseFirestore.instance.collection('users').doc(name);
      await user.get().then((DocumentSnapshot documentSnapshot) {
        requests = documentSnapshot.get(FieldPath(const ['Friend Requests']));
        friends = documentSnapshot.get(FieldPath(const ['Friends List']));
        pfp = documentSnapshot.get(FieldPath(const ['pfp']));
      });
    });

    if (curr_name == name) {
      return 'setpicture';
    }

    return 'addfriend';
  }

  Future<Uint8List?> getPfp() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('pfps/$pfp');
    const oneMegabyte = 1024 * 1024;
    final Uint8List? data = await imageRef.getData(oneMegabyte);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    //title: Text(name + '\'s Profile'),
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
                IconButton(
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection('id map')
                          .doc(Firestore.getCurrentUser())
                          .get()
                          .then((DocumentSnapshot documentSnapshot) async {
                        String name = await documentSnapshot
                            .get(FieldPath(const ['name']));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UIUserProfile(name)));
                      });
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: Color.fromARGB(255, 255, 225, 52),
                    )),
                IconButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UIHome())),
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UIFriendsList())),
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    )),
              ],
            )),
        body:

            /**
       * Background Designer
       */
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
          Container(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 400,
                    width: 300,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: const EdgeInsets.all(20.0),
                    child: FutureBuilder<String>(
                        future: createButton(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    FutureBuilder<Uint8List?>(
                                        future: getPfp(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<Uint8List?>
                                                snapshot) {
                                          if (snapshot.hasData) {
                                            return Container(
                                              width: 200,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: Image.memory(
                                                              snapshot.data!)
                                                          .image,
                                                      fit: BoxFit.fill)),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                    if (snapshot.data! == 'addfriend')
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 75, 57, 233),
                                            shape: const StadiumBorder(),
                                          ),
                                          child: const Text('Add Friend'),
                                          onPressed: () {
                                            fs.sendRequest(code, name);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => const UIHome()));
                                          }),
                                    if (snapshot.data! == 'setpicture')
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 75, 57, 233),
                                              shape: const StadiumBorder()),
                                          onPressed: () async => fs.updatePfp(),
                                          child: const Text('Set Picture'))
                                  ]),
                            );
                          } else {
                            return Container();
                          }
                        }),
                  )))
        ]));
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
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), size.height);
    var secondEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldDelagate) {
    return oldDelagate != this;
  }
}
