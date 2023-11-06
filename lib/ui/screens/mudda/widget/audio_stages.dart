import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';

import '../../profile_screen/view/profile_screen.dart';

class AudioStagesScreen extends StatelessWidget {
  const AudioStagesScreen({Key? key}) : super(key: key);

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "82.31%",
                                style: size13_M_bold(textColor: Colors.black),
                              ),
                              Row(
                                children: [
                                  Text("1.2% ",
                                      style: size12_M_bold(
                                          textColor: colorFF2121)),
                                  const Icon(
                                    Icons.arrow_downward,
                                    color: colorFF2121,
                                    size: 15,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "1,02,03,122",
                                    style: size13_M_bold(
                                        textColor: Colors.blueAccent),
                                  ),
                                  Image.asset(
                                    AppIcons.shakeHandIcon,
                                    height: 20,
                                    width: 20,
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              getSizedBox(h: 8),
              Container(
                height: 1.5,
                color: Colors.white,
              ),
              getSizedBox(h: 8),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Spacer(),
                        Image.asset(AppIcons.muteIcon, height: 20, width: 20),
                        getSizedBox(w: 25),
                        Container(
                          height: 32,
                          width: 32,
                          child: Center(
                            child: Image.asset(AppIcons.shakeHandIcon,
                                color: Colors.white, height: 18, width: 18),
                          ),
                          decoration: const BoxDecoration(
                            color: colorGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        getSizedBox(w: 25)
                      ],
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 33,
                    color: Colors.red,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        getSizedBox(w: 25),
                        Container(
                          height: 32,
                          width: 32,
                          child: Center(
                            child: Image.asset(AppIcons.disLikeThumb,
                                color: Colors.grey, height: 18, width: 18),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: colorGrey,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        getSizedBox(w: 25),
                        Image.asset(AppIcons.unMuteIcon,
                            height: 20, width: 20, color: Colors.green),
                        getSizedBox(w: 5),
                        Text(
                          "-40 secs",
                          style: size13_M_medium(textColor: Colors.green),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        preferredSize: const Size.fromHeight(120),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: audioMembers(6),
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 280,
                          color: Colors.red,
                        ),
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: audioMembers(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: audioMembers(40),
                          ),
                        ),
                        Container(
                          width: 2,
                          color: Colors.transparent,
                        ),
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: audioMembers(40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 170,
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Text("End Stage"),
                          Icon(
                            Icons.cancel_outlined,
                            color: colorGrey,
                            size: 18,
                          )
                        ],
                      ),
                      Spacer(),
                      Container(
                        width: 150,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppIcons.volumeMuteIcon,
                              height: 20,
                              width: 20,
                            ),
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  Container(
                                    height: 15,
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              AppIcons.unMuteIcon,
                              height: 20,
                              color: Colors.black,
                              width: 20,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                whiteDivider(),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            AppIcons.fireBlueIcon,
                            height: 20,
                            width: 20,
                          ),
                          Text(
                            "1.2k",
                            style:
                            size15_M_medium(textColor: Colors.blueAccent),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            AppIcons.likeHand,
                            color: Colors.amber,
                            height: 20,
                            width: 20,
                          ),
                          Text(
                            "1.2k",
                            style: size15_M_medium(textColor: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            AppIcons.disLikeThumb,
                            color: Colors.amber,
                            height: 20,
                            width: 20,
                          ),
                          Text(
                            "1.2k",
                            style: size15_M_medium(textColor: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "1.2k",
                            style:
                            size15_M_medium(textColor: Colors.blueAccent),
                          ),
                          getSizedBox(w: 10),
                          Image.asset(
                            AppIcons.eyeIcon,
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                whiteDivider(),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteConstants.stageLiveCommentsScreen);
                      },
                      child: Container(
                        width: 45,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorAppBackground,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(2, 2),
                                blurRadius: 2,
                                color: Colors.grey)
                          ],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 9,
                            ),
                            Image.asset(
                              AppIcons.msgIcon,
                              height: 25,
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        AppIcons.carBonUserSpeaker,
                        height: 18,
                        width: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        AppIcons.muteIcon,
                        color: Colors.black,
                        height: 18,
                        width: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorAppBackground,
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 2,
                              color: Colors.grey)
                        ],
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            AppIcons.dislike,
                            height: 20,
                            width: 20,
                          ),
                          const Spacer(),
                          Image.asset(
                            AppIcons.likeHand,
                            color: colorGrey,
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  audioMembers(int index) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      children: List.generate(
        index,
            (index) => Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: () {
                    otherUserProfileBottomSheet();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    child: index == 3
                        ? Center(
                      child: Text(
                        "A",
                        style: size18_M_bold(textColor: colorGrey),
                      ),
                    )
                        : Container(),
                    decoration: index == 3
                        ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    )
                        : BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(AppIcons.dummyImage)),
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ),
                index == 1
                    ? CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: Image.asset(AppIcons.unMuteIcon,
                      height: 10, width: 10),
                )
                    : const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.transparent,
                )
              ],
            ),
            getSizedBox(h: 8),
            Text(
              "Mohmadd H",
              style: size12_M_bold(textColor: Colors.black),
            )
          ],
        ),
      ),
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

otherUserProfileBottomSheet() {
  return showModalBottomSheet(
    context: Get.context as BuildContext,
    builder: (BuildContext context) {
      return const OtherUserProfileBottomDetails();
    },
  );
}

class OtherUserProfileBottomDetails extends StatefulWidget {
  const OtherUserProfileBottomDetails({Key? key}) : super(key: key);

  @override
  State<OtherUserProfileBottomDetails> createState() =>
      _OtherUserProfileBottomDetailsState();
}

class _OtherUserProfileBottomDetailsState
    extends State<OtherUserProfileBottomDetails> {
  bool boolSendDown = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      color: colorAppBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                Spacer(),
                Text("Report User"),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.toNamed(RouteConstants.otherUserProfileScreen);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(AppIcons.dummyImage)),
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Column(
                  children: [
                    Image.asset(
                      AppIcons.muteIcon,
                      height: 20,
                      width: 20,
                      color: Colors.black,
                    ),
                    Text("Mute",
                        style: size10_M_normal(textColor: Colors.black)),
                  ],
                ),
                const SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  onTap: () {
                    if (boolSendDown) {
                      boolSendDown = false;
                    } else {
                      boolSendDown = true;
                    }
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      boolSendDown
                          ? Image.asset(
                        AppIcons.sendDown,
                        height: 20,
                        width: 20,
                        color: Colors.black,
                      )
                          : Image.asset(
                        AppIcons.carBonUserSpeaker,
                        height: 20,
                        width: 20,
                        color: Colors.black,
                      ),
                      Text("Invite up",
                          style: size10_M_normal(textColor: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  "Mohmadd Hussain",
                  style:
                  size12_M_bold(textColor: Colors.black, letterSpacing: .2),
                ),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Follow",
                  style: size12_M_medium(
                      textColor: Colors.black, letterSpacing: .2),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Row(
                  children: [
                    Text(
                      "12.2k",
                      style: size12_M_medium(
                          textColor: Colors.black, letterSpacing: .2),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      AppIcons.followersIcon2,
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Leading: 3 mudda",
                      style: size12_M_medium(
                          textColor: Colors.black, letterSpacing: .2),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Image.asset(
                      AppIcons.rightSizeArrow,
                      color: Colors.black,
                      height: 16,
                      width: 16,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(descriptionText)
          ],
        ),
      ),
    );
  }
}