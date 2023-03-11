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
        return macos;
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
    apiKey: 'AIzaSyDig29NqSyoYa-HD8FdTTVmah-Td-kpXaY',
    appId: '1:486918878604:web:c2d5a1228f2d7cc70e12a9',
    messagingSenderId: '486918878604',
    projectId: 'the-hit-times',
    authDomain: 'the-hit-times.firebaseapp.com',
    storageBucket: 'the-hit-times.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9gRznQApuNB2H36Rgm49cbs8mJOxQJnQ',
    appId: '1:486918878604:android:f88857a47a3658e60e12a9',
    messagingSenderId: '486918878604',
    projectId: 'the-hit-times',
    storageBucket: 'the-hit-times.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4xCrjwfYhIvvSpkNs7dfvZI5H0bleoPc',
    appId: '1:486918878604:ios:53f0324c199b7f4e0e12a9',
    messagingSenderId: '486918878604',
    projectId: 'the-hit-times',
    storageBucket: 'the-hit-times.appspot.com',
    iosClientId: '486918878604-6tg9bgd4in4h7ppeaupeqkf2uv6ptp55.apps.googleusercontent.com',
    iosBundleId: 'com.example.theHitTimesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD4xCrjwfYhIvvSpkNs7dfvZI5H0bleoPc',
    appId: '1:486918878604:ios:53f0324c199b7f4e0e12a9',
    messagingSenderId: '486918878604',
    projectId: 'the-hit-times',
    storageBucket: 'the-hit-times.appspot.com',
    iosClientId: '486918878604-6tg9bgd4in4h7ppeaupeqkf2uv6ptp55.apps.googleusercontent.com',
    iosBundleId: 'com.example.theHitTimesApp',
  );
}