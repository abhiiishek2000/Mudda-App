import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  RxInt isSelectedAge = (0).obs;
  RxInt isSelectedMale = (0).obs;
  RxString dropdownValue = 'One'.obs;
  RxString nameValue = ''.obs;
  RxBool isGuest = false.obs;
  RxBool isAgree = false.obs;
  RxString profile = ''.obs;
  RxString city = ''.obs;
  RxString state = ''.obs;
  RxString country = ''.obs;

  RxList<String> ageList = ["18-25", "25-40", "40-60", "60+"].obs;
  //RxList<String> maleFemaleList = [maleIcon, femaleIcon, otherIcon].obs;
  RxList<String> maleFemaleList = ["Male", "Female", "Other"].obs;
}
