import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/CategoryListModel.dart';
import 'package:mudda/ui/screens/setting_screen/controller/category_choice_controller.dart';
import 'package:mudda/ui/shared/get_started_button.dart';

import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';

class CategoryChoiceScreen extends StatefulWidget {
  const CategoryChoiceScreen({Key? key}) : super(key: key);

  @override
  State<CategoryChoiceScreen> createState() => _CategoryChoiceScreenState();
}

class _CategoryChoiceScreenState extends State<CategoryChoiceScreen> {

  List<int> selectedCategory = [];
  List<String> categoryList = [];
  List<Category> categoryMainList = [];
  @override
  void initState() {
  // TODO: implement initState
  super.initState();
  Api.get.call(context,
      method: "user-interest/index",
      param: {
        "userId": AppPreference().getString(PreferencesKey.userId),
        "page": "1",
      },
      isLoading: false, onResponseSuccess: (Map object) {
        var result = CategoryListModel.fromJson(object);
        for (int i=0; i< result.data!.length;i++) {
          if(result.data![i].userInterest != null){
            selectedCategory.add(i);
          }
          categoryList.add(result.data![i].name!);
          categoryMainList.add(result.data![i]);
        }
        setState(() {});
      });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Select",
                      style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(14),
                        color: grey,
                      ),
                    ),
                    getSizedBox(w: 5),
                    Text(
                      "Categories",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        fontSize: ScreenUtil().setSp(14),
                        color: black,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.transparent,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setSp(30),
          ),
          Text.rich(TextSpan(children: <TextSpan>[
            TextSpan(
                text: 'Choose',
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(14),
                    color: black)),
            TextSpan(
                text: ' Categories',
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w700,
                    color: black,
                    fontSize: ScreenUtil().setSp(14))),
            TextSpan(
                text: ' of your Choice',
                style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(14),
                    color: black)),
          ])),
          SizedBox(
            height: ScreenUtil().setSp(15),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setWidth(10),left: ScreenUtil().setSp(32),right: ScreenUtil().setSp(32)),
            child: categoryList.isNotEmpty ? GroupButton(
              textPadding: EdgeInsets.only(
                  left: ScreenUtil().setSp(8),
                  right: ScreenUtil().setSp(8)),
              runSpacing: ScreenUtil().setSp(9),
              groupingType: GroupingType.wrap,
              spacing: ScreenUtil().setSp(5),
              crossGroupAlignment: CrossGroupAlignment.start,
              buttonHeight: ScreenUtil().setSp(24),
              isRadio: false,
              direction: Axis.horizontal,
              selectedButtons: selectedCategory,
              onSelected: (index, ageSelected) {
                if (ageSelected &&
                    !selectedCategory
                        .contains(index)) {
                  selectedCategory.add(index);
                } else if (!ageSelected &&
                    selectedCategory
                        .contains(index)) {
                  selectedCategory.remove(index);
                }
                Api.post.call(context,
                    method: "user-interest/store",
                    param: {
                      "userId": AppPreference().getString(PreferencesKey.userId),
                      "categoryId":categoryMainList.elementAt(index).sId
                    },
                    isLoading: false, onResponseSuccess: (Map object) {
                    });
              },
              buttons: categoryList,
              selectedTextStyle: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w400,
                fontSize: ScreenUtil().setSp(12),
                color: Colors.white,
              ),
              unselectedTextStyle: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w400,
                fontSize: ScreenUtil().setSp(12),
                color: lightGray,
              ),
              selectedColor: darkGray,
              unselectedColor: Colors.transparent,
              selectedBorderColor: lightGray,
              unselectedBorderColor: lightGray,
              borderRadius:
              BorderRadius.circular(ScreenUtil().radius(15)),
              selectedShadow: <BoxShadow>[
                BoxShadow(color: Colors.transparent)
              ],
              unselectedShadow: <BoxShadow>[
                BoxShadow(color: Colors.transparent)
              ],
            ):Container(),
          ),
        ],
      ),
    );
  }
}

