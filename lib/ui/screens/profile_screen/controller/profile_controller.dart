import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/model/InitialSurveyPostModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/QuotePostModel.dart';
import 'package:mudda/model/QuotePostModel.dart';

import '../../../../dio/api/api.dart';
import '../../../../model/UserRolesModel.dart';

class ProfileController extends GetxController {
  RxString muddaProfilePath = "".obs;
  RxString quoteProfilePath = "".obs;
  RxInt isSelectedQoute = 0.obs;
  RxBool isProfileMuddaLoading = false.obs;
  RxString quotePostPath = "".obs;
  RxInt isTabSelected = 0.obs;
  RxString countFollowing = "0".obs;
  ScrollController allQuotesScrollController = ScrollController();
  ScrollController quotesScrollController = ScrollController();
  ScrollController activityScrollController = ScrollController();
  RxList<MuddaPost> muddaPostList = List<MuddaPost>.from([]).obs;
  RxList<MuddaPost> orgMuddaPostList = List<MuddaPost>.from([]).obs;
  Rx<Quote> quotesOrActivity = Quote().obs;
  RxList<Quote> quotePostList = List<Quote>.from([]).obs;
  RxList<Quote> quotePostListForProfile = List<Quote>.from([]).obs;
  RxList<Quote> reQuotePostList = List<Quote>.from([]).obs;
  RxList<Quote> singleQuotePostList = List<Quote>.from([]).obs;
  RxList<Quote> singleActivityPostList = List<Quote>.from([]).obs;
  RxList<Quote> activityPostList = List<Quote>.from([]).obs;
  RxList<InitialSurvey> initialSurveyPostList =
      List<InitialSurvey>.from([]).obs;
  RxString quotePostType = 'quote'.obs;
  RxString descriptionValue = ''.obs;
  RxList<String> uploadPhotoVideos = List<String>.from([""]).obs;
  RxList<Role> uploadQuoteRoleList = List<Role>.from([]).obs;
  Rx<Role> selectedRole = Role().obs;
  RxString roleProfilePath = ''.obs;
  RxBool isOnPageHorizontalTurning = false.obs;
  RxInt currentHorizontal = 0.obs;
  RxBool isLoading= false.obs;

  List<String> tabList = [
    AppIcons.fireIcon,
    AppIcons.quotesIcon,
    AppIcons.activityIcon,
    AppIcons.surveyIcon
  ];

  void filterQuote() {
    quotePostList.clear();
    singleActivityPostList.clear();
    isLoading.value = true;
    Api.get.call(Get.context as BuildContext,
        method: "quote-or-activity/index",
        param: {"page": '1', "post_of": "quote"},
        isLoading: false, onResponseSuccess: (Map object) {
          isLoading.value = false;
      var result = QuotePostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        quotePostPath.value = result.path!;
        singleQuotePostList.clear();
        quoteProfilePath.value = result.userpath!;
        singleQuotePostList.addAll(result.data!);
      }
    });
  }
  void filterActivities() {
    quotePostList.clear();
    singleQuotePostList.clear();
    isLoading.value = true;
    Api.get.call(Get.context as BuildContext,
        method: "quote-or-activity/index",
        param: {"page": '1', "post_of": "activity"},
        isLoading: false, onResponseSuccess: (Map object) {
          isLoading.value = false;
      var result = QuotePostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        quotePostPath.value = result.path!;
        quoteProfilePath.value = result.userpath!;
        singleActivityPostList.addAll(result.data!);
      }
    });
  }
  void getReset(){
    if(singleQuotePostList.isNotEmpty ||
       singleActivityPostList
            .isNotEmpty){
      isSelectedQoute.value = 0;
      singleActivityPostList.clear();
      singleQuotePostList.clear();
      isLoading.value = true;
      Api.get.call(Get.context as BuildContext,
          method: "quote-or-activity/index",
          param: {"page": '1'},
          isLoading: false, onResponseSuccess: (Map object) {
            isLoading.value = false;
            var result = QuotePostModel.fromJson(object);
            if (result.data!.isNotEmpty) {
              quotePostPath.value = result.path!;
              quoteProfilePath.value = result.userpath!;
              quotePostList.addAll(result.data!);
            }
          });
    }else{
      isSelectedQoute.value = 0;
    }

  }
  void scrollToTop(){
    if(quotePostList.isNotEmpty){
      allQuotesScrollController.animateTo(0, duration: const Duration(milliseconds: 500), //duration of scroll
          curve:Curves.fastOutSlowIn);
    }else if(singleQuotePostList.isNotEmpty){
      quotesScrollController.animateTo(0, duration: const Duration(milliseconds: 500), //duration of scroll
          curve:Curves.fastOutSlowIn);
    } else if(singleActivityPostList.isNotEmpty){
      activityScrollController.animateTo(0, duration: const Duration(milliseconds: 500), //duration of scroll
          curve:Curves.fastOutSlowIn);
    } else {
      return;
    }
  }
}
