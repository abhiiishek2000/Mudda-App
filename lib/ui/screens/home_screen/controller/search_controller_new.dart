import 'package:get/get.dart';
import 'package:mudda/model/MuddaPostModel.dart';

class SearchController extends GetxController{

  RxList<AcceptUserDetail> userProfilesList = List<AcceptUserDetail>.from([]).obs;
  RxList<AcceptUserDetail> orgList = List<AcceptUserDetail>.from([]).obs;
  RxList<AcceptUserDetail> newUserList = List<AcceptUserDetail>.from([]).obs;
  RxList<MuddaPost> muddaList = List<MuddaPost>.from([]).obs;
  RxString muddaPath = ''.obs;
  RxString userProfilePath = ''.obs;
  String search = '';
  RxBool flag = true.obs;
  RxBool leaders = false.obs;
  RxBool orgs = false.obs;
  RxBool newusers = false.obs;
}