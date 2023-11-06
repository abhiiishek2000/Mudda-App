import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/constant/app_colors.dart';

class CustomCheckBoxWidget extends StatelessWidget {
  CustomCheckBoxWidget(
      {Key? key, required this.isSelected, required this.onTap})
      : super(key: key);

  Function() onTap;
  RxBool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            border: Border.all(color: colorBlack),
            borderRadius: BorderRadius.circular(5)),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isSelected.value ? colorBlack : Colors.transparent),
        ),
      ),
    );
  }
}
