import 'package:cloud_firestore/cloud_firestore.dart';

/*
* This class creates a structure to store users in the database.
*/
class AppUser {
  final String? fName;
  final String? lName;
  final int? code;
  final List<String>? requests;
  final List<String>? friends;
  final double? time;
  final int? goal;
  final String? pfp;

  AppUser({
    this.fName,
    this.lName,
    this.code,
    this.requests,
    this.friends,
    this.time,
    this.goal,
    this.pfp,
  });

  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return AppUser(
        fName: data?['First Name'],
        lName: data?['Last Name'],
        code: data?['Friend Code'],
        requests: data?['Friend Requests'] is Iterable
            ? List.from(data?['Friend Requests'])
            : null,
        friends: data?['Friends List'] is Iterable
            ? List.from(data?['Friends List'])
            : null,
        time: data?['Time'],
        goal: data?['Goal'],
        pfp: data?['pfp']);
  }

/*
* Instantiates the data in the AppUser object
* @return Map<String, dynamic> is the container for the user data
*/
  Map<String, dynamic> toFirestore() {
    return {
      if (fName != null) 'First Name': fName,
      if (lName != null) 'Last Name': lName,
      if (code != null) 'Friend Code': code,
      'Friend Requests': requests,
      'Friends List': friends,
      'Time': time,
      'Goal': 86400000,
      'pfp': 'defaultRef.png'
    };
  }
}
