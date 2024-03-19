import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as FM;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;



class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await auth.signInWithCredential(credential);

    User? userDetails = result.user;

    Map<String, dynamic> userInfoMap = {
      "email": userDetails!.email,
      "name": userDetails.displayName,
      "imgUrl": userDetails.photoURL,
      "id": userDetails.uid
    };

    newSaveData(false, true, context);
    // await DatabaseMethods()
    //     .addUser(userDetails.uid, userInfoMap)
    //     .then((value) {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => Home()));
    // });
  }

  signInWithApple(BuildContext context) async {

    List<Scope> scopes = const [];
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);

    switch (result.status) {
      case AuthorizationStatus.authorized:

        final AppleIdCredential = result.credential!;

        final oAuthCredential = OAuthProvider('apple.com');

        final credential = oAuthCredential.credential(
            idToken: String.fromCharCodes(AppleIdCredential.identityToken!));

        final UserCredential = await auth.signInWithCredential(credential);

        final firebaseUser = UserCredential.user!;

        if (scopes.contains(Scope.fullName)) {

          final fullName = AppleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {

            final displayName = '${fullName.givenName}${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);

          }
        }

        newSaveData(true, false, context);

      case AuthorizationStatus.error:

        throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString());

      case AuthorizationStatus.cancelled:

        throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
      default:
        throw UnimplementedError();
    }
  }

  newSaveData(bool isApple, bool isGoogle, BuildContext context) async {
    var user = auth.currentUser;
    print("successful auth");
    print(user?.uid.toString());
    if (user != null) {
      String userUid = user.uid.toString();

      DatabaseReference ref = FirebaseDatabase.instance
          .ref()
          .child("${GlobalVariable.appType}/project-backend")
          .child("account"); //Todo: change the type to Query

      print(userUid);

      // if(!kIsWeb) {
      //   String? token1 = await FM.FirebaseMessaging.instance.getToken();
      //   ;
      //   http.get(
      //     Uri.parse(
      //       'https://iid.googleapis.com/iid/v1/$token1/rel/topics/$userUid',),
      //     headers: {
      //       'Authorization': GlobalVariable.fcmKey
      //     },
      //   );
      // }
      //
      if (Platform.isAndroid) {
        FM.FirebaseMessaging.instance
            .subscribeToTopic(userUid);
      }



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
          "isApple": isApple,
          "isGoogle": isGoogle,
          "userUid": userUid,
          "name": "FabYatra User",
          "email": isApple?"":user.email.toString(),
          // "phone": "Enter Phone Number",
          "username": username,
          "created-at": DateTime.now().millisecondsSinceEpoch.toString(),
          "updated-at": DateTime.now().millisecondsSinceEpoch.toString(),
          "status": "Active" //Todo: Active/De-Active/Block/Under-Verification
        });


        ref.child("phone-data/user-phone-connection").child(userUid).update({
          "phone": "false",
        });

        ref.child("user-name").update({
          username: userUid,
        });

        // ref.child("user-phone").update({
        //   phoneNumber: userUid,
        // });
        //
        // ref.child("all-phone/user").push().update({
        //   phoneNumber: userUid,
        // });
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', userUid);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const Home(),
        ),
      );
    }

    //Todo: add bus data
    // return user!=null;
  }
}
