import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:fabyatra/utils/services/global.dart';

class Auth {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static String verifyId = "";

  // function to send otp
  static Future sendOtp({
    required String countryCode,
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    print(countryCode+ phone);
    await _firebaseAuth
        .verifyPhoneNumber(
            timeout: Duration(seconds: 30),
            phoneNumber: countryCode + phone,
            verificationCompleted: (PhoneAuthCredential) async {
              return;
            },
            verificationFailed: (error) async {
              print(error);
              return;
            },
            codeSent: (verificationId, forceResendingToken) async {
              verifyId = verificationId;
              nextStep();
            },
            codeAutoRetrievalTimeout: (verificationId) async {
              return;
            })
        .onError((error, stackTrace) {
      errorStep();
    });
  }

  static Future loginWithOtp({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);
    try {
      final user = await _firebaseAuth.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "Wrong OTP";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future logOut() async {
    await _firebaseAuth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', "uid");
    prefs.remove("uid");
    prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }

  static Future<User?> fbUser() async {
    var user = _firebaseAuth.currentUser;
    return user;
  }

  static Future<String> uid() async {
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.uid.toString();
    } else {
      return "";
    }
  }

  static Future<String?> displayName() async {
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.displayName;
    } else {
      return "";
    }
  }

  // static Future<String?> phoneNumber() async {
  //   var user = _firebaseAuth.currentUser;
  //   if (user != null) {
  //     return user.phoneNumber;
  //   } else {
  //     return "";
  //   }
  // }

  static Future<bool> saveData(String phoneNumber) async {
    var user = _firebaseAuth.currentUser;

    if (user != null)
    {
      String userUid = user.uid.toString();

      await FirebaseMessaging.instance.subscribeToTopic(userUid);

      DatabaseReference ref = FirebaseDatabase.instance
          .ref()
          .child("${GlobalVariable.appType}/project-backend")
          .child("account"); //Todo: change the type to Query

      // Fetch a list of users from the database
      final counterSnapshot = await ref
          .child("user-data/user")
          .child(userUid)
          .child("userUid")
          .get();

      if (counterSnapshot.value.runtimeType == Null) {
        String username = const Uuid().v4().toString().trim();

        //Todo: add bus data
        ref.child("user-data/user").child(userUid).update({
          "userUid": userUid,
          "name": "FabYatra User",
          "email":user.email.toString(),
          "phone": phoneNumber,
          "username": username,
          "created-at": DateTime.now().millisecondsSinceEpoch.toString(),
          "updated-at": DateTime.now().millisecondsSinceEpoch.toString(),
          "status": "Active" //Todo: Active/De-Active/Block/Under-Verification
        });

        ref.child("user-name").update({
          username: userUid,
        });

        ref.child("user-phone").update({
          phoneNumber: userUid,
        });

        ref.child("all-phone/user").push().update({
          phoneNumber: userUid,

        });
      }

      ref
          .child("user-data/user")
          .child(userUid)
          .child("login-times")
          .push()
          .update({
        DateTime.now().millisecondsSinceEpoch.toString(): userUid,
        "status": "Active" //Todo: Active/De-Active/Block/Under-Verification
      });
    }

    //Todo: add bus data
    return user != null;
  }
}
