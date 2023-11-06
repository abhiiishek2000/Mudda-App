import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS) {
      // iOS and
      return const FirebaseOptions(
        appId: '1:804294516515:ios:374062623a420aa0613696',
        apiKey: 'AIzaSyAl0mytCV67O3wd_lZG4JShAsmz6RaYHTU',
        projectId: 'mudda-d3423',
        messagingSenderId: '4026382145',
        iosBundleId: 'com.mudda.ios',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:804294516515:android:a0ac9d5f157fc377613696',
        apiKey: 'AIzaSyAl0mytCV67O3wd_lZG4JShAsmz6RaYHTU',
        projectId: 'mudda-d3423',
        messagingSenderId: '3995282433',
      );
    }
  }
}
