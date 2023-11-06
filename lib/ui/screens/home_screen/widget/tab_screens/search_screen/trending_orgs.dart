import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_colors.dart';

import '../../../../../../core/constant/route_constants.dart';
import '../../../../../../core/preferences/preference_manager.dart';
import '../../../../../../core/preferences/preferences_key.dart';
import '../../../../../../core/utils/color.dart';
import '../../../../../../core/utils/size_config.dart';
import '../../../../../../core/utils/text_style.dart';
import '../../../../../../model/MuddaPostModel.dart';
import '../../../../../../model/SearchModel.dart';
import '../../../controller/search_controller_new.dart';
import '../../../../../../dio/Api/Api.dart';

class TrendingOrgs extends StatefulWidget {
  const TrendingOrgs({Key? key}) : super(key: key);

  @override
  State<TrendingOrgs> createState() => _TrendingOrgsState();
}

class _TrendingOrgsState extends State<TrendingOrgs> {
  int page = 1;
  ScrollController scrollController = ScrollController();
  ScrollController memberOfScrollController = ScrollController();
  SearchController? searchController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = Get.find<SearchController>();
    getTrendingOrg(context);
  }
  @override
  Widget build(BuildContext context) {
    print('unchange : ${searchController!.flag.value}');
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        page++;
        getTrendingOrg(context);
      }
    });
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Trending Public Orgs',
              // style: size12_M_regular300(textColor: colorDarkBlack),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 12),
              ),
              onPressed: () {
                searchController!.orgs.value=!searchController!.orgs.value;
                page++;
                getTrendingOrg(context,limit: 10);
              },
              child: Obx(()=>Text(searchController!.orgs.value?'view less':'view all')),
            ),
          ],
        ),
    Obx(() => searchController!.orgs.value?GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 1,
    childAspectRatio: 2.0),
    shrinkWrap: true,
    controller: scrollController,
    scrollDirection: Axis.vertical,
    padding: EdgeInsets.only(bottom: 8),
    itemCount: searchController!.orgList.length,
    itemBuilder: (context, index) {
    AcceptUserDetail org =
    searchController!.orgList.elementAt(index);
    return Padding(padding: EdgeInsets.only(right: 5,bottom: 8),
    child: orgCard(context: context, org: org, index: index),);
    }
    ):
        SizedBox(
          height: getHeight(181),
          child: ListView.builder(
            controller: scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 5),
              itemCount: searchController!.orgList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index) {
                AcceptUserDetail org =
                searchController!.orgList.elementAt(index);
                return Padding(padding: EdgeInsets.only(right: 5),
                  child: orgCard(context: context, org: org, index: index),)
                ;
              }
          ),
        )),
      ],
    );
  }

  orgCard({
    required context,
    required AcceptUserDetail org,
    required int index,
  }) {
    return InkWell(
        onTap: () {
          if (org.sId ==
              AppPreference().getString(PreferencesKey.orgUserId)) {
            Get.toNamed(RouteConstants.profileScreen,
                arguments: {'page':1});
          } else if (org.userType == "user") {
            Map<String, String>? parameters = {
              "userDetail": jsonEncode(org)
            };
            Get.toNamed(RouteConstants.otherUserProfileScreen,
                parameters: parameters);
          } else {
            Map<String, String>? parameters = {
              "userDetail": jsonEncode(org)
            };
            Get.toNamed(RouteConstants.otherOrgProfileScreen,
                parameters: parameters);
          }
        },
        child: Container(
            height: getHeight(171),
            width: getWidth(343),
            decoration: BoxDecoration(
                color: colorAppBackground,
                border: Border.all(
                  color: colorWhite,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: colorA0A0A0,
                    offset: Offset(0,2),
                    blurRadius: 2,
                  )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          org.profile!=null?
                          GestureDetector(
                            child: Container(
                              height: ScreenUtil().setSp(95),
                              width: ScreenUtil().setSp(95),
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius:
                                BorderRadius.circular(ScreenUtil().setSp(8)),
                                border: Border.all(color: white,width: 1),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 3,
                                      offset: Offset(0, 4)
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(ScreenUtil().setSp(8)),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "${searchController!.userProfilePath.value}${org.profile}",
                                  fit: BoxFit.cover,
                                  color: Colors.black.withOpacity(0.50),
                                  colorBlendMode: BlendMode.softLight,
                                ),
                              ),
                            ),
                          ):
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(ScreenUtil().setSp(8)),
                            child: Container(
                              color: white,
                              height: ScreenUtil().setSp(95),
                              width: ScreenUtil().setSp(95),
                              child: Center(
                                child: Text(
                                    org.fullname![0].toUpperCase(),
                                    style:GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(50),
                                        color: black)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setSp(8),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  org.fullname ??
                                  "",
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: ScreenUtil().setSp(18),
                                      fontWeight: FontWeight.w700,
                                      color: black),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(org.organizationType!.length<15?org.organizationType!:'${org.organizationType!.substring(0,13)}..', style: GoogleFonts.nunitoSans(
                                                fontSize: ScreenUtil().setSp(11),
                                                fontWeight: FontWeight.w400,
                                                color: black,)),
                                              Text(org.memberOfOrganizationCount!=null?"${org.memberOfOrganizationCount} Members":"", style: GoogleFonts.nunitoSans(
                                                fontSize: ScreenUtil().setSp(11),
                                                fontWeight: FontWeight.w400,
                                                color: black,)),
                                            ],
                                          ),
                                          getSizedBox(h: 15),
                                          Text("${org.city}, ${org.state}, ${org.country}", style: GoogleFonts.nunitoSans(
                                            fontSize: ScreenUtil().setSp(11),
                                            fontWeight: FontWeight.w400,
                                            color: black,)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (org.amIFollowing ==
                                                  0) {
                                                org.amIFollowing=1;
                                                Api.post.call(
                                                  context,
                                                  method:
                                                  "request-to-user/store",
                                                  param: {
                                                    "user_id": AppPreference()
                                                        .getString(
                                                        PreferencesKey.userId),
                                                    "request_to_user_id":
                                                    org
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
                                                searchController!.orgList.removeAt(index);
                                                searchController!.orgList
                                                    .insert(sunIndex, org);
                                              }
                                            },
                                            child: Container(
                                              width: getWidth(58),
                                              height: getHeight(18),
                                              decoration:
                                              BoxDecoration(
                                                color: org.amIFollowing ==
                                                    0 &&
                                                    org.sId !=
                                                        AppPreference().getString(PreferencesKey.orgUserId)?colorWhite:Colors.transparent,
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(
                                                    color:
                                                    org.amIFollowing ==
                                                        0 &&
                                                        org.sId !=
                                                            AppPreference().getString(PreferencesKey
                                                                .orgUserId) ?
                                                    colorF1B008
                                                  : Colors.transparent
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  org.amIFollowing ==
                                                      0 &&
                                                      org.sId !=
                                                          AppPreference().getString(PreferencesKey.orgUserId)
                                                      ? "Follow":
                                                  "",
                                                  style: size10_M_normal(
                                                      textColor:
                                                      org.amIFollowing ==
                                                          0 &&
                                                          org.sId !=
                                                              AppPreference().getString(PreferencesKey.orgUserId)?
                                                      Colors.black
                                                    : Colors.transparent
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          getSizedBox(h: 10),
                                          InkWell(
                                            onTap: () {
                                              if (org.amIRequested == 0 && org.amIInvited == 0) {
                                                org.amIRequested = 1;
                                                Api.post.call(
                                                  context,
                                                  method: "request-to-user/store",
                                                  param: {
                                                    "user_id": AppPreference()
                                                        .getString(
                                                        PreferencesKey.userId),
                                                    "request_to_user_id": org
                                                        .sId,
                                                    "request_type": "join",
                                                    "requestModalPath":
                                                    searchController!.userProfilePath.value,
                                                    "requestModal": "Users",
                                                  },
                                                  onResponseSuccess: (object) {
                                                    // _getProfile(context);
                                                  },
                                                );
                                                int sunIndex = index;
                                                searchController!.orgList.removeAt(index);
                                                searchController!.orgList
                                                    .insert(sunIndex, org);
                                              }
                                            },
                                            child: Container(
                                              height: getHeight(18),
                                              width: getWidth(58),
                                              decoration:
                                              BoxDecoration(
                                                color: colorWhite,
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(
                                                    color: colorF1B008
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  org.amIRequested == 0 && org.amIInvited == 0?
                                                  "Join Org": org.amIRequested == 1? "Requested" : "Invited",
                                                  style: size10_M_normal(
                                                      textColor:
                                                      // member.amIFollowing ==
                                                      //     0 &&
                                                      //     member.user!.sId !=
                                                      //         AppPreference().getString(PreferencesKey.userId)?
                                                      Colors.black
                                                    // : Colors.transparent
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ]),
                    getSizedBox(h: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: memberOfScrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: List.generate(
                              org.memberOfOrganization !=
                                  null &&  org.memberOfOrganization!.isNotEmpty
                                  ? org.memberOfOrganization!.length
                                  : 0, (index) {
                            return InkWell(
                              onTap: () {
                                if (org.memberOfOrganization!
                                    .elementAt(index)
                                    .userDetail!
                                    .sId ==
                                    AppPreference()
                                        .getString(PreferencesKey.userId) ||
                                    org.memberOfOrganization!
                                        .elementAt(index)
                                        .userDetail!
                                        .sId ==
                                        AppPreference()
                                            .getString(PreferencesKey.orgUserId)) {
                                  Get.toNamed(RouteConstants.profileScreen);
                                } else if (org.memberOfOrganization!
                                    .elementAt(index)
                                    .userDetail!
                                    .userType ==
                                    "user") {
                                  Map<String, String>? parameters = {
                                    "userDetail": jsonEncode(
                                        org.memberOfOrganization!
                                            .elementAt(index)
                                            .userDetail!)
                                  };
                                  Get.toNamed(RouteConstants.otherUserProfileScreen,
                                      parameters: parameters);
                                } else {
                                  Map<String, String>? parameters = {
                                    "userDetail": jsonEncode(
                                        org.memberOfOrganization!
                                            .elementAt(index)
                                            .userDetail!)
                                  };
                                  Get.toNamed(RouteConstants.otherOrgProfileScreen,
                                      parameters: parameters);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 15, bottom: 4),
                                child:
                                  // CircleAvatar(
                                  //   backgroundColor: Colors.lightBlue,
                                  //   radius: 20,
                                  // )
                                org.memberOfOrganization!
                                    .elementAt(index)
                                    .userDetail!
                                    .profile !=
                                    null
                                    ?
                                SizedBox(
                                  width: ScreenUtil().setSp(40),
                                  height: ScreenUtil().setSp(40),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    "${searchController!.userProfilePath.value}${org.memberOfOrganization!.elementAt(index).userDetail!.profile}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          width: ScreenUtil().setSp(40),
                                          height: ScreenUtil().setSp(40),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                Colors.black.withOpacity(.5),
                                                blurRadius: 2.0,
                                                offset: const Offset(0, 2),
                                              )
                                            ],
                                            border: Border.all(
                                                color: org.memberOfOrganization!.isNotEmpty ? org
                                                    .memberOfOrganization!
                                                    .elementAt(index)
                                                    .role?.toLowerCase() ==
                                                    'speaker'
                                                    ? colorF1B008
                                                    : org
                                                    .memberOfOrganization!
                                                    .elementAt(index)
                                                    .role?.toLowerCase() ==
                                                    "admin"
                                                    ? color606060
                                                    : org
                                                    .memberOfOrganization!
                                                    .elementAt(
                                                    index)
                                                    .role?.toLowerCase() ==
                                                    "creator"
                                                    ? color0060FF
                                                    : org
                                                    .memberOfOrganization!
                                                    .elementAt(
                                                    index)
                                                    .role?.toLowerCase() ==
                                                    "co-founder"
                                                    ? color35bedc
                                                    : Colors.transparent : Colors.transparent,
                                                width: 2),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                  ),
                                ) : Container(
                                  height: ScreenUtil().setSp(40),
                                  width: ScreenUtil().setSp(40),
                                  decoration: BoxDecoration(
                                    color: colorAppBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                        Colors.black.withOpacity(.5),
                                        blurRadius: 2.0,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                    border: Border.all(
                                        color:org.memberOfOrganization!.isNotEmpty ? org
                                            .memberOfOrganization!
                                            .elementAt(index)
                                            .role?.toLowerCase() ==
                                            'speaker'
                                            ? colorF1B008
                                            : org
                                            .memberOfOrganization!
                                            .elementAt(index)
                                            .role?.toLowerCase() ==
                                            "admin"
                                            ? color606060
                                            : org
                                            .memberOfOrganization!
                                            .elementAt(
                                            index)
                                            .role?.toLowerCase() ==
                                            "creator"
                                            ? color0060FF
                                            : org
                                            .memberOfOrganization!
                                            .elementAt(
                                            index)
                                            .role?.toLowerCase() ==
                                            "co-founder"
                                            ? color35bedc
                                            : Colors.transparent : Colors.transparent,
                                        width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                        org
                                            .memberOfOrganization!
                                            .elementAt(index)
                                            .userDetail!
                                            .fullname!=null? org
                                            .memberOfOrganization!
                                            .elementAt(index)
                                            .userDetail!
                                            .fullname![0]
                                            .toUpperCase() : "",
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(20),
                                            color: black)),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ]),
            )));
  }

  getTrendingOrg(BuildContext context,{int limit=5}){
    Api.get.call(context,
        method: "user/trending/org",
        param: {
          "page":page.toString(),
          "limit":limit.toString(),
        },
        isLoading: false, onResponseSuccess: (Map object) {
          var result = TrendingUserModel.fromJson(object);
          print(result);
          searchController!.userProfilePath.value = result.path??'';
          if(result.userdata!.isNotEmpty) {
            searchController!.orgList.addAll(result.userdata!);
            print('test role : ${searchController!.orgList.elementAt(0).memberOfOrganization!.elementAt(0).role}');
          }else{
            page = page > 1 ? page-1:page;
          }
        });
  }
}
