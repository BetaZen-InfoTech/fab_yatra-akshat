import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();

  static const String appType = "live";  

  static const String busSewaDomain = (appType == "live") ?"https://diyalodev.com":"https://bussewa.com";
  static const String busSewaUserName = "fab_yatra";
  static const String busSewaPassword = "f@BY@tra_03_03";
  
  //  static Map<String, dynamic> jsonResponse ={};


  static const String fcmKey = "key=AAAAA5H1WlI:APA91bG1emRo2uWS97SclzVfQ02iKo8S93B-efC1w2PT8Z8o3VfzuJO6hpyvAjbY1y6P1zGaKrQiwd7tZ3S68P5cRND3igZmwD213RjAdhuqcjrCgU6ntWg6CAeQyqv198EyOSiJOzP6";
  // static const String appType = "live";
  static Future<String?> token = getToken();

  static Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

}

