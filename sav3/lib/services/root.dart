import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sav3/screens/home_page.dart';
import 'package:sav3/screens/login_matrix.dart';
import 'package:sav3/screens/ui_test.dart';

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
      return const Matrix();
    } else {
      return UITest();
    }
  }
}
