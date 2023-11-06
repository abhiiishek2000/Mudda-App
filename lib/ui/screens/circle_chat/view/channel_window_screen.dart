import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/model/PostForMuddaModel.dart';
import 'package:mudda/ui/screens/mudda/view/mudda_details_screen.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';
import '../../mudda/widget/favour_view.dart';

class ChannelWindowScreen extends StatelessWidget {
  const ChannelWindowScreen({Key? key}) : super(key: key);

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
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: AssetImage(AppIcons.dummyImage),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Followers (All)",
                            style: size12_M_bold(textColor: Colors.black),
                          ),
                          Text(
                            "from Jahnavi Sinha",
                            style: size12_M_normal(textColor: Colors.black),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          reportPostDialogBox(context, "");
                        },
                        child: const Icon(Icons.more_vert_outlined))
                  ],
                ),
              ),
            ],
          ),
        ),
        preferredSize: const Size.fromHeight(50),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "at odio. Enim vulputate congue vulputate mi lectus a. Euismod consequat sed faucibus enim. Facilisi commodo, donec proin leo ipsum, nibh amet lacus feugiat. Fringilla bibendum odio auctor elementum aenean. Dignissim faucibus facilisi luctus ultrices. Purus et, in ornare dolor eu nisi. Nibh in pulvinar tincidunt sed eget sed.",
                  style: size12_M_normal(textColor: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: List.generate(
                    10,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: MuddaVideoBox(PostForMudda(), "", index, ""),
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
