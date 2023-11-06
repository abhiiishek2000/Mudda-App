import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';

class VideoStagesFullScreen extends StatelessWidget {
  const VideoStagesFullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.blue,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                AppIcons.dummyImage,
                                fit: BoxFit.cover,
                                width: 500,
                              ),
                            ),
                            Expanded(
                              child: Image.asset(
                                AppIcons.dummyImage,
                                fit: BoxFit.cover,
                                width: 500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                AppIcons.dummyImage,
                                fit: BoxFit.cover,
                                width: 500,
                              ),
                            ),
                            Expanded(
                              child: Image.asset(
                                AppIcons.dummyImage,
                                fit: BoxFit.cover,
                                width: 500,
                              ),
                            ),
                            Expanded(
                              child: Image.asset(
                                AppIcons.dummyImage,
                                fit: BoxFit.cover,
                                width: 500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppIcons.unMuteIcon,
                          height: 20, width: 20, color: Colors.green),
                      getSizedBox(w: 5),
                      Text(
                        "-40 secs",
                        style: size13_M_medium(textColor: Colors.green),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 50,
                  right: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      height: 35,
                      color: Colors.black54,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Cool down starts in: 00:10 sec",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
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
                  Text(
                    "1.2k",
                    style: size15_M_medium(textColor: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
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
                    style: size15_M_medium(textColor: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 94,
            child: Row(children: [
              Expanded(
                child: Image.asset(
                  AppIcons.dummyImage,
                  fit: BoxFit.cover,
                  width: 500,
                ),
              ),
              Expanded(
                child: Image.asset(
                  AppIcons.dummyImage,
                  fit: BoxFit.cover,
                  width: 500,
                ),
              ),
              Expanded(
                child: Image.asset(
                  AppIcons.dummyImage,
                  fit: BoxFit.cover,
                  width: 500,
                ),
              ),
              Expanded(
                child: Image.asset(
                  AppIcons.dummyImage,
                  fit: BoxFit.cover,
                  width: 500,
                ),
              )
            ]),
          ),
          Container(
            height: 94,
            child: Row(
              children: [
                Expanded(
                  child: Image.asset(
                    AppIcons.dummyImage,
                    fit: BoxFit.cover,
                    width: 500,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Image.asset(
                            AppIcons.expandedLessIcon,
                            height: 25,
                            width: 25,
                            color: Colors.white,
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
                                color: Colors.white,
                                width: 20,
                              ),
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      height: 15,
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                AppIcons.unMuteIcon,
                                height: 20,
                                color: Colors.white,
                                width: 20,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
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
                    color: colorGrey,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
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
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              CircleAvatar(
                radius: 17,
                backgroundColor: colorGrey,
                child: Image.asset(
                  AppIcons.carBonUserSpeaker,
                  height: 18,
                  width: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              CircleAvatar(
                radius: 17,
                backgroundColor: colorGrey,
                child: Image.asset(
                  AppIcons.muteIcon,
                  color: Colors.white,
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
                  color: colorGrey,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                      color: Colors.white,
                    ),
                    const Spacer(),
                    Image.asset(
                      AppIcons.likeHand,
                      height: 20,
                      color: Colors.white,
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
    );
  }
}
