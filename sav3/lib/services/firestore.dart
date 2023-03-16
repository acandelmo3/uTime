import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sav3/services/screentime.dart';
import '../user.dart';

/*
* This class controls reads and writes to the Firestore Database.
*/
class Firestore {
  String fName = '';
  String lName = '';
  static String currentUser = '';

/* 
* Gets the user uid for the user who's data will be read and updated.
*/
  Firestore() {
    getCurrent();
  }

/*
* Gets the first 25 characters of the curren user's uid if there
* is an instance of Firebase Authentication
*/
  Future<void> getCurrent() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      currentUser = uid.substring(0, 25);
    }
  }

/*
 * Grabs data from new user registration.
 * @param String f The user's first name
 * @param String l The user's last name
 */
  void getData(String f, String l, String u) {
    fName = f;
    lName = l;
    createUser(name: '$f $l');
  }

/*
* Creates a new AppUser object to be stored in the database under
* the user's first and last name. Creates a doc linking a user's name and uid.
* @param String name is the name of the database doc
*/
  Future<void> createUser({required String name}) async {
    final user = AppUser(
      fName: fName,
      lName: lName,
      pfp: '',
      code: 0,
      requests: [],
      friends: [],
      time: 0,
      goal: 86400000,
    );

    final docUser = FirebaseFirestore.instance
        .collection('users')
        .withConverter(
          fromFirestore: AppUser.fromFirestore,
          toFirestore: (AppUser user, options) => user.toFirestore(),
        )
        .doc(name);
    await docUser.set(user);

    await getCurrent();
    final idDoc =
        FirebaseFirestore.instance.collection('id map').doc(currentUser);
    await idDoc.set({'name': name});
  }

/*
* Checks to see if a user is in the database.
* @param String name is the user being searched for
* @return Future<int> is the Friend Code of the user if found, else -1
*/
  Future<int> searchUsers(String name) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(name)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        //TODO implement Friend Code
        return doc.get(FieldPath(const ['Friend Code']));
      } else {
        return -1;
      }
    });
  }

/*
* Getter for the current user's uid.
* @return String the uid
*/
  static String getCurrentUser() {
    return currentUser;
  }

/*
* Sends a friend request to another user in the database.
* @param int code is the friend code of the requestee
* @param String name is the name of the requestee
*/
  Future<void> sendRequest(int code, String name) async {
    final outgoing = FirebaseFirestore.instance.collection('users').doc(name);
    List<dynamic> temp = [];
    await outgoing.get().then((DocumentSnapshot doc) {
      temp = doc.get(FieldPath(const ['Friend Requests']));
    });
    final curr =
        FirebaseFirestore.instance.collection('id map').doc(currentUser);
    await curr.get().then((DocumentSnapshot doc) async {
      temp.add(doc.get(FieldPath(const ['name'])));
    });
    await outgoing.update({'Friend Requests': temp});
  }

/*
* Accepts a friend request from a user in the database.
* @param String name the name of the requester
*/
  Future<void> acceptRequest(String name) async {
    List<dynamic> requests = <String>[];
    List<dynamic> friends = <String>[];
    String currName = '';
    FirebaseFirestore.instance
        .collection('id map')
        .doc(currentUser)
        .get()
        .then((DocumentSnapshot doc) async {
      currName = doc.get(FieldPath(const ['name']));
      final user = FirebaseFirestore.instance.collection('users').doc(currName);
      await user.get().then((DocumentSnapshot doc) {
        requests = doc.get(FieldPath(const ['Friend Requests']));
        friends = doc.get(FieldPath(const ['Friends List']));
      });
      requests.remove(name);
      friends.add(name);
      await user.update({'Friend Requests': requests});
      await user.update({'Friends List': friends});
    });

    final requester = FirebaseFirestore.instance.collection('users').doc(name);
    await requester.get().then((DocumentSnapshot doc) {
      friends = doc.get(FieldPath(const ['Friends List']));
    });
    friends.add(currName);
    await requester.update({'Friends List': friends});
  }

/*
* Updates the user's screen time to the database.
* @param double time is the new screen time since monday
*/
  Future<void> updateTime(double time) async {
    FirebaseFirestore.instance
        .collection('id map')
        .doc(currentUser)
        .get()
        .then((DocumentSnapshot doc) async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(doc.get(FieldPath(const ['name'])));
      await user.update({'Time': time});
    });
  }

//TODO Update the PFP system
  Future<void> updatePfp() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    final storageRef = storage.ref();

    /*
    FirebaseFirestore.instance
        .collection('id map')
        .doc(currentUser)
        .get()
        .then((DocumentSnapshot doc) async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(doc.get(FieldPath(['name'])));
      await user.update({'pfp': result});
      
    });
    */
  }

/*
* Gets the percent of screen time the user has used from
* their preset goal.
* @return Future<double> is the percentage
*/
  Future<double> getGoalPercent() async {
    Screentime st = Screentime();
    await st.getUsage();

    double percent = -1;
    final curr =
        FirebaseFirestore.instance.collection('id map').doc(currentUser);
    await curr.get().then((DocumentSnapshot doc) async {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc(doc.get(FieldPath(const ['name'])));
      await user.get().then((DocumentSnapshot doc) {
        double time = doc.get(FieldPath(const ['Time']));
        double goal =
            doc.get(FieldPath(const ['Goal'])).toDouble();
        percent = (time / goal);
      });
    });
    return percent;
  }
}
