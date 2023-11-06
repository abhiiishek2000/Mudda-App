import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/text_style.dart';

import 'package:mudda/ui/screens/muddabuzz_screen/controller/mudda_buzz_controller.dart';

class SuggestionFollow extends StatefulWidget {
  const SuggestionFollow({Key? key}) : super(key: key);

  @override
  _SuggestionFollowState createState() => _SuggestionFollowState();
}

class _SuggestionFollowState extends State<SuggestionFollow> {
  MuddaBuzzController muddaBuzzController = Get.put(MuddaBuzzController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      body: ListView.builder(
        itemCount: muddaBuzzController.followList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://4bgowik9viu406fbr2hsu10z-wpengine.netdna-ssl.com/wp-content/uploads/2020/03/Portrait_5-1.jpg"),
              ),
              title: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "Ranveer Singh",
                        style: size14_M_normal(textColor: colorDarkBlack),
                      ),
                      Text(
                        "Mumbai, India     ",
                        style: size12_M_regular300(textColor: colorA0A0A0),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Obx(
                () => GestureDetector(
                  onTap: () {
                    muddaBuzzController.followList[index] == false
                        ? muddaBuzzController.followList[index] = true
                        : muddaBuzzController.followList[index] = false;
                  },
                  child: Container(
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                      color: muddaBuzzController.followList[index] == true
                          ? color606060
                          : colorAppBackground,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: colorA0A0A0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Follow",
                      style: size12_M_regular300(
                          textColor:
                              muddaBuzzController.followList[index] == true
                                  ? Colors.white
                                  : color606060),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
