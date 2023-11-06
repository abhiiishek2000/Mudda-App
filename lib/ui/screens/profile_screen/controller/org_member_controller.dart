import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/model/InitialSurveyPostModel.dart';
import 'package:mudda/model/MembersDataModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/QuotePostModel.dart';
import 'package:mudda/model/QuotePostModel.dart';

class OrgMemberController extends GetxController {
  RxString userProfilePath = "".obs;
  RxString permission = "Member".obs;
  RxList<MemberModel> memberList = List<MemberModel>.from([]).obs;
  Rx<TextEditingController> locationController = TextEditingController().obs;
}
