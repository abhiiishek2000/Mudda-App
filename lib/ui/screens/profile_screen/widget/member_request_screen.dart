import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';

class MemberRequestScreen extends StatelessWidget {
  const MemberRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                    size: 25,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            getSizedBox(h: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: TextFiledWithBoxShadow(
                title: "Search New Members to Invite",
                icon: AppIcons.searchIcon,
                onFieldSubmitted: (String value) {},
                onChanged: (String value) {}, initialValue: '',
              ),
            ),
            getSizedBox(h: 25),
            Row(
              children: [
                Text(
                  "Join Requests",
                  style: size18_M_bold(textColor: Colors.black),
                )
              ],
            ),
            getSizedBox(h: 25),
            Expanded(
              child: ListView(
                children: List.generate(
                  30,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        AssetImage(AppIcons.dummyImage),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sukhwinder singh Panga",
                                        style: size12_M_bold(
                                            textColor: Colors.black),
                                      ),
                                      getSizedBox(h: 2),
                                      Row(
                                        children: [
                                          Text(
                                            "12.3k Followrs",
                                            style: size12_M_bold(
                                                textColor: colorGrey),
                                          ),
                                          Text(
                                            "Jalandhar,Punjab",
                                            style: size12_M_bold(
                                                textColor: colorGrey),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              getSizedBox(h: 5),
                              Container(
                                height: 1,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        getSizedBox(w: 10),
                        Image.asset(AppIcons.accept, height: 30, width: 30),
                        getSizedBox(w: 10),
                        Image.asset(AppIcons.reject, height: 30, width: 30),
                        getSizedBox(w: 10),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
