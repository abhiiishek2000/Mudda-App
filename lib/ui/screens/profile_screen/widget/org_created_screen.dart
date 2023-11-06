import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData;
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserSuggestionsModel.dart';
import 'package:mudda/ui/screens/edit_profile/controller/create_org_controller.dart';
import 'package:mudda/ui/screens/profile_screen/view/profile_screen.dart';
import 'package:mudda/ui/screens/profile_screen/widget/invite_bottom_sheet.dart';
import 'package:mudda/ui/shared/create_dynamic_link.dart';
import 'package:mudda/ui/shared/get_started_button.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';

import 'package:mudda/core/constant/app_colors.dart';

import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';

import '../../../../core/utils/color.dart';

class OrgCreatedScreen extends StatefulWidget {
  OrgCreatedScreen({Key? key}) : super(key: key);

  @override
  State<OrgCreatedScreen> createState() => _OrgCreatedScreenState();
}

class _OrgCreatedScreenState extends State<OrgCreatedScreen> {
  CreateOrgController createOrgController = Get.put(CreateOrgController());

  ScrollController muddaScrollController = ScrollController();
  TextEditingController locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int page = 1;

  bool moreView = false;
  String? orgProfileLink;

  // bool moreLess = false;
  @override
  void initState() {
    createOrgController = Get.find<CreateOrgController>();
    CreateMyDynamicLinksClass()
        .createDynamicLink(true,
            '/profileScreen?id=${AppPreference().getString(PreferencesKey.orgUserId)}')
        .then((value) => setState(() {
              setState(() {
                orgProfileLink = value;
              });
            }));
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        _getUserSuggestion(context);
      }
    });
    Api.get.call(context,
        method: "organization-member/invite-suggestion",
        param: {
          "page": page.toString(),
          "search": createOrgController.search.value,
          "organization_id":
              AppPreference().getString(PreferencesKey.orgUserId),
        },
        isLoading: true, onResponseSuccess: (Map object) {
      print(object);
      var result = UserSuggestionsModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        createOrgController.profilePath.value = result.path!;
        createOrgController.userList.addAll(result.data!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // log("-=- orgId -=-=-=- ${createOrgController!.orgId.value}");
    createOrgController = Get.find<CreateOrgController>();

    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.transparent,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Text(
                        "Congratulations",
                        style: size14_M_bold(textColor: Colors.black),
                      ),
                      Text(
                        "Your Org Profile is created",
                        style: size12_M_normal(textColor: Colors.black),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () {
                createOrgController.search.value = "";
                createOrgController.userList.clear();
                page = 1;
                return _getUserSuggestion(context);
              },
              child: ListView(
                controller: muddaScrollController,
                children: [
                  Center(
                    child: Text(
                      createOrgController.orgName.value,
                      style: size18_M_normal(textColor: Colors.black),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        "@${createOrgController.username.value}",
                        style:
                            size14_M_normal(textColor: const Color(0xFFF1B008)),
                      )
                    ],
                  ),
                  getSizedBox(h: 10),
                  whiteDivider(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5)),
                  getSizedBox(h: 10),
                  Form(key: _formKey,
                      child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              "Additional Information (Optional)",
                              style: size14_M_normal(textColor: color606060),
                            ),
                          ],
                        ),
                      ),
                      getSizedBox(h: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: getHeight(120),
                          width: Get.width,
                          decoration: BoxDecoration(
                              color: const Color(0xFFf7f7f7),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white)),
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(400),
                            ],
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            style: size14_M_normal(textColor: color606060),
                            onChanged: (text) {
                              createOrgController.visionStatement.value = text;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              hintText:
                              "Write your Org’s Vision Statement in max \n 500 characters",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      getSizedBox(h: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: AppTextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100),
                            ],
                            onChange: (text) {
                              createOrgController.orgAddress.value = text;
                            },
                            hintText:
                            "Type Org Address (this wont be shown to public)"),
                      ),
                    ],
                  )),
                  getSizedBox(h: 20),
                  whiteDivider(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5)),
                  Text(
                    "(Now invite minimum 11 members to have your Org Approved)",
                    style: size12_M_normal(textColor: const Color(0xFF0060FF)),
                  ),
                  getSizedBox(h: 10),
                  Text(
                    "Assign Proper Permissions by reading the below info carefully to protect your Org-",
                    style: size12_M_bold(textColor: color202020),
                  ),
                  getSizedBox(h: 10),
                  whiteDivider(),
                  getSizedBox(h: 10),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Founder',
                              style: size12_M_regular(textColor: color0060FF),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Full Permission: \n',
                                    style: size12_M_bold(textColor: black),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '[ Close Org or Add / Remove Founding Member with 51% Founder + Co-Founder’s voting ]',
                                        style: size12_M_regular(
                                          textColor: black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // whiteDivider(
                                //     margin:
                                //         const EdgeInsets.symmetric(vertical: 5)),
                                // RichText(
                                //   text: TextSpan(
                                //     text: 'Mudda: ',
                                //     style: size12_M_bold(textColor: black),
                                //     children: <TextSpan>[
                                //       TextSpan(
                                //         text: 'Create Mudda, Posts & Comments',
                                //         style: size12_M_regular(
                                //           textColor: black,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // whiteDivider(
                                //     margin:
                                //         const EdgeInsets.symmetric(vertical: 5)),
                                // RichText(
                                //   text: TextSpan(
                                //     text: 'Muddebaaz Feed: ',
                                //     style: size12_M_bold(textColor: black),
                                //     children: <TextSpan>[
                                //       TextSpan(
                                //         text: 'Create Quotes & Activities',
                                //         style: size12_M_regular(
                                //           textColor: black,
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      whiteDivider(
                          margin: const EdgeInsets.symmetric(vertical: 5)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: 'Co-Founder \n',
                                style: size12_M_bold(textColor: color35bedc),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '(Co-Fo)',
                                    style: size10_M_medium(
                                      textColor: color35bedc,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: RichText(
                              text: TextSpan(
                                text: 'Full Permission: \n',
                                style: size12_M_bold(textColor: black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '[ Close Org or Add / Remove Founding Member with 51% Founder + Co-Founder’s voting ]',
                                    style: size12_M_regular(
                                      textColor: black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  whiteDivider(
                      margin: const EdgeInsets.only(top: 8, bottom: 8)),
                  moreView
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            moreView = true;
                            setState(() {});
                          },
                          child: Column(
                            children: [
                              Text(
                                "more",
                                style: size12_M_medium(textColor: grey),
                              ),
                              Image.asset(
                                AppIcons.iconArrowDown,
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                  moreView
                      ? Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  "Speakers",
                                  style:
                                      size12_M_regular(textColor: colorF1B008),
                                )),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Mudda: ',
                                          style:
                                              size12_M_bold(textColor: black),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Posts & Comments',
                                              style: size12_M_regular(
                                                textColor: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      whiteDivider(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5)),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Muddebaaz Feed: ',
                                          style:
                                              size12_M_bold(textColor: black),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  'Create Quotes & Activities',
                                              style: size12_M_regular(
                                                textColor: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            whiteDivider(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  "Admins",
                                  style:
                                      size12_M_regular(textColor: color606060),
                                )),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Org: ',
                                          style:
                                              size12_M_bold(textColor: black),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  'Invite & Join Members, Remove non-Founding Members, Edit Profile',
                                              style: size12_M_regular(
                                                textColor: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            whiteDivider(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                  "Members",
                                  style:
                                      size12_M_regular(textColor: color606060),
                                )),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Mudda: ',
                                          style:
                                              size12_M_bold(textColor: black),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  'Posts {with approvals from any one in the allowed list or if the Mudda is set as All, Auto Approved}',
                                              style: size12_M_regular(
                                                textColor: black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            whiteDivider(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5)),
                            // -=-=-
                            Row(
                              children: [
                                Text(
                                  "Invitation link",
                                  style:
                                      size14_M_normal(textColor: Colors.black),
                                ),
                                getSizedBox(w: 10),
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: orgProfileLink!));
                                    var snackBar = const SnackBar(
                                      content:
                                          Text('Copied your Invitation link'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: const Icon(
                                    Icons.content_copy,
                                    size: 17,
                                    color: colorGrey,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              orgProfileLink!,
                              // "https://userapi.mudda.app/orgprofile/${AppPreference().getString(PreferencesKey.orgUserId)}",
                              style: size12_M_normal(textColor: colorGrey),
                            ),
                            getSizedBox(h: 30),
                            Center(
                              child: orgBox(
                                  title: "Invite",
                                  icon: AppIcons.inviteIcon,
                                  onTap: () {
                                    bottomsheet(context);
                                  }),
                            ),
                            getSizedBox(h: 16),
                            GestureDetector(
                              onTap: () {
                                moreView = false;
                                setState(() {});
                              },
                              child: Column(
                                children: [
                                  Text("less",
                                      style: size14_M_medium(textColor: grey),
                                      textAlign: TextAlign.center),
                                  Image.asset(
                                    AppIcons.iconArrowUp,
                                    height: 20,
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            getSizedBox(h: 30),
                            whiteDivider(),
                          ],
                        )
                      : const SizedBox(),
                  getSizedBox(h: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: kElevationToShadow[3],
                    ),
                    child: AppTextField(
                      hintText: "Search",
                      suffixIcon: Image.asset(AppIcons.searchIcon, scale: 2),
                      borderColor: grey,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (text) {
                        createOrgController.search.value = text!;
                        createOrgController.userList.clear();
                        page = 1;
                        Api.get.call(context,
                            method: "organization-member/invite-suggestion",
                            param: {
                              "page": page.toString(),
                              "search": createOrgController.search.value,
                              "organization_id": AppPreference()
                                  .getString(PreferencesKey.orgUserId),
                            },
                            isLoading: false, onResponseSuccess: (Map object) {
                          print(object);
                          var result = UserSuggestionsModel.fromJson(object);
                          if (result.data!.isNotEmpty) {
                            createOrgController.profilePath.value =
                                result.path!;
                            createOrgController.userList.addAll(result.data!);
                          } else {
                            page = page > 1 ? page - 1 : page;
                          }
                        });
                      },
                      onChange: (text) {
                        if (text.isEmpty) {
                          createOrgController.search.value = "";
                          createOrgController.userList.clear();
                          page = 1;
                          Api.get.call(context,
                              method: "organization-member/invite-suggestion",
                              param: {
                                "page": page.toString(),
                                "search": createOrgController.search.value,
                                "organization_id": AppPreference()
                                    .getString(PreferencesKey.orgUserId),
                              },
                              isLoading: false,
                              onResponseSuccess: (Map object) {
                            print(object);
                            var result = UserSuggestionsModel.fromJson(object);
                            if (result.data!.isNotEmpty) {
                              createOrgController.profilePath.value =
                                  result.path!;
                              createOrgController.userList
                                  .addAll(result.data!);
                            } else {
                              page = page > 1 ? page - 1 : page;
                            }
                          });
                        }
                      },
                    ),
                  ),
                  getSizedBox(h: 20),
                  Row(
                    children: [
                      Text(
                        "Suggestions to Invite",
                        style: size12_M_normal(textColor: colorGrey),
                      ),
                    ],
                  ),
                  getSizedBox(h: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() => createOrgController.userList.isEmpty
                        ? const SizedBox()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: createOrgController.userList.length,
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
                                              createOrgController
                                                          .userList[index]
                                                          .profile !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          "${createOrgController.profilePath.value}${createOrgController.userList[index].profile}",
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        width: ScreenUtil()
                                                            .setSp(48),
                                                        height: ScreenUtil()
                                                            .setSp(48),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colorWhite,
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          24)) //                 <--- border radius here
                                                              ),
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      placeholder:
                                                          (context, url) =>
                                                              CircleAvatar(
                                                        backgroundColor:
                                                            lightGray,
                                                        radius: ScreenUtil()
                                                            .setSp(24),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            lightGray,
                                                        radius: ScreenUtil()
                                                            .setSp(24),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: ScreenUtil()
                                                          .setSp(48),
                                                      width: ScreenUtil()
                                                          .setSp(48),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: darkGray,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            createOrgController
                                                                    .userList[
                                                                        index]
                                                                    .fullname!
                                                                    .isEmpty
                                                                ? "-"
                                                                : createOrgController
                                                                    .userList[
                                                                        index]
                                                                    .fullname![
                                                                        0]
                                                                    .toUpperCase(),
                                                            style: GoogleFonts
                                                                .nunitoSans(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            20),
                                                                    color:
                                                                        black)),
                                                      ),
                                                    ),
                                              getSizedBox(w: 8),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    createOrgController
                                                                .userList[index]
                                                                .fullname !=
                                                            null
                                                        ? createOrgController
                                                            .userList[index]
                                                            .fullname!
                                                        : "-",
                                                    style: size12_M_bold(
                                                        textColor:
                                                            Colors.black),
                                                  ),
                                                  getSizedBox(h: 2),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    child: Text(
                                                      createOrgController
                                                                  .userList[
                                                                      index]
                                                                  .profession !=
                                                              null
                                                          ? createOrgController
                                                              .userList[index]
                                                              .profession!
                                                          : "-",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
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
                                        Api.post.call(
                                          context,
                                          method: "request-to-user/store",
                                          param: {
                                            "user_id": AppPreference()
                                                .getString(
                                                    PreferencesKey.orgUserId),
                                            "request_to_user_id":
                                                createOrgController
                                                    .userList[index].sId,
                                            "requestModalPath":
                                                createOrgController
                                                    .profilePath.value,
                                            "requestModal": "Users",
                                            "request_type": "invite",
                                          },
                                          onResponseSuccess: (object) {
                                            print("Abhishek $object");
                                            AcceptUserDetail user =
                                                createOrgController
                                                    .userList[index];
                                            user.invitedStatus = true;
                                            // user.amIFollowing = 1;
                                            int sunIndex = index;
                                            createOrgController.userList
                                                .removeAt(index);
                                            createOrgController.userList
                                                .insert(sunIndex, user);
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          createOrgController.userList[index]
                                                      .invitedStatus ==
                                                  false
                                              ? "Invite"
                                              : "Invited",
                                          style: size12_M_normal(
                                              textColor: colorGrey),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            })),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GetStartedButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    AppPreference _appPreference = AppPreference();
                  FormData formData = FormData.fromMap({
                    "description":
                    createOrgController.visionStatement.value,
                    "org_address":
                    createOrgController.orgAddress.value,
                    "_id": _appPreference
                        .getString(PreferencesKey.orgUserId),
                    });
                  Api.uploadPost.call(context,
                      method: "user/profile-update",
                      param: formData,
                      isLoading: true,
                      onResponseSuccess: (Map object) {
                        var snackBar = const SnackBar(
                          content: Text('Updated'),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar);
                        createOrgController.visionStatement.value = "";
                        createOrgController.orgAddress.value = "";
                        Get.back();
                      });
                  }
                  print('orgvision : ${createOrgController.visionStatement.value} : ${createOrgController.orgAddress.value}');
                  Get.offNamed(RouteConstants.orgAdditionalData);
                  createOrgController.username.value = "";
                  createOrgController.orgName.value = "";
                  createOrgController.orgThumb.value = "";
                },
                title: "Done",
              ),
            )
          ],
        ),
      ),
    );
  }

  _getUserSuggestion(BuildContext context) async {
    Api.get.call(context,
        method: "organization-member/invite-suggestion",
        param: {
          "page": page.toString(),
          "search": createOrgController.search.value,
          "organization_id":
              AppPreference().getString(PreferencesKey.orgUserId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
      print(object);
      var result = UserSuggestionsModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        createOrgController.profilePath.value = result.path!;
        createOrgController.userList.addAll(result.data!);
      } else {
        page = page > 1 ? page - 1 : page;
      }
    });
  }

  void bottomsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: getHeight(380),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getSizedBox(h: 30),
                    Row(
                      children: [
                        Text(
                          "Invite Existing Mudda Members",
                          style: size14_M_normal(textColor: greyTextColor),
                        ),
                        getSizedBox(w: 20),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            Get.toNamed(RouteConstants.invitedOrgSearchScreen);
                          },
                          child: Image.asset(
                            AppIcons.searchIcon,
                            height: 26,
                            width: 26,
                          ),
                        )
                      ],
                    ),
                    getSizedBox(h: 5),
                    Text("or", style: size12_M_normal(textColor: colorGrey)),
                    getSizedBox(h: 5),
                    Text(
                      "Share Outside",
                      style: size14_M_normal(textColor: greyTextColor),
                    ),
                    getSizedBox(h: 10),
                    Text(
                      "Heylo, I have created my community / Org on Mudda App and would like to invite you to join my community / Org . Please download the app and click the below link to join me. See you there...",
                      style: size14_M_normal(textColor: greyTextColor),
                    ),
                    getSizedBox(h: 10),
                    Text(
                      "https://www.figma.com/proto/pYLkQgjLHNp1i2lEmIhLXl/Mudda-Redesign?node-id=127%3A196&scaling=scale-down&page-id=0%3A1&starting-point-node-id=97%3A202",
                      style: size14_M_normal(textColor: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    getSizedBox(h: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        5,
                        (index) => Container(
                          height: 40,
                          width: 40,
                          child: const Center(child: const Text("App")),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: -17,
              left: 40,
              child: Container(
                height: 34,
                width: 34,
                child: Column(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      child: Center(
                          child: Image.asset(AppIcons.inviteIcon,
                              height: 18, width: 18)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: colorGrey),
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ],
        );
      },
    );
  }
}
