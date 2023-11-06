import 'dart:async';
//
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  String _diaCode = "91";

  String get diaCode => _diaCode;

  late final isOTPOn = false.obs;

  late final isPasswordVisible = false.obs;
  RxString firebaseToken= ''.obs;

  RxInt second = 30.obs;
  FirebaseMessaging? messaging;
  @override
  void onInit() {
    timeLeft();
    accessDeviceFirebaseToken();
  }
  accessDeviceFirebaseToken() {
    messaging = FirebaseMessaging.instance;
    messaging!.subscribeToTopic("messaging");
    messaging!.getToken().then((value) {
      print("firebase token-- " + value!);
      firebaseToken.value = value;
    });
  }
  timeLeft() {
    if (isOTPOn.value) {
      Timer.periodic(const Duration(seconds: 1), (_) {
        if (second.value != 0) {
          second.value--;
        }
      });
    }
  }

  set diaCode(String value) {
    _diaCode = value;
    update();
  }
}
