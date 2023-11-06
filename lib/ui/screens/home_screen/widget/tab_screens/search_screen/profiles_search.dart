import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
import 'package:mudda/model/SearchModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/home_screen/controller/search_controller_new.dart';
import 'package:mudda/ui/shared/spacing_widget.dart';

class ProfilesSearch extends GetView {
  ProfilesSearch({Key? key}) : super(key: key);
  SearchController? searchController;
  MuddaNewsController? muddaNewsController;
  ScrollController muddaScrollController = ScrollController();
  int page = 1;
  @override
  Widget build(BuildContext context) {
    searchController = Get.find<SearchController>();
    muddaNewsController = Get.find<MuddaNewsController>();
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        Api.get.call(context,
            method: "global/search",
            param: {
              "search":searchController!.search,
              "page":page.toString(),
              "user_id": AppPreference().getString(PreferencesKey.userId)
            },
            isLoading: false, onResponseSuccess: (Map object) {
              var result = SearchModel.fromJson(object);
              searchController!.muddaPath.value = result.path!;
              searchController!.userProfilePath.value = result.userpath!;
              if(result.mudda!.isNotEmpty) {
                searchController!.userProfilesList.addAll(result.userdata!);
              }else{
                page = page > 1 ? page-1:page;
              }
            });
      }
    });
    return Obx(
      ()=> ListView.builder(
          shrinkWrap: true,
          controller: muddaScrollController,
          padding: EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
          itemCount: searchController!.userProfilesList.length > 5 ? 5:searchController!.userProfilesList.length,
          itemBuilder: (followersContext, index) {
            return InkWell(
              onTap: (){
                if(searchController!.userProfilesList[index].sId == AppPreference().getString(PreferencesKey.userId)){
                  Get.toNamed(
                      RouteConstants.profileScreen,arguments: searchController!.userProfilesList[index]);
                }else {
                  Map<String, String>? parameters = {
                    "userDetail":jsonEncode(searchController!.userProfilesList[index])
                  };
                  Get.toNamed(RouteConstants.otherUserProfileScreen,parameters: parameters);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              searchController!.userProfilesList[index].profile !=
                                  null
                                  ? CachedNetworkImage(
                                imageUrl: "${searchController!.userProfilePath.value}${searchController!.userProfilesList[index].profile}",
                                imageBuilder: (context, imageProvider) => Container(
                                  width: ScreenUtil().setSp(48),
                                  height: ScreenUtil().setSp(48),
                                  decoration: BoxDecoration(
                                    color: colorWhite,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(ScreenUtil().setSp(24)) //                 <--- border radius here
                                    ),
                                    image: DecorationImage(
                                        image: imageProvider, fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundColor: lightGray,
                                  radius: ScreenUtil().setSp(24),
                                ),
                                errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundColor: lightGray,
                                  radius: ScreenUtil().setSp(24),
                                ),
                              )
                                  : Container(
                                height: ScreenUtil().setSp(48),
                                width: ScreenUtil().setSp(48),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: darkGray,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(searchController!.userProfilesList[index].fullname!=null?searchController!.userProfilesList[index].fullname![0].toUpperCase():"",
                                      style: GoogleFonts.nunitoSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: ScreenUtil().setSp(20),
                                          color: black)),
                                ),
                              ),
                              getSizedBox(w: 5),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    searchController!.userProfilesList[index].fullname ?? "",
                                    style: size12_M_bold(
                                        textColor: Colors.black),
                                  ),
                                  getSizedBox(h: 2),
                                  Text(
                                    searchController!.userProfilesList[index]
                                        .profession !=
                                        null
                                        ? "${searchController!.userProfilesList[index].profession != null ? searchController!.userProfilesList[index].profession! : ""} ${searchController!.userProfilesList[index].state != null ? "/ ${searchController!.userProfilesList[index].state != null ? searchController!.userProfilesList[index].state! : ""}, ${searchController!.userProfilesList[index].country != null ? searchController!.userProfilesList[index].country! : ""}" : ""}"
                                        : searchController!.userProfilesList[index]
                                        .state !=
                                        null
                                        ? "${searchController!.userProfilesList[index].state != null ? searchController!.userProfilesList[index].state! : ""}, ${searchController!.userProfilesList[index].country != null ? searchController!.userProfilesList[index].country! : ""}"
                                        : "",
                                    style: size12_M_normal(
                                        textColor: colorGrey),
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
                    !searchController!.userProfilesList[index]
                        .isUserBlocked! ? InkWell(
                      onTap: () {
                        if (searchController!
                            .userProfilesList[index].amIFollowing ==
                            0) {
                          AcceptUserDetail user =
                          searchController!.userProfilesList[index];
                          user.amIFollowing = 1;
                          int sunIndex = index;
                          searchController!.userProfilesList
                              .removeAt(index);
                          searchController!.userProfilesList
                              .insert(sunIndex, user);
                          Api.post.call(
                            context,
                            method: "request-to-user/store",
                            param: {
                              "user_id": AppPreference()
                                  .getString(PreferencesKey.userId),
                              "request_to_user_id": searchController!
                                  .userProfilesList[index].sId,
                              "request_type": "follow",
                            },
                            onResponseSuccess: (object) {
                              print(object);
                            },
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          searchController!.userProfilesList[index]
                              .amIFollowing ==
                              0 &&
                              searchController!
                                  .userProfilesList[index].sId !=
                                  AppPreference()
                                      .getString(PreferencesKey.userId)
                              ? "Follow"
                              : "",
                          style: size12_M_normal(
                              textColor: searchController!
                                  .userProfilesList[index]
                                  .amIFollowing ==
                                  0
                                  ? colorGrey
                                  : colorA0A0A0),
                        ),
                      ),
                    ) :
                    InkWell(
                      onTap: () {
                        _showUnBlockDialog(
                            context, "${searchController!.userProfilesList[index].sId}",index)
                            .then((value) =>
                        {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Unblock",
                          style: size12_M_normal(
                              textColor:colorGrey),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );

  }
  Future<bool?> _showUnBlockDialog(BuildContext context, String userId,int index) async {
    final searchController = Get.put(SearchController());
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Are you sure Unblock this user?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Api.post.call(context,
                    method: 'user/unblock/$userId',
                    isLoading: false,
                    param: {}, onResponseSuccess: (object) {
                      AcceptUserDetail user =
                      searchController.userProfilesList[index];
                      user.isUserBlocked = false;
                      searchController.userProfilesList[index] = user;
                      Navigator.pop(context, true);
                    });
              },
            ),
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hr ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} mins ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} sec ago';
    } else {
      return 'just now';
    }
  }
}
class ProfileListWidget extends StatelessWidget {
  const ProfileListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                height: 50.w,
                width: 50.w,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colorWhite, width: 1),
                      image: const DecorationImage(
                          image: NetworkImage(
                              "https://4bgowik9viu406fbr2hsu10z-wpengine.netdna-ssl.com/wp-content/uploads/2020/03/Portrait_5-1.jpg"))),
                )),
            Hs(width: 10.w),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Abdul Rehman Khan Sahab",
                        style: size12_M_regular300(textColor: colorDarkBlack),
                      ),
                      Text(
                        "Follow  ",
                        style: size14_M_normal(textColor: colorA0A0A0),
                      ),
                    ],
                  ),
                  Vs(height: 5.h),
                  Row(
                    children: [
                      Text(
                        "Activist, Social worker / Punjab, India",
                        style: size10_M_regular300(textColor: color606060),
                      ),
                    ],
                  ),
                  Vs(height: 5.h),
                ],
              ),
            ),
          ],
        ),
        Vs(height: 10.h),
        Row(
          children: [
            Container(
              height: 1.h,
              width: 250,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}

class MuddasListWidget extends StatelessWidget {
  MuddasListWidget({this.name});

  String? name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteConstants.muddaDetailsScreen);
      },
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80.h,
                    width: 80.w,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://assets.entrepreneur.com/content/3x2/2000/20180717194808-GettyImages-805012084.jpeg?auto=webp&quality=95&crop=16:9&width=675",
                          fit: BoxFit.cover,
                        )),
                  ),
                  Container(
                    height: 20.h,
                    width: 30.w,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: colorWhite),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.play_arrow_outlined,
                      color: colorWhite,
                      size: 20,
                    ),
                  )
                ],
              ),
              Hs(width: 10.w),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "$name",
                      style: size14_M_bold(textColor: color606060),
                    ),
                    Vs(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "1.3B  ",
                          style: size14_M_normal(textColor: colorDarkBlack),
                        ),
                        SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: Image.asset(AppIcons.shakeHandIcon)),
                        Hs(width: 20.w),
                        Column(
                          children: [
                            Container(
                              height: 20.h,
                              width: 20.w,
                              child: const Icon(
                                Icons.arrow_upward_outlined,
                                size: 15,
                                color: colorWhite,
                              ),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: color26C123),
                            ),
                            Vs(height: 2.h),
                            Text(
                              "1.2%",
                              style: size10_M_semibold(textColor: color26C123),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Vs(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("#Political, #Social, #Educational",
                  style: size10_M_normal(textColor: colorDarkBlack)),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: colorDarkBlack),
                  ),
                  Hs(width: 5.w),
                  Text("Lucknow, UP, India",
                      style: size10_M_normal(textColor: colorDarkBlack)),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: colorDarkBlack),
                  ),
                  Hs(width: 5.w),
                  Text("2 days ago",
                      style: size10_M_normal(textColor: colorDarkBlack)),
                ],
              ),
            ],
          ),
          Vs(height: 10.h),
          Row(
            children: [
              Container(
                height: 1.h,
                width: 250,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


