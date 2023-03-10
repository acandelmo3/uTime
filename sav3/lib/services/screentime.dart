import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'firestore.dart';

class Screentime {
  Firestore fs = Firestore();
  static const platform = MethodChannel("com.example/sav3");
  static double limitTest = 1000.0;
  double currentPercent = 0.0;
  double tempDouble = 0.0;
  Future<String> getUsage() async {
    if (Platform.isAndroid) {
      final result = await platform.invokeMethod('usageStats');
      print(result);
      print(result / (1000 * 60 * 60));
      print(result / (1000 * 60));
      fs.updateTime(result);
      currentPercent = (result / (1000 * 60)) / limitTest; // Current time / limit 
      print("Current percent is $currentPercent");
      return 'Screentime This Week: ' +
          ((result / (1000 * 60 * 60)) % 24).toInt().toString() +
          " hr " +
          ((result / (1000 * 60) % 60)).toInt().toString() +
          " min";
    } else if (Platform.isIOS) {}
    return 'ERR';
  }
  Future<double> getPercent() async {
  //double getPercent() async {
  //double getPercent() {
    if (Platform.isAndroid) {
      final result = await platform.invokeMethod('usageStats');
      fs.updateTime(result);
      print("Result $result");
      print("Limit $limitTest");
      double divideTest = (result / (1000 * 60)) / limitTest;
      print("Division $divideTest");
      tempDouble = divideTest;
      currentPercent = (result / (1000 * 60)) / limitTest; // Current time / limit 
      //return currentPercent;
      return divideTest;
      //return ((result / (1000 * 60)) / limitTest); 
    } else if (Platform.isIOS) {}
    return -1.0;
  }
  //void updatePercent() async {

  //}
  double getCurrentPercent() {
    //Future<double> currentPercent1 = getPercent();
    //double cp2 = currentPercent1.toDouble();
    //currentPercent
    //getPercent().then((currentPercent) => .005);
    //getPercent().then((currentPercent) { print("New percent $currentPercent"); });
    //getPercent().then((currentPercent) => tempDouble);
    //getPercent().then((value) => setPercent(tempDouble));
    //getPercent().then((value) => return currentPercent);
    //return 
    //print("Current percent $currentPercent");
    return currentPercent;
  }

  void setPercent(double newPercent) {
    currentPercent = newPercent;
  }
}
