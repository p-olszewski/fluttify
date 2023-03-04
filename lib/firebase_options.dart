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
    apiKey: 'AIzaSyA0GVpjzuGoVrvl2K4sixP3xTlpWN5CZS0',
    appId: '1:489283869019:web:6e8f0052ed870f5218227e',
    messagingSenderId: '489283869019',
    projectId: 'fluttify-4e9eb',
    authDomain: 'fluttify-4e9eb.firebaseapp.com',
    storageBucket: 'fluttify-4e9eb.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDlb4ws065BYrcA0hzPmLHCNBjG7R9u86o',
    appId: '1:489283869019:android:8a0d1c165fd5316118227e',
    messagingSenderId: '489283869019',
    projectId: 'fluttify-4e9eb',
    storageBucket: 'fluttify-4e9eb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAgkVrvhtB39QlyF47OPQ5lT5A4lnz5Myk',
    appId: '1:489283869019:ios:f97d170f7b1a276a18227e',
    messagingSenderId: '489283869019',
    projectId: 'fluttify-4e9eb',
    storageBucket: 'fluttify-4e9eb.appspot.com',
    iosClientId: '489283869019-n3chhc517ld9v9l9da7c5n084glnv89b.apps.googleusercontent.com',
    iosBundleId: 'com.example.fluttify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAgkVrvhtB39QlyF47OPQ5lT5A4lnz5Myk',
    appId: '1:489283869019:ios:f97d170f7b1a276a18227e',
    messagingSenderId: '489283869019',
    projectId: 'fluttify-4e9eb',
    storageBucket: 'fluttify-4e9eb.appspot.com',
    iosClientId: '489283869019-n3chhc517ld9v9l9da7c5n084glnv89b.apps.googleusercontent.com',
    iosBundleId: 'com.example.fluttify',
  );
}