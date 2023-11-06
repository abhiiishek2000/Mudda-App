import 'package:get/get.dart';
import 'package:mudda/model/CategoryListModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserSuggestionsModel.dart';

class CreateOrgController extends GetxController {
  bool _isSelected = false;
  RxString orgThumb = ''.obs;
  RxString registrationDoc = ''.obs;
  RxString username = ''.obs;
  RxBool userNameAvilable = false.obs;
  RxString orgName = ''.obs;
  RxString city = ''.obs;
  RxString state = ''.obs;
  RxString country = ''.obs;
  RxString orgType = ''.obs;
  RxString orgId = ''.obs;
  RxString visionStatement = ''.obs;
  RxString orgAddress = ''.obs;
  RxString search = ''.obs;
  RxString isGovDepartment = 'Yes'.obs;
  RxString profilePath = ''.obs;
  RxInt page = 1.obs;
  RxList<AcceptUserDetail> userList = List<AcceptUserDetail>.from([]).obs;
  RxList<Category> categoryList = List<Category>.from([]).obs;

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
    update();
  }
}
