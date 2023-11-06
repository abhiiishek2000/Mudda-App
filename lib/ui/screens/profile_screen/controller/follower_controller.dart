import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/model/FollowerUser.dart';
import 'package:mudda/model/MuddaPostModel.dart';

class FollowerController extends GetxController with GetTickerProviderStateMixin{

  RxList<Data> myFollowersResult = List<Data>.from([]).obs;
  RxList<Data> myFollowingResult = List<Data>.from([]).obs;
  RxList<AcceptUserDetail> mySuggestionsResult = List<AcceptUserDetail>.from([]).obs;
  RxList<AcceptUserDetail> mySuggestionsCityResult = List<AcceptUserDetail>.from([]).obs;
  RxList<AcceptUserDetail> mySuggestionsStateResult = List<AcceptUserDetail>.from([]).obs;
  RxList<AcceptUserDetail> mySuggestionsCountryResult = List<AcceptUserDetail>.from([]).obs;
  RxString userPath = "".obs;
  RxInt followersCount = 0.obs;
  RxInt followingCount = 0.obs;
  AcceptUserDetail? userDetail;

  TabController? controller;
  TabController? suggestionTabController;
  ScrollController followingScrollController = ScrollController();


  @override
  void onInit() {
    super.onInit();
    if(Get.parameters['user']!= null) {
      userDetail =
          AcceptUserDetail.fromJson(jsonDecode(Get.parameters['user']!));
      controller = TabController(
          vsync: this, length: 3, initialIndex: userDetail!.followerIndex!);
    }
    suggestionTabController = TabController(length: AppPreference().getString(PreferencesKey.city).isEmpty?2:5, vsync: this);
  }

  @override
  void onClose() {
    controller!.dispose();
    suggestionTabController!.dispose();
    super.onClose();
  }
}