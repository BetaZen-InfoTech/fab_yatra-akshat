
import 'dart:async';

import 'package:fabyatra/notification_services.dart';
import 'package:fabyatra/view/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fabyatra/Controllers/auth.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  NotificationServices notificationServices = NotificationServices();

  var uid = null;


  Future<void> initialize() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');

    print(uid);
    print("uid");
    bool authSuccess = await Auth.isLoggedIn();


    // Timer(
    //   const Duration(seconds: 2),
    //       () =>
    //       Navigator.of(context).pushReplacement(MaterialPageRoute(
    //           builder: (BuildContext context) => loginPage()
    //       )),
    // );


    if (uid != null) {
      // if (authSuccess) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder:
                  (BuildContext context) =>
              const Home()
          )
      );
    }else{
      Timer(
        const Duration(seconds: 2),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => loginPage()
            )),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {


    // Todo: Add this code to every page ⤵️⤵️⤵️⤵️⤵️
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);
    // Todo: Add this code to every page ⤴️⤴️⤴️⤴️⤴️



    return SafeArea(

      child: Scaffold(
          backgroundColor: Color(0xff7d2aff),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/fabyatra.png", height: heightF*80, width:  widthP*80,),
              ],
            ),
          )),
    );

  }
}
