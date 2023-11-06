import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/CategoryListModel.dart';
import 'package:mudda/model/PostForMuddaModel.dart';
import 'package:mudda/model/UserRolesModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';

import 'package:mudda/ui/screens/mudda/view/mudda_details_screen.dart';
import 'package:mudda/ui/screens/profile_screen/controller/profile_controller.dart';
import 'package:mudda/ui/shared/get_started_button.dart';
import 'package:mudda/core/constant/app_colors.dart';

import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/ui/shared/image_compression.dart';
import 'package:mudda/ui/shared/trimmer_view.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../../../model/QuotePostModel.dart';

class UploadQuoteActivityScreen extends StatefulWidget {
  const UploadQuoteActivityScreen({Key? key}) : super(key: key);

  @override
  State<UploadQuoteActivityScreen> createState() =>
      _UploadQuoteActivityScreenState();
}

class _UploadQuoteActivityScreenState extends State<UploadQuoteActivityScreen> {
  MuddaNewsController? muddaNewsController;
  ProfileController? profileController;
  final Trimmer _trimmer = Trimmer();
  int selectedIndex = 0;
  int rolePage = 1;
  ScrollController roleController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    muddaNewsController = Get.find<MuddaNewsController>();
    profileController = Get.find<ProfileController>();
    muddaNewsController!.quotePostType.value = "quote";
    muddaNewsController!.descriptionValue.value = "";
    muddaNewsController!.uploadPhotoVideos.value = [""];
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
    super.initState();
  }

  @override
  void dispose() {
    muddaNewsController!.quoteCategoryList.clear();
    super.dispose();
  }

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
                Text(
                  "Create Quote or Activity",
                  style: GoogleFonts.nunitoSans(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w700,
                      color: black),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getSizedBox(h: 30),
            SizedBox(
              height: 100,
              child: Obx(
                () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: ScreenUtil().setSp(38)),
                    itemCount: muddaNewsController!.uploadPhotoVideos.length > 5
                        ? 5
                        : muddaNewsController!.uploadPhotoVideos.length,
                    itemBuilder: (followersContext, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().setSp(4)),
                        child: GestureDetector(
                          onTap: () {
                            if ((muddaNewsController!.uploadPhotoVideos.length -
                                    index) ==
                                1) {
                              uploadPic(context);
                            } else {
                              // muddaVideoDialog(
                              //     context, muddaNewsController!.uploadPhotoVideos);
                            }
                          },
                          child: (muddaNewsController!
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
                                      border: Border.all(color: Colors.grey)),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)),
                                  child: muddaNewsController!.uploadPhotoVideos
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
                                      : Image.file(
                                          File(muddaNewsController!
                                              .uploadPhotoVideos
                                              .elementAt(index)),
                                          height: 100,
                                          width: 100,
                                        ),
                                ),
                        ),
                      );
                    }),
              ),
            ),
            getSizedBox(h: ScreenUtil().setSp(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(42)),
              child: Container(
                height: getHeight(160),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue)),
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(300),
                  ],
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  maxLength: 300,
                  onChanged: (text) {
                    muddaNewsController!.descriptionValue.value = text;
                  },
                  style: size14_M_normal(textColor: color606060),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    hintText: "Enter Text for the Post",
                    border: InputBorder.none,
                    hintStyle: size12_M_normal(textColor: color606060),
                  ),
                ),
              ),
            ),
            getSizedBox(h: 5),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Spacer(),
                    Text(
                      "remain ${300 - muddaNewsController!.descriptionValue.value.length} characters",
                      style: size10_M_normal(textColor: colorGrey),
                    )
                  ],
                ),
              ),
            ),
            getSizedBox(h: 20),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                    spacing: 5,
                    children: List.generate(
                        muddaNewsController!.quoteCategoryList.length, (index) {
                      return Chip(
                        label: Text(muddaNewsController!
                            .quoteCategoryList[index].name!),
                        onDeleted: () {
                          muddaNewsController!.quoteCategoryList
                              .removeAt(index);
                        },
                      );
                    })),
              ),
            ),
            getSizedBox(h: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
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
                        if (muddaNewsController!.quoteCategoryList.length < 3) {
                          muddaNewsController!.quoteCategoryList
                              .add(suggestion);
                          if (muddaNewsController!.muddaPost.value.hashtags !=
                              null) {
                            muddaNewsController!.muddaPost.value.hashtags!
                                .add(suggestion.name!);
                          }
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
            ),
            getSizedBox(h: ScreenUtil().setSp(35)),
            Obx(
              () => Visibility(
                visible: muddaNewsController!.uploadQuoteRoleList.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "Post as: ",
                        style: GoogleFonts.nunitoSans(
                            fontSize: ScreenUtil().setSp(12),
                            fontWeight: FontWeight.w400,
                            color: blackGray),
                      ),
                      InkWell(
                        onTap: () {
                          showRolesDialog(context);
                        },
                        child: Row(
                          children: [
                            muddaNewsController!.selectedRole.value.user != null
                                ? muddaNewsController!
                                            .selectedRole.value.user!.profile !=
                                        null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "${muddaNewsController!.roleProfilePath.value}${muddaNewsController!.selectedRole.value.user!.profile}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: ScreenUtil().setSp(30),
                                          height: ScreenUtil().setSp(30),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            border: Border.all(
                                              width: ScreenUtil().setSp(1),
                                              color: buttonBlue,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(ScreenUtil().setSp(
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
                                        errorWidget: (context, url, error) =>
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
                                              muddaNewsController!.selectedRole
                                                  .value.user!.fullname![0]
                                                  .toUpperCase(),
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(16),
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
                                              width: ScreenUtil().setSp(1),
                                              color: buttonBlue,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(ScreenUtil().setSp(
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
                                        errorWidget: (context, url, error) =>
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
                                                  .getString(PreferencesKey
                                                      .fullName)[0]
                                                  .toUpperCase(),
                                              style: GoogleFonts.nunitoSans(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      ScreenUtil().setSp(16),
                                                  color: black)),
                                        ),
                                      ),
                            getSizedBox(w: 6),
                            Text(
                                muddaNewsController!.selectedRole.value.user !=
                                        null
                                    ? muddaNewsController!
                                        .selectedRole.value.user!.fullname!
                                    : "Self",
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtil().setSp(10),
                                    color: buttonBlue,
                                    fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            getSizedBox(h: 20),
            Container(
              height: 1,
              color: Colors.black,
            ),
            Obx(
              () => Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          muddaNewsController!.quotePostType.value = "quote";
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              child: muddaNewsController!.quotePostType.value ==
                                      "quote"
                                  ? const Center(
                                      child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.black87,
                                    ))
                                  : Container(),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            getSizedBox(w: 10),
                            Text(
                              "Quote ",
                              style: size12_M_normal(textColor: colorGrey),
                            ),
                            SvgPicture.asset("assets/svg/quote.svg")
                          ],
                        ),
                      ),
                      getSizedBox(w: 20),
                      InkWell(
                        onTap: () {
                          muddaNewsController!.quotePostType.value = "activity";
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              child: muddaNewsController!.quotePostType.value ==
                                      "activity"
                                  ? const Center(
                                      child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.black87,
                                    ))
                                  : Container(),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            getSizedBox(w: 10),
                            Text(
                              "Activity ",
                              style: size12_M_normal(textColor: colorGrey),
                            ),
                            SvgPicture.asset("assets/svg/activity.svg")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetStartedButton(
                  onTap: () async {
                    AppPreference _appPreference = AppPreference();
                    List<String> idList = [];
                    for (Category challenges
                        in muddaNewsController!.quoteCategoryList) {
                      idList.add("#${challenges.name!}");
                    }
                    FormData formData = FormData.fromMap({
                      "description":
                          muddaNewsController!.descriptionValue.value,
                      "post_of": muddaNewsController!.quotePostType.value,
                      "hashtags": jsonEncode(idList),
                      "user_id": _appPreference
                          .getString(PreferencesKey.interactUserId),
                    });
                    for (int i = 0;
                        i <
                            (muddaNewsController!.uploadPhotoVideos.length == 5
                                ? 5
                                : (muddaNewsController!
                                        .uploadPhotoVideos.length -
                                    1));
                        i++) {
                      formData.files.addAll([
                        MapEntry(
                            "gallery",
                            await MultipartFile.fromFile(
                                muddaNewsController!.uploadPhotoVideos[i],
                                filename: muddaNewsController!
                                    .uploadPhotoVideos[i]
                                    .split('/')
                                    .last)),
                      ]);
                    }
                    Api.uploadPost.call(context,
                        method: "quote-or-activity/store",
                        param: formData,
                        isLoading: true, onResponseSuccess: (Map object) {
                      print(object);
                      var snackBar = const SnackBar(
                        content: Text('Uploaded'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      muddaNewsController!.quoteCategoryList.clear();
                      profileController!.quotePostList
                          .insert(0, Quote.fromJson(object['data']));
                      Get.back();
                    });
                  },
                  title: "Post",
                )
              ],
            )
          ],
        ),
      ),
    );
  }

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

  _getRoles(BuildContext context) async {
    Api.get.call(context,
        method: "user/my-roles",
        param: {
          "page": rolePage.toString(),
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "interactModal": "QuoteOrActivity"
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = UserRolesModel.fromJson(object);
      if (rolePage == 1) {
        muddaNewsController!.uploadQuoteRoleList.clear();
      }
      if (result.data!.isNotEmpty) {
        muddaNewsController!.roleProfilePath.value = result.path!;
        muddaNewsController!.uploadQuoteRoleList.addAll(result.data!);
        Role role = Role();
        role.user = User();
        role.user!.profile = AppPreference().getString(PreferencesKey.profile);
        role.user!.fullname = "Self";
        role.user!.sId = AppPreference().getString(PreferencesKey.userId);
        muddaNewsController!.uploadQuoteRoleList.add(role);
      } else {
        rolePage = rolePage > 1 ? rolePage - 1 : rolePage;
      }
    });
  }

  showRolesDialog(BuildContext context) {
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
                    itemCount: muddaNewsController!.uploadQuoteRoleList.length,
                    itemBuilder: (followersContext, index) {
                      Role role =
                          muddaNewsController!.uploadQuoteRoleList[index];
                      return InkWell(
                        onTap: () {
                          muddaNewsController!.selectedRole.value = role;
                          AppPreference().setString(
                              PreferencesKey.interactUserId, role.user!.sId!);
                          AppPreference().setString(
                              PreferencesKey.interactProfile,
                              role.user!.profile!);
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
                                            "${muddaNewsController!.roleProfilePath}${role.user!.profile}",
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
                    })
              ],
            ),
          ),
        );
      },
    );
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
                      final pickedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery, imageQuality: ImageCompression.imageQuality);
                      if (pickedFile != null) {
                        _cropImage(File(pickedFile.path)).then((value) async {
                          // if(value.lengthSync()>150000) {
                          //   await ImageCompression.compressAndGetFile(value, '${value.path}compressed.jpg').then((value) {
                          //     muddaNewsController!.uploadPhotoVideos.insert(
                          //         muddaNewsController!.uploadPhotoVideos.length - 1,
                          //         value!.path);
                          //   });
                          //   // testCompressAndGetFile(90,
                          //   //     value, '${value.path}compressed.jpg').then((
                          //   //     value) {
                          //   //   print('final size${value.lengthSync()}');
                          //   //
                          //   // });
                          // }
                          // else{
                          //   muddaNewsController!.uploadPhotoVideos.insert(
                          //       muddaNewsController!.uploadPhotoVideos.length - 1,
                          //       value.path);
                          // }
                          muddaNewsController!.uploadPhotoVideos.insert(
                              muddaNewsController!.uploadPhotoVideos.length - 1,
                              value.path);
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
                    final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.camera, imageQuality: ImageCompression.imageQuality);
                    if (pickedFile != null) {
                      _cropImage(File(pickedFile.path)).then((value) async {
                        muddaNewsController!.uploadPhotoVideos.insert(
                            muddaNewsController!.uploadPhotoVideos.length - 1,
                            value.path);
                      });
                    }
                    //     else{

                    //     }
                    //   });
                    // }
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
                          muddaNewsController!.uploadPhotoVideos.insert(
                              muddaNewsController!.uploadPhotoVideos.length - 1,
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
                          muddaNewsController!.uploadPhotoVideos.add(info.path!);*/
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
                    final video = await ImagePicker()
                        .pickVideo(source: ImageSource.camera);
                    if (video == null) return;
                    if (video != null) {
                      File file = File(video.path);
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
                        muddaNewsController!.uploadPhotoVideos.insert(
                            muddaNewsController!.uploadPhotoVideos.length - 1,
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

  Future<File> testCompressAndGetFile(
      int quality, File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
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
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
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
}
