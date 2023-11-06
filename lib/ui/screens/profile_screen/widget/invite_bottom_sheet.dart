import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';

import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';

inviteBottomSheet(BuildContext context, String sId) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (context) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: getHeight(380),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getSizedBox(h: 30),
                  Row(
                    children: [
                      Text(
                        "Invite Existing Mudda Members",
                        style: size14_M_normal(textColor: greyTextColor),
                      ),
                      getSizedBox(w: 20),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.toNamed(RouteConstants.invitedSearchScreen,arguments: sId);
                        },
                        child: Image.asset(
                          AppIcons.searchIcon,
                          height: 26,
                          width: 26,
                        ),
                      )
                    ],
                  ),
                  getSizedBox(h: 5),
                  Text("or", style: size12_M_normal(textColor: colorGrey)),
                  getSizedBox(h: 5),
                  Text(
                    "Share Outside",
                    style: size14_M_normal(textColor: greyTextColor),
                  ),
                  getSizedBox(h: 10),
                  Text(
                    "Heylo, I have created my community / Org on Mudda App and would like to invite you to join my community / Org . Please download the app and click the below link to join me. See you there...",
                    style: size14_M_normal(textColor: greyTextColor),
                  ),
                  getSizedBox(h: 10),
                  Text(
                    "https://www.figma.com/proto/pYLkQgjLHNp1i2lEmIhLXl/Mudda-Redesign?node-id=127%3A196&scaling=scale-down&page-id=0%3A1&starting-point-node-id=97%3A202",
                    style: size14_M_normal(textColor: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  getSizedBox(h: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      5,
                      (index) => Container(
                        height: 40,
                        width: 40,
                        child: Center(child: Text("App")),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: -17,
            left: 40,
            child: Container(
              height: 34,
              width: 34,
              child: Column(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    child: Center(
                        child: Image.asset(AppIcons.inviteIcon,
                            height: 18, width: 18)),
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
      );
    },
  );
}
