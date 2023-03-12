import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:usage_stats/usage_stats.dart';
import 'firestore.dart';

class Screentime {
  static const platform = MethodChannel("com.example/sav3");
  Future<void> prepUsage() async {
      if (Platform.isAndroid) {
        await platform.invokeMethod('prepStats');
        Firestore fs = Firestore();
      } else if (Platform.isIOS) {
        //INVOKE IOS METHOD
      }
  }

  Future<int> getUsage() async {
    int result = -1;
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      Firestore fs = Firestore();
      var end = DateTime.now();
      var start = end.subtract(Duration(days: end.weekday - 1));

      double total = 0;
      List<UsageInfo> t = await UsageStats.queryUsageStats(start, end);
      for (var i in t) {
        total += double.parse(i.totalTimeInForeground!);
      }
      result = total.toInt();
      fs.updateTime(result);
    });
    return result;
  }
}
