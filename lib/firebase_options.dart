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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDT6OOwINGrGMF4irro6ir2ygQ_cBiIu1A',
    appId: '1:53404766354:web:7881ea8b8a7c16fc90564b',
    messagingSenderId: '53404766354',
    projectId: 'aplikasipermohonan-bd27a',
    authDomain: 'aplikasipermohonan-bd27a.firebaseapp.com',
    storageBucket: 'aplikasipermohonan-bd27a.firebasestorage.app',
    measurementId: 'G-Y5VCET0J1J',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDImcPJSxwY_TMnmmSRbiVMAFGcaPF6zU',
    appId: '1:53404766354:ios:83e0e768f70d424090564b',
    messagingSenderId: '53404766354',
    projectId: 'aplikasipermohonan-bd27a',
    storageBucket: 'aplikasipermohonan-bd27a.firebasestorage.app',
    iosBundleId: 'com.example.flutterProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBDImcPJSxwY_TMnmmSRbiVMAFGcaPF6zU',
    appId: '1:53404766354:ios:83e0e768f70d424090564b',
    messagingSenderId: '53404766354',
    projectId: 'aplikasipermohonan-bd27a',
    storageBucket: 'aplikasipermohonan-bd27a.firebasestorage.app',
    iosBundleId: 'com.example.flutterProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDT6OOwINGrGMF4irro6ir2ygQ_cBiIu1A',
    appId: '1:53404766354:web:729c27f93a532d0690564b',
    messagingSenderId: '53404766354',
    projectId: 'aplikasipermohonan-bd27a',
    authDomain: 'aplikasipermohonan-bd27a.firebaseapp.com',
    storageBucket: 'aplikasipermohonan-bd27a.firebasestorage.app',
    measurementId: 'G-D9VCDVP4PT',
  );
}
