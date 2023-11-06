import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/screens/sign_up_screen/controller/sign_up_controller.dart';

import '../../core/utils/size_config.dart';

class CustomTextFieldWidget extends StatelessWidget {
  CustomTextFieldWidget(
      {Key? key, this.borderColor, this.hintText,this.signUpController,this.keyboardType,this.inputFormatters, this.fillColor, this.maxLine, this.validator, this.controller})
      : super(key: key);

  Color? borderColor;
  Color? fillColor;
  String? hintText;
  int? maxLine;
  FormFieldValidator<String>? validator;
  SignUpController? signUpController;
  TextEditingController? controller;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLine ?? 1,
      onChanged: (text){
        if(signUpController!=null) {
          signUpController!.nameValue.value = text;
        }
      },
      validator: validator,
      controller: controller,
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

class AppTextField extends StatelessWidget {
  final String? hintText;
  final String? suffixText;
  final String? initialValue;
  final String? Function(String?)? validate;
  final String? Function(String?)? onFieldSubmitted;
  final Function(String)? onChange;
  final bool obsecureText;
  final TextInputType keyboardType;
  final int maxLines;
  final TextEditingController? controller;
  final AutovalidateMode? autoValidateMode;
  final int? maxLength;
  final bool readOnly;
  final Widget? suffixIcon;
  final Color borderColor;
  final List<TextInputFormatter>? inputFormatters;
  TextCapitalization textCapitalization;
  TextInputAction textInputAction;

  AppTextField(
      {Key? key,
        this.suffixIcon,
        this.hintText,
        this.suffixText,
        this.readOnly = false,
        this.initialValue,
        this.validate,
        this.onFieldSubmitted,
        this.onChange,
        this.obsecureText = false,
        this.keyboardType = TextInputType.text,
        this.textInputAction = TextInputAction.done,
        this.maxLines = 1,
        this.controller,
        this.autoValidateMode,
        this.maxLength,
        this.inputFormatters,
        this.borderColor = Colors.white,
        this.textCapitalization = TextCapitalization.none})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      maxLength: maxLength,
      autovalidateMode: autoValidateMode,
      controller: controller,
      cursorColor: Colors.black,
      style: size14_M_normal(textColor: color606060),
      initialValue: initialValue,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        counterStyle: const TextStyle(color: Colors.black),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        hintText: hintText,
        suffixText: suffixText,
        filled: true,
        fillColor: const Color(0xFFf7f7f7),
        hintStyle: size14_M_normal(textColor: color606060),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
      ),
      onChanged: onChange,
      validator: validate,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obsecureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}

class TextFiledWithBoxShadow extends StatelessWidget {
  final String title;
  final String icon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? initialValue;

  const TextFiledWithBoxShadow({
    Key? key,
    required this.title,
    required this.icon,
    required this.onChanged,
    required this.onFieldSubmitted,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colorGrey),
        boxShadow: [
          BoxShadow(
            color: colorGrey.withOpacity(.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
          const BoxShadow(
            color: colorAppBackground,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -2),
          )
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              style: size13_M_normal(textColor: color606060),
              cursorHeight: 15,
              initialValue: initialValue,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(bottom: 15, left: 15),
                hintStyle: size13_M_normal(textColor: color606060),
                hintText: title,
                border: InputBorder.none,
              ),
            ),
          ),
          Image.asset(
            icon,
            height: 18,
            width: 18,
          ),
          getSizedBox(w: 10)
        ],
      ),
    );
  }
}

class TextFieldWithoutBoxShadow extends StatelessWidget {
  final String title;
  final String icon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String? initialValue;

  const TextFieldWithoutBoxShadow({
    Key? key,
    required this.title,
    required this.icon,
    required this.onChanged,
    required this.onFieldSubmitted,
    required this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colorGrey),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              style: size13_M_normal(textColor: color606060),
              cursorHeight: 15,
              initialValue: initialValue,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(bottom: 15, left: 15),
                hintStyle: size13_M_normal(textColor: color606060),
                hintText: title,
                border: InputBorder.none,
              ),
            ),
          ),
          Image.asset(
            icon,
            height: 18,
            width: 18,
          ),
          getSizedBox(w: 10)
        ],
      ),
    );
  }
}
