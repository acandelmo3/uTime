import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'firestore.dart';

class Screentime {
  Firestore fs = Firestore();
  static const platform = MethodChannel("com.example/sav3");
  Future<String> getUsage() async {
    if (Platform.isAndroid) {
      final result = await platform.invokeMethod('usageStats');
      fs.updateTime(result);
      return 'Screentime This Week: ' +
          ((result / (1000 * 60 * 60)) % 24).toInt().toString() +
          " hr " +
          ((result / (1000 * 60) % 60)).toInt().toString() +
          " min";
    } else if (Platform.isIOS) {}
    return 'ERR';
  }
}
