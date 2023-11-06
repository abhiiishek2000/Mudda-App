import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants {
  static final String baseUrl = 'http://famelinks.in/v1/';
  static const int NORMAL_VALIDATION = 1;
  static const int EMAIL_VALIDATION = 2;
  static const int PHONE_VALIDATION = 3;
  static const int PHONE_OR_EMAIL_VALIDATION = 4;
  static const int PASSWORD_VALIDATION = 5;
  static const int ZIP_VALIDATION = 6;
  static const int MIN_CHAR_VALIDATION = 7;
  static int page = 1;
  static String firstName = "";
  static String otp = "";
  static String otpHash = "";
  static String district = "";
  static String state = "";
  static String country = "";
  static int todayPosts = 0;
  static int perdayPost = 1;
  static int fameCoins = 0;
  static bool isVerified = false;
  static String verificationStatus = "";
  static dynamic token;
  static dynamic userId;
  static dynamic userType;
  static dynamic profileUserId;
  static int retries = 0;
  static int registered = 0;
  static String appBarTitle = "";
  static String bearerToken = "";
  static int finalStatus = 0;
  static int type = 3;
  static bool following = false;
  static bool isRegisterdForContest = true;
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static int re_tries = 0;

  static toastMessage({String? msg}) {
    Fluttertoast.showToast(
        msg: msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 15.0);
  }

  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

}
