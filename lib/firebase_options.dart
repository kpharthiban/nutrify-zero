// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSu8YqiM6z9wSHtLOIYvlCuYh3TN1Z7Dw',
    appId: '1:449895393030:android:37181ae4ec0eb95c16a087',
    messagingSenderId: '449895393030',
    projectId: 'nutrifyzero',
    storageBucket: 'nutrifyzero.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9DBnSsOQJiwKqKS3nQ2dJ8tsjEk1tZKQ',
    appId: '1:449895393030:ios:d28cfc9d09534bd816a087',
    messagingSenderId: '449895393030',
    projectId: 'nutrifyzero',
    storageBucket: 'nutrifyzero.firebasestorage.app',
    androidClientId: '449895393030-9jt7bsnbiakjtnaq3t8pqolene8ca77a.apps.googleusercontent.com',
    iosClientId: '449895393030-peuopqo00pochh9vgir096ejltjjq1u2.apps.googleusercontent.com',
    iosBundleId: 'com.example.nutrifyZero',
  );

}