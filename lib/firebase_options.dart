// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
// / ```dart
// / import 'firebase_options.dart';
// / // ...
// / await Firebase.initializeApp(
// /   options: DefaultFirebaseOptions.currentPlatform,
// / );
// / ```
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
    apiKey: 'AIzaSyCl2bvJIYz_qitqE388M06X294wfg06gQY',
    appId: '1:802887877955:android:502f06ca9bb70c6bc2dbf6',
    messagingSenderId: '802887877955',
    projectId: 'camemis-150215',
    databaseURL: 'https://camemis-150215.firebaseio.com',
    storageBucket: 'camemis-150215.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMPPbf7an82FdRD-ynxsB_efVEdhoL_HU',
    appId: '1:802887877955:ios:ad178e0c99583fd6c2dbf6',
    messagingSenderId: '802887877955',
    projectId: 'camemis-150215',
    databaseURL: 'https://camemis-150215.firebaseio.com',
    storageBucket: 'camemis-150215.appspot.com',
    androidClientId: '802887877955-03pe1ndghakbm3nhhbt80u8msvui9u3m.apps.googleusercontent.com',
    iosClientId: '802887877955-forfss09nu4hssa5m9tb4hlrd5tcfket.apps.googleusercontent.com',
    iosBundleId: 'com.camis.camemisTeacher',
  );
}
