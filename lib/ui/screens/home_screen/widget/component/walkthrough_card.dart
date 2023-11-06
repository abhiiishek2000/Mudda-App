
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';

import '../../../../../core/preferences/preference_manager.dart';
import '../../../../../core/preferences/preferences_key.dart';
import '../../../../../core/utils/color.dart';
import '../../../../../core/utils/text_style.dart';

class WalkthroughCardWidget extends StatelessWidget {
   WalkthroughCardWidget({Key? key}) : super(key: key);
  final muddaNewsController = Get.put(MuddaNewsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => !muddaNewsController.isDismissWalkthrough.value ? Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Know how to use Mudda App',style: size14_M_normal(textColor: black),),
              TextButton(onPressed: (){
                muddaNewsController.dismissWalkthrough();
              }, child: const Text('Dismiss')),
            ],
          ),
          Wrap(
            children: [
              Text.rich(TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'This is your home feed ',
                    style: size14_M_bold(textColor: buttonBlue)),
                TextSpan(
                    text: "where you can see all the Muddas (Topics).",
                    style: size14_M_normal(textColor: black)),
              ])),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => !muddaNewsController.isSupport.value && !AppPreference().getBool(PreferencesKey.isSupport)?  Wrap(
            children: [
              Text.rich(TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "1. ",
                    style: size14_M_normal(textColor: black)),
                TextSpan(
                    text: '“Support”',
                    style: size14_M_bold(textColor: black)),
                TextSpan(
                    text: " or ",
                    style: size14_M_normal(textColor: black)),
                TextSpan(
                    text: '“Not Support”',
                    style: size14_M_bold(textColor: black)),

                TextSpan(
                    text: " them",
                    style:size14_M_normal(textColor: black)),
              ])),
            ],
          ) : const SizedBox()),
          const SizedBox(height: 16),
          Obx(() => !muddaNewsController.isOpenForm.value && !AppPreference().getBool(PreferencesKey.isOpenForm)? Wrap(
            children: [
              Text.rich(TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "2. ",
                    style: size14_M_normal(textColor: black)),
                TextSpan(
                    text: 'Click on any Mudda Card to go to the ',
                    style: size14_M_normal(textColor: black)),
                TextSpan(
                    text: "Mudda Debate Forum",
                    style:  GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w700,
                        color: buttonBlue,
                        decoration: TextDecoration.underline,
                        fontSize:
                        ScreenUtil().setSp(14))),

              ])),
            ],
          ): const SizedBox()),
          const SizedBox(height: 16),
          Obx(() => !muddaNewsController.isPlusIcon.value && !AppPreference().getBool(PreferencesKey.isPlusIcon)?Wrap(
            children: [
              Text.rich(TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "3. ",
                    style: size14_M_normal(textColor: black)),
                TextSpan(
                    text: 'Create your own Mudda. Click  ',
                    style: size14_M_normal(textColor: black)),
                TextSpan(
                    text: "Plus Icon",
                    style:  GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w700,
                        color: yellow,
                        decoration: TextDecoration.underline,
                        fontSize:
                        ScreenUtil().setSp(14))),
                TextSpan(
                    text: ' in the bottom ',
                    style: size14_M_normal(textColor: black)),

              ])),
            ],
          ): const SizedBox()),
        ],
      ),
    ): const SizedBox());
  }
}
