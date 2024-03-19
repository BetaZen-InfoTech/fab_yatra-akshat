import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:khalti_flutter/khalti_flutter.dart';
// import 'package:khalti_flutter/localization/khalti_localizations.dart';
import 'package:fabyatra/utils/services/global.dart';
import 'package:fabyatra/view/home/home_navigation.dart';
import 'package:fabyatra/view/login/login_page.dart';
import 'package:fabyatra/view/splash.dart';
import 'package:fabyatra/utils/constant/dimensions.dart';

import 'firebase_options.dart';
// import 'package:timezone/data/latest.dart' as tz;


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}


Future<void> main() async
{

  HttpOverrides.global = MyHttpOverrides();


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // tz.initializeTimeZones();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showingSplash=true;
  LoadHome(){
    Future.delayed(const Duration(seconds: 5),(){
      setState(() {
        showingSplash=false;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    LoadHome();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double widthP = Dimensions.myWidthThis(context);
    double heightP = Dimensions.myHeightThis(context);
    double heightF = Dimensions.myHeightFThis(context);

          return MaterialApp(
              navigatorKey: GlobalVariable.navState,

              supportedLocales: const [
                Locale('en', 'US'),
                Locale('ne', 'NP'),
              ],

              debugShowCheckedModeBanner: false,
              routes: {
                "/home": (context) => const Home(),
              },
              // home:showingSplash ? const SplashScreen() : const loginPage());
              home: const SplashScreen()
          );

  }
}