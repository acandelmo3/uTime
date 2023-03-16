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

  Future<double> getUsage() async {
    UsageStats.checkUsagePermission().then((bool? b) async {
      if (!b!) {
        await prepUsage();
      }
    });

    var end = DateTime.now();
    var start = DateTime.now().subtract(Duration(days: end.weekday - 1));
    start = start.subtract(Duration(hours: start.hour));
    start = start.subtract(Duration(minutes: start.minute));
    start = start.subtract(Duration(seconds: start.second));

    double total = 0;
    List<UsageInfo> t = await UsageStats.queryUsageStats(start, end);
    for (var i in t) {
      total += double.parse(i.totalTimeInForeground!);
    }
    return total;
  }
}
