import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/model/UserJoinLeadersModel.dart';

import '../../../../model/LeadersDataModel.dart';
import '../../../../model/MuddaPostModel.dart';

class LeaderBoardApprovalController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? controller;
  RxInt tabIndex = 0.obs;
  RxString search = "".obs;
  RxString invitedSearch = "".obs;
  RxString profilePath = "".obs;
  RxBool isInvitedTab = false.obs;
  RxBool isOppositionInvitedTab = false.obs;
  Rx<AcceptUserDetail> creator = AcceptUserDetail().obs;
  Rx<AcceptUserDetail> oppositionLeader = AcceptUserDetail().obs;
  Rx<DataMudda> dataMudda = DataMudda().obs;
  Rx<LeadersDataModel> dataMuddaForOpposition = LeadersDataModel().obs;
  Rx<LeadersDataModel> dataMuddaForFavour = LeadersDataModel().obs;
  RxList<Leaders> favoursLeaders = List<Leaders>.from([]).obs;
  RxList<MuddaMuddebaazOpposition> oppositionMuddebaaz =
      List<MuddaMuddebaazOpposition>.from([]).obs;
  RxList<MuddaMuddebaazFavour> favourMuddebaaz =
      List<MuddaMuddebaazFavour>.from([]).obs;
  RxList<Leaders> oppositionLeaders = List<Leaders>.from([]).obs;
  Rx<JoinLeader> oppositionUser = JoinLeader().obs;
  RxList<JoinLeader> joinLeaderList = List<JoinLeader>.from([]).obs;
  RxList<JoinLeader> invitedLeaderList = List<JoinLeader>.from([]).obs;
  RxList<JoinLeader> requestsList = List<JoinLeader>.from([]).obs;

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: 3);
    controller!.addListener(() {
      tabIndex.value = controller!.index;
    });
  }

  @override
  void onClose() {
    controller!.dispose();
    super.onClose();
  }
}
