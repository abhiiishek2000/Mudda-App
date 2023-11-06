import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/shared/get_started_button.dart';

class VerifyYourProfileScreen extends StatelessWidget {
  const VerifyYourProfileScreen({Key? key}) : super(key: key);

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
                  child: Row(
                    children: [
                      Text(
                        "Verify",
                        style: size18_M_medium(textColor: Colors.black),
                      ),
                      Text(
                        " your Profile",
                        style: size18_M_medium(textColor: Colors.grey),
                      ),
                    ],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                "To verify your profile, please take a selfie Video using FameLinks Camera and submit it for verification.",
                style: size14_M_normal(textColor: Colors.black),
              ),
              Text(
                "Please show your Front Face, Right Profile & Left Profile.",
                style: size14_M_bold(textColor: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CircleAvatar(
                backgroundColor: Colors.red,
                radius: 30,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Start Recording",
                style: size14_M_bold(textColor: Colors.red),
              ),
              const SizedBox(
                height: 20,
              ),
              GetStartedButton(
                onTap: () {
                  Get.back();
                },
                title: "Submit",
              )
            ],
          ),
        ),
      ),
    );
  }
}
