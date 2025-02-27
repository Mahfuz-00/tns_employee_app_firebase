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
    apiKey: 'AIzaSyA0qZ9rgKX7GjhBT2aQMQgYc--FN6OARzs',
    appId: '1:66369294186:web:06728345e4fb62b7141f13',
    messagingSenderId: '66369294186',
    projectId: 'fir-integration-aab9e',
    authDomain: 'fir-integration-aab9e.firebaseapp.com',
    storageBucket: 'fir-integration-aab9e.firebasestorage.app',
    measurementId: 'G-PP1EL2NENY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCw5zbZW8C3zGq4ph763cUbdEkbZeERlSc',
    appId: '1:66369294186:android:562594241f204abd141f13',
    messagingSenderId: '66369294186',
    projectId: 'fir-integration-aab9e',
    storageBucket: 'fir-integration-aab9e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDrs5TrIRy98PYyXESt6pq7A30gq0xgr5s',
    appId: '1:66369294186:ios:022d08e122261076141f13',
    messagingSenderId: '66369294186',
    projectId: 'fir-integration-aab9e',
    storageBucket: 'fir-integration-aab9e.firebasestorage.app',
    iosBundleId: 'com.example.firebaseIntegration',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDrs5TrIRy98PYyXESt6pq7A30gq0xgr5s',
    appId: '1:66369294186:ios:022d08e122261076141f13',
    messagingSenderId: '66369294186',
    projectId: 'fir-integration-aab9e',
    storageBucket: 'fir-integration-aab9e.firebasestorage.app',
    iosBundleId: 'com.example.firebaseIntegration',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA0qZ9rgKX7GjhBT2aQMQgYc--FN6OARzs',
    appId: '1:66369294186:web:6dd39c6758a73347141f13',
    messagingSenderId: '66369294186',
    projectId: 'fir-integration-aab9e',
    authDomain: 'fir-integration-aab9e.firebaseapp.com',
    storageBucket: 'fir-integration-aab9e.firebasestorage.app',
    measurementId: 'G-8D0XT0V8CY',
  );
}
