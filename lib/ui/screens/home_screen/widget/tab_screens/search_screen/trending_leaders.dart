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

class TrendingLeaders extends StatefulWidget {
  const TrendingLeaders({Key? key}) : super(key: key);

  @override
  State<TrendingLeaders> createState() => _TrendingLeadersState();
}

class _TrendingLeadersState extends State<TrendingLeaders> {
  int page = 1;
  ScrollController scrollController = ScrollController();
  SearchController? searchController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = Get.find<SearchController>();
    getTrendingLeader(context);
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        page++;
        getTrendingLeader(context);
      }
    });
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Trending Muddebaaz',
              // style: size12_M_regular300(textColor: colorDarkBlack),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 12),
              ),
              onPressed: () {
                searchController!.leaders.value=!searchController!.leaders.value;
                page++;
                getTrendingLeader(context,limit: 10);
              },
              child: Obx(()=>Text(searchController!.leaders.value?'view less':'view all')),
            ),
          ],
        ),
        Obx(() => searchController!.leaders.value?GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            childAspectRatio: 0.67),
            shrinkWrap: true,
            controller: scrollController,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(bottom: 8),
            itemCount: searchController!.userProfilesList.length,
            itemBuilder: (context, index) {
              AcceptUserDetail user =
              searchController!.userProfilesList.elementAt(index);
              return Padding(padding: EdgeInsets.only(right: 5,bottom: 8),
                child: userCard(context: context, user: user, index: index),);
            }
        ):
        SizedBox(
          height: getHeight(181),
          child:  ListView.builder(
            controller: scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 5),
              itemCount: searchController!.userProfilesList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index) {
                AcceptUserDetail user =
                searchController!.userProfilesList.elementAt(index);
                return Padding(padding: EdgeInsets.only(right: 5),
                  child: userCard(context: context, user: user, index: index),);
              }
          ),
        )),
      ],
    );
  }

  userCard({
    required context,
    required AcceptUserDetail user,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        if (user.sId ==
            AppPreference().getString(PreferencesKey.userId)) {
          Get.toNamed(RouteConstants.profileScreen,
              arguments: user);
        } else if (user.userType == "user") {
          Map<String, String>? parameters = {
            "userDetail": jsonEncode(user)
          };
          Get.toNamed(RouteConstants.otherUserProfileScreen,
              parameters: parameters);
        } else {
          Map<String, String>? parameters = {
            "userDetail": jsonEncode(user)
          };
          Get.toNamed(RouteConstants.otherOrgProfileScreen,
              parameters: parameters);
        }
      },
      child: Container(
        height: getHeight(170),
        width: getWidth(127),
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
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: colorWhite,
                child: Center(
                  child:
                  user.profile != null ?
                  CachedNetworkImage(
                    imageUrl:
                    "${searchController!.userProfilePath}${user.profile!}",
                    imageBuilder: (context, imageProvider) => Container(
                      width: ScreenUtil().setSp(60),
                      height: ScreenUtil().setSp(60),
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setSp(
                                30)) //                 <--- border radius here
                        ),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: lightGray,
                      radius: ScreenUtil().setSp(30),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: lightGray,
                      radius: ScreenUtil().setSp(30),
                    ),
                  )
                      : Container(
                    height: ScreenUtil().setSp(60),
                    width: ScreenUtil().setSp(60),
                    decoration: BoxDecoration(
                      color: colorWhite,
                      border: Border.all(
                        color: darkGray,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(user.fullname![0].toUpperCase(),
                          style: GoogleFonts.nunitoSans(
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil().setSp(30),
                              color: black)),
                    ),
                  ),
                ),
              ),
              Text(user.fullname??'',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w700,
                  fontSize: ScreenUtil().setSp(14),
                  color: black)),
              Text(user.profession != null ?
                    user.profession!.length<12?
                      user.profession ?? ""
                      : '${user.profession!.substring(0,10)}..'
                  : "", style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().setSp(10),
                  color: black)),
              Text("${user.state!.length<10? user.state ?? "" : '${user.state!.substring(0,9)}'} ${user.country ?? ""}", style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().setSp(10),
                  color: black)),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(user.muddebaazCount != null? "in ${user.muddebaazCount} muddas" : "", style: GoogleFonts.nunitoSans(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(12),
                    color: black)),
              ),
              InkWell(
                onTap: () {
                  if (user.amIFollowing ==
                      0) {
                    user.amIFollowing=1;
                    Api.post.call(
                      context,
                      method:
                      "request-to-user/store",
                      param: {
                        "user_id": AppPreference()
                            .getString(
                            PreferencesKey.userId),
                        "request_to_user_id": user.sId,
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
                    searchController!.userProfilesList.removeAt(index);
                    searchController!.userProfilesList
                        .insert(sunIndex, user);
                  }
                },
                child: Container(
                  decoration:
                  BoxDecoration(
                    color: user.amIFollowing ==
                        0 &&
                        user.sId !=
                            AppPreference().getString(PreferencesKey
                                .userId) ?colorWhite:Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color:
                        user.amIFollowing ==
                            0 &&
                            user.sId !=
                                AppPreference().getString(PreferencesKey
                                    .userId) ?
                        colorF1B008
                            : Colors.transparent
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal:
                        8,
                        vertical:
                        0),
                    child: Text(
                      user.amIFollowing ==
                          0 &&
                          user.sId !=
                              AppPreference().getString(PreferencesKey.userId)
                          ? "Follow":
                      "",
                      style: size10_M_normal(
                          textColor:
                          user.amIFollowing ==
                              0 &&
                              user.sId !=
                                  AppPreference().getString(PreferencesKey.userId)?
                          colorBlack
                              : Colors.transparent
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTrendingLeader(BuildContext context,{int limit=5}){
    Api.get.call(context,
        method: "post-for-mudda/trending/muddebaaz",
        param: {
          "page":page.toString(),
          "limit":limit.toString(),
        },
        isLoading: false, onResponseSuccess: (Map object) {
          print("Data received");
          var result = TrendingUserModel.fromJson(object);
          searchController!.userProfilePath.value = result.path??'';
          if(result.userdata!.isNotEmpty) {
            searchController!.userProfilesList.addAll(result.userdata!);
          }else{
            page = page > 1 ? page-1:page;
          }
          print("datareceived ${searchController!.userProfilesList}");
        });
  }
}
