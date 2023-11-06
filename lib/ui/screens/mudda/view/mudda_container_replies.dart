

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/mudda/view/see_all_replies.dart';

import '../../../../core/utils/text_style.dart';
import '../widget/mudda_post_comment.dart';

class MuddaContainerReplies extends StatefulWidget {
  const MuddaContainerReplies({Key? key}) : super(key: key);

  @override
  State<MuddaContainerReplies> createState() => _MuddaContainerRepliesState();
}

class _MuddaContainerRepliesState extends State<MuddaContainerReplies> {
  MuddaNewsController muddaNewsController= Get.put(MuddaNewsController());


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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TabBar(
                      indicatorColor: Colors.transparent,
                      labelColor: Colors.black,
                      labelStyle: size16_M_bold(textColor: Colors.black),
                      unselectedLabelStyle:
                      size14_M_normal(textColor: Colors.grey),
                      labelPadding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      tabs:  [
                        Tab(
                          text: "Replies (${NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol:
                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                          ).format(muddaNewsController.postForMudda.value.replies)})",
                        ),
                        Tab(
                          text: "Comments (${NumberFormat.compactCurrency(
                        decimalDigits: 0,
                        symbol:
                        '', // if you want to add currency symbol then pass that in this else leave it empty.
                        ).format(muddaNewsController.postForMudda.value.commentorsCount)})",
                        )
                      ],
                      controller: muddaNewsController.muddaRepliesController),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
          children: [
            SeeAllRepliesScreen(),
            MuddaPostCommentsScreen(),
          ], controller: muddaNewsController.muddaRepliesController),
    );
  }
}
