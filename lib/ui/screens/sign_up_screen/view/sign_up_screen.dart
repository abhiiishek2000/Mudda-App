import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/UserProfileModel.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/sign_up_screen/controller/sign_up_controller.dart';
import 'package:mudda/ui/screens/sign_up_screen/widgets/top_widget_column.dart';
import 'package:mudda/ui/shared/WebViewScreen.dart';
import 'package:mudda/ui/shared/back_button.dart';
import 'package:mudda/ui/shared/get_started_button.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';

import '../../../../core/preferences/preference_manager.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../home_screen/controller/mudda_fire_news_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController signUpController = Get.put(SignUpController());
  final MuddaNewsController muddaNewsController =
      Get.put(MuddaNewsController());
  UserProfileUpdateController? userProfileUpdateController;
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    userProfileUpdateController = Get.find<UserProfileUpdateController>();
    return Scaffold(
      backgroundColor: colorAppBackground,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5.h, left: 15, bottom: 0),
                  child: const CustomBackButton(),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TopWidgetColumnWidget(
                      formKey: _formKey,
                      signUpController: signUpController,
                    ),
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        decoration: const BoxDecoration(
                          color: colorWhite,
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: colorA0A0A0,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Hs(width: 30),
                            InkWell(
                              onTap: () {
                                signUpController.isGuest.value =
                                    !signUpController.isGuest.value;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    border: Border.all(color: colorBlack),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: signUpController.isGuest.value
                                          ? colorBlack
                                          : Colors.transparent),
                                ),
                              ),
                            ),
                            const Hs(width: 11),
                            Text(
                              "Continue as Guest",
                              style: size14_M_normal(textColor: colorA0A0A0),
                            )
                          ],
                        ),
                      ),
                    ),
                    Vs(height: 20.h),
                    Row(
                      children: [
                        const Hs(width: 28),
                        // InkWell(
                        //   onTap: () {
                        //     signUpController.isAgree.value =
                        //     !signUpController.isAgree.value;
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.all(4),
                        //     decoration: BoxDecoration(
                        //         border: Border.all(color: colorBlack),
                        //         borderRadius: BorderRadius.circular(5)),
                        //     child: Container(
                        //       padding: const EdgeInsets.all(5),
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(2),
                        //           color: signUpController.isAgree.value
                        //               ? colorBlack
                        //               : Colors.transparent),
                        //     ),
                        //   ),
                        // ),
                        // Hs(width: 10),
                        Flexible(
                          child: Text.rich(TextSpan(
                              text: "By continuing, you agree to Mudda ",
                              style: size10_M_normal(textColor: color606060),
                              children: [
                                TextSpan(
                                  text: "Terms of Service, ",
                                  style: size10_M_semibold(
                                      textColor: colorDarkBlack),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WebViewScreen(
                                                "Terms of Service")),
                                      );
                                    },
                                ),
                                TextSpan(
                                  text: "Community Guidelines ",
                                  style: size10_M_semibold(
                                      textColor: colorDarkBlack),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WebViewScreen(
                                                "Community Guidelines")),
                                      );
                                    },
                                ),
                                TextSpan(
                                  text: "& \n",
                                  style:
                                      size10_M_normal(textColor: color606060),
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: size10_M_semibold(
                                      textColor: colorDarkBlack),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WebViewScreen(
                                                "Privacy Policy")),
                                      );
                                    },
                                )
                              ])),
                        )
                      ],
                    ),
                    GetStartedButton(
                      title: "Get Started",
                      onTap: () async {
                        if (signUpController.isGuest.value) {
                          AppPreference _appPreference = AppPreference();
                          _appPreference.setBool(PreferencesKey.isGuest,
                              signUpController.isGuest.value);
                          muddaNewsController.isShowGuide.value = true;
                          // Get.toNamed(RouteConstants.homeScreen);
                          Get.offAllNamed(RouteConstants.homeScreen);
                        } else {
                          if (_formKey.currentState!.validate()) {
                            AppPreference _appPreference = AppPreference();
                            _appPreference.setBool(
                                PreferencesKey.isGuest, false);
                            FormData formData = FormData.fromMap({
                              "fullname": signUpController.nameValue.value,
                              "city": signUpController.city.value,
                              "state": signUpController.state.value,
                              "country": signUpController.country.value,
                              "gender": signUpController.maleFemaleList
                                  .elementAt(
                                      signUpController.isSelectedMale.value),
                              "age": signUpController.ageList.elementAt(
                                  signUpController.isSelectedAge.value),
                              "_id": _appPreference
                                  .getString(PreferencesKey.userId),
                            });
                            if (signUpController.profile.value.isNotEmpty) {
                              print("PROFILE:::" +
                                  signUpController.profile.value);
                              var video = await MultipartFile.fromFile(
                                  signUpController.profile.value,
                                  filename: signUpController.profile.value
                                      .split('/')
                                      .last);
                              formData.files.addAll([
                                MapEntry("profile", video),
                              ]);
                            }

                            Api.uploadPost.call(context,
                                method: "user/profile-update",
                                param: formData,
                                isLoading: true,
                                onResponseSuccess: (Map object) {
                              var snackBar = const SnackBar(
                                content: Text('Updated'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              var result = UserProfileModel.fromJson(object);
                              userProfileUpdateController!
                                  .userProfilePath.value = result.path!;
                              userProfileUpdateController!.userProfile.value =
                                  result.data!;
                              AppPreference().setString(PreferencesKey.fullName,
                                  object['data']['fullname']);
                              AppPreference().setString(PreferencesKey.city,
                                  signUpController.nameValue.value);
                              AppPreference().setString(
                                  PreferencesKey.state,
                                  userProfileUpdateController!
                                      .userProfile.value.state!);
                              AppPreference().setString(
                                  PreferencesKey.country,
                                  userProfileUpdateController!
                                      .userProfile.value.country!);
                              muddaNewsController.isShowGuide.value = true;
                              Get.offAllNamed(RouteConstants.homeScreen);
                            });
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
