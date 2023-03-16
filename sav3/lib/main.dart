import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sav3/services/firestore.dart';
import 'package:sav3/services/root.dart';
import 'package:sav3/services/screentime.dart';
import 'package:workmanager/workmanager.dart';

var logger = Logger();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    Screentime st = Screentime();
    double time = await st.getUsage();
    await Firebase.initializeApp();
    try {
      final user = FirebaseFirestore.instance
          .collection('users')
          .doc('Anthony Candelmo');
      logger.d('TimeL:  $time');
      await user.update({'Time': time});
    } catch (e) {
      throw Exception(e);
    }
    return Future.value(false);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Workmanager().registerOneOffTask(
      "task-identifier", "simpleTask",
      initialDelay: const Duration(seconds: 10),
      constraints: Constraints(networkType: NetworkType.connected));
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
