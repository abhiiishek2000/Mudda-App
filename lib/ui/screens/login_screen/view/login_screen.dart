import 'dart:developer';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/ui/screens/login_screen/controller/login_screen_controller.dart';
import 'package:mudda/ui/shared/keychain.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../dio/api/api.dart';
import '../../../shared/WebViewScreen.dart';
import '../../home_screen/controller/mudda_fire_news_controller.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with CodeAutoFill {
  PageController controller = PageController();

  final LoginScreenController _loginScreenController =
      Get.put(LoginScreenController());
  final MuddaNewsController muddaNewsController =
      Get.put(MuddaNewsController());
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);
  TextEditingController mobileNumber = TextEditingController();
  final ScrollController _controller = ScrollController();
  TextEditingController otpNumber = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  bool isOTPFieldOn = false;
  bool flag = false;
  int isNew = 1;
  int selectedIndex = 0;

  // OTP count
  int isResendOtp = 0;
  String codeValue = "";

  // Telephony telephony = Telephony.instance;
  OtpFieldController otpbox = OtpFieldController();

  @override
  void codeUpdated() {
    print("Update code $code");
    setState(() {
      print("codeUpdated");
    });
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   listenOtp();
  // }

  @override
  void initState() {
    // telephony.listenIncomingSms(
    //   onNewMessage: (SmsMessage message) {
    //     // print(message.address); //+977981******67, sender nubmer
    //     // print(message.body); //Your OTP code is 34567
    //     // print(message.date); //1659690242000, timestamp
    //
    //     String sms = message.body.toString(); //get the message
    //
    //     // if (message.address == "VM-MuddaA") {
    //     //verify SMS is sent for OTP with sender number
    //     // String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'), '');
    //     // //prase code from the OTP sms
    //     // otpbox.set(otpcode.split(""));
    //     //split otp code to list of number
    //
    //     // print(
    //     //     "only otp code is here ${sms.replaceAll(new RegExp(r'[^0-9]'), '').toString()}");
    //
    //     otpNumber.text = sms.replaceAll(RegExp(r'[^0-9]'), '').toString();
    //     //and populate to otb boxes
    //
    //     setState(() {
    //       //refresh UI
    //     });
    //     // } else {
    //     //   print("Normal message.");
    //     // }
    //   },
    //   listenInBackground: false,
    // );
    super.initState();
  }

  void listenOtp() async {
    await SmsAutoFill().unregisterListener();
    listenForCode();
    var response = await SmsAutoFill().listenForCode;
    print("OTP listen Called  ${response.toString()} ");
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("unregisterListener");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    flag = Get.arguments;
    //otpNumber.text = otpbox.toString();
    return Scaffold(
      backgroundColor: colorAppBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: ScreenUtil().screenHeight - ScreenUtil().setSp(720) <
                          0
                      ? (ScreenUtil().screenHeight - ScreenUtil().setSp(623))
                      : ScreenUtil().screenHeight - ScreenUtil().setSp(623),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppIcons.appLogo,
                      height: 130.w,
                      width: 130.w,
                    ),
                  ],
                ),
                Vs(height: ScreenUtil().setSp(32)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: colorWhite,
                          border: Border.all(color: colorBlack),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        child: Text(
                          welcomeTo,
                          style: size18_M_normal(textColor: colorBlack),
                        )),
                    Container(
                        decoration: const BoxDecoration(color: colorBlack),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 5),
                        child: Text(
                          mudda,
                          style: size18_M_normal(),
                        ))
                  ],
                ),

                // Stack(
                //   alignment: Alignment.bottomCenter,
                //   children: [
                //     SizedBox(
                //       height: ScreenUtil().setSp(197),
                //       child: PageView.builder(
                //           itemCount: 4,
                //           scrollDirection: Axis.horizontal,
                //           controller: controller,
                //           onPageChanged: (value) {
                //             selectedIndex = value;
                //             setState(() {});
                //           },
                //           itemBuilder: (context, index) {
                //             return Container(
                //                 margin: EdgeInsets.symmetric(horizontal: 10.h),
                //                 height: 100.h,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(10),
                //                     color: colorWhite),
                //                 child: Column(
                //                   children: [
                //                     Padding(
                //                       padding: const EdgeInsets.only(
                //                           top: 17, left: 13, right: 33),
                //                       child: Row(
                //                         children: [
                //                           Text(
                //                             selectedIndex == 0
                //                                 ? theWorldIsStillImperfect
                //                                 : selectedIndex == 1
                //                                     ? leadership
                //                                     : "",
                //                             style: selectedIndex == 1
                //                                 ? size14_M_normal(
                //                                     textColor: color606060)
                //                                 : size10_M_normal(
                //                                     textColor: color606060),
                //                           ),
                //                           const Spacer(),
                //                           Text(
                //                             selectedIndex == 0
                //                                 ? initiateMudda
                //                                 : selectedIndex == 1
                //                                     ? gatherSupport
                //                                     : selectedIndex == 2
                //                                         ? goToStages
                //                                         : changeWorld,
                //                             style: size18_M_normal(
                //                                 textColor: color606060),
                //                           )
                //                         ],
                //                       ),
                //                     ),
                //                     Row(
                //                       children: [
                //                         Column(
                //                           children: [
                //                             Padding(
                //                               padding: EdgeInsets.symmetric(
                //                                   vertical: 21.h,
                //                                   horizontal: 18.w),
                //                               child: SvgPicture.asset(
                //                                 "${AppIcons.loginScreenSliderImage}$selectedIndex.svg",
                //                                 height: 100,
                //                               ),
                //                             )
                //                           ],
                //                         ),
                //                         Expanded(
                //                           child: Padding(
                //                             padding:
                //                                 EdgeInsets.only(right: 8.w),
                //                             child: Column(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.start,
                //                               crossAxisAlignment:
                //                                   CrossAxisAlignment.end,
                //                               children: [
                //                                 Text(
                //                                   selectedIndex == 0
                //                                       ? wantToChangeDisc
                //                                       : selectedIndex == 1
                //                                           ? notAlone
                //                                           : selectedIndex == 2
                //                                               ? getYourMudda
                //                                               : youHaveBrought,
                //                                   textAlign: TextAlign.center,
                //                                   style: size14_M_normal(
                //                                       textColor: color606060),
                //                                 )
                //                               ],
                //                             ),
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ],
                //                 ));
                //           }),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: buildPageIndicator(selectedIndex),
                //       ),
                //     ),
                //   ],
                // ),
                Vs(height: ScreenUtil().setSp(80)),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: !_loginScreenController.isOTPOn.value,
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setSp(40),
                                  vertical: ScreenUtil().setSp(10)),
                              decoration: BoxDecoration(
                                  color: colorWhite,
                                  border: Border.all(color: color0060FF),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showCountryPicker(
                                          context: context,
                                          showPhoneCode: true,
                                          // optional. Shows phone code before the country name.
                                          onSelect: (Country country) {
                                            Get.find<LoginScreenController>()
                                                .diaCode = country.phoneCode;
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.flag_rounded,
                                            color: color606060,
                                          ),
                                          //Image.asset(googleIcon),
                                          Hs(width: 6.h),
                                          GetBuilder(
                                            builder: (LoginScreenController
                                                controller) {
                                              return Text(
                                                  "+${controller.diaCode}");
                                            },
                                          ),
                                          Hs(width: 12.h),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 2.w,
                                      height: 20.h,
                                      color: colorA0A0A0,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 20.h,
                                        child: TextFormField(
                                          controller: mobileNumber,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                10),
                                          ],
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: colorWhite,
                                              border: InputBorder.none,
                                              hintText: enterPhoneNumber,
                                              hintStyle: size14_M_normal(
                                                  textColor: color606060),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 9)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  AppPreference _appPreference =
                                      AppPreference();
                                  if (_appPreference
                                          .getString(PreferencesKey.dateTime) ==
                                      "") {
                                    log('-------- date --------');
                                    log("Abhishek -=-=- ${_appPreference.getString(PreferencesKey.userToken)}");
                                    _appPreference.setString(
                                      PreferencesKey.dateTime,
                                      DateTime.now().toString(),
                                    );
                                  }

                                  var currentTime = DateTime.now();
                                  var startTime = DateTime.parse(
                                      _appPreference.getString(PreferencesKey
                                          .dateTime)); // TODO: change this to your DateTime from firebase

                                  var diff = currentTime
                                      .difference(startTime)
                                      .inMinutes;

                                  print('abc--- $diff');

                                  if (diff <= 10) {
                                    if (isResendOtp < 3) {
                                      if (mobileNumber.text.isNotEmpty) {
                                        Api.post.call(
                                          context,
                                          method: "user/get-otp",
                                          param: {
                                            "country_code": Get.find<
                                                    LoginScreenController>()
                                                .diaCode,
                                            "mobile": mobileNumber.text,
                                            "is_new": isNew.toString(),
                                            "OTPState": 'GetOTP',
                                          },
                                          onResponseSuccess: (object) {
                                            print("Abhishek $object");
                                            setState(() {
                                              _loginScreenController
                                                  .isOTPOn.value = true;
                                              _loginScreenController
                                                  .second.value = 30;
                                              isOTPFieldOn = true;
                                              //       otp = int.parse(
                                              //     object['data']['otp'].toString());
                                              // otpNumber.text = otp.toString();
                                              isNew = int.parse(object['data']
                                                      ['is_new']
                                                  .toString());

                                              _loginScreenController.onInit();
                                              isResendOtp++;
                                            });
                                          },
                                        );
                                      }
                                    } else {
                                      Get.snackbar(
                                        "Warning",
                                        "You have exceeded the OTP limit. Please try again after 10 minutes",
                                      );
                                    }
                                  } else {
                                    _appPreference.setString(
                                      PreferencesKey.dateTime,
                                      DateTime.now().toString(),
                                    );
                                  }

                                  /*Get.toNamed(RouteConstants.signupScreen);*/
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: ScreenUtil().setSp(60),
                                  width: ScreenUtil().setSp(60),
                                  padding: const EdgeInsets.all(2),
                                  margin: EdgeInsets.only(
                                      right: ScreenUtil().setSp(35)),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorWhite),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorWhite,
                                        border: Border.all(color: color606060)),
                                    child: Icon(
                                      Icons.chevron_right_rounded,
                                      size: 50.sp,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _loginScreenController.isOTPOn.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 45.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                  color: colorWhite,
                                  border: Border.all(color: color0060FF),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 20.h,
                                        child: TextFormField(
                                          controller: otpNumber,
                                          autofocus: true,
                                          scrollPadding: EdgeInsets.only(
                                              bottom:
                                                  ScreenUtil().setHeight(120)),
                                          keyboardType: TextInputType.number,
                                          obscureText: _loginScreenController
                                              .isPasswordVisible.value,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: colorWhite,
                                              border: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.vpn_key_outlined,
                                                color: colorGrey,
                                                size: 20.h,
                                              ),
                                              suffixIcon: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(
                                                  _loginScreenController
                                                          .isPasswordVisible
                                                          .value
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                  color: colorGrey,
                                                ),
                                                onPressed: () {
                                                  _loginScreenController
                                                          .isPasswordVisible
                                                          .value =
                                                      !_loginScreenController
                                                          .isPasswordVisible
                                                          .value;
                                                },
                                              ),
                                              hintText: enterOTPNumber,
                                              hintStyle: size14_M_normal(
                                                  textColor: color606060),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 9)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 45.w),
                                child: _loginScreenController.second.value == 0
                                    ? TextButton(
                                        onPressed: () {
                                          log("-=-=-=-=- Resend OTP -=-=-=-=-");
                                          AppPreference _appPreference =
                                              AppPreference();
                                          if (_appPreference.getString(
                                                  PreferencesKey.dateTime) ==
                                              "") {
                                            log('-------- date --------');
                                            _appPreference.setString(
                                              PreferencesKey.dateTime,
                                              DateTime.now().toString(),
                                            );
                                          }

                                          var currentTime = DateTime.now();
                                          var startTime = DateTime.parse(
                                              _appPreference.getString(
                                                  PreferencesKey
                                                      .dateTime)); // TODO: change this to your DateTime from firebase

                                          var diff = currentTime
                                              .difference(startTime)
                                              .inMinutes;

                                          print('abc--- $diff');

                                          if (diff <= 10) {
                                            if (isResendOtp < 3) {
                                              if (mobileNumber
                                                  .text.isNotEmpty) {
                                                Api.post.call(
                                                  context,
                                                  method: "user/get-otp",
                                                  param: {
                                                    "country_code": Get.find<
                                                            LoginScreenController>()
                                                        .diaCode,
                                                    "mobile": mobileNumber.text,
                                                    "OTPState": 'ResendOTP',
                                                    "is_new": isNew.toString(),
                                                  },
                                                  onResponseSuccess: (object) {
                                                    print("Abhishek $object");
                                                    setState(() {
                                                      _loginScreenController
                                                          .isOTPOn.value = true;
                                                      _loginScreenController
                                                          .second.value = 30;
                                                      isOTPFieldOn = true;
                                                      //       otp = int.parse(
                                                      //     object['data']['otp'].toString());
                                                      // otpNumber.text = otp.toString();
                                                      isNew = int.parse(
                                                          object['data']
                                                                  ['is_new']
                                                              .toString());
                                                      _loginScreenController
                                                          .onInit();
                                                      isResendOtp++;
                                                    });
                                                  },
                                                );
                                              }
                                            } else {
                                              Get.snackbar(
                                                "Warning",
                                                "You have exceeded the OTP limit. Please try again after 10 minutes",
                                              );
                                            }
                                          } else {
                                            _appPreference.setString(
                                              PreferencesKey.dateTime,
                                              DateTime.now().toString(),
                                            );
                                          }
                                          /*else {
                                            Get.snackbar(
                                              "Warning",
                                              "You have exceeded the OTP limit. Please try again after 10 minutes",
                                            );
                                          }*/

                                          /*if (isResendOtp < 3) {
                                            log("-=-=- isResendOtp -=-= $isResendOtp");
                                            if (mobileNumber.text.isNotEmpty) {
                                              Api.post.call(
                                                context,
                                                method: "user/get-otp",
                                                param: {
                                                  "country_code": Get.find<
                                                          LoginScreenController>()
                                                      .diaCode,
                                                  "mobile": mobileNumber.text,
                                                  "is_new": isNew.toString(),
                                                },
                                                onResponseSuccess: (object) {
                                                  print("Abhishek $object");
                                                  setState(() {
                                                    _loginScreenController
                                                        .isOTPOn.value = true;
                                                    _loginScreenController
                                                        .second.value = 30;
                                                    isOTPFieldOn = true;
                                                    // otp = int.parse(
                                           // object['data']['otp'].toString());
                                       // otpNumber.text = otp.toString();
                                                    isNew = int.parse(
                                                        object['data']['is_new']
                                                            .toString());
                                                    _loginScreenController
                                                        .onInit();
                                                    isResendOtp++;
                                                  });
                                                },
                                              );
                                            }
                                          } else {
                                            Get.snackbar("Warning",
                                                "OTP send limit only 3 times");
                                          }*/
                                        },
                                        child: Text(
                                          resendOTP,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ))
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            resendOTPIn,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            zeroZero +
                                                _loginScreenController.second
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: color0060FF,
                                            ),
                                          ),
                                        ],
                                      )),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                if (otpNumber.text.isNotEmpty) {
                                  Api.post.call(
                                    context,
                                    method: "user/verify-otp",
                                    param: {
                                      "country_code":
                                          Get.find<LoginScreenController>()
                                              .diaCode,
                                      "mobile": mobileNumber.text,
                                      "is_new": isNew.toString(),
                                      "otp": otpNumber.text,
                                      "OTPState": 'VerifiedOTP',
                                      'firebase_token':
                                          '${Get.find<LoginScreenController>().firebaseToken.value}'
                                    },
                                    onResponseSuccess: (object) {
                                      print("Abhishek ${object}");
                                      if (flag) {
                                        AppPreference _appPreference =
                                        AppPreference();
                                        _appPreference.setString(
                                            PreferencesKey.userId,
                                            object['data']['_id']);
                                        _appPreference.setString(
                                            PreferencesKey.interactUserId,
                                            object['data']['_id']);
                                        _appPreference.setString(
                                            PreferencesKey.profilePath,
                                            object['path']);
                                        if (object['data']['profile'] != null) {
                                          _appPreference.setString(
                                              PreferencesKey.profile,
                                              object['data']['profile']);
                                          _appPreference.setString(
                                              PreferencesKey.interactProfile,
                                              object['data']['profile']);
                                        }
                                        _appPreference.setString(
                                            PreferencesKey.countFollowing,
                                            object['data']['countFollowing']
                                                .toString());
                                        _appPreference.setString(
                                            PreferencesKey.userToken,
                                            object['data']['auth_token']);
                                        _appPreference.setString(
                                            PreferencesKey.city,
                                            object['data']['city'] ?? "");
                                        _appPreference.setString(
                                            PreferencesKey.state,
                                            object['data']['state'] ?? "");
                                        _appPreference.setString(
                                            PreferencesKey.country,
                                            object['data']['country'] ?? "");
                                        if (object['data']['myOrganization'] !=
                                            null) {
                                          _appPreference.setString(
                                              PreferencesKey.orgUserId,
                                              object['data']['myOrganization']
                                              ['organization_id'] ??
                                                  "");
                                        }
                                        log("Abhishek -=-=- ${_appPreference.getString(PreferencesKey.userToken)}");
                                        if (object['data']['fullname'] == null) {
                                          _appPreference.setBool(
                                              PreferencesKey.isGuest, true);
                                          muddaNewsController.isShowGuide.value =
                                          true;
                                          Get.offAllNamed(
                                              RouteConstants.introScreen, arguments: false);
                                          // Get.offAllNamed(
                                          //     RouteConstants.signupScreen);
                                        } else {
                                          _appPreference.setString(
                                              PreferencesKey.fullName,
                                              object['data']['fullname']);
                                          _appPreference.setBool(
                                              PreferencesKey.isGuest, false);
                                          Get.offAllNamed(
                                              RouteConstants.introScreen, arguments: false);
                                        }
                                      }
                                      else{
                                        AppPreference _appPreference =
                                        AppPreference();
                                        _appPreference.setString(
                                            PreferencesKey.userId,
                                            object['data']['_id']);
                                        _appPreference.setString(
                                            PreferencesKey.interactUserId,
                                            object['data']['_id']);
                                        _appPreference.setString(
                                            PreferencesKey.profilePath,
                                            object['path']);
                                        if (object['data']['profile'] != null) {
                                          _appPreference.setString(
                                              PreferencesKey.profile,
                                              object['data']['profile']);
                                          _appPreference.setString(
                                              PreferencesKey.interactProfile,
                                              object['data']['profile']);
                                        }
                                        _appPreference.setString(
                                            PreferencesKey.countFollowing,
                                            object['data']['countFollowing']
                                                .toString());
                                        _appPreference.setString(
                                            PreferencesKey.userToken,
                                            object['data']['auth_token']);
                                        _appPreference.setString(
                                            PreferencesKey.city,
                                            object['data']['city'] ?? "");
                                        _appPreference.setString(
                                            PreferencesKey.state,
                                            object['data']['state'] ?? "");
                                        _appPreference.setString(
                                            PreferencesKey.country,
                                            object['data']['country'] ?? "");
                                        if (object['data']['myOrganization'] !=
                                            null) {
                                          _appPreference.setString(
                                              PreferencesKey.orgUserId,
                                              object['data']['myOrganization']
                                              ['organization_id'] ??
                                                  "");
                                        }
                                        log("Abhishek -=-=- ${_appPreference.getString(PreferencesKey.userToken)}");
                                        if (object['data']['fullname'] == null) {
                                          _appPreference.setBool(
                                              PreferencesKey.isGuest, true);
                                          muddaNewsController.isShowGuide.value =
                                          true;
                                          Get.offAllNamed(
                                              RouteConstants.homeScreen);
                                          // Get.offAllNamed(
                                          //     RouteConstants.signupScreen);
                                        } else {
                                          _appPreference.setString(
                                              PreferencesKey.fullName,
                                              object['data']['fullname']);
                                          _appPreference.setBool(
                                              PreferencesKey.isGuest, false);
                                          Get.offAllNamed(
                                              RouteConstants.homeScreen);
                                        }
                                      }
                                    },
                                  );
                                } else {
                                  var snackBar = const SnackBar(
                                    content: Text('Enter OTP'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 45.w, vertical: 10.h),
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.h,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: colorWhite,
                                    border: Border.all(color: colorA0A0A0),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  verifyOTP,
                                  style: TextStyle(
                                    color: greyTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                _loginScreenController.isOTPOn.value = false;
                                // _loginScreenController.dispose();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 45.h, vertical: 10.h),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      color: colorDarkBlack,
                                      size: 18.sp,
                                    ),
                                    Text(
                                      goBack,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Positioned(
                            //   right: 0,
                            //   child: InkWell(
                            //     onTap: () {
                            //       Api.post.call(
                            //         context,
                            //         method: "user/verify-otp",
                            //         param: {
                            //           "country_code":Get.find<LoginScreenController>()
                            //               .diaCode,
                            //           "mobile":mobileNumber.text,
                            //           "is_new": isNew,
                            //           "otp": otp,
                            //         },
                            //         onResponseSuccess: (object) {
                            //
                            //         },
                            //       );
                            //       // Get.toNamed(RouteConstants.signupScreen);
                            //     },
                            //     child: Container(
                            //       alignment: Alignment.center,
                            //       height: 60.w,
                            //       width: 60.w,
                            //       padding: const EdgeInsets.all(2),
                            //       margin: const EdgeInsets.only(right: 40),
                            //       decoration: const BoxDecoration(
                            //           shape: BoxShape.circle, color: colorWhite),
                            //       child: Container(
                            //         alignment: Alignment.center,
                            //         decoration: BoxDecoration(
                            //             shape: BoxShape.circle,
                            //             color: colorWhite,
                            //             border: Border.all(color: color606060)),
                            //         child: Icon(
                            //           Icons.chevron_right_rounded,
                            //           size: 50.sp,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !_loginScreenController.isOTPOn.value,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setSp(40)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Vs(height: ScreenUtil().setSp(5)),
                              Center(
                                child: Text(
                                  or,
                                  style:
                                      size14_M_normal(textColor: colorA0A0A0),
                                ),
                              ),
                              Vs(height: ScreenUtil().setSp(12)),
                              InkWell(
                                onTap: () {
                                  _googleSignIn.signOut();
                                  _googleSignIn.signIn().then((result) {
                                    print(result?.displayName);
                                    print("+==========================");
                                    print(
                                      _googleSignIn.currentUser!.displayName!,
                                    );

                                    print("+==========================");
                                    result!.authentication.then((googleKey) {
                                      Map<String, String> map = {
                                        "email":
                                            _googleSignIn.currentUser!.email,
                                        "fullname": _googleSignIn
                                            .currentUser!.displayName!,
                                        "social_id":
                                            _googleSignIn.currentUser!.id,
                                        "social_pic": _googleSignIn
                                            .currentUser!.photoUrl!,
                                        // "age":  GoogleSignInApi.getGender(),
                                        "social_token": googleKey.accessToken!,
                                        "register_type": "google",
                                        'firebase_token':
                                            '${Get.find<LoginScreenController>().firebaseToken.value}'
                                      };
                                      Api.post.call(context,
                                          method: "user/social-login",
                                          param: map, onResponseSuccess:
                                              (Map object) async {
                                        log('$object');
                                        if (flag) {
                                          AppPreference _appPreference =
                                          AppPreference();
                                          _appPreference.setString(
                                              PreferencesKey.userId,
                                              object['data']['_id']);
                                          _appPreference.setString(
                                              PreferencesKey.interactUserId,
                                              object['data']['_id']);

                                          _appPreference.setString(
                                              PreferencesKey.profilePath,
                                              object['path']);
                                          if (object['data']['profile'] != null) {
                                            _appPreference.setString(
                                                PreferencesKey.profile,
                                                object['data']['profile']);
                                            _appPreference.setString(
                                                PreferencesKey.interactProfile,
                                                object['data']['profile']);
                                          }
                                          _appPreference.setString(
                                              PreferencesKey.countFollowing,
                                              object['data']['countFollowing']
                                                  .toString());
                                          _appPreference.setString(
                                              PreferencesKey.userToken,
                                              object['data']['auth_token']);
                                          _appPreference.setString(
                                              PreferencesKey.city,
                                              object['data']['city'] ?? "");
                                          _appPreference.setString(
                                              PreferencesKey.state,
                                              object['data']['state'] ?? "");
                                          _appPreference.setString(
                                              PreferencesKey.country,
                                              object['data']['country'] ?? "");
                                          if (object['data']['myOrganization'] !=
                                              null) {
                                            _appPreference.setString(
                                                PreferencesKey.orgUserId,
                                                object['data']['myOrganization']
                                                ['organization_id'] ??
                                                    "");
                                          }
                                          if (object['data']['city'] == null) {
                                            _appPreference.setBool(
                                                PreferencesKey.isGuest, true);
                                            muddaNewsController
                                                .isShowGuide.value = true;
                                            Get.offAllNamed(
                                                RouteConstants.introScreen,arguments: false);
                                            // Get.offAllNamed(
                                            //     RouteConstants.signupScreen);
                                          } else {
                                            _appPreference.setString(
                                                PreferencesKey.fullName,
                                                object['data']['fullname']);
                                            _appPreference.setBool(
                                                PreferencesKey.isGuest, false);

                                            Get.offAllNamed(
                                                RouteConstants.introScreen,arguments: false);
                                          }
                                        }
                                        else{
                                          AppPreference _appPreference =
                                          AppPreference();
                                          _appPreference.setString(
                                              PreferencesKey.userId,
                                              object['data']['_id']);
                                          _appPreference.setString(
                                              PreferencesKey.interactUserId,
                                              object['data']['_id']);
                                          _appPreference.setString(
                                              PreferencesKey.profilePath,
                                              object['path']);
                                          if (object['data']['profile'] != null) {
                                            _appPreference.setString(
                                                PreferencesKey.profile,
                                                object['data']['profile']);
                                            _appPreference.setString(
                                                PreferencesKey.interactProfile,
                                                object['data']['profile']);
                                          }
                                          _appPreference.setString(
                                              PreferencesKey.countFollowing,
                                              object['data']['countFollowing']
                                                  .toString());
                                          _appPreference.setString(
                                              PreferencesKey.userToken,
                                              object['data']['auth_token']);
                                          _appPreference.setString(
                                              PreferencesKey.city,
                                              object['data']['city'] ?? "");
                                          _appPreference.setString(
                                              PreferencesKey.state,
                                              object['data']['state'] ?? "");
                                          _appPreference.setString(
                                              PreferencesKey.country,
                                              object['data']['country'] ?? "");
                                          if (object['data']['myOrganization'] !=
                                              null) {
                                            _appPreference.setString(
                                                PreferencesKey.orgUserId,
                                                object['data']['myOrganization']
                                                ['organization_id'] ??
                                                    "");
                                          }
                                          if (object['data']['city'] == null) {
                                            _appPreference.setBool(
                                                PreferencesKey.isGuest, true);
                                            muddaNewsController
                                                .isShowGuide.value = true;
                                            Get.offAllNamed(
                                                RouteConstants.homeScreen);
                                            // Get.offAllNamed(
                                            //     RouteConstants.signupScreen);
                                          } else {
                                            _appPreference.setString(
                                                PreferencesKey.fullName,
                                                object['data']['fullname']);
                                            _appPreference.setBool(
                                                PreferencesKey.isGuest, false);

                                            Get.offAllNamed(
                                                RouteConstants.homeScreen);
                                          }
                                        }
                                      });
                                    }).catchError((err) {
                                      print('inner error');
                                    });
                                  }).catchError((err) {
                                    print('error occured${err.toString()}');
                                  });

                                  /*Map<String, String> map = {
                                 // "email": _googleSignIn.currentUser!.email,
                                 "email": "kalzstudios@gmail.com",
                                 // "fullname": _googleSignIn.currentUser!.displayName!,
                                 // "social_id": _googleSignIn.currentUser!.id,
                                 // "social_pic": _googleSignIn.currentUser!.photoUrl!,
                                 // "social_token": googleKey.accessToken!,
                                 "fullname": "Kalz Studios",
                                 "social_id": "100968676452588781096",
                                 "social_pic": "https://lh3.googleusercontent.com/a-/AFdZucquPcPtlMRAUX9U7iTEBJiyJ3rnANLbcoRpw1sn=s96-c",
                                 "social_token": "ya29.a0AVA9y1tjqosi1D1r188-Xx_YBEaY83jK7rcZ1OfVsJBvnN1O2k4K4N5Tc2ORFHT_r8iajsRot--ASYMKIMgsz7fzxgS383Ap5-FfC5JA82VwcK-vwfaRSfK9jBDoE8aV6KbmHuWb2vxnXAmDJpkucDC6S3wHDgaCgYKATASAQASFQE65dr8rbB2Da4kGOsR2z_jOt-aCA0165",
                                 "register_type": "google",
                               };
                               Api.post.call(context, method: "user/social-login", param: map,
                                   onResponseSuccess: (Map object) async {
                                     AppPreference _appPreference = AppPreference();
                                     _appPreference.setString(PreferencesKey.userId, object['data']['_id']);
                                     _appPreference.setString(
                                         PreferencesKey.interactUserId,
                                         object['data']['_id']);
                                     _appPreference.setString(PreferencesKey.profilePath, object['path']);
                                     if(object['data']['profile'] != null) {
                                       _appPreference.setString(
                                           PreferencesKey.profile,
                                           object['data']['profile']);
                                       _appPreference.setString(
                                           PreferencesKey.interactProfile,
                                           object['data']['profile']);
                                     }
                                     _appPreference.setString(PreferencesKey.countFollowing, object['data']['countFollowing'].toString());
                                     _appPreference.setString(PreferencesKey.userToken, object['data']['auth_token']);
                                     _appPreference.setString(PreferencesKey.city, object['data']['city'] ?? "");
                                     _appPreference.setString(PreferencesKey.state, object['data']['state'] ?? "");
                                     _appPreference.setString(PreferencesKey.country, object['data']['country'] ?? "");
                                     if(object['data']['myOrganization'] != null){
                                       _appPreference.setString(PreferencesKey.orgUserId, object['data']['myOrganization']['organization_id'] ?? "");
                                     }
                                     if(object['data']['city'] == null){
                                       _appPreference.setBool(PreferencesKey.isGuest, true);
                                       Get.offAllNamed(RouteConstants.signupScreen);
                                     }else{
                                       _appPreference.setString(PreferencesKey.fullName, object['data']['fullname']);
                                       _appPreference.setBool(PreferencesKey.isGuest, false);
                                       Get.offAllNamed(RouteConstants.homeScreen);
                                     }
                                   });*/
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(),
                                  decoration: BoxDecoration(
                                      color: colorWhite,
                                      border: Border.all(color: colorA0A0A0),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(AppIcons.googleIcon),
                                        Hs(width: 16.w),
                                        Text(signInWithGoogle)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Vs(
                                  height: Platform.isIOS
                                      ? ScreenUtil().setSp(12)
                                      : 0),
                              Platform.isIOS
                                  ? InkWell(
                                      onTap: () async {
                                        await SignInWithApple
                                            .getAppleIDCredential(
                                          scopes: [
                                            AppleIDAuthorizationScopes.email,
                                            AppleIDAuthorizationScopes.fullName,
                                          ],
                                        ).then((value) async {
                                          if (value.email != null) {
                                            await KeyChainAccess().putKeyChain(
                                                email: value.email);
                                          }
                                          final cred = await KeyChainAccess()
                                              .getKeyChain();
                                          if (cred == null) {
                                            showEmailIDDialog(context);
                                          } else {
                                            Map<String, String> map = {
                                              "email":
                                                  value.email ?? cred["email"],
                                              "fullname": value.givenName!,
                                              "social_token":
                                                  value.identityToken!,
                                              "register_type": "apple",
                                            };
                                            Api.post.call(context,
                                                method: "user/social-login",
                                                param: map, onResponseSuccess:
                                                    (Map object) async {
                                                    if (flag) {
                                                      AppPreference _appPreference =
                                                      AppPreference();
                                                      _appPreference.setString(
                                                          PreferencesKey.userId,
                                                          object['data']['_id']);
                                                      _appPreference.setString(
                                                          PreferencesKey.interactUserId,
                                                          object['data']['_id']);
                                                      _appPreference.setString(
                                                          PreferencesKey.profilePath,
                                                          object['path']);
                                                      if (object['data']['profile'] !=
                                                          null) {
                                                        _appPreference.setString(
                                                            PreferencesKey.profile,
                                                            object['data']['profile']);
                                                        _appPreference.setString(
                                                            PreferencesKey
                                                                .interactProfile,
                                                            object['data']['profile']);
                                                      }
                                                      _appPreference.setString(
                                                          PreferencesKey.countFollowing,
                                                          object['data']
                                                          ['countFollowing']
                                                              .toString());
                                                      _appPreference.setString(
                                                          PreferencesKey.userToken,
                                                          object['data']['auth_token']);
                                                      _appPreference.setString(
                                                          PreferencesKey.city,
                                                          object['data']['city'] ?? "");
                                                      _appPreference.setString(
                                                          PreferencesKey.state,
                                                          object['data']['state'] ??
                                                              "");
                                                      _appPreference.setString(
                                                          PreferencesKey.country,
                                                          object['data']['country'] ??
                                                              "");
                                                      if (object['data']
                                                      ['myOrganization'] !=
                                                          null) {
                                                        _appPreference.setString(
                                                            PreferencesKey.orgUserId,
                                                            object['data'][
                                                            'myOrganization']
                                                            [
                                                            'organization_id'] ??
                                                                "");
                                                      }
                                                      if (object['data']['city'] ==
                                                          null) {
                                                        _appPreference.setBool(
                                                            PreferencesKey.isGuest,
                                                            true);
                                                        muddaNewsController
                                                            .isShowGuide.value = true;
                                                        Get.offAllNamed(
                                                            RouteConstants.introScreen,arguments: false);
                                                        // Get.offAllNamed(RouteConstants
                                                        //     .signupScreen);
                                                      } else {
                                                        _appPreference.setString(
                                                            PreferencesKey.fullName,
                                                            object['data']['fullname']);
                                                        _appPreference.setBool(
                                                            PreferencesKey.isGuest,
                                                            false);
                                                        Get.offAllNamed(
                                                            RouteConstants.introScreen, arguments: false);
                                                      }
                                                    }
                                                    else{
                                                      AppPreference _appPreference =
                                                      AppPreference();
                                                      _appPreference.setString(
                                                          PreferencesKey.userId,
                                                          object['data']['_id']);
                                                      _appPreference.setString(
                                                          PreferencesKey.interactUserId,
                                                          object['data']['_id']);
                                                      _appPreference.setString(
                                                          PreferencesKey.profilePath,
                                                          object['path']);
                                                      if (object['data']['profile'] !=
                                                          null) {
                                                        _appPreference.setString(
                                                            PreferencesKey.profile,
                                                            object['data']['profile']);
                                                        _appPreference.setString(
                                                            PreferencesKey
                                                                .interactProfile,
                                                            object['data']['profile']);
                                                      }
                                                      _appPreference.setString(
                                                          PreferencesKey.countFollowing,
                                                          object['data']
                                                          ['countFollowing']
                                                              .toString());
                                                      _appPreference.setString(
                                                          PreferencesKey.userToken,
                                                          object['data']['auth_token']);
                                                      _appPreference.setString(
                                                          PreferencesKey.city,
                                                          object['data']['city'] ?? "");
                                                      _appPreference.setString(
                                                          PreferencesKey.state,
                                                          object['data']['state'] ??
                                                              "");
                                                      _appPreference.setString(
                                                          PreferencesKey.country,
                                                          object['data']['country'] ??
                                                              "");
                                                      if (object['data']
                                                      ['myOrganization'] !=
                                                          null) {
                                                        _appPreference.setString(
                                                            PreferencesKey.orgUserId,
                                                            object['data'][
                                                            'myOrganization']
                                                            [
                                                            'organization_id'] ??
                                                                "");
                                                      }
                                                      if (object['data']['city'] ==
                                                          null) {
                                                        _appPreference.setBool(
                                                            PreferencesKey.isGuest,
                                                            true);
                                                        muddaNewsController
                                                            .isShowGuide.value = true;
                                                        Get.offAllNamed(
                                                            RouteConstants.homeScreen);
                                                        // Get.offAllNamed(RouteConstants
                                                        //     .signupScreen);
                                                      } else {
                                                        _appPreference.setString(
                                                            PreferencesKey.fullName,
                                                            object['data']['fullname']);
                                                        _appPreference.setBool(
                                                            PreferencesKey.isGuest,
                                                            false);
                                                        Get.offAllNamed(
                                                            RouteConstants.homeScreen);
                                                      }
                                                    }
                                            });
                                          }
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: colorA0A0A0),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: color606060),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(AppIcons.appleIcon),
                                              Hs(width: 16.h),
                                              Text(
                                                signInWithApple,
                                                style: size14_M_normal(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Vs(height: ScreenUtil().setSp(24)),
                Obx(() => Visibility(
                    visible: !_loginScreenController.isOTPOn.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text.rich(TextSpan(
                          text: "By continuing, you agree to Mudda ",
                          style: size10_M_normal(textColor: color606060),
                          children: [
                            TextSpan(
                              text: "Terms of Service, ",
                              style:
                                  size10_M_semibold(textColor: colorDarkBlack),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WebViewScreen("Terms of Service")),
                                  );
                                },
                            ),
                            TextSpan(
                              text: "Community Guidelines ",
                              style:
                                  size10_M_semibold(textColor: colorDarkBlack),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                            "Community Guidelines")),
                                  );
                                },
                            ),
                            TextSpan(
                              text: "& ",
                              style: size10_M_normal(textColor: color606060),
                            ),
                            TextSpan(
                              text: "Privacy Policy",
                              style:
                                  size10_M_semibold(textColor: colorDarkBlack),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WebViewScreen("Privacy Policy")),
                                  );
                                },
                            )
                          ])),
                    ))),
                Vs(height: ScreenUtil().setSp(22)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setSp(40),
                      vertical: ScreenUtil().setSp(24)),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteConstants.supportRegister);
                      },
                      child: Text(
                        troubleSignIn,
                        style: size12_M_normal(textColor: color606060),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showEmailIDDialog(BuildContext context) {
    TextEditingController emailTextController = TextEditingController();
    emailTextController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.only(
                  left: ScreenUtil()
                      .setWidth((ScreenUtil().screenWidth - 213) / 2),
                  right: ScreenUtil()
                      .setWidth((ScreenUtil().screenWidth - 213) / 2)),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStates) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setSp(16))),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 4),
                          color: black25,
                          blurRadius: 4.0,
                        ),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(ScreenUtil().setSp(16)),
                                topRight:
                                    Radius.circular(ScreenUtil().setSp(16))),
                            gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [lightRedWhite, lightRed])),
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(21),
                            bottom: ScreenUtil().setHeight(12),
                            left: ScreenUtil().setWidth(5),
                            right: ScreenUtil().setWidth(5)),
                        child: Center(
                          child: Text(
                            'Enter email',
                            style: GoogleFonts.nunitoSans(
                                fontSize: ScreenUtil().setSp(14),
                                color: white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(4),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(ScreenUtil().setSp(16)),
                              bottomRight:
                                  Radius.circular(ScreenUtil().setSp(16))),
                          color: appBackgroundColor,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(14),
                                  left: ScreenUtil().setWidth(20),
                                  right: ScreenUtil().setWidth(20)),
                              child: TextFormField(
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.name,
                                controller: emailTextController,
                                textInputAction: TextInputAction.done,
                                style: GoogleFonts.nunitoSans(
                                    fontSize: ScreenUtil().setSp(14),
                                    color: darkGray,
                                    fontWeight: FontWeight.w700),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: white25,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: lightGray,
                                        width: ScreenUtil().radius(1)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().radius(8))),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: buttonBlue,
                                        width: ScreenUtil().radius(1)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().radius(8))),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: lightGray,
                                        width: ScreenUtil().radius(1)),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().radius(8))),
                                  ),
                                  hintText: "example@mail.com",
                                  contentPadding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(11)),
                                  hintStyle: GoogleFonts.nunitoSans(
                                      fontStyle: FontStyle.italic,
                                      fontSize: ScreenUtil().setSp(14),
                                      color: lightGray,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setSp(32),
                                  bottom: ScreenUtil().setSp(20)),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: InkWell(
                                          onTap: () async {
                                            if (emailTextController
                                                .text.isNotEmpty) {
                                              Navigator.pop(context);
                                              Map<String, String> map = {
                                                "email":
                                                    emailTextController.text,
                                                "fullname": "AppUser",
                                                "register_type": "apple",
                                              };
                                              Api.post.call(context,
                                                  method: "user/social-login",
                                                  param: map, onResponseSuccess:
                                                      (Map object) async {
                                                AppPreference _appPreference =
                                                    AppPreference();
                                                _appPreference.setString(
                                                    PreferencesKey.userId,
                                                    object['data']['_id']);
                                                _appPreference.setString(
                                                    PreferencesKey
                                                        .interactUserId,
                                                    object['data']['_id']);
                                                _appPreference.setString(
                                                    PreferencesKey.profilePath,
                                                    object['path']);
                                                if (object['data']['profile'] !=
                                                    null) {
                                                  _appPreference.setString(
                                                      PreferencesKey.profile,
                                                      object['data']
                                                          ['profile']);
                                                  _appPreference.setString(
                                                      PreferencesKey
                                                          .interactProfile,
                                                      object['data']
                                                          ['profile']);
                                                }
                                                _appPreference.setString(
                                                    PreferencesKey
                                                        .countFollowing,
                                                    object['data']
                                                            ['countFollowing']
                                                        .toString());
                                                _appPreference.setString(
                                                    PreferencesKey.userToken,
                                                    object['data']
                                                        ['auth_token']);
                                                _appPreference.setString(
                                                    PreferencesKey.city,
                                                    object['data']['city'] ??
                                                        "");
                                                _appPreference.setString(
                                                    PreferencesKey.state,
                                                    object['data']['state'] ??
                                                        "");
                                                _appPreference.setString(
                                                    PreferencesKey.country,
                                                    object['data']['country'] ??
                                                        "");
                                                if (object['data']
                                                        ['myOrganization'] !=
                                                    null) {
                                                  _appPreference.setString(
                                                      PreferencesKey.orgUserId,
                                                      object['data'][
                                                                  'myOrganization']
                                                              [
                                                              'organization_id'] ??
                                                          "");
                                                }
                                                if (object['data']
                                                        ['fullname'] ==
                                                    null) {
                                                  _appPreference.setBool(
                                                      PreferencesKey.isGuest,
                                                      true);
                                                  muddaNewsController
                                                      .isShowGuide.value = true;
                                                  Get.offAllNamed(RouteConstants
                                                      .homeScreen);
                                                } else {
                                                  _appPreference.setString(
                                                      PreferencesKey.fullName,
                                                      object['data']
                                                          ['fullname']);
                                                  _appPreference.setBool(
                                                      PreferencesKey.isGuest,
                                                      false);
                                                  Get.offAllNamed(RouteConstants
                                                      .homeScreen);
                                                }
                                              });
                                            }
                                          },
                                          child: Text("Submit",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      ScreenUtil().setSp(14),
                                                  color: black)),
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      thickness: 1,
                                      width: 1,
                                      color: lightGray,
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel",
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:
                                                      ScreenUtil().setSp(14),
                                                  color: lightGray)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }));
        });
  }
}
