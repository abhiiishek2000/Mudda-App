import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/model/CategoryListModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/PlaceModel.dart';
import 'package:mudda/model/UserRolesModel.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/raising_mudda/controller/CreateMuddaController.dart';
import 'package:mudda/ui/shared/Validator.dart';
import 'package:mudda/ui/shared/constants.dart';
import 'package:mudda/ui/shared/create_dynamic_link.dart';
import 'package:mudda/ui/shared/get_started_button.dart';
import 'package:mudda/ui/shared/trimmer_view.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../../../dio/api/api.dart';
import '../../../shared/image_compression.dart';
import '../../other_user_profile/controller/ChatController.dart';

class RaisingMuddaScreen extends GetView {
  RaisingMuddaScreen({Key? key}) : super(key: key);
  CreateMuddaController? createMuddaController;
  final Trimmer _trimmer = Trimmer();
  XFile? video;
  TextEditingController tags = TextEditingController();
  TextEditingController locationController = TextEditingController();
  var h, w;
  MuddaNewsController? muddaNewsController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int rolePage = 1;
  ScrollController roleController = ScrollController();
  UserProfileUpdateController? userProfileUpdateController;
  ChatController? chatController;
  String muddaHintText = 'ENTER YOUR MUDDA NAME';
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;
    rolePage = 1;
    muddaNewsController = Get.find<MuddaNewsController>();
    createMuddaController = Get.find<CreateMuddaController>();
    chatController = Get.find<ChatController>();

