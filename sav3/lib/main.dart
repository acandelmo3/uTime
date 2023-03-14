import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sav3/services/firestore.dart';
import 'package:sav3/services/root.dart';
import 'package:sav3/services/screentime.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await Firebase.initializeApp();
    //Screentime st = Screentime();
    Firestore fs = Firestore();
    try {
      //await st.getUsage();
      await fs.updateTime(-5);
      return Future.value(true);
    } catch (e) {
      throw Exception(e);
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  await Workmanager().registerPeriodicTask(
      "simplePeriodicTask", "update-screen-time",
      initialDelay: const Duration(seconds: 15),
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
