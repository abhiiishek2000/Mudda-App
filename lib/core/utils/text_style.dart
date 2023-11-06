import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant/app_colors.dart';

TextStyle size26_M_medium({
  Color? textColor,
  double? letterSpacing = 0.0,
}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 26.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500);

TextStyle size26_M_normal({
  Color? textColor,
  double? letterSpacing = 0.0,
}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 26.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w700);

TextStyle size16_M_medium({
  Color? textColor,
  double? letterSpacing = 0.0,
}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 16.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500);

TextStyle size16_M_semibold({
  Color? textColor,
  double? letterSpacing = 0.0,
}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 16.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size14_M_normal(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 14.sp,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: FontWeight.w400);
TextStyle size13_M_normal(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 13.sp,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: FontWeight.w400);

TextStyle size14_M_semiBold(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 14.sp,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: FontWeight.w600);

TextStyle size16_M_bold({Color? textColor, double? letterSpacing}) =>
    GoogleFonts.nunitoSans(
      color: textColor ?? colorWhite,
      fontSize: 16.sp,
      letterSpacing: letterSpacing ?? 0.0,
      fontWeight: FontWeight.w700,
    );

TextStyle size14_M_light({Color? textColor, double? letterSpacing = 0.0}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 14.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w300);

TextStyle size14_M_semibold(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 14.sp,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size13_M_regular(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: FontWeight.w400,
        fontSize: 13.sp);

TextStyle size13_M_ExtraBold({Color? textColor, double? letterSpacing = 0.0}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 13.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w800);

TextStyle size12_M_regular(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 12.sp,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w400);

TextStyle size12_M_semibold(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 12.sp,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size12_M_bold(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700);

TextStyle size24_M_medium({Color? textColor, double? letterSpacing = 0.0}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 24.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500);

TextStyle size24_M_semibold({Color? textColor, double? letterSpacing = 0.0}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 24.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size24_M_regular({Color? textColor, double? letterSpacing = 0.0}) =>
    GoogleFonts.nunitoSans(
      color: textColor ?? colorWhite,
      fontSize: 24.sp,
      letterSpacing: letterSpacing,
      fontWeight: FontWeight.w400,
    );

TextStyle size24_M_bold({Color? textColor, double? letterSpacing}) =>
    GoogleFonts.nunitoSans(
      color: textColor ?? colorWhite,
      fontSize: 24.sp,
      letterSpacing: letterSpacing ?? 0.0,
      fontWeight: FontWeight.w700,
    );

TextStyle size12_M_extraBold(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 12.sp,
        fontWeight: FontWeight.w800);

TextStyle size15_M_extraBold(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 15.sp,
        fontWeight: FontWeight.w800);

TextStyle size12_M_normal(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400);

TextStyle size14_M_bold({Color? textColor, double? letterSpacing = 0.0}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 14.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w700);

TextStyle size14_M_extraBold({Color? textColor, double? letterSpacing = 0.0}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 14.sp,
        fontWeight: FontWeight.w800);

TextStyle size11_M_medium({Color? textColor, double? letterSpacing = 0.0}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 11.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500);

TextStyle size10_M_semibold({Color? textColor, double? letterSpacing = 0.0}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 10.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w700);

TextStyle size10_M_medium({Color? textColor, double? letterSpacing = 0.0}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        fontSize: 10.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500);

TextStyle size12_M_medium(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    GoogleFonts.nunitoSans(
        color: textColor ?? colorWhite,
        height: height,
        fontSize: 12.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500);

TextStyle size11_M_regular(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 11.sp,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w400);

TextStyle size11_M_semibold(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 11.sp,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size11_M_bold({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 11.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w700);

TextStyle size09_M_bold({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 11.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w700);

TextStyle size10_M_regular300(
        {Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 10.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w300);

TextStyle size12_M_regular300(
        {Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 12.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w300);

TextStyle size14_M_medium({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 14.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500);

TextStyle size10_M_normal({Color? textColor, double? letterSpacing}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 10.sp,
        letterSpacing: letterSpacing ?? 0.0,
        fontWeight: FontWeight.w400);

TextStyle size18_M_medium({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 18.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500);

TextStyle size18_M_semiBold({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 18.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w700);

TextStyle size09_M_semibold({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 9.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size13_M_bold({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 13.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w700);

TextStyle size15_M_semibold({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 15.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size15_M_medium({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 15.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500);

TextStyle size13_M_light({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 13.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w400);

TextStyle size19_M_semibold({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 19.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size13_M_medium(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: FontWeight.w500,
        fontSize: 13.sp);

TextStyle size18_M_normal({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 18.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w400);

TextStyle size08_M_semibold(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 8.sp,
        height: height,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);
TextStyle size08_M_regular({
  Color? textColor,
  double? letterSpacing = 0.0,
}) =>
    TextStyle(
      color: textColor ?? colorWhite,
      fontSize: 08.sp,
      letterSpacing: letterSpacing,
    );

TextStyle size17_M_regular({
  Color? textColor,
  double? letterSpacing = 0.0,
}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 17.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w400);

TextStyle size17_M_semibold({
  Color? textColor,
  double? letterSpacing = 0.0,
}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 17.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size16_M_normal({
  Color? textColor,
  double? letterSpacing = 0.0,
}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 16.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w400);

TextStyle size16_M_extraBold({
  Color? textColor,
}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 16.sp,
        fontWeight: FontWeight.w800);

TextStyle size15_M_regular({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 15.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w400);

TextStyle size15_M_bold({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 15.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w700);
TextStyle size18_M_bold({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 18.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w700);

TextStyle size25_M_semibold({
  Color? textColor,
  double? letterSpacing = 0.0,
}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 25.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size20_M_normal({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 20.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w400);

TextStyle size20_M_semibold({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 20.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size45_M_semibold({
  Color? textColor,
  double? letterSpacing = 0.0,
}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 45.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w600);

TextStyle size22_M_medium(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: FontWeight.w500,
        fontSize: 22.sp);

TextStyle size22_M_semibold(
        {Color? textColor, double? letterSpacing = 0.0, double? height}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: FontWeight.w600,
        fontSize: 22.sp);

TextStyle size20_M_medium({Color? textColor, double? letterSpacing = 0.0}) =>
    TextStyle(
        color: textColor ?? colorWhite,
        fontSize: 20.sp,
        letterSpacing: letterSpacing,
        fontWeight: FontWeight.w500);
