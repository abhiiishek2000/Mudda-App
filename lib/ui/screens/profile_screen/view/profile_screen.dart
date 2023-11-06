import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/const/const.dart';
import 'package:mudda/core/constant/app_icons.dart';

import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/edit_profile/view/org_builder_screen.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/profile_screen/widget/profile_verification_screen.dart';
import 'package:mudda/ui/shared/WebViewScreen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_compress/video_compress.dart';

import '../../../../core/utils/constant_string.dart';
import '../../../shared/create_dynamic_link.dart';
import '../widget/self_profile_tab.dart';
import '../widget/user_profile_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int tabIndex = 0;

  UserProfileUpdateController? userProfileUpdateController;
  MuddaNewsController? muddaNewsController;

  @override
  void initState() {
    fetchLinkData();
    super.initState();
     if(Get.arguments!=null && Get.arguments['page'] !=null){
       tabIndex = Get.arguments['page'];
       setState(() {
       });
     }
    userProfileUpdateController = Get.find<UserProfileUpdateController>();
    muddaNewsController = Get.find<MuddaNewsController>();
    userProfileUpdateController!.isOrgAvailable.value =
        AppPreference().getString(PreferencesKey.orgUserId).isNotEmpty;

  }

  String? profileId;

  fetchLinkData() async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    if (link != null) {
      setState(() {
        profileId = handleLinkData(link);
      });
      log('New -->$profileId');
    }
  }

  String? handleLinkData(PendingDynamicLinkData data) {
    final Uri? uri = data.link;
    if (uri != null) {
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        String? profileId = queryParams["id"];
        log('New1 -->$profileId');
        return profileId;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: drawerSetting(),
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SafeArea(
            child: Column(
              children: [
                Row(
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
                    const Spacer(),
                    IconButton(
                        onPressed: () async {
                          CreateMyDynamicLinksClass()
                              .createDynamicLink(true,
                                  '/otherUserProfileScreen?id=${userProfileUpdateController!.tabController.index == 0 ? AppPreference().getString(PreferencesKey.userId) : AppPreference().getString(PreferencesKey.orgUserId)}')
                              .then((value) {
                            Share.share("$shareMessage$value");
                          });
                        },
                        icon: SvgPicture.asset("assets/svg/share.svg")),
                    const SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: Image.asset(
                        AppIcons.settingIcon,
                        height: 25,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: colorGrey),
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                  child: TabBar(
                    controller: userProfileUpdateController!.tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      borderRadius: tabIndex == 0
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))
                          : const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                      color: colorGrey,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    onTap: (int index) {
                      setState(() {
                        tabIndex = index;
                      });
                    },
                    tabs: [
                      Tab(
                        icon: Image.asset(
                          AppIcons.profileTab1,
                          height: 20,
                          width: 20,
                          color: tabIndex == 0 ? Colors.white : colorGrey,
                        ),
                      ),
                      Tab(
                        icon: Image.asset(
                          AppIcons.profileTab2,
                          height: 20,
                          width: 20,
                          color: tabIndex == 1 ? Colors.white : colorGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setSp(15)),
        child: Obx(
          () => TabBarView(
            controller: userProfileUpdateController!.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              UserProfileTab(userId: profileId),
              userProfileUpdateController!.isOrgAvailable.value
                  ? SelfProfileTab()
                  : OrgBuilderScreen()
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerSetting() {
    return Drawer(
      child: Container(
        height: ScreenUtil().screenHeight,
        color: colorAppBackground,
        child: SafeArea(
          child: Column(
            children: [
              Text(
                "Settings",
                style: size18_M_bold(textColor: colorGrey),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Get.toNamed(RouteConstants.notificationSetting);
                          },
                          title: "Notification Settings"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Get.toNamed(RouteConstants.categoryChoice);
                          },
                          title: "Choose Interest Categories"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final result3 = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfileVideoVerificationScreen()),
                            );
                            if (result3 != null) {
                              var snackBar = const SnackBar(
                                content: Text('Compressing'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
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
                                  filename: File(result3).path.split('/').last);
                              var formData = FormData.fromMap({
                                "verification_video": video,
                                "_id": AppPreference()
                                    .getString(PreferencesKey.userId),
                              });
                              Api.uploadPost.call(context,
                                  method: "user/profile-update",
                                  param: formData,
                                  onResponseSuccess: (Map object) {
                                var snackBar = const SnackBar(
                                  content: Text('Uploaded'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            }
                          },
                          title: "Verify your Individual Profile"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (AppPreference()
                                .getString(PreferencesKey.orgUserId)
                                .isNotEmpty) {
                              Get.toNamed(RouteConstants.orgAdditionalData);
                            }
                          },
                          title: "Verify your Org Profile"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            isDeleteAccount(context).then((value) {
                              if (value!) {
                                Get.offAllNamed(RouteConstants.loginScreen);
                              }
                            });
                          },
                          title: "Delete Account"),
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
                          onPressed: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewScreen("FAQ section")),
                            );
                          },
                          title: "Frequently Asked Questions (FAQs)"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Get.toNamed(RouteConstants.improvementFeedbacks);
                          },
                          title: "Improvements Feedback"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Get.toNamed(RouteConstants.supportRegisterUser);
                          },
                          title: "Help"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Get.toNamed(RouteConstants.introScreen,
                                arguments: true);
                          },
                          title: "Take a Tour"),
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
                          onPressed: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewScreen("Privacy Policy")),
                            );
                          },
                          title: "Privacy Policy"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewScreen("Terms of Service")),
                            );
                          },
                          title: "Terms of Service & Usage"),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewScreen("Community Guidelines")),
                            );
                          },
                          title: "Community Guidelines"),
                      const Spacer(),
                      Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      settingTextButton(
                          onPressed: () {
                            isLogout(context).then((value) {
                              if (value!) {
                                Get.offAllNamed(RouteConstants.loginScreen,arguments: false);
                              }
                            });
                          },
                          title: "Logout"),
                      const SizedBox(
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
          content: const Text("Are you sure you want to logout Mudda?"),
          actions: [
            TextButton(
              child:
                  Text("Yes", style: GoogleFonts.nunitoSans(color: lightRed)),
              onPressed: () async {
                AppPreference().clear();
                muddaNewsController!.tabController.index = 0;
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
      },
    );
  }

  Future<bool?> isDeleteAccount(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Are you sure you want to delete your account?"),
          actions: [
            TextButton(
              child:
                  Text("Yes", style: GoogleFonts.nunitoSans(color: lightRed)),
              onPressed: () async {
                AppPreference _appPreference = AppPreference();
                FormData formData = FormData.fromMap({
                  "status": "0",
                  "deleted": "true",
                  "_id": _appPreference.getString(PreferencesKey.userId),
                });
                Api.uploadPost.call(context,
                    method: "user/user-delete",
                    param: formData,
                    isLoading: true, onResponseSuccess: (Map object) {
                  AppPreference().clear();
                  muddaNewsController!.tabController.index = 0;
                  return Navigator.pop(context, true);
                });
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
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: InkWell(
            onTap: onPressed,
            child: Text(
              title,
              style: size15_M_regular(textColor: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}

orgBox(
    {required String title, required String icon, required Function() onTap}) {
  return Builder(builder: (BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3.5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 28, top: 3.5, bottom: 3.5),
                child: Text(
                  title,
                  style: size14_M_normal(textColor: colorGrey),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: colorGrey),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          Positioned(
            left: -5,
            child: Container(
              height: 34,
              width: 34,
              child: Column(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    child: Center(
                      child: Image.asset(
                        icon,
                        height: 18,
                        width: 18,
                        color: colorGrey,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: colorGrey),
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              ),
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  });
}

leaderBox(
    {required String value,
    required String title,
    required void Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 75,
          width: 70,
          child: Column(
            children: [
              const SizedBox(
                height: 18,
              ),
              Text(
                value,
                style: size14_M_medium(textColor: colorDarkBlack),
              ),
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(color: Colors.white)),
        ),
        Container(
          height: 30,
          width: 70,
          child: Center(
            child: Text(
              title,
              style: size13_M_medium(
                textColor: Colors.white,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
            border: Border.all(
              color: const Color(0xFF555555),
            ),
          ),
        )
      ],
    ),
  );
}

Widget whiteDivider({EdgeInsetsGeometry? margin}) {
  return Container(
    height: 1,
    margin: margin,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    color: Colors.white,
  );
}
