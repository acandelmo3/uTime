import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uTime/screens/ui_test.dart';
import 'package:uTime/services/firestore.dart';

class UserProfile extends StatelessWidget {
  final Firestore fs = Firestore();
  int code = 0;
  String name = '';
  String curr_name = '';
  String pfp = '';
  List<dynamic> requests = <String>[];
  List<dynamic> friends = <String>[];
  List<int> goals = <int>[];

  UserProfile(String name) {
    this.name = name;
    for (int i = 0; i < 55; i++) {
      goals.add(i);
    }
  }

  Future<bool> createButton() async {
    final curr = FirebaseFirestore.instance
        .collection('id map')
        .doc(Firestore.getCurrentUser());
    await curr.get().then((DocumentSnapshot documentSnapshot) async {
      curr_name = documentSnapshot.get(FieldPath(['name']));
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(documentSnapshot.get(FieldPath(['name'])));
      await user.get().then((DocumentSnapshot documentSnapshot) {
        requests = documentSnapshot.get(FieldPath(['Friend Requests']));
        friends = documentSnapshot.get(FieldPath(['Friends List']));
        pfp = documentSnapshot.get(FieldPath(['pfp']));
      });
    });

    if (curr_name == name) {
      return false;
    }

    for (var i in requests) {
      if (await i == name) {
        return false;
      }
    }

    for (var i in friends) {
      if (await i == name) {
        return false;
      }
    }

    return true;
  }

  Future<Uint8List?> getPfp() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    const oneMegabyte = 1024 * 1024;
    try {
      final imageRef = storage.ref().child('pfps/$name');
      final Uint8List? data = await imageRef.getData(oneMegabyte);
      return data;
    } catch (e) {
      final defaultRef = storage.ref().child('pfps/defaultRef.png');
      final Uint8List? data = await defaultRef.getData(oneMegabyte);
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          title: Text('$name\'s Profile'),
        ),
        body: FutureBuilder<bool>(
            future: createButton(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
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
                                  AsyncSnapshot<Uint8List?> snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: Image.memory(snapshot.data!)
                                                .image,
                                            fit: BoxFit.fill)),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                          if (snapshot.data!)
                            ElevatedButton(
                                child: Text('Add Friend'),
                                onPressed: () async {
                                  await fs.sendRequest(code, name);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UITest()));
                                }),
                          if (!(snapshot.data!))
                            Row(children: [
                              ElevatedButton(
                                  onPressed: () async => fs.updatePfp(),
                                  child: const Text('Set Picture')),
                              const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20)),
                              FutureBuilder<int>(
                                  future: fs.getGoal(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<int> snapshot) {
                                    if (snapshot.hasData) {
                                      return DropdownButton<int>(
                                        value: snapshot.data,
                                        onChanged: (int? value) {
                                          fs.setGoal(value!);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UserProfile(name)));
                                        },
                                        items: goals.map<DropdownMenuItem<int>>(
                                            (int value) {
                                          return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text('$value'));
                                        }).toList(),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  })
                            ])
                        ]));
              } else {
                return Container();
              }
            }));
  }
}
