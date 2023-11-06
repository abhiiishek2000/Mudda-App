import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mudda/const/const.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';

import '../../core/constant/app_icons.dart';
import '../../core/constant/route_constants.dart';
import '../../dio/Api/Api.dart';
import '../../model/UserSetting.dart';

class HomeAppBarActions extends StatefulWidget {
  const HomeAppBarActions({Key? key}) : super(key: key);

  @override
  State<HomeAppBarActions> createState() => _HomeAppBarActionsState();
}

class _HomeAppBarActionsState extends State<HomeAppBarActions> {
  final userUpdateController = Get.put(UserProfileUpdateController());

  @override
  void initState() {
    getAppPath();
    super.initState();
  }

  void getAppPath() {
    Api.get.call(Get.context as BuildContext,
        method: "user/config",
        param: {},
        isLoading: false, onResponseSuccess: (Map object) {
      var result = UserSetting.fromJson(object);
      AppPreference _appPreference = AppPreference();
      _appPreference.setString(PreferencesKey.url, result.config!.s3!.url!);
      _appPreference.setString(
          PreferencesKey.user, result.config!.s3!.folder!.user!);
      _appPreference.setString(
          PreferencesKey.channel, result.config!.s3!.folder!.channel!);
      _appPreference.setString(
          PreferencesKey.chat, result.config!.s3!.folder!.chat!);
      _appPreference.setString(
          PreferencesKey.mudda, result.config!.s3!.folder!.mudda!);
      _appPreference.setString(PreferencesKey.notificationType,
          result.config!.s3!.folder!.notificationType!);
      _appPreference.setString(PreferencesKey.postForMudda,
          result.config!.s3!.folder!.postForMudda!);
      _appPreference.setString(PreferencesKey.quoteOrActivity,
          result.config!.s3!.folder!.quoteOrActivity!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (AppPreference().getString(PreferencesKey.orgProfile) != '')
            InkWell(
              onTap: () {
                userUpdateController.tabController.index = 1;
                Get.toNamed(RouteConstants.profileScreen,
                    arguments: {'page': 1});
              },
              child: Container(
                height: ScreenUtil().setHeight(35),
                width: ScreenUtil().setHeight(35),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: white, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.50),
                      offset: const Offset(0, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Obx(() =>
                      userUpdateController.orgUserProfile.value.profile != null
                          ? CachedNetworkImage(
                              height: ScreenUtil().setHeight(35),
                              width: ScreenUtil().setHeight(35),
                              fit: BoxFit.cover,
                              imageUrl:
                                  '${AppPreference().getString(PreferencesKey.url) != '' ? AppPreference().getString(PreferencesKey.url) : Const.url}${AppPreference().getString(PreferencesKey.user) != '' ? AppPreference().getString(PreferencesKey.user) : 'user'}/${userUpdateController.orgUserProfile.value.profile}',
                            )
                          : CachedNetworkImage(
                              height: ScreenUtil().setHeight(35),
                              width: ScreenUtil().setHeight(35),
                              fit: BoxFit.cover,
                              imageUrl:
                                  '${AppPreference().getString(PreferencesKey.url) != '' ? AppPreference().getString(PreferencesKey.url) : Const.url}${AppPreference().getString(PreferencesKey.user) != '' ? AppPreference().getString(PreferencesKey.user) : 'user'}/${AppPreference().getString(PreferencesKey.orgProfile)}',
                            )),
                ),
              ),
            )
          else if (AppPreference().getString(PreferencesKey.orgUserId) != '')
            InkWell(
                onTap: () {
                  userUpdateController.tabController.index = 1;
                  Get.toNamed(RouteConstants.profileScreen,
                      arguments: {'page': 1});
                },
                child: Container(
                    height: ScreenUtil().setHeight(35),
                    width: ScreenUtil().setHeight(35),
                    child: SvgPicture.asset(AppIcons.icOrgProfile)))
          else
            const SizedBox(),
          const SizedBox(width: 23),
          if (AppPreference().getString(PreferencesKey.profile) != '')
            InkWell(
              onTap: () {
                userUpdateController.tabController.index = 0;
                Get.toNamed(RouteConstants.profileScreen);
              },
              child: Container(
                height: ScreenUtil().setHeight(35),
                width: ScreenUtil().setHeight(35),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: white,
                  border: Border.all(width: 1, color: white),
                  boxShadow: [
                    BoxShadow(
                      color: black.withOpacity(0.50),
                      offset: const Offset(0, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Obx(() =>
                      userUpdateController.userProfile.value.profile != null
                          ? CachedNetworkImage(
                              height: ScreenUtil().setHeight(35),
                              width: ScreenUtil().setHeight(35),
                              fit: BoxFit.cover,
                              imageUrl:
                                  '${AppPreference().getString(PreferencesKey.url) != '' ? AppPreference().getString(PreferencesKey.url) : Const.url}${AppPreference().getString(PreferencesKey.user) != '' ? AppPreference().getString(PreferencesKey.user) : 'user'}/${userUpdateController.userProfile.value.profile}',
                            )
                          : CachedNetworkImage(
                              height: ScreenUtil().setHeight(35),
                              width: ScreenUtil().setHeight(35),
                              fit: BoxFit.cover,
                              imageUrl:
                                  '${AppPreference().getString(PreferencesKey.url) != '' ? AppPreference().getString(PreferencesKey.url) : Const.url}${AppPreference().getString(PreferencesKey.user) != '' ? AppPreference().getString(PreferencesKey.user) : 'user'}/${AppPreference().getString(PreferencesKey.profile)}',
                            )),
                ),
              ),
            )
          else
            InkWell(
                onTap: () {
                  userUpdateController.tabController.index = 0;
                  Get.toNamed(RouteConstants.profileScreen);
                },
                child: Container(
                    height: ScreenUtil().setHeight(35),
                    width: ScreenUtil().setHeight(35),
                    child:
                        Center(child: Icon(Icons.person,size: 24,color: black,)))),
        ],
      ),
    );
  }
}
