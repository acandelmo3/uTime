import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:uTime/services/root.dart';
import 'package:uTime/services/screentime.dart';
import 'package:workmanager/workmanager.dart';

var logger = Logger();

@pragma('vm:entry-point')
Future<void> callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((taskName, inputData) async {
    await Firebase.initializeApp();
    logger.d('Executing...');
    Screentime st = Screentime();
    try {
      double time = await st.getUsage();
      logger.d('Time updated!: $time');
    } catch (error) {
      logger.d('Exception thrown!: $error');
    }
    return Future.value(false);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
      "task-identifier", "simplePeriodicTask",
      initialDelay: const Duration(minutes: 2),
      constraints: Constraints(networkType: NetworkType.connected));
  logger.d('Launching App!');
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
