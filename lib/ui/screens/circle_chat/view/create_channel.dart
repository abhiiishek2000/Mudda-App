import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/shared/get_started_button.dart';

class CreateChannelScreen extends StatelessWidget {
  const CreateChannelScreen({Key? key}) : super(key: key);

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
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Create Channel",
                    style: size18_M_bold(textColor: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.transparent,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  getSizedBox(h: 30),
                  Container(
                    height: getHeight(80),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue)),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: size14_M_normal(textColor: color606060),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        hintText: "Enter Text for the post",
                        border: InputBorder.none,
                        hintStyle: size10_M_normal(textColor: color606060),
                      ),
                    ),
                  ),
                  getSizedBox(h: 5),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        "max 7 words",
                        style: size12_M_normal(textColor: colorGrey),
                      ),
                    ],
                  ),
                  getSizedBox(h: 15),
                  Container(
                    height: 30,
                    child: Row(
                      children: [
                        Text(
                          "#",
                          style: size12_M_normal(textColor: Colors.black),
                        ),
                        getSizedBox(w: 10),
                        Expanded(
                          child: TextFormField(
                            style: size12_M_normal(textColor: Colors.grey),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "category",
                              hintStyle:
                                  size12_M_normal(textColor: Colors.grey),
                            ),
                          ),
                        ),
                        Text(
                          "(Max 3)",
                          style: size10_M_normal(textColor: Colors.grey),
                        )
                      ],
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  getSizedBox(h: 20),
                  Container(
                    height: getHeight(80),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: size14_M_normal(textColor: color606060),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        hintText: "Enter Text for the post",
                        border: InputBorder.none,
                        hintStyle: size10_M_normal(textColor: color606060),
                      ),
                    ),
                  ),
                  getSizedBox(h: 5),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        "max 25 words",
                        style: size12_M_normal(textColor: colorGrey),
                      ),
                    ],
                  ),
                  getSizedBox(h: 30),
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            child: const Center(
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.black,
                              ),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Selective Recepients",
                            style: size14_M_bold(textColor: Colors.black),
                          )
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Send to All",
                            style: size12_M_normal(textColor: colorGrey),
                          )
                        ],
                      )
                    ],
                  ),
                  getSizedBox(h: 10),
                  Container(
                    height: 2,
                    color: Colors.white,
                  ),
                  getSizedBox(h: 20),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        child: const Center(
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.black,
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "All your Followers",
                        style: size12_M_medium(textColor: Colors.black),
                      )
                    ],
                  ),
                  getSizedBox(h: 20),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Category of Interest",
                        style: size12_M_medium(textColor: Colors.black),
                      )
                    ],
                  ),
                  getSizedBox(h: 20),
                  Container(
                    height: 30,
                    child: Row(
                      children: [
                        Text(
                          "#",
                          style: size12_M_normal(textColor: Colors.black),
                        ),
                        getSizedBox(w: 10),
                        Expanded(
                          child: TextFormField(
                            style: size12_M_normal(textColor: Colors.grey),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "category",
                              hintStyle:
                                  size12_M_normal(textColor: Colors.grey),
                            ),
                          ),
                        ),
                        Text(
                          "(Max 3)",
                          style: size10_M_normal(textColor: Colors.grey),
                        )
                      ],
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  getSizedBox(h: 20),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Demographics",
                        style: size12_M_medium(textColor: Colors.black),
                      )
                    ],
                  ),
                  getSizedBox(h: 10),
                  Container(
                    height: 30,
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 20,
                        ),
                        getSizedBox(w: 10),
                        Expanded(
                          child: TextFormField(
                            style: size12_M_normal(textColor: Colors.grey),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "category",
                              hintStyle:
                                  size12_M_normal(textColor: Colors.grey),
                            ),
                          ),
                        ),
                        Text(
                          "(Max 3)",
                          style: size10_M_normal(textColor: Colors.grey),
                        )
                      ],
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  getSizedBox(h: 20),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Age & Gender",
                        style: size12_M_medium(textColor: Colors.black),
                      )
                    ],
                  ),
                  getSizedBox(h: 20),
                  Row(
                    children: [
                      Text(
                        "Gender:",
                        style: size14_M_normal(textColor: greyTextColor),
                      ),
                      getSizedBox(w: 20),
                      Expanded(
                        child: GetBuilder(
                          builder: (UserProfileUpdateController
                              userProfileEditController) {
                            return Row(
                              children: List.generate(
                                userProfileEditController.genderList.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      userProfileEditController.genderSelected =
                                          index;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: userProfileEditController
                                                          .genderSelected ==
                                                      index
                                                  ? Colors.transparent
                                                  : colorA0A0A0),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: userProfileEditController
                                                      .genderSelected ==
                                                  index
                                              ? colorBlack
                                              : Colors.transparent),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          userProfileEditController
                                              .genderList[index],
                                          style: size12_M_normal(
                                              textColor:
                                                  userProfileEditController
                                                              .genderSelected ==
                                                          index
                                                      ? colorWhite
                                                      : colorA0A0A0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            getSizedBox(h: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    "Age:",
                    style: size14_M_normal(textColor: greyTextColor),
                  ),
                  getSizedBox(w: 20),
                  Expanded(
                    child: GetBuilder(
                      builder: (UserProfileUpdateController
                          userProfileEditController) {
                        return Row(
                          children: List.generate(
                            userProfileEditController.ageList.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: GestureDetector(
                                onTap: () {
                                  userProfileEditController.ageSelected.value = index;
                                },
                                child: Container(
                                  width: getWidth(60),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: userProfileEditController
                                                      .ageSelected ==
                                                  index
                                              ? Colors.transparent
                                              : colorA0A0A0),
                                      borderRadius: BorderRadius.circular(8),
                                      color: userProfileEditController
                                                  .ageSelected ==
                                              index
                                          ? colorBlack
                                          : Colors.transparent),
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      userProfileEditController.ageList[index],
                                      style: size12_M_normal(
                                          textColor: userProfileEditController
                                                      .ageSelected ==
                                                  index
                                              ? colorWhite
                                              : colorA0A0A0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            GetStartedButton(
              title: "Create",
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