    if (muddaNewsController!.muddaPost.value.initialScope != null) {
      createMuddaController!.dropdownScopeValue.value =
          muddaNewsController!.muddaPost.value.initialScope != null
              ? muddaNewsController!.muddaPost.value.initialScope!
              : "District";
    }
    // if(muddaNewsController!.muddaPost.value.title != null){
    //   createMuddaController!.titleValue.value = muddaNewsController!.muddaPost.value.title!;
    // }
    // if(muddaNewsController!.muddaPost.value.muddaDescription != null){
    //   createMuddaController!.descriptionValue.value = muddaNewsController!.muddaPost.value.muddaDescription!;
    // }
    // if(muddaNewsController!.muddaPost.value.city != null){
    //   createMuddaController!.city.value = muddaNewsController!.muddaPost.value.city!;
    // }
    // if(muddaNewsController!.muddaPost.value.state != null){
    //   createMuddaController!.state.value = muddaNewsController!.muddaPost.value.state!;
    // }
    // if(muddaNewsController!.muddaPost.value.country != null){
    //   createMuddaController!.country.value = muddaNewsController!.muddaPost.value.country!;
    // }
    locationController.text = muddaNewsController!.muddaPost.value.city != null
        ? "${muddaNewsController!.muddaPost.value.city ?? ''}, ${muddaNewsController!.muddaPost.value.state ?? ''}, ${muddaNewsController!.muddaPost.value.country ?? ''}"
        : createMuddaController!.searchLocation.value;
    if (muddaNewsController!.muddaPost.value.hashtags != null) {
      createMuddaController!.categoryList.clear();
      for (String tag in muddaNewsController!.muddaPost.value.hashtags!) {
        createMuddaController!.categoryList.add(Category(name: tag));
      }
    }
    if (muddaNewsController!.muddaPost.value.title == null) {
      roleController.addListener(() {
        if (roleController.position.maxScrollExtent ==
            roleController.position.pixels) {
          rolePage++;
          _getRoles(context);
        }
      });
      AppPreference().setString(PreferencesKey.interactUserId,
          AppPreference().getString(PreferencesKey.userId));
      _getRoles(context);
    }
    var scopeValue;
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  width: 20,
                ),
                Expanded(
                  child: TabBar(
                      indicatorColor: Colors.transparent,
                      labelColor: Colors.black,
                      labelStyle: size16_M_bold(textColor: Colors.black),
                      unselectedLabelStyle:
                          size14_M_normal(textColor: Colors.grey),
                      labelPadding: EdgeInsets.zero,
                      indicatorPadding: EdgeInsets.zero,
                      tabs: const [
                        Tab(
                          text: "Create Mudda",
                        ),
                        Tab(
                          text: "Initiate Survey",
                        )
                      ],
                      controller: createMuddaController!.controller),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(children: [
       Obx(() =>  Form(
         key: _formKey,
         autovalidateMode: createMuddaController!.autoValidate.value? AutovalidateMode.onUserInteraction :AutovalidateMode.disabled,
         child: ListView(
           children: [
             muddaNewsController?.muddaPost.value.isVerify == 3
                 ? Container(
               margin: const EdgeInsets.only(left: 30, right: 30),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     "Hi,\nYour Mudda is sent back for Corrections. Please check the below and revert-",
                     style: size12_M_regular(textColor: black),
                   ),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         "1. ",
                         style: size12_M_regular(textColor: black),
                       ),
                       Expanded(
                         child: Obx(() => Text(
                           "${createMuddaController!.adminMessage.value.isEmpty ? "A" : createMuddaController!.adminMessage.value[0].data!.body!.message}",
                           // "Mudda Name is matching with another one. Please keep the name unique or join that mudda with the same name",
                           /* Get.arguments['adminMessage'] == null
                                ? "A"
                                : "${Get.arguments['adminMessage']['body']['message']}",*/
                           style: size12_M_regular(textColor: black),
                         )),
                       ),
                     ],
                   ),
                   // Row(
                   //   crossAxisAlignment: CrossAxisAlignment.start,
                   //   children: [
                   //     Text(
                   //       "2. ",
                   //       style: size12_M_regular(textColor: black),
                   //     ),
                   //     Expanded(
                   //       child: Text(
                   //         "Images uploaded doesn’t confirm to your Mudda Purpose. We encourge you to upload only relevant Mudda to keep the Mudda Platform Clean & Safe.",
                   //         style: size12_M_regular(textColor: black),
                   //       ),
                   //     ),
                   //   ],
                   // ),
                   Text(
                     "Once you have updated the same, please resubmit your Mudda",
                     style: size12_M_regular(textColor: black),
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       Text(
                         "-Regards",
                         style: size12_M_regular(textColor: black),
                       ),
                     ],
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       Text(
                         "Mudda Admin",
                         style: size12_M_regular(textColor: black),
                       ),
                     ],
                   ),
                 ],
               ),
             )
                 : Container(),
             muddaNewsController?.muddaPost.value.isVerify == 3
                 ? Row(
               children: [
                 Expanded(
                   child: Container(
                     height: 51,
                     margin: const EdgeInsets.symmetric(
                         horizontal: 24, vertical: 20),
                     decoration: BoxDecoration(
                       color: white,
                       borderRadius: BorderRadius.circular(10),
                       // border: Border.all(color: colorGrey),
                     ),
                     child: TextFormField(
                       textCapitalization: TextCapitalization.sentences,
                       keyboardType: TextInputType.multiline,
                       maxLines: 3,
                       controller: commentController,
                       // maxLength: 600,
                       // initialValue: muddaNewsController!.muddaPost.value.muddaDescription ?? "",
                       // onChanged: (text) {
                       //   muddaNewsController!.muddaPost.value.muddaDescription =
                       //       text;
                       //   muddaNewsController!.descriptionValue.value = text;
                       // },
                       style: size14_M_normal(textColor: color606060),
                       decoration: InputDecoration(
                         // counterText: '',
                         contentPadding: const EdgeInsets.symmetric(
                             horizontal: 15, vertical: 10),
                         hintText: "Your Comments",
                         border: InputBorder.none,
                         hintStyle: size12_M_normal(textColor: grey),
                       ),
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: () {
                     chatController?.admin.value = createMuddaController!
                         .adminMessage.value[0].data!;
                     chatController?.userName = "Budlinks Admin";
                     log("-=-=- Chat with Support -=-=-");
                     Get.toNamed(RouteConstants.raisingMuddaChatPage);
                   },
                   child: Container(
                     margin: const EdgeInsets.only(right: 30),
                     child: Column(
                       children: [
                         Image.asset(
                           AppIcons.circleChat2Tab,
                           height: 20,
                           width: 20,
                           color: grey,
                         ),
                         getSizedBox(h: 5),
                         Text(
                           "Chat with\nSupport",
                           textAlign: TextAlign.center,
                           style: size12_M_regular(textColor: black),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             )
                 : Container(),
             Padding(
               padding: const EdgeInsets.fromLTRB(20,16,20,0),
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Obx(
                         () => Padding(
                       padding: EdgeInsets.only(top: h * 0.015),
                       child: InkWell(
                           onTap: () {
                             uploadProfilePic(context);
                           },
                           child: createMuddaController!
                               .muddaThumb.value.isNotEmpty
                               ? Container(
                             padding:
                             const EdgeInsets.fromLTRB(1, 1, 1, 1),
                             height: h * 0.13,
                             width: h * 0.13,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 border: Border.all(color: Colors.grey)),
                             child: ClipRRect(
                               borderRadius: BorderRadius.circular(10),
                               child: Image.file(
                                 File(createMuddaController!
                                     .muddaThumb.value),
                                 height: h * 0.15,
                                 width: w * 0.3,
                               ),
                             ),
                           )
                               : muddaNewsController!
                               .muddaPost.value.thumbnail !=
                               null
                               ? Container(
                             padding: const EdgeInsets.fromLTRB(
                                 1, 1, 1, 1),
                             height: h * 0.13,
                             width: h * 0.13,
                             decoration: BoxDecoration(
                                 borderRadius:
                                 BorderRadius.circular(10),
                                 border:
                                 Border.all(color: Colors.grey)),
                             child: ClipRRect(
                               borderRadius:
                               BorderRadius.circular(10),
                               child: Image.network(
                                 "${muddaNewsController!.muddaProfilePath.value}${muddaNewsController!.muddaPost.value.thumbnail}",
                                 height: h * 0.13,
                                 width: h * 0.13,
                               ),
                             ),
                           )
                               : Container(
                             margin: const EdgeInsets.only(left: 2),
                             height: h * 0.13,
                             width: h * 0.13,
                             child: Column(
                               mainAxisSize: MainAxisSize.max,
                               mainAxisAlignment:
                               MainAxisAlignment.center,
                               children: [
                                 Icon(
                                   Icons.camera_alt,
                                   size: h * 0.06,
                                   color: Colors.grey,
                                 ),
                                 Text(
                                   "Mudda \nThumbnail",
                                   textAlign: TextAlign.center,
                                   style: size10_M_normal(
                                       textColor: Colors.grey),
                                 )
                               ],
                             ),
                             decoration: BoxDecoration(
                                 borderRadius:
                                 BorderRadius.circular(10),
                                 border:
                                 Border.all(color: Colors.grey)),
                           )),
                     ),
                   ),
                   Expanded(
                     child: Padding(
                       padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                       child: Column(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             "You won’t be able to change this name later on",
                             style: TextStyle(
                                 color: buttonBlue,
                                 fontSize: 10.sp,
                                 fontStyle: FontStyle.italic,
                                 fontWeight: FontWeight.w400),
                           ),
                           Container(
                             width: double.maxFinite,
                             decoration: BoxDecoration(
                               color: Colors.white.withOpacity(0.5),
                               border: const Border(
                                 bottom: BorderSide(
                                     color: Colors.white, width: 1),
                               ),
                             ),
                             child: TextFormField(
                               // focusNode:
                               //     muddaNewsController!.muddaPost.value.initialScope !=
                               //             null
                               //         ? AlwaysDisabledFocusNode()
                               //         : null,
                               inputFormatters: [
                                 LengthLimitingTextInputFormatter(55),
                               ],
                               initialValue: muddaNewsController!
                                   .muddaPost.value.title ??
                                   "",
                               style: size18_M_bold(
                                   textColor: Colors.black),
                               maxLines: 3,
                               minLines: 2,
                               maxLength: 55,
                               onChanged: (text) {
                                 muddaNewsController!
                                     .muddaPost.value.title = text;
                                 createMuddaController!
                                     .titleValue.value = text;
                               },
                               validator: (value) {

                                 return Validator.validateFormField(
                                     value!,
                                     "Enter Title",
                                     "Enter Valid Title",
                                     Constants.NORMAL_VALIDATION);
                               },
                               decoration: InputDecoration(
                                 border: InputBorder.none,
                                 hintText: muddaHintText,
                                 contentPadding:
                                 EdgeInsets.fromLTRB(0, 0, 0, 0),
                                 counterText: '',
                                 hintStyle: size18_M_bold(
                                     textColor: Colors.black),
                               ),
                             ),
                           ),
                           Obx(() => Align(
                               alignment: Alignment.bottomRight,
                               child: Text(
                                 "${55 - createMuddaController!.titleValue.value.length}",
                                 style: size10_M_normal(
                                     textColor: colorGrey),
                               ))),
                           // Container(
                           //   width: double.maxFinite,
                           //   height: h * 0.07,
                           //   child: Stack(
                           //     children: [
                           //
                           //       Obx(() => Align(
                           //           alignment: Alignment.bottomRight,
                           //           child: Text(
                           //             "${55 - createMuddaController!.titleValue.value.length}",
                           //             style: size10_M_normal(
                           //                 textColor: colorGrey),
                           //           )))
                           //     ],
                           //   ),
                           // ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               // const Text("Scope:"),
                               // const SizedBox(width: 6),
                               Container(
                                 width: w * 1 / 2.8,
                                 alignment: Alignment.center,
                                 height: h * 0.05,
                                 child: muddaNewsController!
                                     .muddaPost.value.initialScope !=
                                     null
                                     ? Container(
                                   alignment: Alignment.centerLeft,
                                   height: h * 0.05,
                                   child: Text(
                                     createMuddaController!
                                         .dropdownScopeValue.value,
                                     style: TextStyle(
                                       fontSize: 14.sp,
                                       fontWeight: FontWeight.bold,
                                       color: colorGrey,
                                     ),
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                 )
                                     : Container(
                                   height: h * 0.03,
                                   decoration: BoxDecoration(
                                     color:
                                     Colors.white.withOpacity(0.5),
                                   ),
                                   child: Obx(
                                         () => DropdownButtonHideUnderline(
                                       child: DropdownButton2(
                                         isExpanded: true,
                                         hint: Row(
                                           children: [
                                             const SizedBox(
                                               width: 3,
                                             ),
                                             Expanded(
                                               child: Text(
                                                 createMuddaController!
                                                     .dropdownScopeValue
                                                     .value,
                                                 style: TextStyle(
                                                   fontSize: 10.sp,
                                                   fontWeight:
                                                   FontWeight.bold,
                                                   color: colorGrey,
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ),
                                         items: createMuddaController!
                                             .scopeList
                                             .map((item) =>
                                             DropdownMenuItem<
                                                 String>(
                                               value: item,
                                               child: Text(
                                                 item,
                                                 style: TextStyle(
                                                   fontSize: 14.sp,
                                                   color:
                                                   Colors.black,
                                                   letterSpacing:
                                                   0.50,
                                                 ),
                                                 overflow:
                                                 TextOverflow
                                                     .ellipsis,
                                               ),
                                             ))
                                             .toList(),
                                         onChanged: (value) {
                                           print("value $value");
                                           createMuddaController!
                                               .dropdownScopeValue
                                               .value = value.toString();
                                         },
                                         value: scopeValue,
                                         icon: Padding(
                                           padding:
                                           const EdgeInsets.only(
                                               right: 4),
                                           child: Image.asset(
                                             AppIcons.downArrow2,
                                             height: 10,
                                             width: 10,
                                             color: Colors.black,
                                           ),
                                         ),
                                         iconSize: 14,
                                         iconEnabledColor: Colors.black,
                                         iconDisabledColor: Colors.grey,
                                         dropdownMaxHeight: h * 0.3,
                                         dropdownWidth: w * 0.3,
                                         dropdownDecoration:
                                         BoxDecoration(
                                           borderRadius:
                                           BorderRadius.circular(14),
                                           color: colorWhite,
                                         ),
                                         dropdownElevation: 8,
                                         scrollbarRadius:
                                         const Radius.circular(40),
                                         scrollbarThickness: 6,
                                         scrollbarAlwaysShow: true,
                                         offset: const Offset(-1, 0),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                               const SizedBox(width: 4),
                               Row(
                                 children: [
                                   //Spacer(),
                                   InkWell(
                                     onTap: () {
                                       Get.defaultDialog(
                                         radius: 10.w,
                                         content:
                                         Image.asset(AppIcons.dialogAlert),
                                         titlePadding:
                                         EdgeInsets.only(top: 5.h),
                                         title: "",
                                         titleStyle: TextStyle(
                                           fontSize: 1.sp,
                                           fontWeight: FontWeight.bold,
                                         ),
                                         contentPadding: EdgeInsets.zero,
                                       );
                                     },
                                     child: Row(
                                       children: const [
                                         Text(
                                           "Know More",
                                           style: TextStyle(
                                               color: Colors.blue,
                                               fontSize: 12),
                                         ),
                                         SizedBox(width: 2),
                                         Icon(
                                           CupertinoIcons.question_circle,
                                           size: 10,
                                           color: Colors.blue,
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                             ],
                           ),
                           // Row(
                           //   children: [
                           //     Spacer(),
                           //     InkWell(
                           //       onTap: () {
                           //         Get.defaultDialog(
                           //           radius: 10.w,
                           //           content: Image.asset(AppIcons.dialogAlert),
                           //           titlePadding: EdgeInsets.only(top: 5.h),
                           //           title: "",
                           //           titleStyle: TextStyle(
                           //             fontSize: 1.sp,
                           //             fontWeight: FontWeight.bold,
                           //           ),
                           //           contentPadding: EdgeInsets.zero,
                           //         );
                           //       },
                           //       child: Row(
                           //         children: const [
                           //           Text(
                           //             "Know More",
                           //             style: TextStyle(
                           //                 color: Colors.blue, fontSize: 10),
                           //           ),
                           //           SizedBox(width: 2),
                           //           Icon(
                           //             CupertinoIcons.question_circle,
                           //             size: 14,
                           //             color: Colors.blue,
                           //           ),
                           //           SizedBox(width: 10),
                           //         ],
                           //       ),
                           //     ),
                           //   ],
                           // ),
                           // const SizedBox(height: 18),
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             ),
             Container(
               margin: EdgeInsets.fromLTRB(20, 12, 20, 0),
               padding: EdgeInsets.fromLTRB(5, 0, 14, 0),
               width: w * 1,
               height: h * 0.05,
               decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.5),
                   border: const Border(
                     bottom: BorderSide(color: Colors.white, width: 1),
                   )),
               child: Row(
                 children: [
                   SvgPicture.asset(
                     AppIcons.locationPinIcon,
                     height: 12,
                     width: 8,
                   ),
                   SizedBox(width: 10),
                   Expanded(
                     child: TypeAheadFormField<Place>(
                       validator: (value) {
                         if (value!.isEmpty) {
                           return 'Location required';
                         }
                       },
                       textFieldConfiguration: TextFieldConfiguration(
                           controller: locationController,
                           keyboardType: TextInputType.multiline,
                           minLines: 1,
                           maxLines: 3,
                           style: GoogleFonts.nunitoSans(
                               color: darkGray,
                               fontWeight: FontWeight.w300,
                               fontSize: ScreenUtil().setSp(12)),
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               hintText: "Origin Location",
                               hintStyle: GoogleFonts.nunitoSans(
                                   color: darkGray,
                                   fontWeight: FontWeight.w300,
                                   fontSize: ScreenUtil().setSp(12)))),
                       suggestionsCallback: (pattern) {
                         return _getLocation(pattern, context);
                       },
                       hideSuggestionsOnKeyboardHide: false,
                       itemBuilder: (context, suggestion) {
                         return Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: Text(
                             "${suggestion.district}, ${suggestion.state}, ${suggestion.country}",
                             style: GoogleFonts.nunitoSans(
                                 color: darkGray,
                                 fontWeight: FontWeight.w300,
                                 fontSize: ScreenUtil().setSp(12)),
                           ),
                         );
                       },
                       transitionBuilder:
                           (context, suggestionsBox, controller) {
                         return suggestionsBox;
                       },
                       onSuggestionSelected: (suggestion) async {
                         locationController.text =
                         "${suggestion.district}, ${suggestion.state}, ${suggestion.country}";
                         muddaNewsController?.muddaPost.value.city =
                             suggestion.district;
                         muddaNewsController?.muddaPost.value.state =
                             suggestion.state;
                         muddaNewsController?.muddaPost.value.country =
                             suggestion.country;
                       },
                     ),
                   ),
                   SizedBox(width: 10),
                   Image.asset(
                     'assets/png/search_icon.png',
                     height: 14,
                   )
                 ],
               ),
             ),

             // Padding(
             //   padding: const EdgeInsets.symmetric(horizontal: 20),
             //   child: Container(
             //     decoration: BoxDecoration(
             //       color: Colors.white.withOpacity(0.5),
             //       border: const Border(
             //         bottom: BorderSide(color: Colors.white, width: 2),
             //       ),
             //     ),
             //     child: TextFormField(
             //       // focusNode:
             //       //     muddaNewsController!.muddaPost.value.initialScope !=
             //       //             null
             //       //         ? AlwaysDisabledFocusNode()
             //       //         : null,
             //       inputFormatters: [
             //         LengthLimitingTextInputFormatter(60),
             //       ],
             //       initialValue:
             //           muddaNewsController!.muddaPost.value.title ?? "",
             //       style: size18_M_bold(textColor: Colors.black),
             //       maxLines: 2,
             //       minLines: 2,
             //       onChanged: (text) {
             //         muddaNewsController!.muddaPost.value.title = text;
             //         createMuddaController!.titleValue.value = text;
             //       },
             //       validator: (value) {
             //         return Validator.validateFormField(value!, "Enter Title",
             //             "Enter Valid Title", Constants.NORMAL_VALIDATION);
             //       },
             //       decoration: InputDecoration(
             //         border: InputBorder.none,
             //         hintText: "ENTER YOUR MUDDA NAME HERE ",
             //         hintStyle: size18_M_bold(textColor: Colors.black),
             //       ),
             //     ),
             //   ),
             // ),
             // getSizedBox(h: 2),
             // Obx(
             //   () => Padding(
             //     padding: const EdgeInsets.symmetric(horizontal: 20),
             //     child: Row(
             //       children: [
             //         Container(
             //           width: MediaQuery.of(context).size.width * 0.5,
             //           child: Text(
             //             "You won’t be able to change this name later on",
             //             style: size10_M_normal(textColor: Colors.blue),
             //           ),
             //         ),
             //         Spacer(),
             //         Visibility(
             //           visible:
             //               muddaNewsController!.muddaPost.value.initialScope ==
             //                   null,
             //           child: Text(
             //             "${60 - createMuddaController!.titleValue.value.length} characters",
             //             style: size10_M_normal(textColor: colorGrey),
             //           ),
             //         )
             //       ],
             //     ),
             //   ),
             // ),
             getSizedBox(h: 24),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Container(
                 height: h * 0.2,
                 decoration: BoxDecoration(
                     color: Colors.white.withOpacity(0.5),
                     borderRadius: BorderRadius.circular(10),
                     border: Border.all(color: Colors.white)),
                 child: TextFormField(
                   textCapitalization: TextCapitalization.sentences,
                   keyboardType: TextInputType.multiline,
                   maxLines: 10,
                   maxLength: 600,
                   validator: ((value) {
                     if (value!.isEmpty) {
                       return 'Mudda description is required';
                     }
                   }),
                   initialValue:
                   muddaNewsController!.muddaPost.value.muddaDescription ??
                       "",
                   onChanged: (text) {
                     muddaNewsController!.muddaPost.value.muddaDescription =
                         text;
                     createMuddaController!.descriptionValue.value = text;
                   },
                   style: size14_M_normal(textColor: color606060),
                   decoration: InputDecoration(
                     counterText: '',
                     contentPadding: const EdgeInsets.symmetric(
                         horizontal: 15, vertical: 10),
                     hintText:
                     "Enter Mudda Description, Your Vision, why people should support you...etc",
                     border: InputBorder.none,
                     hintStyle: size14_M_normal(textColor: colorA0A0A0),
                   ),
                 ),
               ),
             ),
             Obx(
                   () => Padding(
                 padding:
                 const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Text(
                       "max ${500 - createMuddaController!.descriptionValue.value.length} characters",
                       style: size10_M_normal(textColor: colorGrey),
                     )
                   ],
                 ),
               ),
             ),
             getSizedBox(h: 6),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Row(
                 children: [
                   Text(
                     "Upload Photo / Video",
                     style: size10_M_semibold(textColor: Colors.black),
                   ),
                   Text(
                     " (Optional)",
                     style: size10_M_normal(textColor: Colors.grey),
                   )
                 ],
               ),
             ),
             getSizedBox(h: 10),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Container(
                 height: 1,
                 color: Colors.white,
               ),
             ),
             getSizedBox(h: 10),
             muddaNewsController!.muddaPost.value.gallery != null
                 ? Padding(
               padding: const EdgeInsets.only(left: 20),
               child: SizedBox(
                 height: 100,
                 child: Obx(
                       () => ListView.builder(
                       scrollDirection: Axis.horizontal,
                       itemCount: createMuddaController!
                           .uploadPhotoVideos.length +
                           muddaNewsController!
                               .muddaPost.value.gallery!.length >
                           5
                           ? 5
                           : createMuddaController!
                           .uploadPhotoVideos.length +
                           muddaNewsController!
                               .muddaPost.value.gallery!.length,
                       itemBuilder: (followersContext, index) {
                         return Padding(
                           padding: const EdgeInsets.only(right: 10),
                           child: ((createMuddaController!
                               .uploadPhotoVideos
                               .length +
                               muddaNewsController!.muddaPost
                                   .value.gallery!.length) -
                               index) ==
                               1
                               ? InkWell(
                             onTap: () {
                               uploadPic(context);
                             },
                             child: Container(
                               height: 100,
                               width: 100,
                               child: const Center(
                                 child: Icon(
                                   Icons.camera_alt,
                                   size: 50,
                                   color: Colors.grey,
                                 ),
                               ),
                               decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   border: Border.all(
                                       color: Colors.grey)),
                             ),
                           )
                               : muddaNewsController!.muddaPost.value
                               .gallery!.length >
                               index
                               ? SizedBox(
                             height: ScreenUtil().setSp(100),
                             width: ScreenUtil().setSp(100),
                             child: Stack(
                               children: [
                                 Container(
                                   height:
                                   ScreenUtil().setSp(100),
                                   width:
                                   ScreenUtil().setSp(100),
                                   decoration: BoxDecoration(
                                       border: Border.all(
                                           color:
                                           Colors.grey)),
                                   child: CachedNetworkImage(
                                     imageUrl:
                                     "${muddaNewsController!.muddaProfilePath.value}${muddaNewsController!.muddaPost.value.gallery!.elementAt(index).file!}",
                                     fit: BoxFit.cover,
                                   ),
                                 ),
                                 Align(
                                   alignment:
                                   Alignment.topRight,
                                   child: InkWell(
                                     onTap: () {
                                       Api.delete.call(context,
                                           method:
                                           "mudda/image-delete/${muddaNewsController!.muddaPost.value.gallery!.elementAt(index).sId!}",
                                           param: {
                                             "_id":
                                             muddaNewsController!
                                                 .muddaPost
                                                 .value
                                                 .gallery!
                                                 .elementAt(
                                                 index)
                                                 .sId!
                                           },
                                           isLoading: true,
                                           onResponseSuccess:
                                               (Map object) {
                                             print(object);
                                             muddaNewsController!
                                                 .muddaPost
                                                 .value
                                                 .gallery!
                                                 .removeAt(index);
                                             createMuddaController!
                                                 .uploadPhotoVideos
                                                 .removeAt(createMuddaController!
                                                 .uploadPhotoVideos
                                                 .length -
                                                 1);
                                             createMuddaController!
                                                 .uploadPhotoVideos
                                                 .insert(
                                                 createMuddaController!
                                                     .uploadPhotoVideos
                                                     .length,
                                                 "");
                                           });
                                     },
                                     child: Container(
                                       decoration: const BoxDecoration(
                                           color: white,
                                           borderRadius:
                                           BorderRadius
                                               .all(Radius
                                               .circular(
                                               20))),
                                       child: const Padding(
                                         padding:
                                         EdgeInsets.all(2),
                                         child:
                                         Icon(Icons.close),
                                       ),
                                     ),
                                   ),
                                 )
                               ],
                             ),
                           )
                               : Container(
                             decoration: BoxDecoration(
                                 border: Border.all(
                                     color: Colors.grey)),
                             child: createMuddaController!
                                 .uploadPhotoVideos
                                 .elementAt(index -
                                 muddaNewsController!
                                     .muddaPost
                                     .value
                                     .gallery!
                                     .length)
                                 .contains("Trimmer")
                                 ? Stack(
                               children: [
                                 SizedBox(
                                   height: 100,
                                   width: 100,
                                   child: VideoViewer(
                                       trimmer:
                                       _trimmer),
                                 )
                               ],
                             )
                                 : Image.file(
                               File(createMuddaController!
                                   .uploadPhotoVideos
                                   .elementAt(index -
                                   muddaNewsController!
                                       .muddaPost
                                       .value
                                       .gallery!
                                       .length)),
                               height: 100,
                               width: 100,
                             ),
                           ),
                         );
                       }),
                 ),
               ),
             )
                 : Padding(
               padding: const EdgeInsets.only(left: 20),
               child: SizedBox(
                 height: 100,
                 child: Obx(
                       () => ListView.builder(
                       scrollDirection: Axis.horizontal,
                       itemCount: createMuddaController!
                           .uploadPhotoVideos.length >
                           5
                           ? 5
                           : createMuddaController!
                           .uploadPhotoVideos.length,
                       itemBuilder: (followersContext, index) {
                         return Padding(
                           padding: const EdgeInsets.only(right: 10),
                           child: GestureDetector(
                             onTap: () {
                               if ((createMuddaController!
                                   .uploadPhotoVideos.length -
                                   index) ==
                                   1) {
                                 uploadPic(context);
                               } else {
                                 // muddaVideoDialog(context,
                                 //     createMuddaController!.uploadPhotoVideos);
                               }
                             },
                             child: (createMuddaController!
                                 .uploadPhotoVideos.length -
                                 index) ==
                                 1
                                 ? Container(
                               height: 100,
                               width: 100,
                               child: const Center(
                                 child: Icon(
                                   Icons.camera_alt,
                                   size: 50,
                                   color: Colors.grey,
                                 ),
                               ),
                               decoration: BoxDecoration(
                                   shape: BoxShape.circle,
                                   border: Border.all(
                                       color: Colors.grey)),
                             )
                                 : Container(
                               decoration: BoxDecoration(
                                   border: Border.all(
                                       color: Colors.grey)),
                               child: createMuddaController!
                                   .uploadPhotoVideos
                                   .elementAt(index)
                                   .contains("Trimmer")
                                   ? Stack(
                                 children: [
                                   SizedBox(
                                     height: 100,
                                     width: 100,
                                     child: VideoViewer(
                                         trimmer: _trimmer),
                                   )
                                 ],
                               )
                                   : Stack(children: [
                                 Image.file(
                                   File(
                                       createMuddaController!
                                           .uploadPhotoVideos
                                           .elementAt(
                                           index)),
                                   height: 100,
                                   width: 100,
                                 ),
                                 Positioned(
                                     right: -2,
                                     bottom: 0,
                                     child: IconButton(
                                         icon: const Icon(
                                           Icons.delete,
                                           color:
                                           Colors.white,
                                           size: 18,
                                         ),
                                         onPressed: () {
                                           createMuddaController!
                                               .uploadPhotoVideos
                                               .removeAt(
                                               index);
                                         }))
                               ]),
                             ),
                           ),
                         );
                       }),
                 ),
               ),
             ),
             getSizedBox(h: 10),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Container(
                 height: 1,
                 color: Colors.white,
               ),
             ),
             getSizedBox(h: 10),
             // Padding(
             //   padding: const EdgeInsets.symmetric(horizontal: 20),
             //   child: Row(children: [
             //     const Icon(Icons.location_on_outlined, size: 15),
             //     getSizedBox(w: 5),
             //     Expanded(
             //       child: TypeAheadFormField<Place>(
             //         textFieldConfiguration: TextFieldConfiguration(
             //             controller: locationController,
             //             keyboardType: TextInputType.multiline,
             //             minLines: 1,
             //             maxLines: 3,
             //             style: GoogleFonts.nunitoSans(
             //                 color: darkGray,
             //                 fontWeight: FontWeight.w300,
             //                 fontSize: ScreenUtil().setSp(12)),
             //             decoration: InputDecoration(
             //                 hintText: "Origin Location",
             //                 hintStyle: GoogleFonts.nunitoSans(
             //                     color: darkGray,
             //                     fontWeight: FontWeight.w300,
             //                     fontSize: ScreenUtil().setSp(12)))),
             //         suggestionsCallback: (pattern) {
             //           return _getLocation(pattern, context);
             //         },
             //         hideSuggestionsOnKeyboardHide: false,
             //         itemBuilder: (context, suggestion) {
             //           return Padding(
             //             padding: const EdgeInsets.all(10.0),
             //             child: Text(
             //               "${suggestion.district}, ${suggestion.state}, ${suggestion.country}",
             //               style: GoogleFonts.nunitoSans(
             //                   color: darkGray,
             //                   fontWeight: FontWeight.w300,
             //                   fontSize: ScreenUtil().setSp(12)),
             //             ),
             //           );
             //         },
             //         transitionBuilder: (context, suggestionsBox, controller) {
             //           return suggestionsBox;
             //         },
             //         onSuggestionSelected: (suggestion) async {
             //           locationController.text =
             //               "${suggestion.district}, ${suggestion.state}, ${suggestion.country}";
             //           muddaNewsController!.muddaPost.value.city =
             //               suggestion.district!;
             //           muddaNewsController!.muddaPost.value.state =
             //               suggestion.state!;
             //           muddaNewsController!.muddaPost.value.country =
             //               suggestion.country!;
             //         },
             //       ),
             //     ),
             //     Image.asset(
             //       AppIcons.downArrow2,
             //       height: 10,
             //       width: 10,
             //       color: Colors.black,
             //     )
             //   ]),
             // ),
             // getSizedBox(h: 10),

             // muddaNewsController!.muddaPost.value.initialScope == null
             //     ? Obx(
             //       () => Padding(
             //     padding: const EdgeInsets.symmetric(horizontal: 20),
             //     child: InkWell(
             //       onTap: () {
             //         showRolesDialog(context, true);
             //       },
             //       child: Row(
             //         children: [
             //           Text("Create as:",
             //               style: GoogleFonts.nunitoSans(
             //                   fontWeight: FontWeight.w400,
             //                   fontSize: ScreenUtil().setSp(12),
             //                   color: blackGray)),
             //           getSizedBox(w: 6),
             //           createMuddaController!.selectedRole.value.user !=
             //               null
             //               ? createMuddaController!.selectedRole.value
             //               .user!.profile !=
             //               null
             //               ? CachedNetworkImage(
             //             imageUrl:
             //             "${createMuddaController!.roleProfilePath.value}${createMuddaController!.selectedRole.value.user!.profile}",
             //             imageBuilder:
             //                 (context, imageProvider) =>
             //                 Container(
             //                   width: ScreenUtil().setSp(30),
             //                   height: ScreenUtil().setSp(30),
             //                   decoration: BoxDecoration(
             //                     color: colorWhite,
             //                     border: Border.all(
             //                       width: ScreenUtil().setSp(1),
             //                       color: buttonBlue,
             //                     ),
             //                     borderRadius: BorderRadius.all(
             //                         Radius.circular(ScreenUtil()
             //                             .setSp(
             //                             15)) //                 <--- border radius here
             //                     ),
             //                     image: DecorationImage(
             //                         image: imageProvider,
             //                         fit: BoxFit.cover),
             //                   ),
             //                 ),
             //             placeholder: (context, url) =>
             //                 CircleAvatar(
             //                   backgroundColor: lightGray,
             //                   radius: ScreenUtil().setSp(15),
             //                 ),
             //             errorWidget: (context, url, error) =>
             //                 CircleAvatar(
             //                   backgroundColor: lightGray,
             //                   radius: ScreenUtil().setSp(15),
             //                 ),
             //           )
             //               : Container(
             //             height: ScreenUtil().setSp(30),
             //             width: ScreenUtil().setSp(30),
             //             decoration: BoxDecoration(
             //               border: Border.all(
             //                 color: darkGray,
             //               ),
             //               shape: BoxShape.circle,
             //             ),
             //             child: Center(
             //               child: Text(
             //                   createMuddaController!
             //                       .selectedRole
             //                       .value
             //                       .user!
             //                       .fullname![0]
             //                       .toUpperCase(),
             //                   style: GoogleFonts.nunitoSans(
             //                       fontWeight: FontWeight.w400,
             //                       fontSize:
             //                       ScreenUtil().setSp(16),
             //                       color: black)),
             //             ),
             //           )
             //               : AppPreference()
             //               .getString(PreferencesKey.profile)
             //               .isNotEmpty
             //               ? CachedNetworkImage(
             //             imageUrl:
             //             "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
             //             imageBuilder:
             //                 (context, imageProvider) =>
             //                 Container(
             //                   width: ScreenUtil().setSp(30),
             //                   height: ScreenUtil().setSp(30),
             //                   decoration: BoxDecoration(
             //                     color: colorWhite,
             //                     border: Border.all(
             //                       width: ScreenUtil().setSp(1),
             //                       color: buttonBlue,
             //                     ),
             //                     borderRadius: BorderRadius.all(
             //                         Radius.circular(ScreenUtil()
             //                             .setSp(
             //                             15)) //                 <--- border radius here
             //                     ),
             //                     image: DecorationImage(
             //                         image: imageProvider,
             //                         fit: BoxFit.cover),
             //                   ),
             //                 ),
             //             placeholder: (context, url) =>
             //                 CircleAvatar(
             //                   backgroundColor: lightGray,
             //                   radius: ScreenUtil().setSp(15),
             //                 ),
             //             errorWidget: (context, url, error) =>
             //                 CircleAvatar(
             //                   backgroundColor: lightGray,
             //                   radius: ScreenUtil().setSp(15),
             //                 ),
             //           )
             //               : Container(
             //             height: ScreenUtil().setSp(30),
             //             width: ScreenUtil().setSp(30),
             //             decoration: BoxDecoration(
             //               border: Border.all(
             //                 color: darkGray,
             //               ),
             //               shape: BoxShape.circle,
             //             ),
             //             child: Center(
             //               child: Text(
             //                   AppPreference()
             //                       .getString(PreferencesKey
             //                       .fullName)[0]
             //                       .toUpperCase(),
             //                   style: GoogleFonts.nunitoSans(
             //                       fontWeight: FontWeight.w400,
             //                       fontSize:
             //                       ScreenUtil().setSp(16),
             //                       color: black)),
             //             ),
             //           ),
             //           getSizedBox(w: 6),
             //           Text(
             //               createMuddaController!
             //                   .selectedRole.value.user !=
             //                   null
             //                   ? createMuddaController!
             //                   .selectedRole.value.user!.fullname!
             //                   : "Self",
             //               style: GoogleFonts.nunitoSans(
             //                   fontWeight: FontWeight.w400,
             //                   fontSize: ScreenUtil().setSp(10),
             //                   color: buttonBlue,
             //                   fontStyle: FontStyle.italic)),
             //         ],
             //       ),
             //     ),
             //   ),
             // )
             //     : Container(),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 GetStartedButton(
                   onTap: () async {
                     createMuddaController!.autoValidate.value=true;
                     if (_formKey.currentState!.validate()) {
                       // List<String> idList = [];
                       // for (Category challenges
                       //     in createMuddaController!.categoryList) {
                       //   idList.add(challenges.name!);
                       // }
                       if (createMuddaController!.dropdownScopeValue.value ==
                           '[ Select Initial Scope ]') {
                         var snackBar = const SnackBar(
                           content: Text('Please Select Initial Scope'),
                         );
                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                       } else {
                         AppPreference _appPreference = AppPreference();
                         FormData formData = FormData.fromMap({
                           "title":
                           muddaNewsController!.muddaPost.value.title!,
                           "mudda_description": muddaNewsController!
                               .muddaPost.value.muddaDescription!,
                           "initial_scope": createMuddaController!
                               .dropdownScopeValue.value
                               .toLowerCase(),
                           "city": muddaNewsController!.muddaPost.value.city!,
                           "country":
                           muddaNewsController!.muddaPost.value.country!,
                           "state":
                           muddaNewsController!.muddaPost.value.state!,
                           // "hashtags": jsonEncode(idList),
                           "user_id": createMuddaController!
                               .selectedRole.value.user !=
                               null
                               ? createMuddaController!
                               .selectedRole.value.user!.sId
                               : _appPreference
                               .getString(PreferencesKey.userId),
                         });
                         if (createMuddaController!
                             .muddaThumb.value.isNotEmpty) {
                           var video = await MultipartFile.fromFile(
                               createMuddaController!.muddaThumb.value,
                               filename: createMuddaController!
                                   .muddaThumb.value
                                   .split('/')
                                   .last);
                           formData.files.addAll([
                             MapEntry("thumbnail", video),
                           ]);
                         }
                         for (int i = 0;
                         i <
                             (createMuddaController!
                                 .uploadPhotoVideos.length +
                                 (muddaNewsController!.muddaPost
                                     .value.gallery !=
                                     null
                                     ? muddaNewsController!
                                     .muddaPost
                                     .value
                                     .gallery!
                                     .length
                                     : 0) ==
                                 5
                                 ? 5
                                 : (createMuddaController!
                                 .uploadPhotoVideos.length -
                                 1));
                         i++) {
                           formData.files.addAll([
                             MapEntry(
                                 "gallery",
                                 await MultipartFile.fromFile(
                                     createMuddaController!
                                         .uploadPhotoVideos[i],
                                     filename: createMuddaController!
                                         .uploadPhotoVideos[i]
                                         .split('/')
                                         .last)),
                           ]);
                         }
                         if (muddaNewsController!.muddaPost.value.sId !=
                             null) {
                           formData.fields.addAll([
                             MapEntry("_id",
                                 muddaNewsController!.muddaPost.value.sId!)
                           ]);
                           Api.uploadPost.call(context,
                               method: "mudda/update",
                               param: formData,
                               isLoading: true,
                               onResponseSuccess: (Map object) {
                                 print(object);
                                 var snackBar = const SnackBar(
                                   content: Text('Updated'),
                                 );
                                 ScaffoldMessenger.of(context)
                                     .showSnackBar(snackBar);
                                 createMuddaController!.muddaId.value =
                                 muddaNewsController!.muddaPost.value.sId!;
                                 createMuddaController!.muddaPost.value =
                                     muddaNewsController!.muddaPost.value;

                                 Get.offNamed(RouteConstants
                                     .raisingMuddaAdditionalInformation);
                               });
                           commentController.text.isNotEmpty
                               ? sendMessageApi(
                               context,
                               commentController.text,
                               '${createMuddaController!.adminMessage.value[0].data!.chatId}')
                               : null;
                         } else {
                           Api.uploadPost.call(context,
                               method: "mudda/store",
                               param: formData,
                               isLoading: true,
                               onResponseSuccess: (Map object) {
                                 print(object);
                                 var snackBar = const SnackBar(
                                   content: Text('Uploaded'),
                                 );
                                 ScaffoldMessenger.of(context)
                                     .showSnackBar(snackBar);
                                 print("ID::" + object['data']['_id']);
                                 var id = object['data']['_id'];
                                 createMuddaController!.muddaId.value =
                                     id.toString();
                                 createMuddaController!.muddaPost.value =
                                     MuddaPost.fromJson(object['data']);
                                 createMuddaController!.descriptionValue.value =
                                 '';
                                 createMuddaController!.titleValue.value = '';
                                 Get.offNamed(RouteConstants
                                     .raisingMuddaAdditionalInformation);
                               });
                         }
                       }
                     }
                   },
                   title: "Create",
                 )
               ],
             )
           ],
         ),
       )),
        InitiateSurvey(
            muddaNewsController!, createMuddaController!, roleController),
      ], controller: createMuddaController!.controller),
    );
  }

  void sendMessageApi(BuildContext context, String msg, String chatId) {
    Api.post.call(
      context,
      method: "chats/sendMessage",
      isLoading: false,
      param: {"chatId": chatId, "type": "message", "message": msg},
      onResponseSuccess: (object) {
        print('Message sent');
        commentController.clear();
      },
    );
  }

  Future<List<Place>> _getLocation(String query, BuildContext context) async {
    List<Place> matches = <Place>[];
    createMuddaController!.searchLocation.value = query;
    if (query.length >= 3 && query.length < 20) {
      var responce = await Api.get.futureCall(context,
          method: "country/location",
          param: {
            "search": query,
            "page": "1",
            "search_type": "district",
          },
          isLoading: false);
      if (responce != null) {
        final result = PlaceModel.fromJson(responce.data!);
        return result.data!;
      } else {
        return matches;
      }
    } else {
      return matches;
    }
  }

  Future uploadPic(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    try {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery,imageQuality: ImageCompression.imageQuality);
                      if (pickedFile != null) {
                        _cropImage(File(pickedFile.path)).then((value) async {
                          createMuddaController!.uploadPhotoVideos.insert(
                              createMuddaController!.uploadPhotoVideos.length -
                                  1,
                              value.path);
                          // if(value.lengthSync()>150000) {
                          //   testCompressAndGetFile(90,
                          //       value, '${value.path}compressed.jpg').then((
                          //       value) {
                          //     print('final size${value.lengthSync()}');
                          //     createMuddaController!.uploadPhotoVideos.insert(
                          //         createMuddaController!.uploadPhotoVideos.length -
                          //             1,
                          //         value.path);
                          //   });
                          // }
                          // else{
                          //   createMuddaController!.uploadPhotoVideos.insert(
                          //       createMuddaController!.uploadPhotoVideos.length -
                          //           1,
                          //       value.path);
                          // }
                        });
                      }
                    } on PlatformException catch (e) {
                      print('FAILED $e');
                    }
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  try {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera,imageQuality: ImageCompression.imageQuality);
                    if (pickedFile != null) {
                      _cropImage(File(pickedFile.path)).then((value) async {
                        createMuddaController!.uploadPhotoVideos.insert(
                            createMuddaController!.uploadPhotoVideos.length -
                                1,
                            value.path);
                        // if(value.lengthSync()>150000) {
                        //   testCompressAndGetFile(90,
                        //       value, '${value.path}compressed.jpg').then((
                        //       value) {
                        //     print('final size${value.lengthSync()}');
                        //     createMuddaController!.uploadPhotoVideos.insert(
                        //         createMuddaController!.uploadPhotoVideos.length -
                        //             1,
                        //         value.path);
                        //   });
                        // }
                        // else{
                        //   createMuddaController!.uploadPhotoVideos.insert(
                        //       createMuddaController!.uploadPhotoVideos.length -
                        //           1,
                        //       value.path);
                        // }
                      });
                    }
                  } on PlatformException catch (e) {
                    print('FAILED $e');
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Video Library'),
                  onTap: () async {
                    try {
                      Navigator.of(context).pop();
                      var result = await ImagePicker()
                          .pickVideo(source: ImageSource.gallery);
                      if (result != null) {
                        File file = File(result.path);
                        // print("ORG:::${_getVideoSize(file: file)}");
                        print(file.path);
                        var filePath = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrimmerView(file)));
                        if (filePath != null) {
                          File videoFile = File(filePath);
                          _trimmer.loadVideo(videoFile: videoFile);
                          createMuddaController!.uploadPhotoVideos.insert(
                              createMuddaController!.uploadPhotoVideos.length -
                                  1,
                              filePath);
                          /*final MediaInfo? info =
                          await VideoCompress.compressVideo(
                            videoFile.path,
                            quality: VideoQuality.MediumQuality,
                            deleteOrigin: false,
                            includeAudio: true,
                          );
                          print(info!.path);
                          _trimmer.loadVideo(videoFile: File(info.path!));
                          createMuddaController!.uploadPhotoVideos.add(info.path!);*/
                        }
                      }
                    } on PlatformException catch (e) {
                      print('FAILED $e');
                    }
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Video Camera'),
                onTap: () async {
                  try {
                    // XFile? video = await ImagePicker()
                    //     .pickVideo(source: ImageSource.camera);
                    video = await ImagePicker()
                        .pickVideo(source: ImageSource.camera);
                    if (video == null) return;
                    if (video != null) {
                      File file = File(video!.path);
                      // print("ORG:::${_getVideoSize(file: file)}");
                      print(file.path);
                      var filePath = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrimmerView(file)));
                      if (filePath != null) {
                        var videoFile = File(filePath);
                        // print("TRIMM:::${_getVideoSize(file: videoFile)}");
                        // String  _desFile = await _destinationFile;
                        // print("DEST:::${_desFile}");
                        final MediaInfo? info =
                            await VideoCompress.compressVideo(
                          videoFile.path,
                          quality: VideoQuality.MediumQuality,
                          deleteOrigin: false,
                          includeAudio: true,
                        );
                        print(info!.path);
                        _trimmer.loadVideo(videoFile: videoFile);
                        createMuddaController!.uploadPhotoVideos.insert(
                            createMuddaController!.uploadPhotoVideos.length - 1,
                            info.path!);
                      }
                    }
                  } on PlatformException catch (e) {
                    print('FAILED $e');
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future uploadProfilePic(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () async {
                    try {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _cropImage(File(pickedFile.path)).then((value) async {
                          if(value.lengthSync()>150000) {
                            testCompressAndGetFile(90,
                              value, '${value.path}compressed.jpg').then((
                              value) {
                                print('final size${value.lengthSync()}');
                                createMuddaController!.muddaThumb.value =
                                value.path;
                            });
                          }
                          else{
                            createMuddaController!.muddaThumb.value =
                          value.path;
                          }
                        });
                      }
                    } on PlatformException catch (e) {
                      print('FAILED $e');
                    }
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  try {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      _cropImage(File(pickedFile.path)).then((value) async {
                        if(value.lengthSync()>150000) {
                          testCompressAndGetFile(90,
                              value, '${value.path}compressed.jpg').then((
                              value) {
                            print('final size${value.lengthSync()}');
                            createMuddaController!.muddaThumb.value =
                                value.path;
                          });
                        }
                        else{
                          createMuddaController!.muddaThumb.value =
                              value.path;
                        }
                      });
                    }
                  } on PlatformException catch (e) {
                    print('FAILED $e');
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Future<File> testCompressAndGetFile(int quality,File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: quality,
    );
    if(result!.lengthSync()>150000 && quality>0){
      result = await testCompressAndGetFile(quality-=10,
          file, '${file.path}compressed.jpg');
    }
    return File(result.path);
  }

  Future<File> _cropImage(File profileImageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: profileImageFile.path,
        // aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          )
        ]);
    return File(croppedFile!.path);
  }

  _getRoles(BuildContext context) async {
    Api.get.call(context,
        method: "user/my-roles",
        param: {
          "page": rolePage.toString(),
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "interactModal": "CreateMudda"
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = UserRolesModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        if (rolePage == 1) {
          createMuddaController!.roleList.clear();
        }
        createMuddaController!.roleProfilePath.value = result.path!;
        createMuddaController!.roleList.addAll(result.data!);
        Role role = Role();
        role.user = User();
        role.user!.profile = AppPreference().getString(PreferencesKey.profile);
        role.user!.fullname = "Self";
        role.user!.sId = AppPreference().getString(PreferencesKey.userId);
        createMuddaController!.roleList.add(role);
      } else {
        if (rolePage == 1) {
          Role role = Role();
          role.user = User();
          role.user!.profile =
              AppPreference().getString(PreferencesKey.profile);
          role.user!.fullname = "Self";
          role.user!.sId = AppPreference().getString(PreferencesKey.userId);
          createMuddaController!.roleProfilePath.value =
              AppPreference().getString(PreferencesKey.profilePath);
          createMuddaController!.roleList.add(role);
        }
        rolePage = rolePage > 1 ? rolePage - 1 : rolePage;
      }
    });
  }

  showRolesDialog(BuildContext context, bool isMudda) {
    return showDialog(
      context: Get.context as BuildContext,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(16))),
            padding: EdgeInsets.only(
                top: ScreenUtil().setSp(24),
                left: ScreenUtil().setSp(24),
                right: ScreenUtil().setSp(24),
                bottom: ScreenUtil().setSp(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Interact as",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(13),
                        color: black,
                        decoration: TextDecoration.underline,
                        decorationColor: black)),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: roleController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                      itemCount: createMuddaController!.roleList.length,
                      itemBuilder: (followersContext, index) {
                        Role role = createMuddaController!.roleList[index];
                        return InkWell(
                          onTap: () {
                            if (isMudda) {
                              createMuddaController!.selectedRole.value = role;
                            } else {
                              createMuddaController!.selectedSurveyRole.value =
                                  role;
                            }
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(role.user!.fullname!,
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(13),
                                            color: black))),
                                SizedBox(
                                  width: ScreenUtil().setSp(14),
                                ),
                                role.user!.profile != null
                                    ? SizedBox(
                                        width: ScreenUtil().setSp(30),
                                        height: ScreenUtil().setSp(30),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${createMuddaController!.roleProfilePath}${role.user!.profile}",
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: ScreenUtil().setSp(30),
                                            height: ScreenUtil().setSp(30),
                                            decoration: BoxDecoration(
                                              color: colorWhite,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(.2),
                                                    blurRadius: 5.0,
                                                    offset: const Offset(0, 5))
                                              ],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setSp(
                                                          4)) //                 <--- border radius here
                                                  ),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      )
                                    : Container(
                                        height: ScreenUtil().setSp(30),
                                        width: ScreenUtil().setSp(30),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: darkGray,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(ScreenUtil().setSp(
                                                  4)) //                 <--- border radius here
                                              ),
                                        ),
                                        child: Center(
                                          child: Text(
                                              role.user!.fullname![0]
                                                  .toUpperCase(),
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(20),
                                                  color: black)),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// -=-=-
