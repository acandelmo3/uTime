import 'package:firebase_auth/firebase_auth.dart';

import 'firestore.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore fs = new Firestore();

  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      fs.getCurrent();
      return result.user?.getIdToken();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
          fs.getCurrent();
      return result.user?.getIdToken();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void signOut() {
    _auth.signOut();
    fs.getCurrent();
  }
}
