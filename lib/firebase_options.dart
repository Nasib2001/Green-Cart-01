import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyA3tKjMe2USn1za_VYqPJPIOLx97gvpX74',
    appId: '1:1054720669690:web:c5893d1d1075876dc55643',
    messagingSenderId: '1054720669690',
    projectId: 'greencart2002',
    authDomain: 'greencart2002.firebaseapp.com',
    storageBucket: 'greencart2002.firebasestorage.app',
    measurementId: 'G-1PFG609S03',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2M2HrCFdSf0Cf9TEyOq0s4vcmL8tdw94',
    appId: '1:1054720669690:android:c94a1939fc0bc428c55643',
    messagingSenderId: '1054720669690',
    projectId: 'greencart2002',
    storageBucket: 'greencart2002.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClkhgva1BsFl2NMhpNkET-vrEB6xHUDDs',
    appId: '1:1054720669690:ios:035029383abba25dc55643',
    messagingSenderId: '1054720669690',
    projectId: 'greencart2002',
    storageBucket: 'greencart2002.firebasestorage.app',
    iosBundleId: 'com.example.groceryApp',
  );

}