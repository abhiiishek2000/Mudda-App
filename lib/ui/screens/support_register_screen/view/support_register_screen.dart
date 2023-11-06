import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/ui/screens/support_register_screen/widget/back_bar_widget.dart';
import 'package:mudda/ui/shared/Validator.dart';
import 'package:mudda/ui/shared/WebViewScreen.dart';
import 'package:mudda/ui/shared/constants.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';

import 'package:mudda/core/constant/app_colors.dart';

import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/text_style.dart';

class SupportRegisterScreen extends StatefulWidget {
  const SupportRegisterScreen({Key? key}) : super(key: key);

  @override
  _SupportRegisterScreenState createState() => _SupportRegisterScreenState();
}

class _SupportRegisterScreenState extends State<SupportRegisterScreen> {

  TextEditingController commentController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            Vs(height: 42.h),
            const BackBarWidget(),
            Expanded(
              child: Form(
                key: _editFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Vs(height: 38.h),
                      Text(
                        weApologizeText,
                        textAlign: TextAlign.center,
                        style: size14_M_normal(textColor: colorA0A0A0),
                      ),
                      const Vs(height: 7),
                      InkWell(
                        onTap: ()async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewScreen("FAQ section")),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              " FAQ section",
                              style: size18_M_semiBold(textColor: colorDarkBlack),
                            ),
                            const Hs(width: 5),
                            Image.asset(
                              AppIcons.linkIcon,
                              height: 12,
                              width: 13,
                            )
                          ],
                        ),
                      ),
                      const Vs(height: 48),
                      Text(
                        "or lodge a support request below",
                        style: size14_M_normal(textColor: colorA0A0A0),
                      ),
                      const Vs(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.w),
                        child: CustomTextFieldWidget(
                          borderColor: colorWhite,
                          hintText: "Enter Full Name",
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                          ],
                          fillColor: colorWhite.withOpacity(0.5),
                          validator: (value) {
                            return Validator.validateFormField(
                                value!,
                                "Enter Full Name",
                                "Enter Valid Full Name",
                                Constants.MIN_CHAR_VALIDATION);
                          },
                        ),
                      ),
                      const Vs(height: 14),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.w),
                        child: CustomTextFieldWidget(
                          hintText: enterPhoneNumber,
                          keyboardType: TextInputType.phone,
                          borderColor: colorWhite,
                          fillColor: colorWhite.withOpacity(0.5),
                          controller: mobileController,
                          validator: (value) {
                            return Validator.validateFormField(
                                value!,
                                enterPhoneNumber,
                                enterPhoneNumber,
                                Constants.PHONE_VALIDATION);
                          },
                        ),
                      ),
                      const Vs(height: 15),
                     /* Text(
                        or,
                        style: size14_M_normal(textColor: color606060),
                      ),
                      const Vs(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.w),
                        child: CustomTextFieldWidget(
                          hintText: "Enter Email ID",
                          borderColor: colorWhite,
                          fillColor: colorWhite.withOpacity(0.5),
                        ),
                      ),
                      const Vs(height: 15),*/
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.w),
                        child: CustomTextFieldWidget(
                          keyboardType: TextInputType.text,
                          hintText: describeYourIssue,
                          borderColor: colorWhite,
                          fillColor: colorWhite.withOpacity(0.5),
                          maxLine: 5,
                          controller: commentController,
                          validator: (value) {
                            return Validator.validateFormField(
                                value!,
                                describeYourIssue,
                                describeYourIssue,
                                Constants.MIN_CHAR_VALIDATION);
                          },
                        ),
                      ),
                      Vs(height: 50.h),
                      GestureDetector(
                        onTap: () {
                          if (_editFormKey.currentState!.validate()) {
                            Map<String, dynamic> map = {
                              "name": nameController.text,
                              "mobile": mobileController.text,
                              "description": commentController.text,
                            };
                            Api.post.call(context, method: "trouble-login/store",
                                param: map,
                                onResponseSuccess: (Map object){
                                  Navigator.pop(context);
                                });
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 18.h, bottom: 41.h),
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 45, vertical: 10),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  border: Border.all(color: color606060),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 40),
                                  child: Text(
                                    "Submit",
                                    style: size18_M_normal(
                                        textColor: colorDarkBlack),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 50,
                                  padding: const EdgeInsets.all(2),
                                  margin:
                                      const EdgeInsets.only(right: 10, top: 4),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle, color: colorWhite),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorWhite,
                                        border: Border.all(color: color606060)),
                                    child: const Icon(
                                      Icons.chevron_right_rounded,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
