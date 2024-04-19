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
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBVICIAHoE9u0Ja7xUxG6JEH9q5t2iUv1w',
    appId: '1:2310216331:web:04553c9ff7b024d84bd28e',
    messagingSenderId: '2310216331',
    projectId: 'financify-27722',
    authDomain: 'financify-27722.firebaseapp.com',
    databaseURL: 'https://financify-27722-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'financify-27722.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_g-c3evNH1WxRYCUP-uWQoSAe_DphmyY',
    appId: '1:2310216331:android:7462f77b9c69985f4bd28e',
    messagingSenderId: '2310216331',
    projectId: 'financify-27722',
    databaseURL: 'https://financify-27722-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'financify-27722.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDvCWtMfZ7rtoxa5CFtpntnY_6LWaEhhj4',
    appId: '1:2310216331:ios:b0c3347da56391004bd28e',
    messagingSenderId: '2310216331',
    projectId: 'financify-27722',
    databaseURL: 'https://financify-27722-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'financify-27722.appspot.com',
    iosClientId: '2310216331-h70he7fk9es03fnmrlrhcsl7f1kfoua9.apps.googleusercontent.com',
    iosBundleId: 'com.example.financify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBVICIAHoE9u0Ja7xUxG6JEH9q5t2iUv1w',
    appId: '1:2310216331:web:82c58ea80ce585c64bd28e',
    messagingSenderId: '2310216331',
    projectId: 'financify-27722',
    authDomain: 'financify-27722.firebaseapp.com',
    databaseURL: 'https://financify-27722-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'financify-27722.appspot.com',
  );
}