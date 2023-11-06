import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/hot_mudda_post.dart';
import '../../../shared/Hot_Mudda_Ad.dart';
import '../../../shared/report_post_dialog_box.dart';
import 'component/loading_view.dart';

class SuportMudda extends GetView {
  SuportMudda({
    Key? key,
  }) : super(key: key);

  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  ScrollController muddaScrollController = ScrollController();
  int page = 1;

  @override
  Widget build(BuildContext context) {
    muddaScrollController.addListener(() {
      if (muddaScrollController.position.maxScrollExtent ==
          muddaScrollController.position.pixels) {
        page++;
        _getMuddaPost(context);
      }
    });
    return Obx(() => RefreshIndicator(
          onRefresh: () {
            muddaNewsController.supportMuddaPostList.clear();
            page = 1;
            return _getMuddaPost(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setSp(16),
                    bottom: ScreenUtil().setSp(12)),
                child: Text(
                  "Supported",
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(14),
                      color: blackGray),
                ),
              ),
              if (muddaNewsController.supportMuddaPostList.isEmpty)
                const Expanded(
                    child: Center(
                        child:
                            Text('You haven\'t supported any Mudda as yet.')))
              else
                Expanded(
                  child: muddaNewsController.isSupportedMuddaLoading.value
                      ? ListView.separated(
                          shrinkWrap: true,
                          itemCount: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 24);
                          },
                          itemBuilder: (context, index) {
                            return const HotMuddaLoadingView();
                          })
                      : ListView.builder(
                          shrinkWrap: true,
                          controller: muddaScrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding:
                              EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
                          itemCount:
                              muddaNewsController.supportMuddaPostList.length,
                          itemBuilder: (followersContext, index) {
                            MuddaPost muddaPost =
                                muddaNewsController.supportMuddaPostList[index];
                            int muddaCreator = muddaPost.leaders!
                                .where((element) =>
                                    element.joinerType == 'creator')
                                .length;
                            int muddaLeader = muddaPost.leaders!
                                .where(
                                    (element) => element.joinerType == 'leader')
                                .length;
                            int muddaInitialLeader = muddaPost.leaders!
                                .where((element) =>
                                    element.joinerType == 'initial_leader')
                                .length;
                            int muddaOpposition = muddaPost.leaders!
                                .where((element) =>
                                    element.joinerType == 'opposition')
                                .length;
                            if (index != 0 && index == 2) {
                              return Column(
                                children: [
                                  const HotMuddaAD(),
                                  // SizedBox(height:ScreenUtil().setSp(16)),
                                  HotMuddaPost(
                                      muddaPost: muddaPost,
                                      index: index,
                                      muddaCreator: muddaCreator,
                                      muddaInitialLeader: muddaInitialLeader,
                                      muddaLeader: muddaLeader,
                                      muddaOpposition: muddaOpposition)
                                ],
                              );
                            } else if (index != 0 && (index - 2) % 5 == 0) {
                              return Column(
                                children: [
                                  const HotMuddaAD(),
                                  // SizedBox(height:ScreenUtil().setSp(16)),
                                  HotMuddaPost(
                                    muddaPost: muddaPost,
                                    index: index,
                                    muddaCreator: muddaCreator,
                                    muddaInitialLeader: muddaInitialLeader,
                                    muddaLeader: muddaLeader,
                                    muddaOpposition: muddaOpposition,
                                  )
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  HotMuddaPost(
                                      muddaPost: muddaPost,
                                      index: index,
                                      muddaCreator: muddaCreator,
                                      muddaInitialLeader: muddaInitialLeader,
                                      muddaLeader: muddaLeader,
                                      muddaOpposition: muddaOpposition),

                                  /*index % 5 == 4
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                'To help you serve better...\n',
                                            style: size14_M_normal(
                                              textColor: color606060,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Choose',
                                                style: size14_M_normal(
                                                  textColor: color606060,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' Categories ',
                                                style: size14_M_bold(
                                                  textColor: color202020,
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'of your Choice',
                                                style: size14_M_normal(
                                                  textColor: color606060,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Obx(
                                          () => Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    ScreenUtil().setWidth(20)),
                                            child: GroupButton(
                                              textPadding: EdgeInsets.only(
                                                  left: ScreenUtil().setSp(8),
                                                  right: ScreenUtil().setSp(8)),
                                              runSpacing: ScreenUtil().setSp(9),
                                              groupingType: GroupingType.wrap,
                                              spacing: ScreenUtil().setSp(5),
                                              crossGroupAlignment:
                                                  CrossGroupAlignment.start,
                                              buttonHeight:
                                                  ScreenUtil().setSp(24),
                                              isRadio: false,
                                              direction: Axis.horizontal,
                                              selectedButtons:
                                                  muddaNewsController
                                                      .selectedCategory,
                                              onSelected: (index, ageSelected) {
                                                if (ageSelected &&
                                                    !muddaNewsController
                                                        .selectedCategory
                                                        .contains(index)) {
                                                  muddaNewsController
                                                      .selectedCategory
                                                      .add(index);
                                                } else if (!ageSelected &&
                                                    muddaNewsController
                                                        .selectedCategory
                                                        .contains(index)) {
                                                  muddaNewsController
                                                      .selectedCategory
                                                      .remove(index);
                                                }
                                              },
                                              buttons: muddaNewsController
                                                  .categoryList.value,
                                              selectedTextStyle:
                                                  GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: Colors.white,
                                              ),
                                              unselectedTextStyle:
                                                  GoogleFonts.nunitoSans(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    ScreenUtil().setSp(12),
                                                color: lightGray,
                                              ),
                                              selectedColor: darkGray,
                                              unselectedColor:
                                                  Colors.transparent,
                                              selectedBorderColor: lightGray,
                                              unselectedBorderColor: lightGray,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil().radius(15)),
                                              selectedShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.transparent)
                                              ],
                                              unselectedShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.transparent)
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                List<String> hashtags = [];
                                                List<String> location = [];
                                                List<String> customLocation =
                                                    [];
                                                List<String> locationValues =
                                                    [];
                                                List<String>
                                                    customLocationValues = [];
                                                List<String> gender = [];
                                                List<String> age = [];
                                                for (int index
                                                    in muddaNewsController
                                                        .selectedLocation) {
                                                  location.add(
                                                      muddaNewsController
                                                          .apiLocationList
                                                          .elementAt(index));
                                                  if (index == 0) {
                                                    locationValues.add(
                                                        AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .city));
                                                  } else if (index == 1) {
                                                    locationValues.add(
                                                        AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .state));
                                                  } else if (index == 2) {
                                                    locationValues.add(
                                                        AppPreference()
                                                            .getString(
                                                                PreferencesKey
                                                                    .country));
                                                  } else {
                                                    locationValues.add("");
                                                  }
                                                }
                                                for (int index
                                                    in muddaNewsController
                                                        .selectedCategory) {
                                                  hashtags.add(
                                                      muddaNewsController
                                                          .categoryList
                                                          .elementAt(index));
                                                }
                                                for (int index
                                                    in muddaNewsController
                                                        .selectedGender) {
                                                  gender.add(muddaNewsController
                                                      .genderList
                                                      .elementAt(index)
                                                      .toLowerCase());
                                                }
                                                for (int index
                                                    in muddaNewsController
                                                        .selectedAge) {
                                                  age.add(muddaNewsController
                                                      .ageList
                                                      .elementAt(index));
                                                }
                                                if (muddaNewsController
                                                    .selectDistrict
                                                    .value
                                                    .isNotEmpty) {
                                                  customLocation.add(
                                                      muddaNewsController
                                                          .apiLocationList
                                                          .elementAt(0));
                                                  customLocationValues.add(
                                                      muddaNewsController
                                                          .selectDistrict
                                                          .value);
                                                }
                                                if (muddaNewsController
                                                    .selectState
                                                    .value
                                                    .isNotEmpty) {
                                                  customLocation.add(
                                                      muddaNewsController
                                                          .apiLocationList
                                                          .elementAt(1));
                                                  customLocationValues.add(
                                                      muddaNewsController
                                                          .selectState.value);
                                                }
                                                if (muddaNewsController
                                                    .selectCountry
                                                    .value
                                                    .isNotEmpty) {
                                                  customLocation.add(
                                                      muddaNewsController
                                                          .apiLocationList
                                                          .elementAt(2));
                                                  customLocationValues.add(
                                                      muddaNewsController
                                                          .selectCountry.value);
                                                }
                                                Map<String, dynamic> map = {
                                                  "user_id": AppPreference()
                                                      .getString(PreferencesKey
                                                          .userId),
                                                };
                                                if (hashtags.isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "hashtags",
                                                      () =>
                                                          jsonEncode(hashtags));
                                                }
                                                if (location.isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "location_types",
                                                      () =>
                                                          jsonEncode(location));
                                                }
                                                if (locationValues.isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "location_types_values",
                                                      () => jsonEncode(
                                                          locationValues));
                                                }
                                                if (customLocation.isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "custom_location_types",
                                                      () => jsonEncode(
                                                          customLocation));
                                                }
                                                if (customLocationValues
                                                    .isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "custom_location_types_values",
                                                      () => jsonEncode(
                                                          customLocationValues));
                                                }
                                                if (gender.isNotEmpty) {
                                                  map.putIfAbsent(
                                                      "gender_types",
                                                      () => jsonEncode(gender));
                                                }
                                                if (age.isNotEmpty) {
                                                  map.putIfAbsent("age_types",
                                                      () => jsonEncode(age));
                                                }
                                                Api.get.call(context,
                                                    method: "mudda/index",
                                                    param: map,
                                                    isLoading: true,
                                                    onResponseSuccess:
                                                        (Map object) {
                                                  var result =
                                                      MuddaPostModel.fromJson(
                                                          object);
                                                  if (result.data!.isNotEmpty) {
                                                    muddaNewsController
                                                        .muddaProfilePath
                                                        .value = result.path!;
                                                    muddaNewsController
                                                            .muddaUserProfilePath
                                                            .value =
                                                        result.userpath!;
                                                    muddaNewsController
                                                        .muddaPostList
                                                        .clear();
                                                    muddaNewsController
                                                        .muddaPostList
                                                        .addAll(result.data!);
                                                    Get.back();
                                                  } else {
                                                    showDialog<void>(
                                                      context: Get.context!,
                                                      barrierDismissible: false,
                                                      // user must tap button!
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                              result.message!,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: const Text(
                                                                  'OK'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                });
                                              },
                                              child: Stack(
                                                alignment: Alignment.centerLeft,
                                                children: [
                                                  Container(
                                                    width:
                                                        ScreenUtil().setSp(70),
                                                    height:
                                                        ScreenUtil().setSp(25),
                                                    margin: EdgeInsets.only(
                                                        right: ScreenUtil()
                                                            .setSp(17),
                                                        top: ScreenUtil()
                                                            .setSp(2.5),
                                                        bottom: ScreenUtil()
                                                            .setSp(2.5)),
                                                    decoration: BoxDecoration(
                                                      color: colorWhite,
                                                      border: Border.all(
                                                          color: color606060),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              ScreenUtil()
                                                                  .setSp(8)),
                                                    ),
                                                    child: Center(
                                                      child: Text("Apply",
                                                          style: GoogleFonts
                                                              .nunitoSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              12),
                                                                  color:
                                                                      black)),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 1,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: ScreenUtil()
                                                          .setSp(30),
                                                      width: ScreenUtil()
                                                          .setSp(30),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              2),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: colorWhite,
                                                          border: Border.all(
                                                              color:
                                                                  color606060)),
                                                      child: const Icon(
                                                        Icons
                                                            .chevron_right_rounded,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  )
                                : SizedBox(),*/
                                ],
                              );
                            }
                          }),
                ),
            ],
          ),
        ));
  }

  anynymousDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Container(
              height: ScreenUtil().setSp(97),
              width: ScreenUtil().screenWidth - ScreenUtil().setSp(50),
              decoration: const BoxDecoration(color: Colors.white),
              child: Material(
                child: commonPostText(
                  text: "Anonymous user profiles can be visited or contacted.",
                  onPressed: () {
                    Get.back();
                  },
                  color: Colors.black,
                  size: 12,
                ),
              ),
            ),
          ),
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

  _getMuddaPost(BuildContext context) async {
    Api.get.call(context,
        method: "mudda/my-engagement",
        param: {
          "page": page.toString(),
          "filterType": "support",
          "user_id": AppPreference().getString(PreferencesKey.userId)
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = MuddaPostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        muddaNewsController.muddaProfilePath.value = result.path!;
        muddaNewsController.muddaUserProfilePath.value = result.userpath!;
        muddaNewsController.supportMuddaPostList.clear();
        muddaNewsController.supportMuddaPostList.addAll(result.data!);
      } else {
        page = page > 1 ? page - 1 : page;
      }
    });
  }
}
