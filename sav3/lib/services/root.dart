import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uTime/screens/home_page.dart';
import 'package:uTime/screens/ui_login_matrix.dart';
import 'package:uTime/screens/ui_test_copy.dart';

/*
* This class acts as a checkpoint to ensure the user is
* signed in using Firebase Authentication before navigating
* them to the app.
*/
class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return const UIMatrix();
    } else {
      return UITest();
    }
  }
}
