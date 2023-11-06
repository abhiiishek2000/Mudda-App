import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/CategoryListModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserRolesModel.dart';
import 'package:mudda/model/UserSuggestionsModel.dart';
import 'package:mudda/model/invited_org_model.dart';
import 'package:mudda/model/support_chat.dart';
import 'package:video_trimmer/video_trimmer.dart';

class CreateMuddaController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Trimmer trimmer = Trimmer();
  RxString dropdownScopeValue = '[ Select Initial Scope ]'.obs;
  RxBool autoValidate = false.obs;

  // RxString titleValue = ''.obs;
  // RxString descriptionValue = ''.obs;
  // RxString area = ''.obs;
  // RxString city = ''.obs;
  // RxString state = ''.obs;
  // RxString country = ''.obs;
  RxString zipcode = ''.obs;
  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  RxString muddaThumb = ''.obs;
  RxString descriptionValue = ''.obs;
  RxString titleValue = ''.obs;
  RxInt inviteCount = 0.obs;
  RxBool isInvited = false.obs;
  RxInt invitedCount = 0.obs;
  RxString tag = ''.obs;
  RxString muddaId = ''.obs;
  RxInt genderSelected = 2.obs;
  RxInt ageSelected = 4.obs;
  RxString search = ''.obs;
  RxString searchLocation = ''.obs;
  RxString profilePath = ''.obs;
  RxString roleProfilePath = ''.obs;
  Rx<Role> selectedRole = Role().obs;
  Rx<Role> selectedSurveyRole = Role().obs;
  Rx<MuddaPost> muddaPost = MuddaPost().obs;
  RxList<String> uploadPhotoVideos = List<String>.from([""]).obs;
  RxList<SupportChatResult> adminMessage = <SupportChatResult>[].obs;
  RxList<Role> roleList = List<Role>.from([]).obs;
  RxList<Category> categoryList = List<Category>.from([]).obs;
  RxList<String> scopeList =
      List<String>.from(['District', 'State', 'Country', 'World']).obs;
  RxList<String> ageList = [
    "18-25",
    "25-40",
    "40-60",
    "60+",
    "All",
  ].obs;
  RxList<String> genderList = ["Male", "Female", "Both"].obs;
  RxList<AcceptUserDetail> userList = List<AcceptUserDetail>.from([]).obs;
  RxList<InvitedOrg> userListInviteOrg = List<InvitedOrg>.from([]).obs;

  TabController? controller;

  @override
  void onInit() {
    super.onInit();
    titleValue.value = '';
    descriptionValue.value = '';
    controller = TabController(vsync: this, length: 2);
  }

  @override
  void onClose() {
    controller!.dispose();
    uploadPhotoVideos.clear();
    titleValue.value = '';
    descriptionValue.value = '';
    trimmer.dispose();
    roleList.clear();
    super.onClose();
  }
}
