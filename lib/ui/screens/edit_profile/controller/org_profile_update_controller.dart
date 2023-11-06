import 'package:get/get.dart';

class OrgProfileUpdateController extends GetxController {
  String _districtName = "Enter your District Name";

  String get districtName => _districtName;

  set districtName(String value) {
    _districtName = value;
    update();
  }

  List<String> districtList = [
    "Delhi",
    "Gujarat",
    "Punjab",
  ];
}
