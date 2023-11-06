import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';

import '../../../../../core/preferences/preference_manager.dart';
import '../../../../../core/preferences/preferences_key.dart';
import '../../../../../core/utils/color.dart';
import '../../../../../core/utils/text_style.dart';
import '../../../../core/constant/app_icons.dart';

class ActionTaskWidget extends StatelessWidget {
  ActionTaskWidget({Key? key}) : super(key: key);
  final muddaNewsController = Get.put(MuddaNewsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => !muddaNewsController.isDismissActionTask.value
        ? Container(
            padding:
                const EdgeInsets.only(left: 12, right: 12, bottom: 4, top: 4),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(8)),
              border: Border.all(color: yellow, width: 1),
              boxShadow: [
                BoxShadow(
                  color: colorBlack.withOpacity(0.16),
                  offset: const Offset(
                    0.0,
                    4.0,
                  ),
                  blurRadius: 4,
                  spreadRadius: 0.8,
                ), //BoxShadow//BoxShadow
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: InkWell(
                          onTap: () {
                            muddaNewsController.dismissActionTask();
                          },
                          child: Text(
                            'Dismiss',
                            style: size14_M_normal(textColor: buttonBlue),
                          )),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    Text.rich(TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: 'This is the Mudda Debate Forum',
                          style: size20_M_semibold(textColor: buttonBlue)),
                    ])),
                    Text("where a topic is debated Publicly- ",
                        style: size12_M_normal(textColor: black)),
                  ],
                ),
                const SizedBox(height: 4),
                Obx(() => !muddaNewsController.isLiked.value &&
                        !AppPreference().getBool(PreferencesKey.isLiked)
                    ? Wrap(
                        children: [
                          Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "1. ",
                                style: size14_M_normal(textColor: black)),
                            TextSpan(
                                text: '“Agree”',
                                style: size14_M_bold(textColor: black)),
                            TextSpan(
                                text: " or ",
                                style: size14_M_normal(textColor: black)),
                            TextSpan(
                                text: '“Disagree”',
                                style: size14_M_bold(textColor: black)),
                            TextSpan(
                                text: " to User Posts",
                                style: size14_M_normal(textColor: black)),
                          ])),
                          Row(
                            children: [
                              Image.asset(
                                AppIcons.dislike,
                                height: 16,
                                color: colorF1B008,
                              ),
                              SvgPicture.asset(AppIcons.icLine),
                              Image.asset(
                                AppIcons.handIcon,
                                height: 16,
                                color: buttonBlue,
                              )
                            ],
                          )
                        ],
                      )
                    : const SizedBox()),
                const SizedBox(height: 4),
                Obx(() => !muddaNewsController.isReplied.value &&
                        !AppPreference().getBool(PreferencesKey.isReplied)
                    ? Wrap(children: [
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: "2. ",
                                  style: size14_M_normal(textColor: black)),
                              TextSpan(
                                  text: 'Swipe ',
                                  style:
                                      size14_M_normal(textColor: buttonBlue)),
                              TextSpan(
                                  text: "on any Post to reply",
                                  style: size14_M_normal(textColor: black)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset(
                            AppIcons.icSwipe,
                            color: colorF1B008,
                          ),
                        )
                      ])
                    : const SizedBox()),
                const SizedBox(height: 4),
                Obx(() => !muddaNewsController.isClickedPlusIcon.value &&
                        !AppPreference()
                            .getBool(PreferencesKey.isClickedPlusIcon)
                    ? Wrap(
                        children: [
                          Text.rich(TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: "3. ",
                                style: size14_M_normal(textColor: black)),
                            TextSpan(
                                text: 'Write your own Post. ',
                                style: size14_M_normal(textColor: black)),
                            TextSpan(
                                text: ' Click ',
                                style: size14_M_normal(textColor: black)),
                            TextSpan(
                                text: "Plus Icon",
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w700,
                                    color: yellow,
                                    decoration: TextDecoration.underline,
                                    fontSize: ScreenUtil().setSp(14))),
                            TextSpan(
                                text: ' in the bottom',
                                style: size14_M_normal(textColor: black)),
                          ])),
                        ],
                      )
                    : const SizedBox())
              ],
            ),
          )
        : const SizedBox());
  }
}
