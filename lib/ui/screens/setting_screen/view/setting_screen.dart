import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/ui/screens/profile_screen/widget/profile_verification_screen.dart';
import 'package:video_compress/video_compress.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: ScreenUtil().screenHeight,
        color: colorAppBackground,
        child: SafeArea(
          child: Column(
            children: [
              Text(
                "Setting",
                style: size18_M_bold(textColor: colorGrey),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Get.toNamed(RouteConstants.notificationSetting);
                          },
                          title: "Notificaton Setting"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Get.toNamed(RouteConstants.categoryChoice);
                          },
                          title: "Choose Interest Categories"),
                      SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () async{
                            Navigator.pop(context);
                            final result3 = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileVideoVerificationScreen()),
                            );
                            if (result3 != null) {
                              var snackBar = SnackBar(
                                content: Text('Compressing'),
                              );
                              ScaffoldMessenger.of(
                                  context).showSnackBar(
                                  snackBar);
                              // Constants.verificationStatus = "Submitted";
                              final MediaInfo? info =
                                  await VideoCompress.compressVideo(
                                result3,
                                quality: VideoQuality.MediumQuality,
                                deleteOrigin: false,
                                includeAudio: true,
                              );
                              var video = await MultipartFile.fromFile(
                                  info!.path!,
                                  filename:
                                  "${File(result3).path.split('/').last}");
                              var formData = FormData.fromMap({
                                "verification_video": video,
                                "_id": AppPreference()
                                    .getString(PreferencesKey.userId),
                              });
                              Api.uploadPost.call(context,
                                  method: "user/profile-update",
                                  param: formData,
                                  onResponseSuccess: (Map object) {
                                    var snackBar = SnackBar(
                                      content: Text('Uploaded'),
                                    );
                                    ScaffoldMessenger.of(
                                        context).showSnackBar(
                                        snackBar);
                                  });
                            }
                          },
                          title: "Verify your Individual Profile"),
                      SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Get.toNamed(RouteConstants.orgAdditionalData);
                          },
                          title: "Verify your Org Profile"),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      settingTextButton(
                          onPressed: () {},
                          title: "Frequently Asked Questions (FAQs)"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Get.toNamed(RouteConstants.improvementFeedbacks);
                          },
                          title: "Improvements Feedback"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Get.toNamed(RouteConstants.supportRegisterUser);
                          },
                          title: "Help"),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      settingTextButton(
                          onPressed: () {}, title: "Privacy Policy"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {}, title: "Terms of Service & Usage"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {}, title: "Security Settings"),
                      const Spacer(),
                      Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(onPressed: () {
                        isLogout(context).then((value) {
                          if(value!) {
                            Get.offAllNamed(RouteConstants.loginScreen);
                          }
                        });
                      }, title: "Logout"),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<bool?> isLogout(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Are you sure you won't to logout this app?"),
          actions: [
            TextButton(
              child:
              Text("Yes", style: GoogleFonts.nunitoSans(color: lightRed)),
              onPressed: () async {
                AppPreference().clear();
                return Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text("No", style: GoogleFonts.nunitoSans(color: lightRed)),
              onPressed: () async {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
        ;
      },
    );
  }

  settingTextButton({required Function() onPressed, required String title}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 3,
          backgroundColor: Colors.black,
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: onPressed,
          child: Text(
            title,
            style: size15_M_regular(textColor: Colors.black),
          ),
        )
      ],
    );
  }
}
