import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/screens/profile_screen/view/profile_screen.dart';

class VideoStagesScreen extends StatelessWidget {
  const VideoStagesScreen({Key? key}) : super(key: key);

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
                                          textColor: Colors.green)),
                                  const Icon(
                                    Icons.arrow_upward,
                                    color: Colors.green,
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
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Spacer(),
                        Image.asset(AppIcons.unMuteIcon,
                            height: 20, width: 20, color: Colors.green),
                        getSizedBox(w: 5),
                        Text(
                          "-40 secs",
                          style: size13_M_medium(textColor: Colors.green),
                        ),
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
                        getSizedBox(w: 20),
                        Image.asset(AppIcons.muteIcon, height: 20, width: 20),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 2,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 400,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(AppIcons.dummyImage,
                                    fit: BoxFit.cover, width: 600),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Image.asset(
                                                  AppIcons.dummyImage,
                                                  fit: BoxFit.cover,
                                                  width: 600),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Expanded(
                                              child: Image.asset(
                                                  AppIcons.dummyImage,
                                                  fit: BoxFit.cover,
                                                  width: 600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Image.asset(
                                                  AppIcons.dummyImage,
                                                  fit: BoxFit.cover,
                                                  width: 600),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Expanded(
                                              child: Image.asset(
                                                  AppIcons.dummyImage,
                                                  fit: BoxFit.cover,
                                                  width: 600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 2,
                        height: 400,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          height: 400,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(AppIcons.dummyImage,
                                    fit: BoxFit.cover, width: 600),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Expanded(
                                child: Image.asset(AppIcons.dummyImage,
                                    fit: BoxFit.cover, width: 600),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Expanded(
                                child: Image.asset(AppIcons.dummyImage,
                                    fit: BoxFit.cover, width: 600),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Expanded(
                                child: Image.asset(AppIcons.dummyImage,
                                    fit: BoxFit.cover, width: 600),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Expanded(
                                child: Image.asset(AppIcons.dummyImage,
                                    fit: BoxFit.cover, width: 600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                ],
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
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Row(
                              children: [
                                Text("End Stage"),
                                Icon(
                                  Icons.cancel_outlined,
                                  color: colorGrey,
                                  size: 18,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteConstants.videoStagesFull);
                        },
                        child: Image.asset(
                          AppIcons.expandedMoreIcon,
                          width: 25,
                          height: 25,
                        ),
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
                      GestureDetector(
                        onTap: () {
                          avtarBottomSheet();
                        },
                        child: Row(
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
}

avtarBottomSheet() {
  return showModalBottomSheet(
    context: Get.context as BuildContext,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 250,
        decoration: const BoxDecoration(
          color: colorAppBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Stack(
          children: [
            Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: List.generate(
                          100,
                          (index) => Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(AppIcons.dummyImage),
                                  ),
                                  border: Border.all(color: Colors.blue),
                                ),
                              ),
                              Text(
                                "Mohmadd H",
                                style: size12_M_bold(textColor: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(RouteConstants.leaderBoardWithGridview);
                },
                child: Image.asset(
                  AppIcons.expandedMoreIcon,
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
