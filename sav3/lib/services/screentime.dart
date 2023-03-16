import 'dart:io';
import 'package:flutter/services.dart';
import 'package:usage_stats/usage_stats.dart';

/*
* This class gets the total screen time for a user using the
* usage statistics package for flutter.
* //TODO find implementation for IOS using ScreenTime API
*/
class Screentime {

//Creates a MethodChannel to access Main Activity
  static const platform = MethodChannel("com.example/sav3");
  
/*
* Uses Main Activity to get usage permissions for Android.
*/
  Future<void> prepUsage() async {
    if (Platform.isAndroid) {
      await platform.invokeMethod('prepStats');
    } else if (Platform.isIOS) {
      //TODO Ensure permissions for IOS if necessary
    }
  }

/*
* Gets the screen time from a user's device.
* @return Future<double> is the screen time in milliseconds
* //TODO find implementation for IOS using ScreenTime API
*/
  Future<double> getUsage() async {
    UsageStats.checkUsagePermission().then((bool? permGranted) async {
      if (!permGranted!) {
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
