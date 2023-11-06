import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart' hide FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/const/const.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserSuggestionsModel.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/profile_screen/widget/invite_bottom_sheet.dart';
import 'package:mudda/ui/screens/raising_mudda/controller/CreateMuddaController.dart';
import 'package:mudda/ui/shared/get_started_button.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../model/CategoryListModel.dart';

class RaisingMuddaAdditionalInformationScreen extends StatefulWidget {
  const RaisingMuddaAdditionalInformationScreen({Key? key}) : super(key: key);

  @override
  State<RaisingMuddaAdditionalInformationScreen> createState() =>
      _RaisingMuddaAdditionalInformationScreenState();
}

class _RaisingMuddaAdditionalInformationScreenState
    extends State<RaisingMuddaAdditionalInformationScreen> {
  CreateMuddaController? createMuddaController;
  MuddaNewsController? muddaNewsController;
  ScrollController muddaScrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        _getUserSuggestion(context);
      }
    });
    muddaNewsController = Get.find<MuddaNewsController>();
    createMuddaController = Get.find<CreateMuddaController>();
    createMuddaController!.genderSelected
        .value = createMuddaController!.genderList.indexOf(muddaNewsController!
                .muddaPost.value.audienceGender !=
            null
        ? "${muddaNewsController!.muddaPost.value.audienceGender!.substring(0, 1).toUpperCase()}${muddaNewsController!.muddaPost.value.audienceGender!.substring(1).toLowerCase()}"
        : "Both");
    createMuddaController!.ageSelected.value = createMuddaController!.ageList
        .indexOf(muddaNewsController!.muddaPost.value.audienceAge ?? "All");
    Api.get.call(context,
        method: "user/mudda-suggestion",
        param: {
          "page": page.toString(),
          "search": createMuddaController!.search.value,
          "mudda_id": createMuddaController!.muddaId.value,
          "user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: true, onResponseSuccess: (Map object) {
      print(object);
      var result = UserSuggestionsModel.fromJson(object);
      createMuddaController!.profilePath.value = result.path!;
      createMuddaController!.userList.clear();
      createMuddaController!.userList.addAll(result.data!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      resizeToAvoidBottomInset: false,
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
                    "Additional Information",
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
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () {
              createMuddaController!.search.value = "";
              createMuddaController!.userList.clear();
              page = 1;
              return _getUserSuggestion(context);
            },
            child: ListView(
              controller: muddaScrollController,
              padding: EdgeInsets.only(bottom: ScreenUtil().setSp(100)),
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Good Job! Your Mudda is submitted for\n Approval.",
                    style: size14_M_bold(textColor: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "To help your Mudda reach the right audience, provide below information-",
                    style: size12_M_normal(textColor: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                      () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                        spacing: 5,
                        children: List.generate(
                            createMuddaController!.categoryList.length, (index) {
                          return Chip(
                            label: Text(
                                createMuddaController!.categoryList[index].name!),
                            onDeleted: () {
                              createMuddaController!.categoryList.removeAt(index);
                            },
                          );
                        })),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 2),
                        )),
                    child: Row(children: [
                      getSizedBox(w: 5),
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
                                  border: InputBorder.none,
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
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) async{
                            if(await checkIsExistCategory(suggestion)){
                              var snackBar = const SnackBar(
                                content: Text('You already added this category')
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              if (createMuddaController!.categoryList.length < 3 ) {
                                createMuddaController!.categoryList.add(suggestion);
                                if (muddaNewsController!.muddaPost.value.hashtags !=
                                    null) {
                                  muddaNewsController!.muddaPost.value.hashtags!
                                      .add(suggestion.name!);
                                }
                              } else {
                                var snackBar = const SnackBar(
                                  content: Text('Max 3 allowed'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
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
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Text(
                        "Gender:",
                        style: size14_M_normal(textColor: greyTextColor),
                      ),
                      getSizedBox(w: 20),
                      Expanded(
                        child: Obx(() => Row(
                              children: List.generate(
                                createMuddaController!.genderList.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      createMuddaController!
                                          .genderSelected.value = index;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: createMuddaController!
                                                          .genderSelected
                                                          .value ==
                                                      index
                                                  ? Colors.transparent
                                                  : colorA0A0A0),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: createMuddaController!
                                                      .genderSelected.value ==
                                                  index
                                              ? colorBlack
                                              : Colors.transparent),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          createMuddaController!
                                              .genderList[index],
                                          style: size12_M_normal(
                                              textColor: createMuddaController!
                                                          .genderSelected
                                                          .value ==
                                                      index
                                                  ? colorWhite
                                                  : colorA0A0A0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Text(
                        "Age:",
                        style: size14_M_normal(textColor: greyTextColor),
                      ),
                      getSizedBox(w: 10),
                      Expanded(
                        child: Obx(() => Wrap(
                              children: List.generate(
                                createMuddaController!.ageList.length,
                                (index) => Padding(
                                  padding:
                                      const EdgeInsets.only(right: 15, top: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      createMuddaController!.ageSelected.value =
                                          index;
                                    },
                                    child: Container(
                                      width: getWidth(60),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: createMuddaController!
                                                          .ageSelected.value ==
                                                      index
                                                  ? Colors.transparent
                                                  : colorA0A0A0),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: createMuddaController!
                                                      .ageSelected.value ==
                                                  index
                                              ? colorBlack
                                              : Colors.transparent),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          createMuddaController!.ageList[index],
                                          style: size12_M_normal(
                                              textColor: createMuddaController!
                                                          .ageSelected.value ==
                                                      index
                                                  ? colorWhite
                                                  : colorA0A0A0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "Invite Leadership:",
                        style: size14_M_bold(textColor: Colors.black),
                      ),
                      Text(
                        "(Minimum ${createMuddaController!.muddaPost.value.initialScope!.toLowerCase() == "district" ? "11" : createMuddaController!.muddaPost.value.initialScope!.toLowerCase() == "state" ? "15" : createMuddaController!.muddaPost.value.initialScope!.toLowerCase() == "country" ? "20" : "25"} Members)",
                        style: size14_M_medium(textColor: Colors.black),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            /*muddaNewsController.muddaPost.value = muddaPost;
                                    inviteBottomSheet(context,muddaPost.sId!);*/
                            Share.share(
                              '${Const.shareUrl}mudda/${createMuddaController!.muddaPost.value.sId!}',
                            );
                          },
                          icon: SvgPicture.asset("assets/svg/share.svg"))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "While your Mudda is under review, you will need to form a Mudda Leadership team of",
                          style: size12_M_normal(textColor: Colors.black),
                        ),
                        TextSpan(
                          text:
                              " minimum ${createMuddaController!.muddaPost.value.initialScope!.toLowerCase() == "district" ? "11" : createMuddaController!.muddaPost.value.initialScope!.toLowerCase() == "state" ? "15" : createMuddaController!.muddaPost.value.initialScope!.toLowerCase() == "country" ? "20" : "25"} Members.",
                          style: size12_M_bold(textColor: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                getSizedBox(h: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppTextField(
                    hintText: "Search",
                    suffixIcon: Image.asset(AppIcons.searchIcon, scale: 2),
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (text) {
                      createMuddaController!.search.value = text!;
                      createMuddaController!.userList.clear();
                      page = 1;
                      Api.get.call(context,
                          method: "user/mudda-suggestion",
                          param: {
                            "page": page.toString(),
                            "search": createMuddaController!.search.value,
                            "mudda_id": createMuddaController!.muddaId.value,
                            "user_id": AppPreference()
                                .getString(PreferencesKey.userId),
                          },
                          isLoading: false, onResponseSuccess: (Map object) {
                        print(object);
                        var result = UserSuggestionsModel.fromJson(object);
                        if (result.data!.isNotEmpty) {
                          createMuddaController!.profilePath.value =
                              result.path!;
                          createMuddaController!.userList.clear();
                          createMuddaController!.userList.addAll(result.data!);
                        }
                      });
                    },
                    onChange: (text) {
                      if (text.isEmpty) {
                        createMuddaController!.search.value = "";
                        createMuddaController!.userList.clear();
                        page = 1;
                        Api.get.call(context,
                            method: "user/mudda-suggestion",
                            param: {
                              "page": page.toString(),
                              "search": createMuddaController!.search.value,
                              "mudda_id": createMuddaController!.muddaId.value,
                              "user_id": AppPreference()
                                  .getString(PreferencesKey.userId),
                            },
                            isLoading: false, onResponseSuccess: (Map object) {
                          print(object);
                          var result = UserSuggestionsModel.fromJson(object);
                          if (result.data!.isNotEmpty) {
                            createMuddaController!.profilePath.value =
                                result.path!;
                            createMuddaController!.userList.clear();
                            createMuddaController!.userList
                                .addAll(result.data!);
                          }
                        });
                      }
                    },
                  ),
                ),
                getSizedBox(h: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        "Profile",
                        style: size12_M_normal(textColor: colorGrey),
                      ),
                    ],
                  ),
                ),
                getSizedBox(h: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: createMuddaController!.userList.length,
                      itemBuilder: (followersContext, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        createMuddaController!
                                                    .userList[index].profile !=
                                                null
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    "${createMuddaController!.profilePath.value}${createMuddaController!.userList[index].profile}",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: ScreenUtil().setSp(40),
                                                  height:
                                                      ScreenUtil().setSp(40),
                                                  decoration: BoxDecoration(
                                                    color: colorWhite,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            ScreenUtil().setSp(
                                                                20)) //                 <--- border radius here
                                                        ),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                  backgroundColor: lightGray,
                                                  radius:
                                                      ScreenUtil().setSp(20),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        CircleAvatar(
                                                  backgroundColor: lightGray,
                                                  radius:
                                                      ScreenUtil().setSp(20),
                                                ),
                                              )
                                            : Container(
                                                height: ScreenUtil().setSp(40),
                                                width: ScreenUtil().setSp(40),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: darkGray,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      createMuddaController!
                                                                      .userList[
                                                                          index]
                                                                      .fullname !=
                                                                  null &&
                                                              createMuddaController!
                                                                  .userList[
                                                                      index]
                                                                  .fullname!
                                                                  .isNotEmpty
                                                          ? createMuddaController!
                                                              .userList[index]
                                                              .fullname![0]
                                                              .toUpperCase()
                                                          : "",
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          20),
                                                              color: black)),
                                                ),
                                              ),
                                        getSizedBox(w: 5),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              createMuddaController!
                                                  .userList[index].fullname!,
                                              style: size12_M_bold(
                                                  textColor: Colors.black),
                                            ),
                                            getSizedBox(h: 2),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              child: Text(
                                                createMuddaController!
                                                            .userList[index]
                                                            .profession !=
                                                        null
                                                    ? "${createMuddaController!.userList[index].profession != null ? createMuddaController!.userList[index].profession! : ""} ${createMuddaController!.userList[index].state != null ? "/ ${createMuddaController!.userList[index].state != null ? createMuddaController!.userList[index].state! : ""}, ${createMuddaController!.userList[index].country != null ? createMuddaController!.userList[index].country! : ""}" : ""}"
                                                    : createMuddaController!
                                                                .userList[index]
                                                                .state !=
                                                            null
                                                        ? "${createMuddaController!.userList[index].state != null ? createMuddaController!.userList[index].state! : ""}, ${createMuddaController!.userList[index].country != null ? createMuddaController!.userList[index].country! : ""}"
                                                        : "",
                                                overflow: TextOverflow.ellipsis,
                                                style: size12_M_normal(
                                                    textColor: colorGrey),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    getSizedBox(h: 5),
                                    Container(
                                      height: 1,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (createMuddaController!
                                          .userList[index].invitedStatus ==
                                      false) {
                                    AcceptUserDetail user =
                                        createMuddaController!.userList[index];
                                    user.invitedStatus = true;
                                    int sunIndex = index;
                                    createMuddaController!.userList
                                        .removeAt(index);
                                    createMuddaController!.userList
                                        .insert(sunIndex, user);
                                    Api.post.call(
                                      context,
                                      method: "request-to-user/store",
                                      param: {
                                        "user_id": AppPreference()
                                            .getString(PreferencesKey.userId),
                                        "request_to_user_id":
                                            createMuddaController!
                                                .userList[index].sId,
                                        "joining_content_id":
                                            createMuddaController!
                                                .muddaId.value,
                                        "requestModalPath": muddaNewsController!
                                            .muddaProfilePath.value,
                                        "requestModal": "RealMudda",
                                        "request_type": "initial_leader",
                                        // "request_type": Get.arguments['opposition'] != ""
                                        //     ? Get.arguments['opposition']
                                        //     : "leader",
                                      },
                                      onResponseSuccess: (object) {
                                        _getUserSuggestion(context);

                                        // MuddaPost muddaPost = muddaNewsController!.muddaPost.value;
                                        // muddaPost.inviteCount = muddaPost.inviteCount! + 1;
                                        // muddaNewsController!.muddaPost.value =  MuddaPost();
                                        // muddaNewsController!.muddaPost.value = muddaPost;
                                      },
                                    );
                                  } else if (createMuddaController!
                                          .userList[index].invitedStatus ==
                                      true) {
                                    AcceptUserDetail user =
                                        createMuddaController!.userList[index];
                                    user.invitedStatus = false;
                                    int sunIndex = index;
                                    createMuddaController!.userList
                                        .removeAt(index);
                                    createMuddaController!.userList
                                        .insert(sunIndex, user);
                                    Api.delete.call(
                                      context,
                                      method:
                                          "request-to-user/delete/${createMuddaController!.userList[index].invitedId}",
                                      param: {},
                                      onResponseSuccess: (object) {
                                        _getUserSuggestion(context);
                                        // MuddaPost muddaPost = muddaNewsController!.muddaPost.value;
                                        // muddaPost.inviteCount = muddaPost.inviteCount! - 1;
                                        // muddaNewsController!.muddaPost.value =  MuddaPost();
                                        // muddaNewsController!.muddaPost.value = muddaPost;
                                      },
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    createMuddaController!.userList[index]
                                                .invitedStatus !=
                                            true
                                        ? "Invite"
                                        : "Invited",
                                    style: size12_M_normal(
                                        textColor: createMuddaController!
                                                    .userList[index]
                                                    .invitedStatus !=
                                                true
                                            ? colorGrey
                                            : buttonBlue),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      })),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GetStartedButton(
              onTap: () {
                List<String> idList = [];
                for (Category challenges
                in createMuddaController!.categoryList) {
                  idList.add(challenges.name!);
                }
                print(createMuddaController!.genderList
                    .elementAt(createMuddaController!.genderSelected.value));
                FormData formData = FormData.fromMap({
                  "_id": createMuddaController!.muddaPost.value.sId,
                  "audience_age": createMuddaController!.ageList
                      .elementAt(createMuddaController!.ageSelected.value),
                  "audience_gender": createMuddaController!.genderList
                      .elementAt(createMuddaController!.genderSelected.value)
                      .toLowerCase(),
                  "hashtags": jsonEncode(idList),
                });
                Api.uploadPost.call(context,
                    method: "mudda/update",
                    param: formData,
                    isLoading: true, onResponseSuccess: (Map object) {
                  print(object);
                  var snackBar = const SnackBar(
                    content: Text('Updated'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // muddaNewsController!.waitingMuddaPostList.insert(0,MuddaPost.fromJson(object['data']));
                  muddaNewsController!.tabController.index = 2;
                  Get.offAllNamed(RouteConstants.homeScreen);

                });
              },
              title: "Done",
            ),
          )
        ],
      ),
    );
  }
  Future<bool> checkIsExistCategory(Category category) async{
    log('${category.name}');
   List<Category> cat =createMuddaController!.categoryList.where((element) => element.name==category.name).toList();
    if(cat.isNotEmpty && cat.length>0){
      return true;
    }else {
      return false;
    }
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
  _getUserSuggestion(BuildContext context) async {
    Api.get.call(context,
        method: "user/mudda-suggestion",
        param: {
          "page": page.toString(),
          "search": createMuddaController!.search.value,
          "mudda_id": createMuddaController!.muddaId.value,
          "user_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
      print(object);
      var result = UserSuggestionsModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        // createMuddaController!.userList.clear();
        createMuddaController!.profilePath.value = result.path!;
        createMuddaController!.userList.addAll(result.data!);
      } else {
        page = page > 1 ? page - 1 : page;
      }
    });
  }
}
