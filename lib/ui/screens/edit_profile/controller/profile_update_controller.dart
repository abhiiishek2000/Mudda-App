import 'package:get/get.dart';
import 'package:mudda/model/MuddaPostModel.dart';

import '../../../../model/UserProfileModel.dart';

class ProfileUpdateController extends GetxController {
  AcceptUserDetail userProfile = AcceptUserDetail();
  // Rx<AcceptUserDetail> orgUserProfile = AcceptUserDetail().obs;
  String userProfilePath = "";
  String userProfileImage = "";
  int updateProfile = 0;
  bool userNameAvilable = false;
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
  void addData(UserProfileModel model) {
    userProfilePath = model.path!;
    userProfile = model.data!;
    updateProfile = model.data!.amIFollowing!;
    update();
  }
  void updateFollowStatus(AcceptUserDetail acceptUserDetail) {
    userProfile = acceptUserDetail;
    updateProfile = acceptUserDetail.amIFollowing!;
    update();
  }
  RxInt ageSelected = 0.obs;


  String _districtName = "Enter your District Name";

  String get districtName => _districtName;

  set districtName(String value) {
    _districtName = value;
    update();
  }
}
