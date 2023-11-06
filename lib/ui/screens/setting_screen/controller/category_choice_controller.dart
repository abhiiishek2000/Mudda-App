import 'package:get/get.dart';
import 'package:mudda/model/CategoryListModel.dart';

class CategoryChoiceController extends GetxController{

  RxList<String> categoryList = List<String>.from([]).obs;
  RxList<Category> categoryMainList = List<Category>.from([]).obs;
  // RxList<int> selectedCategory = List<int>.from([]).obs;
  List<int> selectedCategory = [];
}