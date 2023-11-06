import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/model/MuddaPostModel.dart';

import '../../../../dio/api/api.dart';
import '../../../../model/UserProfileModel.dart';

class UserProfileUpdateController extends GetxController with GetSingleTickerProviderStateMixin{
  Rx<AcceptUserDetail> userProfile = AcceptUserDetail().obs;
  Rx<AcceptUserDetail> orgUserProfile = AcceptUserDetail().obs;
  RxBool isLoading = false.obs;
  late TabController tabController;
  RxString userProfilePath = "".obs;
  RxString userProfileImage = "".obs;
  RxString orgUserProfileImage = "".obs;
  RxInt updateProfile = 0.obs;
  RxBool userNameAvilable = false.obs;
  RxBool isOrgAvailable = false.obs;
  RxBool isVerifiedProfiles = false.obs;
  List<String> ageList = [
    "18-25",
    "25-40",
    "40-60",
    "60+",
  ];
  List<String> genderList = ["Male", "Female", "Other"];
  List<String> districtList = [
    "Delhi",
    "Gujarat",
    "Punjab",
  ];
  int _genderSelected = 0;

  int get genderSelected => _genderSelected;

  set genderSelected(int value) {
    _genderSelected = value;
    update();
  }

  RxInt ageSelected = 0.obs;

  String _districtName = "Enter your District Name";

  String get districtName => _districtName;

  set districtName(String value) {
    _districtName = value;
    update();
  }

  RxInt startTime = 0.obs;
  RxString days = "".obs;

  RxBool isBlock = false.obs;
  Timer? timer;

  void startTimer() {
    log("message ----- ${startTime.value}");

    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (startTime.value == 0) {
          timer.cancel();
        } else {
          startTime.value--;
        }
      },
    );
  }

  @override
  void onInit() {
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.onInit();
  }
}
