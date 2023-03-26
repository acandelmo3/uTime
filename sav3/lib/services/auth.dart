import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'firestore.dart';

//Logger Object to print Errors to console
Logger logger = Logger();

/*
* Auth class uses methods from the firebase authentication
* service to register, sign in, and sign out users.
*/
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore fs = Firestore();

  /*
  * Creates an account using Firebase Authentication
  * @param String email is the user's input email
  * @param String password is the user's input password
  * @return Future representing the ID token of the new user
  */
  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user?.getIdToken();
    } catch (error) {
      logger.d(error);
      return null;
    }
  }

  /*
  * Signs into an account using Firebase Authentication
  * @param String email is the user's input email
  * @param String password is the user's input password
  * @return Future representing the ID token of the new user
  */
  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await fs.getCurrent();
      return result.user?.getIdToken();
    } catch (error) {
      logger.d(error);
      return null;
    }
  }

  /*
  * Signs out of an account using Firebase Authentication
  */
  Future<void> signOut() async {
    await _auth.signOut();
    await fs.getCurrent();
  }
}