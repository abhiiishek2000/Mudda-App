import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/screens/mudda/widget/stages_live_comments.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';

class StagesLiveCommentsLeaders extends StatelessWidget {
  const StagesLiveCommentsLeaders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      width: 10,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: Container(
                        height: 52,
                        width: 52,
                        child: Image.asset(AppIcons.dummyImage),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BYCOTT CHINA SAVE THE WORLD, TO SAVE US TOO. IT’S JUST TESTING",
                            style: size13_M_bold(textColor: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          reportPostDialogBox(context,"");
                        },
                        child: const Icon(Icons.more_vert_outlined))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 120, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 2,
                    ),
                    Row(
                      children: [
                        Text(
                          "Stage",
                          style: size15_M_regular(textColor: Colors.black),
                        ),
                        Icon(
                          Icons.live_tv,
                          size: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              getSizedBox(h: 4),
              Container(
                height: 1.5,
                color: Colors.white,
              ),
            ],
          ),
        ),
        preferredSize: const Size.fromHeight(100),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const MessageBox(
                  isSend: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                const MessageBox(
                  isSend: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: List.generate(
                    20,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: MessageBox(isSend: index % 2 == 0 ? true : false),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 30,
            right: 30,
            bottom: 30,
            child: Row(
              children: [
                Expanded(
                  child: TextFiledWithBoxShadow(
                    title: "Type your Message",
                    icon: AppIcons.galleryIcon,
                    onFieldSubmitted: (String value) {},
                    onChanged: (String value) {}, initialValue: '',
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Image.asset(
                  AppIcons.rightSizeArrow,
                  color: colorGrey,
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
