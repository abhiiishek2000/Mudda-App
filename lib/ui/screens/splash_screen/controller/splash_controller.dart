import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';

import '../../../../dio/Api/Api.dart';
import '../../../../model/UserSetting.dart';

class SplashController extends GetxController {
  @override
  void onInit() {

    // TODO: implement onInit
    checkIsLogin();
    super.onInit();
  }

  void checkIsLogin() async {
    Future.delayed(const Duration(seconds: 0), () {
      print(
          'sg => userId : ${AppPreference().getString(PreferencesKey.userId)}');
      if (AppPreference().getString(PreferencesKey.userId).isEmpty) {
        return Get.offAllNamed(RouteConstants.loginScreen, arguments: true);
      } else {
        return Get.offAllNamed(RouteConstants.homeScreen);
      }
    });
  }


  }

