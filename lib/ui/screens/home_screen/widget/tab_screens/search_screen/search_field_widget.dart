import 'package:flutter/material.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/text_style.dart';

class CustomSearchFieldWidget extends StatelessWidget {

  CustomSearchFieldWidget({
    Key? key,
    this.borderColor,
    this.hintText,
    this.fillColor,
    this.maxLine,
    this.onFieldSubmitted,
  }) : super(key: key);

  Color? borderColor;
  Color? fillColor;
  String? hintText;
  ValueChanged<String>? onFieldSubmitted;
  int? maxLine;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      maxLines: maxLine ?? 1,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? colorWhite,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor ?? color0060FF),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor ?? color0060FF),
          ),
          hintText: hintText,
          hintStyle: size14_M_normal(textColor: color606060),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
    );
  }
}
