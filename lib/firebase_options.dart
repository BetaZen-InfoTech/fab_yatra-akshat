// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDhD1GU1xCjzG9lUMOMda9tcCKvnEJeEoU',
    appId: '1:15333677650:web:bb1443140af6676a675d8b',
    messagingSenderId: '15333677650',
    projectId: 'fabyatra',
    authDomain: 'fabyatra.firebaseapp.com',
    databaseURL: 'https://fabyatra-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fabyatra.appspot.com',
    measurementId: 'G-578D76MPCT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDMqzJKURDJPbrLouoLC8gh75JZA7r0bYs',
    appId: '1:15333677650:android:0e3f31ac97919089675d8b',
    messagingSenderId: '15333677650',
    projectId: 'fabyatra',
    databaseURL: 'https://fabyatra-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fabyatra.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFNsTv93JzEae7b_M9J8k_ZYDdbBg3piA',
    appId: '1:15333677650:ios:c95d13ddea0dc4b7675d8b',
    messagingSenderId: '15333677650',
    projectId: 'fabyatra',
    databaseURL: 'https://fabyatra-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'fabyatra.appspot.com',
    androidClientId: '15333677650-2udlgt44gucbvl6fo1r9ie32gkbpair0.apps.googleusercontent.com',
    iosClientId: '15333677650-mmfjo28mbkvbcvouq7nt5lcos8cd0u17.apps.googleusercontent.com',
    iosBundleId: 'com.fabyatra.app',
  );
}
