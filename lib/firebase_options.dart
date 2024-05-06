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
    apiKey: 'AIzaSyCT1CMIejbiCic8vdE64lBkOP8xDLMW0H0',
    appId: '1:806338568386:web:317a2057b7c70b5e5f5b5b',
    messagingSenderId: '806338568386',
    projectId: 'chatapp-e0be9',
    authDomain: 'chatapp-e0be9.firebaseapp.com',
    storageBucket: 'chatapp-e0be9.appspot.com',
    measurementId: 'G-6TE8C3BNEG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwaRW0Pw6IOhPOsGfM5eThR2TNSiIGIGg',
    appId: '1:806338568386:android:a0b9e73e488876885f5b5b',
    messagingSenderId: '806338568386',
    projectId: 'chatapp-e0be9',
    storageBucket: 'chatapp-e0be9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4K7GA2Wi854m5qDGWzL5pTjGymfwNtuE',
    appId: '1:806338568386:ios:9cff778861f3efc95f5b5b',
    messagingSenderId: '806338568386',
    projectId: 'chatapp-e0be9',
    storageBucket: 'chatapp-e0be9.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA4K7GA2Wi854m5qDGWzL5pTjGymfwNtuE',
    appId: '1:806338568386:ios:39bfa6088af0222a5f5b5b',
    messagingSenderId: '806338568386',
    projectId: 'chatapp-e0be9',
    storageBucket: 'chatapp-e0be9.appspot.com',
    iosBundleId: 'com.example.chatApp.RunnerTests',
  );
}