// class RaisingMuddaScreen extends StatefulWidget {
//   const RaisingMuddaScreen({Key? key}) : super(key: key);
//
//   @override
//   State<RaisingMuddaScreen> createState() => _RaisingMuddaScreenState();
// }
//
// class _RaisingMuddaScreenState extends State<RaisingMuddaScreen> {
//
//   CreateMuddaController? createMuddaController;
//   final Trimmer _trimmer = Trimmer();
//
//   TextEditingController tags = TextEditingController();
//   TextEditingController locationController = TextEditingController();
//   var h, w;
//   MuddaNewsController? muddaNewsController;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   int rolePage = 1;
//   ScrollController roleController = ScrollController();
//   UserProfileUpdateController? userProfileUpdateController;
//   var scopeValue;
//
//   @override
//   void initState() {
//     super.initState();
//     rolePage = 1;
//     muddaNewsController = Get.find<MuddaNewsController>();
//     createMuddaController = Get.find<CreateMuddaController>();
//     w = MediaQuery.of(context).size.width;
//     h = MediaQuery.of(context).size.height;
//     if (muddaNewsController!.muddaPost.value.initialScope != null) {
//       createMuddaController!.dropdownScopeValue.value =
//       muddaNewsController!.muddaPost.value.initialScope != null
//           ? muddaNewsController!.muddaPost.value.initialScope!
//           : "District";
//     }
//     // if(muddaNewsController!.muddaPost.value.title != null){
//     //   createMuddaController!.titleValue.value = muddaNewsController!.muddaPost.value.title!;
//     // }
//     // if(muddaNewsController!.muddaPost.value.muddaDescription != null){
//     //   createMuddaController!.descriptionValue.value = muddaNewsController!.muddaPost.value.muddaDescription!;
//     // }
//     // if(muddaNewsController!.muddaPost.value.city != null){
//     //   createMuddaController!.city.value = muddaNewsController!.muddaPost.value.city!;
//     // }
//     // if(muddaNewsController!.muddaPost.value.state != null){
//     //   createMuddaController!.state.value = muddaNewsController!.muddaPost.value.state!;
//     // }
//     // if(muddaNewsController!.muddaPost.value.country != null){
//     //   createMuddaController!.country.value = muddaNewsController!.muddaPost.value.country!;
//     // }
//     locationController.text = muddaNewsController!.muddaPost.value.city != null
//         ? "${muddaNewsController!.muddaPost.value.city ?? ''}, ${muddaNewsController!.muddaPost.value.state ?? ''}, ${muddaNewsController!.muddaPost.value.country ?? ''}"
//         : createMuddaController!.searchLocation.value;
//     if (muddaNewsController!.muddaPost.value.hashtags != null) {
//       createMuddaController!.categoryList.clear();
//       for (String tag in muddaNewsController!.muddaPost.value.hashtags!) {
//         createMuddaController!.categoryList.add(Category(name: tag));
//       }
//     }
//     if (muddaNewsController!.muddaPost.value.title == null) {
//       roleController.addListener(() {
//         if (roleController.position.maxScrollExtent ==
//             roleController.position.pixels) {
//           rolePage++;
//           _getRoles(context);
//         }
//       });
//       _getRoles(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: colorAppBackground,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Get.back();
//                   },
//                   child: const Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.black,
//                     size: 25,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: TabBar(
//                       indicatorColor: Colors.transparent,
//                       labelColor: Colors.black,
//                       labelStyle: size16_M_bold(textColor: Colors.black),
//                       unselectedLabelStyle:
//                       size14_M_normal(textColor: Colors.grey),
//                       labelPadding: EdgeInsets.zero,
//                       indicatorPadding: EdgeInsets.zero,
//                       tabs: const [
//                         Tab(
//                           text: "Create Mudda",
//                         ),
//                         Tab(
//                           text: "Initiate Survey",
//                         )
//                       ],
//                       controller: createMuddaController!.controller),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: TabBarView(children: [
//         Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(left: 30, right: 30),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Hi,\nYour Mudda is sent back for Corrections. Please check the below and revert-",
//                       style: size12_M_regular(textColor: black),
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "1. ",
//                           style: size12_M_regular(textColor: black),
//                         ),
//                         Expanded(
//                           child: Text(
//                             "${adminMessage == null ? "A" : adminMessage[0]['data']['body']['message']}",
//                             // "Mudda Name is matching with another one. Please keep the name unique or join that mudda with the same name",
//                             /* Get.arguments['adminMessage'] == null
//                                 ? "A"
//                                 : "${Get.arguments['adminMessage']['body']['message']}",*/
//                             style: size12_M_regular(textColor: black),
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Row(
//                     //   crossAxisAlignment: CrossAxisAlignment.start,
//                     //   children: [
//                     //     Text(
//                     //       "2. ",
//                     //       style: size12_M_regular(textColor: black),
//                     //     ),
//                     //     Expanded(
//                     //       child: Text(
//                     //         "Images uploaded doesn’t confirm to your Mudda Purpose. We encourge you to upload only relevant Mudda to keep the Mudda Platform Clean & Safe.",
//                     //         style: size12_M_regular(textColor: black),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     Text(
//                       "Once you have updated the same, please resubmit your Mudda",
//                       style: size12_M_regular(textColor: black),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           "-Regards",
//                           style: size12_M_regular(textColor: black),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           "Mudda Admin",
//                           style: size12_M_regular(textColor: black),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 51,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 20),
//                       decoration: BoxDecoration(
//                         color: white,
//                         borderRadius: BorderRadius.circular(10),
//                         // border: Border.all(color: colorGrey),
//                       ),
//                       child: TextFormField(
//                         textCapitalization: TextCapitalization.sentences,
//                         keyboardType: TextInputType.multiline,
//                         maxLines: 3,
//                         // maxLength: 600,
//                         // initialValue: muddaNewsController!.muddaPost.value.muddaDescription ?? "",
//                         // onChanged: (text) {
//                         //   muddaNewsController!.muddaPost.value.muddaDescription =
//                         //       text;
//                         //   muddaNewsController!.descriptionValue.value = text;
//                         // },
//                         style: size14_M_normal(textColor: color606060),
//                         decoration: InputDecoration(
//                           // counterText: '',
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 10),
//                           hintText: "Your Comments",
//                           border: InputBorder.none,
//                           hintStyle: size12_M_normal(textColor: grey),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       log("-=-=- Chat with Support -=-=-");
//                       // AcceptUserDetail user =
//                       //     userProfileUpdateController!.userProfile.value;
//                       // Map<String, String>? parameters = {
//                       //   "user": jsonEncode(user)
//                       // };
//                       // Get.toNamed(RouteConstants.chatPage,
//                       //     parameters: parameters);
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(right: 30),
//                       child: Column(
//                         children: [
//                           Image.asset(
//                             AppIcons.circleChat2Tab,
//                             height: 20,
//                             width: 20,
//                             color: grey,
//                           ),
//                           getSizedBox(h: 5),
//                           Text(
//                             "Chat with\nSupport",
//                             textAlign: TextAlign.center,
//                             style: size12_M_regular(textColor: black),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                         alignment: Alignment.center,
//                         height: h * 0.06,
//                         child: Text("Scope:")),
//                     getSizedBox(w: 6),
//                     SizedBox(
//                       width: w * 0.25,
//                       child: muddaNewsController!
//                           .muddaPost.value.initialScope !=
//                           null
//                           ? Container(
//                         alignment: Alignment.centerLeft,
//                         height: h * 0.06,
//                         child: Text(
//                           createMuddaController!.dropdownScopeValue.value,
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.bold,
//                             color: colorGrey,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       )
//                           : Obx(
//                             () => DropdownButtonHideUnderline(
//                           child: DropdownButton2(
//                             isExpanded: true,
//                             hint: Row(
//                               children: [
//                                 const SizedBox(
//                                   width: 4,
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     createMuddaController!
//                                         .dropdownScopeValue.value,
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.bold,
//                                       color: colorGrey,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             items: createMuddaController!.scopeList
//                                 .map((item) => DropdownMenuItem<String>(
//                               value: item,
//                               child: Text(
//                                 item,
//                                 style: TextStyle(
//                                   fontSize: 14.sp,
//                                   color: Colors.black,
//                                   letterSpacing: 0.50,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ))
//                                 .toList(),
//                             onChanged: (value) {
//                               print("value $value");
//                               createMuddaController!.dropdownScopeValue
//                                   .value = value.toString();
//                             },
//                             value: scopeValue,
//                             icon: const Icon(
//                               Icons.keyboard_arrow_down_sharp,
//                               size: 30,
//                             ),
//                             iconSize: 14,
//                             iconEnabledColor: Colors.black,
//                             iconDisabledColor: Colors.grey,
//                             dropdownMaxHeight: h * 0.3,
//                             dropdownWidth: w * 0.3,
//                             dropdownDecoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(14),
//                               color: colorWhite,
//                             ),
//                             dropdownElevation: 8,
//                             scrollbarRadius: const Radius.circular(40),
//                             scrollbarThickness: 6,
//                             scrollbarAlwaysShow: true,
//                             offset: const Offset(-1, 0),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         Get.defaultDialog(
//                           radius: 10.w,
//                           content: Image.asset(AppIcons.dialogAlert),
//                           titlePadding: EdgeInsets.only(top: 5.h),
//                           title: "",
//                           titleStyle: TextStyle(
//                             fontSize: 1.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           contentPadding: EdgeInsets.zero,
//                         );
//                       },
//                       child: Text("Know More "),
//                     ),
//                     Obx(
//                           () => InkWell(
//                           onTap: () {
//                             uploadProfilePic(context);
//                           },
//                           child: createMuddaController!
//                               .muddaThumb.value.isNotEmpty
//                               ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey)),
//                             child: Image.file(
//                               File(createMuddaController!
//                                   .muddaThumb.value),
//                               height: 100,
//                               width: 100,
//                             ),
//                           )
//                               : muddaNewsController!
//                               .muddaPost.value.thumbnail !=
//                               null
//                               ? Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                                 border:
//                                 Border.all(color: Colors.grey)),
//                             child: Image.network(
//                               "${muddaNewsController!.muddaProfilePath.value}${muddaNewsController!.muddaPost.value.thumbnail}",
//                               height: 100,
//                               width: 100,
//                             ),
//                           )
//                               : Container(
//                             height: 100,
//                             width: 100,
//                             child: Column(
//                               children: [
//                                 const SizedBox(height: 30),
//                                 const Icon(
//                                   Icons.camera_alt,
//                                   size: 50,
//                                   color: Colors.grey,
//                                 ),
//                                 Text(
//                                   "Mudda Thumbnail",
//                                   style: size10_M_normal(
//                                       textColor: Colors.grey),
//                                 )
//                               ],
//                             ),
//                             decoration: BoxDecoration(
//                                 border:
//                                 Border.all(color: Colors.grey)),
//                           )),
//                     )
//                   ],
//                 ),
//               ),
//               getSizedBox(h: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.black),
//                     ),
//                   ),
//                   child: TextFormField(
//                     focusNode:
//                     muddaNewsController!.muddaPost.value.initialScope !=
//                         null
//                         ? AlwaysDisabledFocusNode()
//                         : null,
//                     inputFormatters: [
//                       LengthLimitingTextInputFormatter(50),
//                     ],
//                     initialValue:
//                     muddaNewsController!.muddaPost.value.title ?? "",
//                     style: size18_M_bold(textColor: Colors.black),
//                     maxLines: 2,
//                     minLines: 2,
//                     onChanged: (text) {
//                       muddaNewsController!.muddaPost.value.title = text;
//                       muddaNewsController!.titleValue.value = text;
//                     },
//                     validator: (value) {
//                       return Validator.validateFormField(value!, "Enter Title",
//                           "Enter Valid Title", Constants.NORMAL_VALIDATION);
//                     },
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText:
//                       "ENTER YOUR MUDDA NAME HERE AS SHORT & CRISPY AS POSSIBLE",
//                       hintStyle: size18_M_bold(textColor: Colors.black),
//                     ),
//                   ),
//                 ),
//               ),
//               getSizedBox(h: 2),
//               Obx(
//                     () => Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     children: [
//                       Text(
//                         "You won’t be able to change this name later on",
//                         style: size10_M_normal(textColor: Colors.blue),
//                       ),
//                       Spacer(),
//                       Visibility(
//                         visible:
//                         muddaNewsController!.muddaPost.value.initialScope ==
//                             null,
//                         child: Text(
//                           "remain ${50 - muddaNewsController!.titleValue.value.length} characters",
//                           style: size10_M_normal(textColor: colorGrey),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               getSizedBox(h: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   height: 150,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: colorGrey)),
//                   child: TextFormField(
//                     textCapitalization: TextCapitalization.sentences,
//                     keyboardType: TextInputType.multiline,
//                     maxLines: 10,
//                     maxLength: 600,
//                     initialValue:
//                     muddaNewsController!.muddaPost.value.muddaDescription ??
//                         "",
//                     onChanged: (text) {
//                       muddaNewsController!.muddaPost.value.muddaDescription =
//                           text;
//                       muddaNewsController!.descriptionValue.value = text;
//                     },
//                     style: size14_M_normal(textColor: color606060),
//                     decoration: InputDecoration(
//                       counterText: '',
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 10),
//                       hintText:
//                       "Enter Mudda Description, Your Vision, why people should support you...etc",
//                       border: InputBorder.none,
//                       hintStyle: size12_M_normal(textColor: color606060),
//                     ),
//                   ),
//                 ),
//               ),
//               Obx(
//                     () => Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         "remain ${600 - muddaNewsController!.descriptionValue.value.length} characters",
//                         style: size10_M_normal(textColor: colorGrey),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               getSizedBox(h: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Upload Photo / Video",
//                       style: size10_M_semibold(textColor: Colors.black),
//                     ),
//                     Text(
//                       " (Optional)",
//                       style: size10_M_normal(textColor: Colors.grey),
//                     )
//                   ],
//                 ),
//               ),
//               getSizedBox(h: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   height: 1,
//                   color: Colors.white,
//                 ),
//               ),
//               getSizedBox(h: 10),
//               muddaNewsController!.muddaPost.value.gallery != null
//                   ? Padding(
//                 padding: const EdgeInsets.only(left: 20),
//                 child: SizedBox(
//                   height: 100,
//                   child: Obx(
//                         () => ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: createMuddaController!
//                             .uploadPhotoVideos.length +
//                             muddaNewsController!
//                                 .muddaPost.value.gallery!.length >
//                             5
//                             ? 5
//                             : createMuddaController!
//                             .uploadPhotoVideos.length +
//                             muddaNewsController!
//                                 .muddaPost.value.gallery!.length,
//                         itemBuilder: (followersContext, index) {
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 10),
//                             child: ((createMuddaController!
//                                 .uploadPhotoVideos
//                                 .length +
//                                 muddaNewsController!.muddaPost
//                                     .value.gallery!.length) -
//                                 index) ==
//                                 1
//                                 ? InkWell(
//                               onTap: () {
//                                 uploadPic(context);
//                               },
//                               child: Container(
//                                 height: 100,
//                                 width: 100,
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.camera_alt,
//                                     size: 50,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                         color: Colors.grey)),
//                               ),
//                             )
//                                 : muddaNewsController!.muddaPost.value
//                                 .gallery!.length >
//                                 index
//                                 ? SizedBox(
//                               height: ScreenUtil().setSp(100),
//                               width: ScreenUtil().setSp(100),
//                               child: Stack(
//                                 children: [
//                                   Container(
//                                     height:
//                                     ScreenUtil().setSp(100),
//                                     width:
//                                     ScreenUtil().setSp(100),
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color:
//                                             Colors.grey)),
//                                     child: CachedNetworkImage(
//                                       imageUrl:
//                                       "${muddaNewsController!.muddaProfilePath.value}${muddaNewsController!.muddaPost.value.gallery!.elementAt(index).file!}",
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Align(
//                                     alignment:
//                                     Alignment.topRight,
//                                     child: InkWell(
//                                       onTap: () {
//                                         Api.delete.call(context,
//                                             method:
//                                             "mudda/image-delete/${muddaNewsController!.muddaPost.value.gallery!.elementAt(index).sId!}",
//                                             param: {
//                                               "_id":
//                                               muddaNewsController!
//                                                   .muddaPost
//                                                   .value
//                                                   .gallery!
//                                                   .elementAt(
//                                                   index)
//                                                   .sId!
//                                             },
//                                             isLoading: true,
//                                             onResponseSuccess:
//                                                 (Map object) {
//                                               print(object);
//                                               muddaNewsController!
//                                                   .muddaPost
//                                                   .value
//                                                   .gallery!
//                                                   .removeAt(index);
//                                               createMuddaController!
//                                                   .uploadPhotoVideos
//                                                   .removeAt(createMuddaController!
//                                                   .uploadPhotoVideos
//                                                   .length -
//                                                   1);
//                                               createMuddaController!
//                                                   .uploadPhotoVideos
//                                                   .insert(
//                                                   createMuddaController!
//                                                       .uploadPhotoVideos
//                                                       .length,
//                                                   "");
//                                             });
//                                       },
//                                       child: Container(
//                                         decoration: const BoxDecoration(
//                                             color: white,
//                                             borderRadius:
//                                             BorderRadius
//                                                 .all(Radius
//                                                 .circular(
//                                                 20))),
//                                         child: const Padding(
//                                           padding:
//                                           EdgeInsets.all(2),
//                                           child:
//                                           Icon(Icons.close),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             )
//                                 : Container(
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: Colors.grey)),
//                               child: createMuddaController!
//                                   .uploadPhotoVideos
//                                   .elementAt(index -
//                                   muddaNewsController!
//                                       .muddaPost
//                                       .value
//                                       .gallery!
//                                       .length)
//                                   .contains("Trimmer")
//                                   ? Stack(
//                                 children: [
//                                   SizedBox(
//                                     height: 100,
//                                     width: 100,
//                                     child: VideoViewer(
//                                         trimmer:
//                                         _trimmer),
//                                   )
//                                 ],
//                               )
//                                   : Image.file(
//                                 File(createMuddaController!
//                                     .uploadPhotoVideos
//                                     .elementAt(index -
//                                     muddaNewsController!
//                                         .muddaPost
//                                         .value
//                                         .gallery!
//                                         .length)),
//                                 height: 100,
//                                 width: 100,
//                               ),
//                             ),
//                           );
//                         }),
//                   ),
//                 ),
//               )
//                   : Padding(
//                 padding: const EdgeInsets.only(left: 20),
//                 child: SizedBox(
//                   height: 100,
//                   child: Obx(
//                         () => ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: createMuddaController!
//                             .uploadPhotoVideos.length >
//                             5
//                             ? 5
//                             : createMuddaController!
//                             .uploadPhotoVideos.length,
//                         itemBuilder: (followersContext, index) {
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 10),
//                             child: GestureDetector(
//                               onTap: () {
//                                 if ((createMuddaController!
//                                     .uploadPhotoVideos.length -
//                                     index) ==
//                                     1) {
//                                   uploadPic(context);
//                                 } else {
//                                   // muddaVideoDialog(context,
//                                   //     createMuddaController!.uploadPhotoVideos);
//                                 }
//                               },
//                               child: (createMuddaController!
//                                   .uploadPhotoVideos.length -
//                                   index) ==
//                                   1
//                                   ? Container(
//                                 height: 100,
//                                 width: 100,
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.camera_alt,
//                                     size: 50,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                         color: Colors.grey)),
//                               )
//                                   : Container(
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: Colors.grey)),
//                                 child: createMuddaController!
//                                     .uploadPhotoVideos
//                                     .elementAt(index)
//                                     .contains("Trimmer")
//                                     ? Stack(
//                                   children: [
//                                     SizedBox(
//                                       height: 100,
//                                       width: 100,
//                                       child: VideoViewer(
//                                           trimmer: _trimmer),
//                                     )
//                                   ],
//                                 )
//                                     : Image.file(
//                                   File(createMuddaController!
//                                       .uploadPhotoVideos
//                                       .elementAt(index)),
//                                   height: 100,
//                                   width: 100,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                   ),
//                 ),
//               ),
//               getSizedBox(h: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   height: 1,
//                   color: Colors.white,
//                 ),
//               ),
//               getSizedBox(h: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(children: [
//                   const Icon(Icons.location_on_outlined, size: 15),
//                   getSizedBox(w: 5),
//                   Expanded(
//                     child: TypeAheadFormField<Place>(
//                       textFieldConfiguration: TextFieldConfiguration(
//                           controller: locationController,
//                           keyboardType: TextInputType.multiline,
//                           minLines: 1,
//                           maxLines: 3,
//                           style: GoogleFonts.nunitoSans(
//                               color: darkGray,
//                               fontWeight: FontWeight.w300,
//                               fontSize: ScreenUtil().setSp(12)),
//                           decoration: InputDecoration(
//                               hintText: "Origin Location",
//                               hintStyle: GoogleFonts.nunitoSans(
//                                   color: darkGray,
//                                   fontWeight: FontWeight.w300,
//                                   fontSize: ScreenUtil().setSp(12)))),
//                       suggestionsCallback: (pattern) {
//                         return _getLocation(pattern, context);
//                       },
//                       hideSuggestionsOnKeyboardHide: false,
//                       itemBuilder: (context, suggestion) {
//                         return Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Text(
//                             "${suggestion.district}, ${suggestion.state}, ${suggestion.country}",
//                             style: GoogleFonts.nunitoSans(
//                                 color: darkGray,
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: ScreenUtil().setSp(12)),
//                           ),
//                         );
//                       },
//                       transitionBuilder: (context, suggestionsBox, controller) {
//                         return suggestionsBox;
//                       },
//                       onSuggestionSelected: (suggestion) async {
//                         locationController.text =
//                         "${suggestion.district}, ${suggestion.state}, ${suggestion.country}";
//                         muddaNewsController!.muddaPost.value.city =
//                         suggestion.district!;
//                         muddaNewsController!.muddaPost.value.state =
//                         suggestion.state!;
//                         muddaNewsController!.muddaPost.value.country =
//                         suggestion.country!;
//                       },
//                     ),
//                   ),
//                   Image.asset(
//                     AppIcons.downArrow2,
//                     height: 10,
//                     width: 10,
//                     color: Colors.black,
//                   )
//                 ]),
//               ),
//               getSizedBox(h: 10),
//               Obx(
//                     () => Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Wrap(
//                       spacing: 5,
//                       children: List.generate(
//                           createMuddaController!.categoryList.length, (index) {
//                         return Chip(
//                           label: Text(
//                               createMuddaController!.categoryList[index].name!),
//                           onDeleted: () {
//                             createMuddaController!.categoryList.removeAt(index);
//                           },
//                         );
//                       })),
//                 ),
//               ),
//               getSizedBox(h: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   height: 30,
//                   child: Row(children: [
//                     const Text("#"),
//                     getSizedBox(w: 5),
//                     Expanded(
//                       child: TypeAheadFormField<Category>(
//                         textFieldConfiguration: TextFieldConfiguration(
//                             style: GoogleFonts.nunitoSans(
//                                 color: darkGray,
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: ScreenUtil().setSp(12)),
//                             decoration: InputDecoration(
//                                 hintText: "category",
//                                 hintStyle: GoogleFonts.nunitoSans(
//                                     color: darkGray,
//                                     fontWeight: FontWeight.w300,
//                                     fontSize: ScreenUtil().setSp(12)))),
//                         suggestionsCallback: (pattern) {
//                           return _getCategory(pattern, context);
//                         },
//                         hideSuggestionsOnKeyboardHide: false,
//                         itemBuilder: (context, suggestion) {
//                           return Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Text(
//                               suggestion.name!,
//                               style: GoogleFonts.nunitoSans(
//                                   color: darkGray,
//                                   fontWeight: FontWeight.w300,
//                                   fontSize: ScreenUtil().setSp(12)),
//                             ),
//                           );
//                         },
//                         transitionBuilder:
//                             (context, suggestionsBox, controller) {
//                           return suggestionsBox;
//                         },
//                         onSuggestionSelected: (suggestion) {
//                           if (createMuddaController!.categoryList.length < 3) {
//                             createMuddaController!.categoryList.add(suggestion);
//                             if (muddaNewsController!.muddaPost.value.hashtags !=
//                                 null) {
//                               muddaNewsController!.muddaPost.value.hashtags!
//                                   .add(suggestion.name!);
//                             }
//                           } else {
//                             var snackBar = const SnackBar(
//                               content: Text('Max 3 allowed'),
//                             );
//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(snackBar);
//                           }
//                         },
//                       ),
//                     ),
//                     Text(
//                       "(max 3)",
//                       style: size12_M_normal(textColor: Colors.grey),
//                     ),
//                   ]),
//                 ),
//               ),
//               getSizedBox(h: 20),
//               muddaNewsController!.muddaPost.value.initialScope == null
//                   ? Obx(
//                     () => Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: InkWell(
//                     onTap: () {
//                       showRolesDialog(context, true);
//                     },
//                     child: Row(
//                       children: [
//                         Text("Create as:",
//                             style: GoogleFonts.nunitoSans(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: ScreenUtil().setSp(12),
//                                 color: blackGray)),
//                         getSizedBox(w: 6),
//                         createMuddaController!.selectedRole.value.user !=
//                             null
//                             ? createMuddaController!.selectedRole.value
//                             .user!.profile !=
//                             null
//                             ? CachedNetworkImage(
//                           imageUrl:
//                           "${createMuddaController!.roleProfilePath.value}${createMuddaController!.selectedRole.value.user!.profile}",
//                           imageBuilder:
//                               (context, imageProvider) =>
//                               Container(
//                                 width: ScreenUtil().setSp(30),
//                                 height: ScreenUtil().setSp(30),
//                                 decoration: BoxDecoration(
//                                   color: colorWhite,
//                                   border: Border.all(
//                                     width: ScreenUtil().setSp(1),
//                                     color: buttonBlue,
//                                   ),
//                                   borderRadius: BorderRadius.all(
//                                       Radius.circular(ScreenUtil()
//                                           .setSp(
//                                           15)) //                 <--- border radius here
//                                   ),
//                                   image: DecorationImage(
//                                       image: imageProvider,
//                                       fit: BoxFit.cover),
//                                 ),
//                               ),
//                           placeholder: (context, url) =>
//                               CircleAvatar(
//                                 backgroundColor: lightGray,
//                                 radius: ScreenUtil().setSp(15),
//                               ),
//                           errorWidget: (context, url, error) =>
//                               CircleAvatar(
//                                 backgroundColor: lightGray,
//                                 radius: ScreenUtil().setSp(15),
//                               ),
//                         )
//                             : Container(
//                           height: ScreenUtil().setSp(30),
//                           width: ScreenUtil().setSp(30),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: darkGray,
//                             ),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Text(
//                                 createMuddaController!
//                                     .selectedRole
//                                     .value
//                                     .user!
//                                     .fullname![0]
//                                     .toUpperCase(),
//                                 style: GoogleFonts.nunitoSans(
//                                     fontWeight: FontWeight.w400,
//                                     fontSize:
//                                     ScreenUtil().setSp(16),
//                                     color: black)),
//                           ),
//                         )
//                             : AppPreference()
//                             .getString(PreferencesKey.profile)
//                             .isNotEmpty
//                             ? CachedNetworkImage(
//                           imageUrl:
//                           "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
//                           imageBuilder:
//                               (context, imageProvider) =>
//                               Container(
//                                 width: ScreenUtil().setSp(30),
//                                 height: ScreenUtil().setSp(30),
//                                 decoration: BoxDecoration(
//                                   color: colorWhite,
//                                   border: Border.all(
//                                     width: ScreenUtil().setSp(1),
//                                     color: buttonBlue,
//                                   ),
//                                   borderRadius: BorderRadius.all(
//                                       Radius.circular(ScreenUtil()
//                                           .setSp(
//                                           15)) //                 <--- border radius here
//                                   ),
//                                   image: DecorationImage(
//                                       image: imageProvider,
//                                       fit: BoxFit.cover),
//                                 ),
//                               ),
//                           placeholder: (context, url) =>
//                               CircleAvatar(
//                                 backgroundColor: lightGray,
//                                 radius: ScreenUtil().setSp(15),
//                               ),
//                           errorWidget: (context, url, error) =>
//                               CircleAvatar(
//                                 backgroundColor: lightGray,
//                                 radius: ScreenUtil().setSp(15),
//                               ),
//                         )
//                             : Container(
//                           height: ScreenUtil().setSp(30),
//                           width: ScreenUtil().setSp(30),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: darkGray,
//                             ),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Text(
//                                 AppPreference()
//                                     .getString(PreferencesKey
//                                     .fullName)[0]
//                                     .toUpperCase(),
//                                 style: GoogleFonts.nunitoSans(
//                                     fontWeight: FontWeight.w400,
//                                     fontSize:
//                                     ScreenUtil().setSp(16),
//                                     color: black)),
//                           ),
//                         ),
//                         getSizedBox(w: 6),
//                         Text(
//                             createMuddaController!
//                                 .selectedRole.value.user !=
//                                 null
//                                 ? createMuddaController!
//                                 .selectedRole.value.user!.fullname!
//                                 : "Self",
//                             style: GoogleFonts.nunitoSans(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: ScreenUtil().setSp(10),
//                                 color: buttonBlue,
//                                 fontStyle: FontStyle.italic)),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//                   : Container(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GetStartedButton(
//                     onTap: () async {
//                       if (_formKey.currentState!.validate()) {
//                         List<String> idList = [];
//                         for (Category challenges
//                         in createMuddaController!.categoryList) {
//                           idList.add(challenges.name!);
//                         }
//                         AppPreference _appPreference = AppPreference();
//                         FormData formData = FormData.fromMap({
//                           "title": muddaNewsController!.muddaPost.value.title!,
//                           "mudda_description": muddaNewsController!
//                               .muddaPost.value.muddaDescription!,
//                           "initial_scope": createMuddaController!
//                               .dropdownScopeValue.value
//                               .toLowerCase(),
//                           "city": muddaNewsController!.muddaPost.value.city!,
//                           "country":
//                           muddaNewsController!.muddaPost.value.country!,
//                           "state": muddaNewsController!.muddaPost.value.state!,
//                           "hashtags": jsonEncode(idList),
//                           "user_id": createMuddaController!
//                               .selectedRole.value.user !=
//                               null
//                               ? createMuddaController!
//                               .selectedRole.value.user!.sId
//                               : _appPreference.getString(PreferencesKey.userId),
//                         });
//                         if (createMuddaController!
//                             .muddaThumb.value.isNotEmpty) {
//                           var video = await MultipartFile.fromFile(
//                               createMuddaController!.muddaThumb.value,
//                               filename: createMuddaController!.muddaThumb.value
//                                   .split('/')
//                                   .last);
//                           formData.files.addAll([
//                             MapEntry("thumbnail", video),
//                           ]);
//                         }
//                         for (int i = 0;
//                         i <
//                             (createMuddaController!
//                                 .uploadPhotoVideos.length +
//                                 (muddaNewsController!.muddaPost
//                                     .value.gallery !=
//                                     null
//                                     ? muddaNewsController!.muddaPost
//                                     .value.gallery!.length
//                                     : 0) ==
//                                 5
//                                 ? 5
//                                 : (createMuddaController!
//                                 .uploadPhotoVideos.length -
//                                 1));
//                         i++) {
//                           formData.files.addAll([
//                             MapEntry(
//                                 "gallery",
//                                 await MultipartFile.fromFile(
//                                     createMuddaController!.uploadPhotoVideos[i],
//                                     filename: createMuddaController!
//                                         .uploadPhotoVideos[i]
//                                         .split('/')
//                                         .last)),
//                           ]);
//                         }
//                         if (muddaNewsController!.muddaPost.value.sId != null) {
//                           formData.fields.addAll([
//                             MapEntry("_id",
//                                 muddaNewsController!.muddaPost.value.sId!)
//                           ]);
//                           Api.uploadPost.call(context,
//                               method: "mudda/update",
//                               param: formData,
//                               isLoading: true, onResponseSuccess: (Map object) {
//                                 print(object);
//                                 var snackBar = const SnackBar(
//                                   content: Text('Updated'),
//                                 );
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(snackBar);
//                                 createMuddaController!.muddaId.value =
//                                 muddaNewsController!.muddaPost.value.sId!;
//                                 createMuddaController!.muddaPost.value =
//                                     muddaNewsController!.muddaPost.value;
//                                 Get.offNamed(RouteConstants
//                                     .raisingMuddaAdditionalInformation);
//                               });
//                         } else {
//                           Api.uploadPost.call(context,
//                               method: "mudda/store",
//                               param: formData,
//                               isLoading: true, onResponseSuccess: (Map object) {
//                                 print(object);
//                                 var snackBar = const SnackBar(
//                                   content: Text('Uploaded'),
//                                 );
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(snackBar);
//                                 print("ID::" + object['data']['_id']);
//                                 var id = object['data']['_id'];
//                                 createMuddaController!.muddaId.value =
//                                     id.toString();
//                                 createMuddaController!.muddaPost.value =
//                                     MuddaPost.fromJson(object['data']);
//                                 Get.offNamed(RouteConstants
//                                     .raisingMuddaAdditionalInformation);
//                               });
//                         }
//                       }
//                     },
//                     title: "Create",
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//         InitiateSurvey(
//             muddaNewsController!, createMuddaController!, roleController),
//       ], controller: createMuddaController!.controller),
//     );
//   }
//   Future<List<Category>> _getCategory(
//       String query, BuildContext context) async {
//     List<Category> matches = <Category>[];
//     if (query.isNotEmpty) {
//       var responce = await Api.get.futureCall(context,
//           method: "category/index",
//           param: {"page": "1", "search": query},
//           isLoading: false);
//       print("RES:::${responce.data!}");
//       var result = CategoryListModel.fromJson(responce.data!);
//       return result.data!;
//     } else {
//       return matches;
//     }
//   }
//
//   Future<List<Place>> _getLocation(String query, BuildContext context) async {
//     List<Place> matches = <Place>[];
//     createMuddaController!.searchLocation.value = query;
//     if (query.length >= 3 && query.length < 20) {
//       var responce = await Api.get.futureCall(context,
//           method: "country/location",
//           param: {
//             "search": query,
//             "page": "1",
//             "search_type": "district",
//           },
//           isLoading: false);
//       if (responce != null) {
//         final result = PlaceModel.fromJson(responce.data!);
//         return result.data!;
//       } else {
//         return matches;
//       }
//     } else {
//       return matches;
//     }
//   }
//
//   Future uploadPic(BuildContext context) async {
//     return showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                   leading: const Icon(Icons.photo_library),
//                   title: const Text('Photo Library'),
//                   onTap: () async {
//                     try {
//                       final pickedFile = await ImagePicker()
//                           .pickImage(source: ImageSource.gallery);
//                       if (pickedFile != null) {
//                         _cropImage(File(pickedFile.path)).then((value) async {
//                           createMuddaController!.uploadPhotoVideos.insert(
//                               createMuddaController!.uploadPhotoVideos.length -
//                                   1,
//                               value.path);
//                         });
//                       }
//                       ;
//                     } on PlatformException catch (e) {
//                       print('FAILED $e');
//                     }
//                     Navigator.of(context).pop();
//                   }),
//               ListTile(
//                 leading: const Icon(Icons.photo_camera),
//                 title: const Text('Camera'),
//                 onTap: () async {
//                   try {
//                     final pickedFile = await ImagePicker()
//                         .pickImage(source: ImageSource.camera);
//                     if (pickedFile != null) {
//                       _cropImage(File(pickedFile.path)).then((value) async {
//                         createMuddaController!.uploadPhotoVideos.insert(
//                             createMuddaController!.uploadPhotoVideos.length - 1,
//                             value.path);
//                       });
//                     }
//                   } on PlatformException catch (e) {
//                     print('FAILED $e');
//                   }
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                   leading: const Icon(Icons.photo_library),
//                   title: const Text('Video Library'),
//                   onTap: () async {
//                     try {
//                       Navigator.of(context).pop();
//                       var result = await ImagePicker()
//                           .pickVideo(source: ImageSource.gallery);
//                       if (result != null) {
//                         File file = File(result.path);
//                         // print("ORG:::${_getVideoSize(file: file)}");
//                         print(file.path);
//                         var filePath = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => TrimmerView(file)));
//                         if (filePath != null) {
//                           File videoFile = File(filePath);
//                           _trimmer.loadVideo(videoFile: videoFile);
//                           createMuddaController!.uploadPhotoVideos.insert(
//                               createMuddaController!.uploadPhotoVideos.length -
//                                   1,
//                               filePath);
//                           /*final MediaInfo? info =
//                           await VideoCompress.compressVideo(
//                             videoFile.path,
//                             quality: VideoQuality.MediumQuality,
//                             deleteOrigin: false,
//                             includeAudio: true,
//                           );
//                           print(info!.path);
//                           _trimmer.loadVideo(videoFile: File(info.path!));
//                           createMuddaController!.uploadPhotoVideos.add(info.path!);*/
//                         }
//                       }
//                     } on PlatformException catch (e) {
//                       print('FAILED $e');
//                     }
//                   }),
//               ListTile(
//                 leading: const Icon(Icons.photo_camera),
//                 title: const Text('Video Camera'),
//                 onTap: () async {
//                   try {
//                     final video = await ImagePicker()
//                         .pickVideo(source: ImageSource.camera);
//                     if (video == null) return;
//                     if (video != null) {
//                       File file = File(video.path);
//                       // print("ORG:::${_getVideoSize(file: file)}");
//                       print(file.path);
//                       var filePath = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => TrimmerView(file)));
//                       if (filePath != null) {
//                         var videoFile = File(filePath);
//                         // print("TRIMM:::${_getVideoSize(file: videoFile)}");
//                         // String  _desFile = await _destinationFile;
//                         // print("DEST:::${_desFile}");
//                         final MediaInfo? info =
//                         await VideoCompress.compressVideo(
//                           videoFile.path,
//                           quality: VideoQuality.MediumQuality,
//                           deleteOrigin: false,
//                           includeAudio: true,
//                         );
//                         print(info!.path);
//                         _trimmer.loadVideo(videoFile: videoFile);
//                         createMuddaController!.uploadPhotoVideos.insert(
//                             createMuddaController!.uploadPhotoVideos.length - 1,
//                             info.path!);
//                       }
//                     }
//                   } on PlatformException catch (e) {
//                     print('FAILED $e');
//                   }
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future uploadProfilePic(BuildContext context) async {
//     return showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return SafeArea(
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                   leading: const Icon(Icons.photo_library),
//                   title: const Text('Photo Library'),
//                   onTap: () async {
//                     try {
//                       final pickedFile = await ImagePicker()
//                           .pickImage(source: ImageSource.gallery);
//                       if (pickedFile != null) {
//                         _cropImage(File(pickedFile.path)).then((value) async {
//                           createMuddaController!.muddaThumb.value = value.path;
//                         });
//                       }
//                       ;
//                     } on PlatformException catch (e) {
//                       print('FAILED $e');
//                     }
//                     Navigator.of(context).pop();
//                   }),
//               ListTile(
//                 leading: const Icon(Icons.photo_camera),
//                 title: const Text('Camera'),
//                 onTap: () async {
//                   try {
//                     final pickedFile = await ImagePicker()
//                         .pickImage(source: ImageSource.camera);
//                     if (pickedFile != null) {
//                       _cropImage(File(pickedFile.path)).then((value) async {
//                         createMuddaController!.muddaThumb.value = value.path;
//                       });
//                     }
//                   } on PlatformException catch (e) {
//                     print('FAILED $e');
//                   }
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<File> _cropImage(File profileImageFile) async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//         sourcePath: profileImageFile.path,
//         aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
//         aspectRatioPresets: Platform.isAndroid
//             ? [
//           CropAspectRatioPreset.square,
//           CropAspectRatioPreset.ratio3x2,
//           CropAspectRatioPreset.original,
//           CropAspectRatioPreset.ratio4x3,
//           CropAspectRatioPreset.ratio16x9
//         ]
//             : [
//           CropAspectRatioPreset.original,
//           CropAspectRatioPreset.square,
//           CropAspectRatioPreset.ratio3x2,
//           CropAspectRatioPreset.ratio4x3,
//           CropAspectRatioPreset.ratio5x3,
//           CropAspectRatioPreset.ratio5x4,
//           CropAspectRatioPreset.ratio7x5,
//           CropAspectRatioPreset.ratio16x9
//         ],
//         uiSettings: [
//           AndroidUiSettings(
//               toolbarTitle: 'Cropper',
//               toolbarColor: Colors.deepOrange,
//               toolbarWidgetColor: Colors.white,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: false),
//           IOSUiSettings(
//             title: 'Cropper',
//           )
//         ]);
//     return File(croppedFile!.path);
//   }
//
//   _getRoles(BuildContext context) async {
//     Api.get.call(context,
//         method: "user/my-roles",
//         param: {
//           "page": rolePage.toString(),
//           "user_id": AppPreference().getString(PreferencesKey.userId),
//           "interactModal": "CreateMudda"
//         },
//         isLoading: false, onResponseSuccess: (Map object) {
//           var result = UserRolesModel.fromJson(object);
//           if (result.data!.isNotEmpty) {
//             if (rolePage == 1) {
//               createMuddaController!.roleList.clear();
//             }
//             createMuddaController!.roleProfilePath.value = result.path!;
//             createMuddaController!.roleList.addAll(result.data!);
//             Role role = Role();
//             role.user = User();
//             role.user!.profile = AppPreference().getString(PreferencesKey.profile);
//             role.user!.fullname = "Self";
//             role.user!.sId = AppPreference().getString(PreferencesKey.userId);
//             createMuddaController!.roleList.add(role);
//           } else {
//             if (rolePage == 1) {
//               Role role = Role();
//               role.user = User();
//               role.user!.profile =
//                   AppPreference().getString(PreferencesKey.profile);
//               role.user!.fullname = "Self";
//               role.user!.sId = AppPreference().getString(PreferencesKey.userId);
//               createMuddaController!.roleProfilePath.value =
//                   AppPreference().getString(PreferencesKey.profilePath);
//               createMuddaController!.roleList.add(role);
//             }
//             rolePage = rolePage > 1 ? rolePage - 1 : rolePage;
//           }
//         });
//   }
//
//   showRolesDialog(BuildContext context, bool isMudda) {
//     return showDialog(
//       context: Get.context as BuildContext,
//       barrierColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             decoration: BoxDecoration(
//                 color: white,
//                 borderRadius: BorderRadius.circular(ScreenUtil().setSp(16))),
//             padding: EdgeInsets.only(
//                 top: ScreenUtil().setSp(24),
//                 left: ScreenUtil().setSp(24),
//                 right: ScreenUtil().setSp(24),
//                 bottom: ScreenUtil().setSp(24)),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Interact as",
//                     style: GoogleFonts.nunitoSans(
//                         fontWeight: FontWeight.w400,
//                         fontSize: ScreenUtil().setSp(13),
//                         color: black,
//                         decoration: TextDecoration.underline,
//                         decorationColor: black)),
//                 Expanded(
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       controller: roleController,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
//                       itemCount: createMuddaController!.roleList.length,
//                       itemBuilder: (followersContext, index) {
//                         Role role = createMuddaController!.roleList[index];
//                         return InkWell(
//                           onTap: () {
//                             if (isMudda) {
//                               createMuddaController!.selectedRole.value = role;
//                             } else {
//                               createMuddaController!.selectedSurveyRole.value =
//                                   role;
//                             }
//                             Get.back();
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                     child: Text(role.user!.fullname!,
//                                         style: GoogleFonts.nunitoSans(
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: ScreenUtil().setSp(13),
//                                             color: black))),
//                                 SizedBox(
//                                   width: ScreenUtil().setSp(14),
//                                 ),
//                                 role.user!.profile != null
//                                     ? SizedBox(
//                                   width: ScreenUtil().setSp(30),
//                                   height: ScreenUtil().setSp(30),
//                                   child: CachedNetworkImage(
//                                     imageUrl:
//                                     "${createMuddaController!.roleProfilePath}${role.user!.profile}",
//                                     imageBuilder:
//                                         (context, imageProvider) =>
//                                         Container(
//                                           width: ScreenUtil().setSp(30),
//                                           height: ScreenUtil().setSp(30),
//                                           decoration: BoxDecoration(
//                                             color: colorWhite,
//                                             boxShadow: [
//                                               BoxShadow(
//                                                   color: Colors.black
//                                                       .withOpacity(.2),
//                                                   blurRadius: 5.0,
//                                                   offset: const Offset(0, 5))
//                                             ],
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(ScreenUtil()
//                                                     .setSp(
//                                                     4)) //                 <--- border radius here
//                                             ),
//                                             image: DecorationImage(
//                                                 image: imageProvider,
//                                                 fit: BoxFit.cover),
//                                           ),
//                                         ),
//                                     errorWidget: (context, url, error) =>
//                                     const Icon(Icons.error),
//                                   ),
//                                 )
//                                     : Container(
//                                   height: ScreenUtil().setSp(30),
//                                   width: ScreenUtil().setSp(30),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: darkGray,
//                                     ),
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(ScreenUtil().setSp(
//                                             4)) //                 <--- border radius here
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                         role.user!.fullname![0]
//                                             .toUpperCase(),
//                                         style: GoogleFonts.nunitoSans(
//                                             fontWeight: FontWeight.w400,
//                                             fontSize:
//                                             ScreenUtil().setSp(20),
//                                             color: black)),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
// -=-=-

class InitiateSurvey extends StatefulWidget {
  MuddaNewsController muddaNewsController;
  CreateMuddaController createMuddaController;
  ScrollController roleController;

  InitiateSurvey(
      this.muddaNewsController, this.createMuddaController, this.roleController,
      {Key? key})
      : super(key: key);

  @override
  State<InitiateSurvey> createState() => _InitiateSurveyState();
}

class _InitiateSurveyState extends State<InitiateSurvey> {
  int selectedIndex = 0;
  TextEditingController option1Controller = TextEditingController();
  TextEditingController option2Controller = TextEditingController();
  TextEditingController option3Controller = TextEditingController();
  TextEditingController option4Controller = TextEditingController();
  TextEditingController option5Controller = TextEditingController();
  TextEditingController titleController = TextEditingController();
  var postAnynymous = false;
  final GlobalKey<FormState> _surveyFormKey = GlobalKey<FormState>();
  var isAdd = false;

  Future<List<Category>> _getCategory(
      String query, BuildContext context) async {
    List<Category> matches = <Category>[];
    if (query.isNotEmpty) {
      var responce = await Api.get.futureCall(context,
          method: "category/index",
          param: {"page": "1", "search": query},
          isLoading: false);
      print("RES:::${responce.data!}");
      var result = CategoryListModel.fromJson(responce.data!);
      return result.data!;
    } else {
      return matches;
    }
  }

  List<String> categoryList = [];

  @override
  Widget build(BuildContext context) {
    List<String> scopeList = [
      "State",
      "Country",
      "World",
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _surveyFormKey,
          child: Column(
            children: [
              getSizedBox(h: 30),
              TextFormField(
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  controller: titleController,
                  validator: (value) {
                    return Validator.validateFormField(
                        value!,
                        "Enter your Survey Question",
                        "Enter Valid your Survey Question",
                        Constants.NORMAL_VALIDATION);
                  },
                  decoration: const InputDecoration(
                      hintText: "Type your Survey Question",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: black),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: black),
                      ))),
              getSizedBox(h: 5),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    "Max 15 words",
                    style: size12_M_normal(textColor: Colors.grey),
                  )
                ],
              ),
              getSizedBox(h: 30),
              Row(
                children: [
                  Text(
                    "Options    ",
                    style: size14_M_normal(textColor: Colors.black),
                  ),
                  Text(
                    "(Min 2 Max 5 answers allowed)",
                    style: size10_M_normal(textColor: Colors.grey),
                  )
                ],
              ),
              getSizedBox(h: 10),
              optionsTextFiled("1.", option1Controller),
              const SizedBox(
                height: 15,
              ),
              optionsTextFiled("2.", option2Controller),
              const SizedBox(
                height: 15,
              ),
              optionsTextFiled("3.", option3Controller),
              const SizedBox(
                height: 15,
              ),
              optionsTextFiled("4.", option4Controller),
              const SizedBox(
                height: 15,
              ),
              Visibility(
                  child: optionsTextFiled("5.", option5Controller),
                  visible: isAdd),
              Visibility(
                visible: !isAdd,
                child: InkWell(
                  onTap: () {
                    isAdd = true;
                    setState(() {});
                  },
                  child: Container(
                    height: 20,
                    width: 20,
                    child: const Icon(Icons.add, color: Colors.black, size: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 1,
                color: Colors.white,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Text("Scope:"),
                  Expanded(
                    child: Row(
                      children: List.generate(
                          scopeList.length,
                          (index) => Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    selectedIndex = index;
                                    setState(() {});
                                  },
                                  child: index == selectedIndex
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                const Radius.circular(10),
                                              ),
                                              border: Border.all(
                                                  color: Colors.black)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 2),
                                            child: Text(
                                              scopeList[index],
                                            ),
                                          ),
                                        )
                                      : Text(
                                          scopeList[index],
                                        ),
                                ),
                              )),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Wrap(
                  spacing: 5,
                  children: List.generate(categoryList.length, (index) {
                    return Chip(
                      label: Text(categoryList[index]),
                      onDeleted: () {
                        categoryList.removeAt(index);
                        setState(() {});
                      },
                    );
                  })),
              SizedBox(
                height: 30,
                child: Row(children: [
                  const Text("#"),
                  getSizedBox(w: 5),
                  Expanded(
                    child: TypeAheadFormField<Category>(
                      textFieldConfiguration: TextFieldConfiguration(
                          style: GoogleFonts.nunitoSans(
                              color: darkGray,
                              fontWeight: FontWeight.w300,
                              fontSize: ScreenUtil().setSp(12)),
                          decoration: InputDecoration(
                              hintText: "category",
                              hintStyle: GoogleFonts.nunitoSans(
                                  color: darkGray,
                                  fontWeight: FontWeight.w300,
                                  fontSize: ScreenUtil().setSp(12)))),
                      suggestionsCallback: (pattern) {
                        return _getCategory(pattern, context);
                      },
                      hideSuggestionsOnKeyboardHide: false,
                      itemBuilder: (context, suggestion) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            suggestion.name!,
                            style: GoogleFonts.nunitoSans(
                                color: darkGray,
                                fontWeight: FontWeight.w300,
                                fontSize: ScreenUtil().setSp(12)),
                          ),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        if (categoryList.length < 3) {
                          categoryList.add(suggestion.name!);
                          setState(() {});
                        } else {
                          var snackBar = const SnackBar(
                            content: Text('Max 3 allowed'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                  ),
                  Text(
                    "(max 3)",
                    style: size12_M_normal(textColor: Colors.grey),
                  ),
                ]),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      postAnynymous = !postAnynymous;
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          child: Center(
                            child: Container(
                              height: 8,
                              width: 8,
                              color: postAnynymous
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        getSizedBox(w: 10),
                        Text(
                          "Post as Anonymous ",
                          style: size12_M_normal(textColor: colorGrey),
                        ),
                      ],
                    ),
                  ),
                  getSizedBox(w: 10),
                  GestureDetector(
                    onTap: () {
                      postAnynymousDialogBox(
                          "Posting Anonymously would hide your identity to the general public but you can see your posts in your profile page marked as Anynymous. You can choose to turn them as Public Profile later on as well.");
                    },
                    child: Container(
                      height: 15,
                      width: 15,
                      child: const Icon(Icons.question_mark, size: 10),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: colorGrey),
                      ),
                    ),
                  ),
                  widget.muddaNewsController.muddaPost.value.initialScope ==
                          null
                      ? Obx(
                          () => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              onTap: () {
                                showRolesDialog(
                                    context,
                                    false,
                                    widget.createMuddaController,
                                    widget.roleController);
                              },
                              child: Row(
                                children: [
                                  Text("Create as:",
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(12),
                                          color: blackGray)),
                                  getSizedBox(w: 6),
                                  widget.createMuddaController
                                              .selectedSurveyRole.value.user !=
                                          null
                                      ? widget
                                                  .createMuddaController
                                                  .selectedSurveyRole
                                                  .value
                                                  .user!
                                                  .profile !=
                                              null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  "${widget.createMuddaController.roleProfilePath.value}${widget.createMuddaController.selectedSurveyRole.value.user!.profile}",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: ScreenUtil().setSp(30),
                                                height: ScreenUtil().setSp(30),
                                                decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  border: Border.all(
                                                    width:
                                                        ScreenUtil().setSp(1),
                                                    color: buttonBlue,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          ScreenUtil().setSp(
                                                              15)) //                 <--- border radius here
                                                      ),
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                backgroundColor: lightGray,
                                                radius: ScreenUtil().setSp(15),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CircleAvatar(
                                                backgroundColor: lightGray,
                                                radius: ScreenUtil().setSp(15),
                                              ),
                                            )
                                          : Container(
                                              height: ScreenUtil().setSp(30),
                                              width: ScreenUtil().setSp(30),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: darkGray,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                    widget
                                                        .createMuddaController
                                                        .selectedSurveyRole
                                                        .value
                                                        .user!
                                                        .fullname![0]
                                                        .toUpperCase(),
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(16),
                                                            color: black)),
                                              ),
                                            )
                                      : AppPreference()
                                              .getString(PreferencesKey.profile)
                                              .isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.profile)}",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: ScreenUtil().setSp(30),
                                                height: ScreenUtil().setSp(30),
                                                decoration: BoxDecoration(
                                                  color: colorWhite,
                                                  border: Border.all(
                                                    width:
                                                        ScreenUtil().setSp(1),
                                                    color: buttonBlue,
                                                  ),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          ScreenUtil().setSp(
                                                              15)) //                 <--- border radius here
                                                      ),
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                backgroundColor: lightGray,
                                                radius: ScreenUtil().setSp(15),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CircleAvatar(
                                                backgroundColor: lightGray,
                                                radius: ScreenUtil().setSp(15),
                                              ),
                                            )
                                          : Container(
                                              height: ScreenUtil().setSp(30),
                                              width: ScreenUtil().setSp(30),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: darkGray,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                    AppPreference()
                                                        .getString(
                                                            PreferencesKey
                                                                .fullName)[0]
                                                        .toUpperCase(),
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(16),
                                                            color: black)),
                                              ),
                                            ),
                                  getSizedBox(w: 6),
                                  Text(
                                      widget.createMuddaController.selectedRole
                                                  .value.user !=
                                              null
                                          ? widget
                                              .createMuddaController
                                              .selectedRole
                                              .value
                                              .user!
                                              .fullname!
                                          : "Self",
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(10),
                                          color: buttonBlue,
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetStartedButton(
                    onTap: () {
                      if (_surveyFormKey.currentState!.validate()) {
                        if (option1Controller.text.isEmpty) {
                          var snackBar = const SnackBar(
                            content: Text('Minimum 2 answer add'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (option2Controller.text.isEmpty) {
                          var snackBar = const SnackBar(
                            content: Text('Minimum 2 answer add'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          List<String> options = [];
                          if (option1Controller.text.isNotEmpty) {
                            options.add(option1Controller.text);
                          }
                          if (option2Controller.text.isNotEmpty) {
                            options.add(option2Controller.text);
                          }
                          if (option3Controller.text.isNotEmpty) {
                            options.add(option3Controller.text);
                          }
                          if (option4Controller.text.isNotEmpty) {
                            options.add(option4Controller.text);
                          }
                          if (option5Controller.text.isNotEmpty) {
                            options.add(option5Controller.text);
                          }
                          Api.post.call(
                            context,
                            method: "initiate-survey/store",
                            param: {
                              "user_id": widget.createMuddaController
                                          .selectedSurveyRole.value.user !=
                                      null
                                  ? widget.createMuddaController
                                      .selectedSurveyRole.value.user!.sId
                                  : AppPreference()
                                      .getString(PreferencesKey.userId),
                              "post_as": postAnynymous ? "anynymous" : "user",
                              "title": titleController.text,
                              "initial_scope":
                                  scopeList.elementAt(selectedIndex),
                              "hashtags": jsonEncode(categoryList),
                              "options": jsonEncode(options),
                            },
                            onResponseSuccess: (object) {
                              Get.back();
                            },
                          );
                        }
                      }
                    },
                    title: "Create",
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  postAnynymousDialogBox(String text) {
    return showDialog(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Text(text),
          ],
        );
      },
    );
  }

  optionsTextFiled(String index, TextEditingController controller) {
    return Container(
      height: 30,
      child: Row(
        children: [
          Text(
            index,
            style: size12_M_normal(textColor: Colors.grey),
          ),
          getSizedBox(w: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: size12_M_normal(textColor: black),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 19)),
            ),
          ),
          Text(
            "Max 07 words",
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
    );
  }
}

showRolesDialog(
    BuildContext context,
    bool isMudda,
    CreateMuddaController createMuddaController,
    ScrollController roleController) {
  return showDialog(
    context: Get.context as BuildContext,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(16))),
          padding: EdgeInsets.only(
              top: ScreenUtil().setSp(24),
              left: ScreenUtil().setSp(24),
              right: ScreenUtil().setSp(24),
              bottom: ScreenUtil().setSp(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Interact as",
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(13),
                      color: black,
                      decoration: TextDecoration.underline,
                      decorationColor: black)),
              ListView.builder(
                  shrinkWrap: true,
                  controller: roleController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                  itemCount: createMuddaController.roleList.length,
                  itemBuilder: (followersContext, index) {
                    Role role = createMuddaController.roleList[index];
                    return InkWell(
                      onTap: () {
                        if (isMudda) {
                          createMuddaController.selectedRole.value = role;
                        } else {
                          createMuddaController.selectedSurveyRole.value = role;
                        }
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(role.user!.fullname!,
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(13),
                                        color: black))),
                            SizedBox(
                              width: ScreenUtil().setSp(14),
                            ),
                            role.user!.profile != null
                                ? SizedBox(
                                    width: ScreenUtil().setSp(30),
                                    height: ScreenUtil().setSp(30),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${createMuddaController.roleProfilePath}${role.user!.profile}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: ScreenUtil().setSp(30),
                                        height: ScreenUtil().setSp(30),
                                        decoration: BoxDecoration(
                                          color: colorWhite,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                blurRadius: 5.0,
                                                offset: const Offset(0, 5))
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(ScreenUtil().setSp(
                                                  4)) //                 <--- border radius here
                                              ),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  )
                                : Container(
                                    height: ScreenUtil().setSp(30),
                                    width: ScreenUtil().setSp(30),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: darkGray,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(ScreenUtil().setSp(
                                              4)) //                 <--- border radius here
                                          ),
                                    ),
                                    child: Center(
                                      child: Text(
                                          role.user!.fullname![0].toUpperCase(),
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: ScreenUtil().setSp(20),
                                              color: black)),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      );
    },
  );
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
