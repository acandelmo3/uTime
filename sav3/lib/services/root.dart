import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sav3/screens/home_page.dart';
import 'package:sav3/screens/login_matrix.dart';

import 'firestore.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return Matrix();
    } else {
      user.getIdToken().then((String result) {
        Firestore.submitCurrent(result);
      });
      return HomePage();
    }
  }
}
