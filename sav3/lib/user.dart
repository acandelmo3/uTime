import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sav3/services/firestore.dart';

class AppUser {
  final String? fName;
  final String? lName;
  final String? pfp;
  final int? code;
  final List<String>? requests;
  final List<String>? friends;
  final int? time;
  final int? goal;

  AppUser({
    this.fName,
    this.lName,
    this.pfp,
    this.code,
    this.requests,
    this.friends,
    this.time,
    this.goal,
  });

  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AppUser(
      fName: data?['First Name'],
      lName: data?['Last Name'],
      pfp: data?['Profile Picture'],
      code: data?['Friend Code'],
      requests: data?['Friend Requests'] is Iterable
          ? List.from(data?['Friend Requests'])
          : null,
      friends: data?['Friends List'] is Iterable
          ? List.from(data?['Friends List'])
          : null,
      time: data?['Time'],
      goal: data?['Goal']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (fName != null) 'First Name': fName,
      if (lName != null) 'Last Name': lName,
      'pfp': 'https://static.thenounproject.com/png/5034901-200.png',
      if (code != null) 'Friend Code': code,
      'Friend Requests': requests,
      'Friends List': friends,
      'Time': time,
      'Goal': 86400000
    };
  }
}
