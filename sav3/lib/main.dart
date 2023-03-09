import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sav3/services/root.dart';
import 'package:sav3/services/screentime.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
Future<void> callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) async {
    await Firebase.initializeApp();
    Screentime st = Screentime();
    print('call1');
    if (taskName == "update-screen-time") {
      print('call2');
      await st.getUsage();
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask("update-screen-time", "simplePeriodicTask",
      initialDelay: Duration(seconds: 15));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      child: const MaterialApp(
        home: Root(),
      ),
    );
  }
}
