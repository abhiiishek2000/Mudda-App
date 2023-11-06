import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/NotificationSettingModel.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool m = false;
  List<NotificationSetting> notificationSettingList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Api.get.call(context,
        method: "notification-setting/index",
        param: {
          "userId": AppPreference().getString(PreferencesKey.userId),
          "page":"1"
        },
        isLoading: true, onResponseSuccess: (Map object) {
          var result = NotificationSettingModel.fromJson(object);
          if(result.data!.isNotEmpty) {
            notificationSettingList.addAll(result.data!);
            setState(() {});
          }
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Text(
                        "Notification",
                        style: size18_M_medium(textColor: Colors.black),
                      ),
                      getSizedBox(w: 5),
                      Text(
                        "Settings",
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getSizedBox(h: 20),
              Text(
                "Enable / Disable Notifications",
                style: size13_M_normal(textColor: Colors.grey),
              ),
              Column(
                children: List.generate(
                  notificationSettingList.length,
                  (index) => Row(
                    children: [
                      Text(notificationSettingList[index].notificationType!.name!,
                          style: size15_M_regular(textColor: Colors.black)),
                      const Spacer(),
                      Transform.scale(
                        scale: 1,
                        child: Switch(
                          value: notificationSettingList[index].status == 1,
                          onChanged: (bool md) {
                            notificationSettingList[index].status = md ? 1 : 0;
                            setState(() {});
                            Api.post.call(context,
                                method: "notification-setting/update",
                                param: {
                                  "_id": notificationSettingList[index].sId,
                                  "status":notificationSettingList[index].status.toString()
                                },
                                isLoading: false, onResponseSuccess: (Map object) {

                                });
                          },
                          inactiveTrackColor: white,
                          activeTrackColor: lightGray,
                          thumbColor: MaterialStateProperty.all(darkGray),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              getSizedBox(h: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Api.post.call(context,
                          method: "notification-setting/resetAll",
                          param: {
                            "userId": AppPreference().getString(PreferencesKey.userId),
                          },
                          isLoading: true, onResponseSuccess: (Map object) {
                            Api.get.call(context,
                                method: "notification-setting/index",
                                param: {
                                  "userId": AppPreference().getString(PreferencesKey.userId),
                                  "page":"1"
                                },
                                isLoading: true, onResponseSuccess: (Map object) {
                                  var result = NotificationSettingModel.fromJson(object);
                                  if(result.data!.isNotEmpty) {
                                    notificationSettingList.clear();
                                    notificationSettingList.addAll(result.data!);
                                    setState(() {});
                                  }
                                });
                          });

                    },
                    child: Text("Reset All",
                        style: size15_M_regular(textColor: Colors.black)),
                  ),
                  InkWell(
                    onTap: (){
                      for(int i=0; i< notificationSettingList.length; i++){
                        notificationSettingList[i].status = 1;
                      }
                      setState(() {});
                      Api.post.call(context,
                          method: "notification-setting/updateAll",
                          param: {
                            "userId": AppPreference().getString(PreferencesKey.userId),
                            "status":"1"
                          },
                          isLoading: false, onResponseSuccess: (Map object) {
                          });

                    },
                    child: Text("Enable All",
                        style: size15_M_regular(textColor: Colors.black)),
                  ),
                  InkWell(
                    onTap: (){
                      for(int i=0; i< notificationSettingList.length; i++){
                        notificationSettingList[i].status = 0;
                      }
                      setState(() {});
                      Api.post.call(context,
                          method: "notification-setting/updateAll",
                          param: {
                            "userId": AppPreference().getString(PreferencesKey.userId),
                            "status":"0"
                          },
                          isLoading: false, onResponseSuccess: (Map object) {
                          });

                    },
                    child: Text("Disable All",
                        style: size15_M_regular(textColor: Colors.black)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
