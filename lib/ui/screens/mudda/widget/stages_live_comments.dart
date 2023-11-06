import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';
import 'package:mudda/core/constant/app_colors.dart';

import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';

class StagesLiveCommentsScreen extends StatelessWidget {
  const StagesLiveCommentsScreen({Key? key}) : super(key: key);

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
                    Text(
                      "from Audiences",
                      style: size14_M_normal(textColor: Colors.amber),
                    ),
                    Row(
                      children: [
                        Text(
                          "Stage",
                          style: size15_M_regular(textColor: Colors.black),
                        ),
                        Image.asset(
                          AppIcons.micIcon,
                          color: Colors.black,
                          height: 14,
                          width: 14,
                        ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppIcons.likeHand,
                          color: Colors.amber,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "123",
                          style: size15_M_medium(textColor: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppIcons.disLikeThumb,
                          color: Colors.amber,
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "123",
                          style: size15_M_medium(textColor: Colors.black),
                        ),
                      ],
                    ),
                  ],
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

class MessageBox extends StatelessWidget {
  final bool isSend;
  const MessageBox({
    Key? key,
    required this.isSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isSend
            ? CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(AppIcons.dummyImage),
              )
            : Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(descriptionText2),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text("23.45",
                                style: size14_M_normal(textColor: colorGrey)),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        const SizedBox(
          width: 10,
        ),
        isSend
            ? Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(descriptionText2),
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Text("23.45",
                                style: size14_M_normal(textColor: colorGrey)),
                            const SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(AppIcons.dummyImage),
              ),
      ],
    );
  }
}
