import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/constant_string.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MembersDataModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/ui/screens/profile_screen/controller/org_member_controller.dart';
import 'package:mudda/ui/screens/profile_screen/view/profile_screen.dart';
import 'package:mudda/ui/shared/text_field_widget.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/utils/size_config.dart';

class OrgMembersScreen extends GetView {
  OrgMembersScreen({Key? key}) : super(key: key);
  String sort = "";
  String searchText = "";
  AcceptUserDetail? userDetail;
  List<String> filterList = [
    "Recent",
    "Oldest",
  ];
  OrgMemberController? orgMemberController;
  int placeUp=0;
  int organizationPage = 1;
  ScrollController membersController = ScrollController();

  @override
  Widget build(BuildContext context) {
    userDetail = Get.arguments;
    orgMemberController = Get.put(OrgMemberController());
    organizationPage = 1;
    membersController.addListener(() {
      if (membersController.position.maxScrollExtent ==
          membersController.position.pixels) {
        organizationPage++;
        callMembers(context, "");
      }
    });
    orgMemberController!.memberList.clear();
    callMembers(context, "");
    return Scaffold(
      backgroundColor: colorAppBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(
              () => orgMemberController!.memberList.isNotEmpty
              ? ListView(
            controller: membersController,
            children: [
              SafeArea(
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
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setSp(10),
                              right: ScreenUtil().setSp(10)),
                          child: Text.rich(
                            TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "${userDetail!.fullname}\n",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: ScreenUtil().setSp(16),
                                      fontWeight: FontWeight.w700,
                                      color: black)),
                              TextSpan(
                                  text:
                                  "{${userDetail!.organizationMemberCount} members}",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: ScreenUtil().setSp(16),
                                      fontWeight: FontWeight.w400,
                                      color: black)),
                            ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                              RouteConstants.invitedOrgSearchScreen);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                "assets/svg/invite_member.svg"),
                            const Text("Invite")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              getSizedBox(h: 35),
              orgMemberBox(
                  context: context,
                  member: orgMemberController!.memberList.elementAt(0),
                  index: 0),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4),
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 10),
                itemCount: placeUp - 1,
                itemBuilder: (followersContext, index) {
                  int index2 = index+1;
                  MemberModel member =
                  orgMemberController!.memberList.elementAt(index2);
                  if(member.placeUp==true) {
                    return Padding(
                        padding: EdgeInsets.only(top: 30), child:
                    orgMemberBox(
                        context: context,
                        member: member,
                        index: index2));
                  }
                  else
                    return Container(width: 0,);
                },
              ),
              // orgMemberController!.memberList.length > 1
              //     ? Padding(
              //         padding: const EdgeInsets.only(top: 30),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             orgMemberController!.memberList.length > 1
              //                 ? orgMemberBox(
              //                   context: context,
              //                     member: orgMemberController!.memberList
              //                         .elementAt(1),
              //                     index: 1)
              //                 : Container(),
              //             orgMemberController!.memberList.length > 2
              //                 ? orgMemberBox(
              //                   context: context,
              //                     member: orgMemberController!.memberList
              //                         .elementAt(2),
              //                     index: 2)
              //                 : Container(),
              //           ],
              //         ),
              //       )
              //     : Container(),
              // orgMemberController!.memberList.length > 3
              //     ? Padding(
              //         padding: const EdgeInsets.only(top: 30),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             orgMemberController!.memberList.length > 3
              //                 ? orgMemberBox(
              //                   context: context,
              //                     member: orgMemberController!.memberList
              //                         .elementAt(3),
              //                     index: 3)
              //                 : Container(),
              //             orgMemberController!.memberList.length > 4
              //                 ? orgMemberBox(
              //                   context: context,
              //                     member: orgMemberController!.memberList
              //                         .elementAt(4),
              //                     index: 4)
              //                 : Container(),
              //           ],
              //         ),
              //       )
              //     : Container(),
              getSizedBox(h: 15),
              whiteDivider(),
              getSizedBox(h: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWithoutBoxShadow(
                      title: "Search",
                      icon: AppIcons.searchIcon,
                      onChanged: (text) {
                        if (text.isEmpty) {
                          searchText = text;
                          organizationPage = 1;
                          orgMemberController!.memberList.clear();
                          callMembers(context, text);
                        }
                      },
                      onFieldSubmitted: (text) {
                        searchText = text;
                        organizationPage = 1;
                        orgMemberController!.memberList.clear();
                        callMembers(context, text);
                      },
                      initialValue: searchText,
                    ),
                  ),
                  getSizedBox(w: 15),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      dropdownWidth: 100,
                      dropdownDecoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      customButton: Image.asset(
                        AppIcons.filterIcon3,
                        height: 30,
                        width: 30,
                      ),
                      items: filterList
                          .map(
                            (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item.toString(),
                              style: size12_M_bold(
                                  textColor: Colors.black)),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              getSizedBox(h: 10),
              /*Row(
                  children: [
                    Text(
                      "Founding Members",
                      style: size13_M_bold(textColor: Colors.black),
                    )
                  ],
                ),
                getSizedBox(h: 8),*/
              /*Column(
                        children: List.generate(
                          orgMemberController!.memberList.length > 5
                              ? orgMemberController!.memberList.length - 5
                              : 0,
                          (index2) {
                            int index = index2 + 5;
                            MemberModel member =
                                orgMemberController!.memberList.elementAt(index);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (member.user!.sId ==
                                              AppPreference().getString(
                                                  PreferencesKey.userId)) {
                                            Get.toNamed(
                                                RouteConstants.profileScreen,
                                                arguments: member.user!);
                                          } else {
                                            Map<String, String>? parameters = {
                                              "userDetail":
                                                  jsonEncode(member.user!)
                                            };
                                            Get.toNamed(
                                                RouteConstants
                                                    .otherUserProfileScreen,
                                                parameters: parameters);
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          child: Center(
                                            child: member.user!.profile != null
                                                ? CachedNetworkImage(
                                                    imageUrl:
                                                        "${orgMemberController!.userProfilePath}${member.user!.profile!}",
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      width:
                                                          ScreenUtil().setSp(36),
                                                      height:
                                                          ScreenUtil().setSp(36),
                                                      decoration: BoxDecoration(
                                                        color: colorWhite,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                                ScreenUtil().setSp(
                                                                    18)) //                 <--- border radius here
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
                                                          ScreenUtil().setSp(18),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            CircleAvatar(
                                                      backgroundColor: lightGray,
                                                      radius:
                                                          ScreenUtil().setSp(18),
                                                    ),
                                                  )
                                                : Container(
                                                    height:
                                                        ScreenUtil().setSp(36),
                                                    width: ScreenUtil().setSp(36),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: darkGray,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          member.user!.fullname![0]
                                                              .toUpperCase(),
                                                          style: GoogleFonts
                                                              .nunitoSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              18),
                                                                  color: black)),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      getSizedBox(w: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            member.user!.fullname!,
                                            style: size12_M_normal(
                                                textColor: Colors.black87),
                                          ),
                                          Text(
                                            member.position != null
                                                ? member.position!
                                                : "",
                                            style: size12_M_normal(
                                                textColor: colorGrey),
                                          ),
                                          Text(
                                            "${member.user!.state!}, ${member.user!.country!}",
                                            style: size10_M_normal(
                                                textColor: colorGrey),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          showEditMemberDialogBox(member, index);
                                        },
                                        child: Image.asset(
                                          AppIcons.editIcon,
                                          height: 15,
                                        ),
                                      ),
                                      getSizedBox(w: 15),
                                      InkWell(
                                        onTap: () {
                                          showMemberRemoveDialogBox(
                                              Get.context as BuildContext,
                                              member,
                                              index);
                                        },
                                        child: Image.asset(
                                          AppIcons.profileWithHeiFun,
                                          height: 15,
                                        ),
                                      ),
                                      getSizedBox(w: 10),
                                      Text(
                                        "${NumberFormat.compactCurrency(
                                          decimalDigits: 0,
                                          symbol:
                                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                                        ).format(member.countFollowers ?? 0)} Followers",
                                        style:
                                            size12_M_normal(textColor: colorGrey),
                                      ),
                                    ],
                                  ),
                                  getSizedBox(h: 10),
                                  whiteDivider()
                                ],
                              ),
                            );
                          },
                        ),
                      ),*/
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: orgMemberController!.memberList.length - 1,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (followersContext, index2) {
                      int index = index2 + 1;
                      MemberModel member =
                      orgMemberController!.memberList.elementAt(index);
                      if(member.placeUp==false){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              if (member.user!.sId ==
                                  AppPreference()
                                      .getString(PreferencesKey.userId)) {
                                Get.toNamed(RouteConstants.profileScreen,
                                    arguments: member.user!);
                              } else if (member.user!.userType == "user") {
                                Map<String, String>? parameters = {
                                  "userDetail": jsonEncode(member.user!)
                                };
                                Get.toNamed(
                                    RouteConstants.otherUserProfileScreen,
                                    parameters: parameters);
                              } else {
                                Map<String, String>? parameters = {
                                  "userDetail": jsonEncode(member.user!)
                                };
                                Get.toNamed(
                                    RouteConstants.otherOrgProfileScreen,
                                    parameters: parameters);
                              }
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: member.role
                                              ?.toLowerCase() ==
                                              'creator'
                                              ? color0060FF
                                              : member.role
                                              ?.toLowerCase() ==
                                              'co-founder'
                                              ? color35bedc
                                              : member.role
                                              ?.toLowerCase() ==
                                              'speaker'
                                              ? colorF1B008
                                              : member.role
                                              ?.toLowerCase() ==
                                              'admin'
                                              ? color606060
                                              : Colors.transparent,
                                          child: CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Colors.white,
                                            child: Center(
                                              child: member.user!.profile !=
                                                  null
                                                  ? CachedNetworkImage(
                                                imageUrl:
                                                "${orgMemberController!.userProfilePath}${member.user!.profile!}",
                                                imageBuilder: (context,
                                                    imageProvider) =>
                                                    Container(
                                                      width: ScreenUtil()
                                                          .setSp(36),
                                                      height: ScreenUtil()
                                                          .setSp(36),
                                                      decoration:
                                                      BoxDecoration(
                                                        color: colorWhite,
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                                ScreenUtil()
                                                                    .setSp(
                                                                    18)) //                 <--- border radius here
                                                        ),
                                                        image: DecorationImage(
                                                            image:
                                                            imageProvider,
                                                            fit: BoxFit
                                                                .cover),
                                                      ),
                                                    ),
                                                placeholder:
                                                    (context, url) =>
                                                    CircleAvatar(
                                                      backgroundColor:
                                                      lightGray,
                                                      radius: ScreenUtil()
                                                          .setSp(18),
                                                    ),
                                                errorWidget: (context,
                                                    url, error) =>
                                                    CircleAvatar(
                                                      backgroundColor:
                                                      lightGray,
                                                      radius: ScreenUtil()
                                                          .setSp(18),
                                                    ),
                                              )
                                                  : Container(
                                                height: ScreenUtil()
                                                    .setSp(36),
                                                width: ScreenUtil()
                                                    .setSp(36),
                                                decoration:
                                                BoxDecoration(
                                                  border: Border.all(
                                                    color: darkGray,
                                                  ),
                                                  shape:
                                                  BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      member
                                                          .user!
                                                          .fullname![
                                                      0]
                                                          .toUpperCase(),
                                                      style: GoogleFonts.nunitoSans(
                                                          fontWeight:
                                                          FontWeight
                                                              .w400,
                                                          fontSize: ScreenUtil()
                                                              .setSp(
                                                              18),
                                                          color:
                                                          black)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                    flex: 5,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          member.user!
                                                              .fullname!,
                                                          style: GoogleFonts.nunitoSans(
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              fontSize:
                                                              ScreenUtil()
                                                                  .setSp(
                                                                  14)),
                                                        ),
                                                        getSizedBox(w: 15),
                                                        member.role != null && member.role?.toLowerCase() != 'member'
                                                            ? Icon(
                                                          Icons
                                                              .circle,
                                                          size: 5,
                                                        )
                                                            : Container(
                                                            width: 0),
                                                        getSizedBox(w: 3),
                                                        Text(
                                                          member.role != null && member.role?.toLowerCase() != 'member'
                                                              ? member.role!
                                                              : "",
                                                          style: size12_M_normal(
                                                              textColor: Colors
                                                                  .black87),
                                                        ),
                                                      ],
                                                    )),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .end,
                                                    children: [
                                                      member.user!.sId !=AppPreference().getString(PreferencesKey.userId)?
                                                      InkWell(
                                                        onTap: () {
                                                          showEditMemberDialogBox(
                                                              member, index);
                                                        },
                                                        child: Image.asset(
                                                          AppIcons.editIcon,
                                                          height: 14,
                                                        ),
                                                      ):SizedBox(width: 0,),
                                                      getSizedBox(w: 18),
                                                      // InkWell(
                                                      //   onTap: () {
                                                      //     showMemberRemoveDialogBox(
                                                      //         Get.context as BuildContext,
                                                      //         member,
                                                      //         index);
                                                      //   },
                                                      //   child: Image.asset(
                                                      //     AppIcons.profileWithHeiFun,
                                                      //     height: 10,
                                                      //   ),
                                                      // ),
                                                      // getSizedBox(w: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          if (member.amIFollowing ==
                                                              0) {
                                                            member.amIFollowing=1;
                                                            Api.post.call(
                                                              context,
                                                              method:
                                                              "request-to-user/store",
                                                              param: {
                                                                "user_id": AppPreference()
                                                                    .getString(
                                                                    PreferencesKey.userId),
                                                                "request_to_user_id":
                                                                member
                                                                    .user!
                                                                    .sId,
                                                                "request_type":
                                                                "follow",
                                                              },
                                                              onResponseSuccess:
                                                                  (object) {
                                                                print(
                                                                    object);
                                                              },
                                                            );
                                                            int sunIndex = index;
                                                            orgMemberController!.memberList.removeAt(index);
                                                            orgMemberController!.memberList
                                                                .insert(sunIndex, member);
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                          BoxDecoration(
                                                            color: Colors
                                                                .transparent,
                                                            border: Border.all(
                                                                color: member.amIFollowing ==
                                                                    0 &&
                                                                    member.user!.sId !=
                                                                        AppPreference().getString(PreferencesKey
                                                                            .userId)
                                                                    ? Colors
                                                                    .white
                                                                    : Colors
                                                                    .transparent),
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                8,
                                                                vertical:
                                                                0),
                                                            child: Text(
                                                              member.amIFollowing ==
                                                                  0 &&
                                                                  member.user!.sId !=
                                                                      AppPreference().getString(PreferencesKey.userId)
                                                                  ? "Follow"
                                                                  : "Follow",
                                                              style: size10_M_normal(
                                                                  textColor: member.amIFollowing ==
                                                                      0 &&
                                                                      member.user!.sId !=
                                                                          AppPreference().getString(PreferencesKey.userId)
                                                                      ? Colors
                                                                      .black
                                                                      : Colors.transparent),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            // Text(
                                            //   member.position != null
                                            //       ? member.position!
                                            //       : "",
                                            //   style: size12_M_normal(
                                            //       textColor: colorGrey),
                                            // ),
                                            // Text(
                                            //   "${member.user!.state!}, ${member.user!.country!}",
                                            //   style: size10_M_normal(
                                            //       textColor: colorGrey),
                                            // ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  member.position != null
                                                      ? member.position!
                                                      : "",
                                                  style: size12_M_normal(
                                                      textColor: colorGrey),
                                                ),
                                                member.position == null
                                                    ? getSizedBox(w: 0)
                                                    : getSizedBox(w: 5),
                                                Text(
                                                  "${member.user!.state!}, ${member.user!.country!}",
                                                  style: size10_M_normal(
                                                      textColor: colorGrey),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "${NumberFormat.compactCurrency(
                                                decimalDigits: 0,
                                                symbol:
                                                '', // if you want to add currency symbol then pass that in this else leave it empty.
                                              ).format(member.countFollowers ?? 0)} Followers",
                                              style: size12_M_normal(
                                                  textColor: colorGrey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                getSizedBox(h: 10),
                                whiteDivider()
                              ],
                            ),
                          ),
                        ); }
                      else {
                        return Container(width: 0);
                      }
                    }),
              )
            ],
          )
              : SafeArea(
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setSp(10),
                          right: ScreenUtil().setSp(10)),
                      child: Text.rich(
                        TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "${userDetail!.fullname}\n",
                              style: GoogleFonts.nunitoSans(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.w700,
                                  color: black)),
                          TextSpan(
                              text:
                              "{${userDetail!.organizationMemberCount} members}",
                              style: GoogleFonts.nunitoSans(
                                  fontSize: ScreenUtil().setSp(16),
                                  fontWeight: FontWeight.w400,
                                  color: black)),
                        ]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteConstants.invitedOrgSearchScreen);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/svg/invite_member.svg"),
                        const Text("Invite")
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  orgMemberBox({
    required context,
    required MemberModel member,
    required int index,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        InkWell(
          onTap: () {
            if (member.user!.sId ==
                AppPreference().getString(PreferencesKey.userId)) {
              Get.toNamed(RouteConstants.profileScreen,
                  arguments: member.user!);
            } else if (member.user!.userType == "user") {
              Map<String, String>? parameters = {
                "userDetail": jsonEncode(member.user!)
              };
              Get.toNamed(RouteConstants.otherUserProfileScreen,
                  parameters: parameters);
            } else {
              Map<String, String>? parameters = {
                "userDetail": jsonEncode(member.user!)
              };
              Get.toNamed(RouteConstants.otherOrgProfileScreen,
                  parameters: parameters);
            }
          },
          child: Container(
            width: getWidth(160),
            height: getHeight(110),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          member.role != null ? member.role == 'Co-Founder'? "Co-Fo.." : member.role! : "",
                          textAlign: TextAlign.center,
                          style: size12_M_semibold(
                            textColor: member.role?.toLowerCase() == 'creator'
                                ? color0060FF
                                : member.role?.toLowerCase() == 'co-founder'
                                ? color35bedc
                                : member.role?.toLowerCase() == 'speaker'
                                ? colorF1B008
                                : member.role?.toLowerCase() ==
                                'admin'
                                ? color606060
                                : colorAppBackground,
                          ),
                        ),
                        member.user!.sId !=AppPreference().getString(PreferencesKey.userId)?InkWell(
                          onTap: () {
                            showEditMemberDialogBox(
                                member, index);
                          },
                          child: Image.asset(
                            AppIcons.editIcon,
                            height: 14,
                          ),
                        ):SizedBox(width: 0,),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        member.user!.fullname !=null? member.user!.fullname! : "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunitoSans(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(14)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setSp(10),
                        right: ScreenUtil().setSp(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          member.position != null ? member.position! : "",
                          textAlign: TextAlign.center,
                          style: size10_M_semibold(
                            textColor: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        Text(
                          member.user!.city != null ? member.user!.city! : "",
                          textAlign: TextAlign.center,
                          style: size10_M_semibold(
                            textColor: Colors.black87,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: getWidth(160),
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.only(top: 6, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                            "${NumberFormat.compactCurrency(
                              decimalDigits: 0,
                              symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                            ).format(member.countFollowers ?? 0)} Followers",
                            style: size10_M_semibold(
                                textColor:
                                member.role?.toLowerCase() != 'creator' &&
                                    member.role?.toLowerCase() !=
                                        'co-founder' &&
                                    member.role?.toLowerCase() !=
                                        'speaker' &&
                                    member.role?.toLowerCase() !=
                                        'admin'
                                    ? colorBlack
                                    : colorWhite)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            if (member.amIFollowing == 0) {
                              member.amIFollowing=1;
                              Api.post.call(
                                context,
                                method: "request-to-user/store",
                                param: {
                                  "user_id": AppPreference()
                                      .getString(PreferencesKey.userId),
                                  "request_to_user_id": member.user!.sId,
                                  "request_type": "follow",
                                },
                                onResponseSuccess: (object) {
                                  print(object);
                                },
                              );
                              int sunIndex = index;
                              orgMemberController!.memberList.removeAt(index);
                              orgMemberController!.memberList
                                  .insert(sunIndex, member);
                            }
                          },
                          child: Text(
                            member.amIFollowing == 0 &&
                                member.user!.sId !=
                                    AppPreference()
                                        .getString(PreferencesKey.userId)
                                ? "Follow"
                                : "",
                            style: size10_M_normal(
                                textColor: member.amIFollowing == 0
                                    ? member.role?.toLowerCase() !=
                                    'creator' &&
                                    member.role?.toLowerCase() !=
                                        'co-founder' &&
                                    member.role?.toLowerCase() !=
                                        'speaker' &&
                                    member.role?.toLowerCase() !=
                                        'admin'
                                    ? colorBlack
                                    : colorWhite
                                    : colorA0A0A0),
                          ),
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: member.role?.toLowerCase() == 'creator'
                        ? color0060FF
                        : member.role?.toLowerCase() == 'co-founder'
                        ? color35bedc
                        : member.role?.toLowerCase() == 'speaker'
                        ? colorF1B008
                        : member.role?.toLowerCase() == 'admin'
                        ? color606060
                        : colorWhite,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    border: Border.all(width: 0.5,color:colorWhite ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0.0, 4.0),
                      blurRadius: 4.0)
                ],
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                color: member.role?.toLowerCase() != 'creator' &&
                    member.role?.toLowerCase() != 'co-founder' &&
                    member.role?.toLowerCase() != 'speaker' &&
                    member.role?.toLowerCase() != 'admin'
                    ? colorAppBackground
                    : colorWhite,
                border: Border.all(
                  width: 0.5,
                  color: member.role?.toLowerCase() == 'creator'
                      ? color0060FF
                      : member.role?.toLowerCase() == 'co-founder'
                      ? color35bedc
                      : member.role?.toLowerCase() == 'speaker'
                      ? colorF1B008
                      : member.role?.toLowerCase() == 'admin'
                      ? color606060
                      : colorWhite,
                )),
          ),
        ),
        Positioned(
          top: -22,
          child: InkWell(
            onTap: () {
              if (member.user!.sId ==
                  AppPreference().getString(PreferencesKey.userId)) {
                Get.toNamed(RouteConstants.profileScreen,
                    arguments: member.user!);
              } else if (member.user!.userType == "user") {
                Map<String, String>? parameters = {
                  "userDetail": jsonEncode(member.user!)
                };
                Get.toNamed(RouteConstants.otherUserProfileScreen,
                    parameters: parameters);
              } else {
                Map<String, String>? parameters = {
                  "userDetail": jsonEncode(member.user!)
                };
                Get.toNamed(RouteConstants.otherOrgProfileScreen,
                    parameters: parameters);
              }
            },
            child: CircleAvatar(
              radius: 22,
              backgroundColor: member.role?.toLowerCase() == 'creator'
                  ? color0060FF
                  : member.role?.toLowerCase() == 'co-founder'
                  ? color35bedc
                  : member.role?.toLowerCase() == 'speaker'
                  ? colorF1B008
                  : member.role?.toLowerCase() == 'admin'
                  ? color606060
                  : Colors.transparent,
              child: Center(
                child: member.user!.profile != null
                    ? CachedNetworkImage(
                  imageUrl:
                  "${orgMemberController!.userProfilePath}${member.user!.profile!}",
                  imageBuilder: (context, imageProvider) => Container(
                    width: ScreenUtil().setSp(40),
                    height: ScreenUtil().setSp(40),
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setSp(
                              20)) //                 <--- border radius here
                      ),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    backgroundColor: lightGray,
                    radius: ScreenUtil().setSp(20),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: lightGray,
                    radius: ScreenUtil().setSp(20),
                  ),
                )
                    : Container(
                  height: ScreenUtil().setSp(40),
                  width: ScreenUtil().setSp(40),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    border: Border.all(
                      color: darkGray,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(member.user!.fullname![0].toUpperCase(),
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(20),
                            color: black)),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Positioned(
        //     top: -10,
        //     right: 180,
        //     child: Image.asset(trueIcon, height: 20, width: 20)),
      ],
    );
  }

  showMemberRemoveDialogBox(
      BuildContext context, MemberModel member, int index) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Container(
              width: getWidth(300),
              height: 70,
              color: Colors.white,
              child: Material(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    const Text(
                      "Are you sure you want to remove the member?",
                      style: TextStyle(
                          color: colorGrey,
                          fontSize: 10,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 35,
                          child: TextButton(
                            onPressed: () {
                              Api.delete.call(
                                context,
                                method:
                                "organization-member/delete/${member.sId}",
                                param: {},
                                onResponseSuccess: (object) {
                                  print(object);
                                  orgMemberController!.memberList
                                      .removeAt(index);
                                  Get.back();
                                },
                              );
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  color: colorGrey,
                                  fontSize: 12.sp,
                                  letterSpacing: 0.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "No",
                              style: TextStyle(
                                  color: colorGrey,
                                  fontSize: 12.sp,
                                  letterSpacing: 0.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showEditMemberDialogBox(MemberModel member, int index) {
    final _formKey = GlobalKey<FormState>();
    orgMemberController!.locationController.value.text =
    member.position != null ? member.position! : "";
    orgMemberController!.permission.value =
    member.role != null ? member.role! : "";
    return showDialog(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(
              left: ScreenUtil().setSp(15),
              right: ScreenUtil().setSp(15),
              bottom: 0,
              top: 0),
          elevation: 3,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil()
                  .setSp(5)) //                 <--- border radius here
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getSizedBox(h: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                // backgroundColor: Colors.white,
                                child: Center(
                                  child: member.user!.profile != null
                                      ? CachedNetworkImage(
                                    imageUrl:
                                    "${orgMemberController!.userProfilePath}${member.user!.profile!}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          width: ScreenUtil().setSp(40),
                                          height: ScreenUtil().setSp(40),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(ScreenUtil().setSp(
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
                                          radius: ScreenUtil().setSp(20),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                          backgroundColor: lightGray,
                                          radius: ScreenUtil().setSp(20),
                                        ),
                                  )
                                      : Container(
                                    height: ScreenUtil().setSp(40),
                                    width: ScreenUtil().setSp(40),
                                    decoration: BoxDecoration(
                                      color: colorAppBackground,
                                      border: Border.all(
                                        color: darkGray,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                          member.user!.fullname![0]
                                              .toUpperCase(),
                                          style: GoogleFonts.nunitoSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                              ScreenUtil().setSp(20),
                                              color: black)),
                                    ),
                                  ),
                                ),
                              ),
                              getSizedBox(w: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.user!.fullname!,
                                    style: size12_M_bold(textColor: Colors.black),
                                  ),
                                  Text(
                                    member.position != null ? member.position! : "",
                                    style: size12_M_medium(textColor: Colors.black),
                                  ),
                                  Text(
                                    "${member.user!.city},${member.user!.state}",
                                    style: size12_M_bold(textColor: Colors.grey),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showMemberRemoveDialogBox(
                                      Get.context as BuildContext,
                                      member,
                                      index);
                                },
                                child: Container(
                                  decoration:
                                  BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: colorWhite,
                                      border: Border.all(
                                          color: colorA0A0A0),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black45,
                                            offset: Offset(0,2),
                                            blurRadius: 2
                                        )
                                      ]
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal:
                                        8,
                                        vertical:
                                        2),
                                    child: Text(
                                      "Remove",
                                      style: size12_M_normal(
                                          textColor: color606060),
                                    ),
                                  ),
                                ),
                              ),
                              getSizedBox(h: 10),
                              InkWell(
                                onTap: () {
                                  member.placeUp = !member.placeUp!;
                                  if (_formKey.currentState!.validate()) {
                                    Api.post.call(
                                      context,
                                      method: "organization-member/update",
                                      param: {
                                        "_id": member.sId,
                                        "placeUp": member.placeUp,
                                      },
                                      onResponseSuccess: (object) {
                                        print(object);
                                        sortMembers(context);
                                        Get.back();
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  decoration:
                                  BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: colorWhite,
                                      border: Border.all(
                                          color: colorA0A0A0),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black45,
                                            offset: Offset(0,2),
                                            blurRadius: 2
                                        )
                                      ]
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal:
                                        8,
                                        vertical:
                                        2),
                                    child: Text(
                                      member.placeUp!?"Place Down":"Place Up",
                                      style: size12_M_normal(
                                          textColor: color606060),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      getSizedBox(h: 20),
                      TypeAheadFormField<String>(
                        // validator: (value) {
                        //   return value!.isEmpty ? "Enter Position" : null;
                        // },
                        textFieldConfiguration: TextFieldConfiguration(
                            controller:
                            orgMemberController!.locationController.value,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            style: size14_M_normal(textColor: color606060),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFf7f7f7),
                              contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              hintText: "Enter Position",
                              hintStyle:
                              size14_M_normal(textColor: color606060),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide:
                                const BorderSide(color: grey, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide:
                                const BorderSide(color: grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide:
                                const BorderSide(color: grey, width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide:
                                const BorderSide(color: grey, width: 1),
                              ),
                            )),
                        suggestionsCallback: (pattern) {
                          return _getLocation(pattern, context);
                        },
                        hideSuggestionsOnKeyboardHide: false,
                        itemBuilder: (context, suggestion) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              suggestion,
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
                          orgMemberController!.locationController.value.text =
                              suggestion;
                        },
                      ),
                      getSizedBox(h: 20),
                      Text(
                        "Role:",
                        style: size14_M_normal(textColor: colorGrey),
                      ),
                      getSizedBox(h: 5),
                      Obx(
                            () => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    orgMemberController!.permission.value = "Co-Founder";
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 15,
                                        child:
                                        orgMemberController!.permission.value ==
                                            "Co-Founder"
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
                                      getSizedBox(w: 5),
                                      Text(
                                        "Co-Founder",
                                        style:
                                        size14_M_normal(textColor: colorDarkBlack),
                                      ),
                                    ],
                                  ),
                                ),
                                getSizedBox(h: 10),
                                InkWell(
                                  onTap: () {
                                    orgMemberController!.permission.value = "Admin";
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 15,
                                        child:
                                        orgMemberController!.permission.value ==
                                            "Admin"
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
                                      getSizedBox(w: 5),
                                      Text(
                                        "Admin",
                                        style:
                                        size14_M_normal(textColor: colorDarkBlack),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            getSizedBox(w: 40),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    orgMemberController!.permission.value =
                                    "Speaker";
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 15,
                                        child:
                                        orgMemberController!.permission.value ==
                                            "Speaker"
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
                                      getSizedBox(w: 5),
                                      Text(
                                        "Speaker",
                                        style:
                                        size14_M_normal(textColor: colorDarkBlack),
                                      ),
                                    ],
                                  ),
                                ),
                                getSizedBox(h: 10),
                                InkWell(
                                  onTap: () {
                                    orgMemberController!.permission.value = "member";
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 15,
                                        child:
                                        orgMemberController!.permission.value ==
                                            "member"
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
                                      getSizedBox(w: 5),
                                      Text(
                                        "Member",
                                        style:
                                        size14_M_normal(textColor: colorDarkBlack),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      getSizedBox(h: 10),
                      Row(
                        children: [
                          Text(
                            "Learn more about ",
                            style: size12_M_regular(textColor: color606060),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.dialog(
                                const PermissionInfoDialog(),
                              );
                            },
                            child: Text(
                              "Permissions",
                              style: size12_M_regular(
                                  textColor: const Color(0xFF0060FF))
                                  .copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      getSizedBox(h: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (orgMemberController!
                                    .permission.value.isNotEmpty) {
                                  Api.post.call(
                                    context,
                                    method: "organization-member/update",
                                    param: {
                                      "_id": member.sId,
                                      "position": orgMemberController!
                                          .locationController.value.text,
                                      "role":
                                      orgMemberController!.permission.value,
                                    },
                                    onResponseSuccess: (object) {
                                      print(object);
                                      member.position = orgMemberController!
                                          .locationController.value.text;
                                      member.role =
                                          orgMemberController!.permission.value;
                                      orgMemberController!.memberList
                                          .removeAt(index);
                                      orgMemberController!.memberList
                                          .insert(index, member);
                                      sortMembers(context);
                                      Get.back();
                                    },
                                  );
                                } else {
                                  var snackBar = const SnackBar(
                                    content: Text('Select Permission'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            },
                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Done",
                                style: size14_M_normal(textColor: Colors.black),
                              ),
                            ),
                          ),
                          getSizedBox(w: 30),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Cancel",
                                style: size14_M_normal(textColor: Colors.black),
                              ),
                            ),
                          )
                        ],
                      ),
                      getSizedBox(h: 5),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<String>> _getLocation(String query, BuildContext context) async {
    List<String> positionList = [
      "Chairman",
      "President",
      "Secretory",
      "Treasurer",
      "Life Member",
      "Member",
      "District Committee",
    ];
    List<String> matches = <String>[];
    if (query.isNotEmpty) {
      for (var userDetail in positionList) {
        if (userDetail.toLowerCase().contains(query.toLowerCase())) {
          matches.add(userDetail);
        }
      }
      return matches;
    } else {
      return matches;
    }
  }

  tickButton() {
    return Container(
      height: 20,
      width: 20,
      child: const Center(
          child: CircleAvatar(
            radius: 5,
            backgroundColor: Colors.black87,
          )),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
        ),
      ),
    );
  }

  placeSort(BuildContext context){
    placeUp = 0;
    orgMemberController!.memberList.forEach((element) {
      if(element.placeUp == true){
        placeUp++;
      }
    });
    int k=1;
    for (int i=1;i<orgMemberController!.memberList.length;i++) {
      if(orgMemberController!.memberList.elementAt(i).placeUp==true){
        var e = orgMemberController!.memberList.elementAt(i);
        int j = i;
        while(j>k){
          orgMemberController!.memberList[j] = orgMemberController!.memberList[j-1];
          j--;
        }
        orgMemberController!.memberList[k] = e;
        k++;
      }
    }
  }

  sortMembers(BuildContext context){
    int k = 0;
    orgMemberController!.memberList.forEach((element) {
      if (element.role?.toLowerCase() == 'creator') {
        element.placeUp = true;
        orgMemberController!.memberList.remove(element);
        orgMemberController!.memberList.insert(k, element);
        k++;
      }
      else if (element.placeUp!=true){
        element.placeUp=false;
      }
    });
    orgMemberController!.memberList.forEach((element) {
      if (element.role?.toLowerCase() == 'co-founder') {
        orgMemberController!.memberList.remove(element);
        orgMemberController!.memberList.insert(k, element);
        k++;
      }
    });
    orgMemberController!.memberList.forEach((element) {
      if (element.role?.toLowerCase() == 'speaker') {
        orgMemberController!.memberList.remove(element);
        orgMemberController!.memberList.insert(k, element);
        k++;
      }
    });
    orgMemberController!.memberList.forEach((element) {
      if (element.role?.toLowerCase() == 'admin') {
        orgMemberController!.memberList.remove(element);
        orgMemberController!.memberList.insert(k, element);
        k++;
      }
    });
    placeSort(context);
  }

  callMembers(BuildContext context, String text) async {
    Api.get.call(context,
        method: "organization-member/index",
        param: {
          "search": text,
          "sort": sort,
          "page": organizationPage.toString(),
          "organization_id": userDetail!.sId!
        },
        isLoading: false, onResponseSuccess: (Map object) {
          var result = MembersDataModel.fromJson(object);
          if (result.data!.isNotEmpty) {
            orgMemberController!.userProfilePath.value = result.path!;
            orgMemberController!.memberList.addAll(result.data!);
            sortMembers(context);
          } else {
            organizationPage =
            organizationPage > 1 ? organizationPage - 1 : organizationPage;
          }
        });
  }
}

class PermissionInfoDialog extends StatefulWidget {
  const PermissionInfoDialog({Key? key}) : super(key: key);

  @override
  State<PermissionInfoDialog> createState() => _PermissionInfoDialogState();
}

class _PermissionInfoDialogState extends State<PermissionInfoDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          color: white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Assign Proper Permissions by reading the below info carefully to protect your Org-",
                style: size12_M_bold(textColor: black),
              ),
              getSizedBox(h: 5),
              const Divider(
                color: Color(0xFFA0A0A0),
                thickness: 0.8,
              ),
              getSizedBox(h: 2),
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
              const Divider(
                color: Color(0xFFA0A0A0),
                thickness: 0.8,
                height: 16,
              ),
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
              const Divider(
                color: Color(0xFFA0A0A0),
                thickness: 0.8,
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                        "Speakers",
                        style: size12_M_regular(textColor: const Color(0xFFF1B008)),
                      )),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Mudda: ',
                            style: size12_M_bold(textColor: black),
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
                            margin: const EdgeInsets.symmetric(vertical: 5)),
                        RichText(
                          text: TextSpan(
                            text: 'Muddebaaz Feed: ',
                            style: size12_M_bold(textColor: black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Create Quotes & Activities',
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
              const Divider(
                color: Color(0xFFA0A0A0),
                thickness: 0.8,
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                        "Admins",
                        style: size12_M_regular(textColor: color606060),
                      )),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Org: ',
                            style: size12_M_bold(textColor: black),
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
              const Divider(
                color: Color(0xFFA0A0A0),
                thickness: 0.8,
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                        "Members",
                        style: size12_M_regular(textColor: color606060),
                      )),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Mudda: ',
                            style: size12_M_bold(textColor: black),
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
              const Divider(
                color: Color(0xFFA0A0A0),
                thickness: 0.8,
                height: 16,
              ),
              getSizedBox(h: 5),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Text(
                  'OK',
                  style: size14_M_bold(textColor: black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
