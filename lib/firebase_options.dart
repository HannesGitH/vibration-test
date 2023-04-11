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
    apiKey: 'AIzaSyD26C7Phls4zW2_qZHhjCGC60Zmlyhztts',
    appId: '1:772602021666:web:3e325f92df0dd3a9d3077b',
    messagingSenderId: '772602021666',
    projectId: 'vibration-359907',
    authDomain: 'vibration-359907.firebaseapp.com',
    storageBucket: 'vibration-359907.appspot.com',
    measurementId: 'G-KBR8ETG5JV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4vZqOFRB8eFSP2m8fFjcv2uM0Sm0wRNI',
    appId: '1:772602021666:android:06ff31e2478bfde3d3077b',
    messagingSenderId: '772602021666',
    projectId: 'vibration-359907',
    storageBucket: 'vibration-359907.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCv9OJnIWOHxdkMWkNgmuT2rQFW3pg97SQ',
    appId: '1:772602021666:ios:044633bc9c982740d3077b',
    messagingSenderId: '772602021666',
    projectId: 'vibration-359907',
    storageBucket: 'vibration-359907.appspot.com',
    iosClientId: '772602021666-jv3qucb5g4okqb9tfesj46jo217e1536.apps.googleusercontent.com',
    iosBundleId: 'hannepps.tools.vibrationtest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCv9OJnIWOHxdkMWkNgmuT2rQFW3pg97SQ',
    appId: '1:772602021666:ios:044633bc9c982740d3077b',
    messagingSenderId: '772602021666',
    projectId: 'vibration-359907',
    storageBucket: 'vibration-359907.appspot.com',
    iosClientId: '772602021666-jv3qucb5g4okqb9tfesj46jo217e1536.apps.googleusercontent.com',
    iosBundleId: 'hannepps.tools.vibrationtest',
  );
}
