import 'dart:ffi';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'firestore.dart';

class Screentime {
  static const platform = MethodChannel("com.example/sav3");
  Future<void> getUsage() async {
    int time = -1;
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        if (Platform.isAndroid) {
          final result = await platform.invokeMethod('usageStats');
          Firestore fs = Firestore();
          await fs.updateTime(result);
          time = result;
        } else if (Platform.isIOS) {
          //INVOKE IOS METHOD
        }
      }
    });
  }
}
