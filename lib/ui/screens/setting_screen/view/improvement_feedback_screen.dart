import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';

import 'package:mudda/ui/shared/get_started_button.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';

class ImprovementFeedBackScreen extends StatelessWidget {
  ImprovementFeedBackScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Text(
                        "Your",
                        style: size18_M_medium(textColor: Colors.grey),
                      ),
                      Text(
                        " Feedback",
                        style: size18_M_medium(textColor: Colors.black),
                      ),
                      Text(
                        " is Welcome",
                        style: size18_M_medium(textColor: Colors.grey),
                      ),
                    ],
                  ),
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: ScreenUtil().setSp(90),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  minLines: 11,
                  maxLines: 15,
                  validator: (text) {
                    return text!.isEmpty ? "Enter your suggestions" : null;
                  },
                  style: size14_M_normal(textColor: Colors.grey),
                  decoration: InputDecoration(
                    fillColor: white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 12),
                    hintText: "Please describe your suggestions to improve",
                    hintStyle: size12_M_normal(textColor: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: white, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: white, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: white, width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: white, width: 1),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setSp(90),
              ),
              GetStartedButton(
                title: "Submit",
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Api.post.call(context,
                        method: "user-setting-feedback-issue/store",
                        param: {
                          "user_id":
                          AppPreference().getString(PreferencesKey.userId),
                          "type": "feedback",
                          "message": controller.text,
                        },
                        isLoading: true, onResponseSuccess: (Map object) {
                          feedBackSubmitDialogBox();
                        });
                  }
                },
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  feedBackSubmitDialogBox() {
    return showDialog(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Material(
              child: Container(
                height: 240,
                width: 300,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Text(feedBackText,
                          style: size15_M_regular(textColor: Colors.black),
                          textAlign: TextAlign.center),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetStartedButton(
                          title: "  Done  ",
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      Get.back();
    });
  }
}
