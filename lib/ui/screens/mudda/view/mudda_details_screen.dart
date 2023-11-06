import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/local/DatabaseProvider.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/PostForMuddaModel.dart';
import 'package:mudda/model/UserRolesModel.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/hot_mudda_post.dart';
import 'package:mudda/ui/screens/mudda/widget/action_task.dart';
import 'package:mudda/ui/screens/mudda/widget/mudda_post_comment.dart';
import 'package:mudda/ui/screens/mudda/widget/oppotion_view.dart';
import 'package:mudda/ui/shared/AdHelper.dart';
import 'package:mudda/ui/shared/VideoPlayerScreen.dart';
import 'package:mudda/ui/shared/create_dynamic_link.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../const/const.dart';
import '../../../../core/utils/count_number.dart';
import '../../../../model/MuddaPostOfflineModel.dart';
import '../../../shared/Mudda_Containier_Ad.dart';
import '../../other_user_profile/controller/ChatController.dart';
import '../widget/admin_dialog.dart';
import '../widget/favour_view.dart';
import '../widget/loading_view.dart';
import '../widget/reply_widget.dart';
import '../widget/user_dialog.dart';

class VideoController {
  void Function(bool b)? onPause;
  void Function()? onPlayCheck;
  bool Function()? onIsPlaying;
  void Function(bool b)? onMute;
}

class MuddaDetailsScreen extends StatefulWidget {
  MuddaDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MuddaDetailsScreen> createState() => _MuddaDetailsScreenState();
}

class _MuddaDetailsScreenState extends State<MuddaDetailsScreen>
    with AutomaticKeepAliveClientMixin<MuddaDetailsScreen> {
  MuddaNewsController? muddaNewsController;
  ChatController? _chatController;
  int topPage = 1;
  int downPage = 1;
  int page = 1;
  int rolePage = 1;
  ScrollController roleController = ScrollController();
  Timer? _timer;
  List<MuddaOfflinePost>? temp;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? lastReadId;
  late String muddaShareLink;

  @override
  void initState() {
    super.initState();

    muddaNewsController = Get.find<MuddaNewsController>();
    _chatController = Get.find<ChatController>();
    CreateMyDynamicLinksClass()
        .createDynamicLink(true,
            '/muddaDetailsScreen?id=${muddaNewsController!.isFromNotification.value ? muddaNewsController!.muddaId.value : Get.parameters['id'] ?? muddaNewsController!.muddaPost.value.sId}')
        .then((value) => setState(() => muddaShareLink = '$value'));
    updateContainerData();
    // itemListener.itemPositions.addListener(() {
    //
    //   final indices = itemListener.itemPositions.value.map((e) => e.index).toList();
    //   log('${indices.last}');
    //   getIdByIndex(indices.last);
    //   if(indices.last == muddaNewsController!.postForMuddaList.length-1)
    //   {
    //         pagination(
    //             lastReadPostID: "${muddaNewsController!.postForMuddaList.last.sId}",
    //             type: 'prev');
    //         downPage++;
    //       }
    // });

    // muddaNewsController!.muddaScrollController.addListener(() {
    //   if (muddaNewsController!.muddaScrollController.offset >=
    //           muddaNewsController!
    //               .muddaScrollController.position.maxScrollExtent &&
    //       !muddaNewsController!.muddaScrollController.position.outOfRange &&
    //       muddaNewsController!.isPaginate.value == true) {
    //     pagination(
    //         lastReadPostID: "${muddaNewsController!.postForMuddaList.last.sId}",
    //         type: 'prev');
    //     downPage++;
    //   }
    //   if (muddaNewsController!.muddaScrollController.offset <=
    //           muddaNewsController!
    //               .muddaScrollController.position.minScrollExtent &&
    //       !muddaNewsController!.muddaScrollController.position.outOfRange &&
    //       muddaNewsController!.isPaginate.value == true) {
    //
    //     // top
    //
    //     paginationNext(
    //         lastReadPostID:
    //             "${muddaNewsController!.postForMuddaList.first.sId}",
    //         type: 'next');
    //     topPage++;
    //
    //   }
    // });
    muddaNewsController!.muddaScrollController.addListener(() {
      if (muddaNewsController!.muddaScrollController.offset >
          muddaNewsController!.muddaScrollController.position.minScrollExtent +
              ScreenUtil().screenHeight * 0.5) {
        muddaNewsController!.isShowArrowDown.value = true;
      } else {
        muddaNewsController!.isShowArrowDown.value = false;
      }
    });

    muddaNewsController!.postForMuddaList.clear();
    muddaNewsController!.fetchRecentPost(
        muddaNewsController!.isFromNotification.value
            ? muddaNewsController!.muddaId.value
            : Get.parameters['id']);
    // getMuddaShareLink(muddaId!);
    // getLocalBbPost();

    // roleController.addListener(() {
    //   if (roleController.position.maxScrollExtent ==
    //       roleController.position.pixels) {
    //     rolePage++;
    //     _getRoles(context);
    //   }
    // });
    // _getRoles(context);

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      updateContainerData();
    });
  }

  @override
  bool get wantKeepAlive => true;

  // TODO: LOCAL & REMOTE OPERATIONS
  // void getLocalBbPost() async {
  //   temp = await DBProvider.db
  //       .getPosts("${muddaNewsController!.muddaPost.value.sId}");
  //   if (temp!.isNotEmpty) {
  //     muddaNewsController!.postForMuddaList.clear();
  //     temp?.forEach((element) {
  //       muddaNewsController!.postForMuddaList.add(PostForMudda(
  //         isContainerAdsLoaded: false,
  //         sId: element.id,
  //         userId: element.user_id,
  //         postAs: element.post_as,
  //         postIn: element.post_in,
  //         userDetail: AcceptUserDetail(
  //             fullname: element.fullname,
  //             id: element.user_id,
  //             profile: element.profile),
  //         thumbnail: element.thumbnail,
  //         title: element.title,
  //         muddaDescription: element.mudda_description,
  //         createdAt: element.createdAt,
  //         commentorsCount: element.commentorsCount,
  //         replies: element.replies,
  //         likersCount: element.likersCount,
  //         dislikersCount: element.dislikersCount,
  //         gallery: element.file != null
  //             ? <Gallery>[
  //           Gallery(file: element.file, path: element.path),
  //         ]
  //             : [],
  //         parentPost: element.parentPost != null
  //             ? PostForMuddaModelDataParentPost(
  //           muddaDescription: element.parentPost![0],
  //           user: PostForMuddaModelDataParentPostUser(
  //             fullname: element.parentPost![1],
  //             profile: element.parentPost![2],
  //             Id: element.parentPost![3],
  //           ),
  //           Id: element.parentPost![4],
  //           createdAt: element.parentPost![5],
  //         )
  //             : null,
  //         agreeStatus: element.agreeStatus == 1 ? true : false,
  //       ));
  //     });
  //     Future.delayed(const Duration(seconds: 2), () {
  //       fetchRecentPost(isLoading: false);
  //     });
  //   } else {
  //     fetchRecentPost(isLoading: true);
  //   }
  // }

  pagination({required String lastReadPostID, required String type}) {
    muddaNewsController!.isPaginateTop.value = true;
    if (lastReadId == null) {
      lastReadId = '${muddaNewsController!.postForMuddaList.last.sId}';
      setState(() {});
    }
    Api.get.call(context,
        method: "post-for-mudda/index",
        param: {
          "mudda_id": muddaNewsController!.muddaPost.value.sId ??
              muddaNewsController!.muddaId.value,
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "lastPostRead": lastReadPostID,
          "posts": type,
          "page": topPage.toString(),
        },
        isLoading: false, onResponseSuccess: (Map object) {
      topPage++;
      var result = PostForMuddaModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        setState(() {});
        muddaNewsController!.postForMuddaPath.value = result.path!;
        muddaNewsController!.postForMuddaUserPath.value = result.userpath!;
        muddaNewsController!.postForMuddaTotalUsers = result.totalUsers!;
        muddaNewsController!.postForMuddaContainerUsers =
            result.containerUsers!;
        muddaNewsController!.postForMuddaMuddaThumbnail =
            result.muddaThumbnail!;
        muddaNewsController!.postForMuddaMuddaOwner = result.muddaOwner!;
        muddaNewsController!.postForMuddaMuddaFavour = result.favour!;
        muddaNewsController!.postForMuddaMuddaOpposition = result.opposition!;
        muddaNewsController!.postForMuddaJoinRequestsAdmin =
            result.joinRequests!;
        muddaNewsController!.postForMuddapostApprovalsAdmin =
            result.postApprovals!;
        muddaNewsController!.postForMuddapostTotalNewPost =
            result.totalNewPosts!;
        //
        muddaNewsController!.postForMuddaList.addAll(result.data!);
        _refreshController.loadComplete();
        muddaNewsController!.isPaginateTop.value = false;
        muddaNewsController?.calAgreeDisAgreePercentage();
        muddaNewsController?.calFavourOppositionPercentage();
        //TODO: DELETE OLD POSTS
        // DBProvider.db.deletePost("${muddaNewsController!.muddaPost.value.sId}");
        // //TODO: ADD TO LOCAL DB
        // result.data?.forEach((element) {
        //   DBProvider.db.addMuddaPostData(
        //       id: element.sId,
        //       user_id: element.userId,
        //       mudda_id: element.muddaId,
        //       post_as: element.postAs,
        //       thumbnail: element.thumbnail,
        //       title: element.title,
        //       mudda_description: element.muddaDescription,
        //       post_in: element.postIn,
        //       createdAt: element.createdAt,
        //       file:
        //           element.gallery!.isNotEmpty ? element.gallery![0].file : null,
        //       path:
        //           element.gallery!.isNotEmpty ? element.gallery![0].path : null,
        //       commentorsCount: element.commentorsCount,
        //       dislikersCount: element.dislikersCount,
        //       likersCount: element.likersCount,
        //       agreeStatus: element.agreeStatus,
        //       fullname: element.userDetail?.fullname,
        //       profile: element.userDetail?.profile,
        //       replies: element.replies,
        //       parentPost: element.parentPost != null
        //           ? [
        //               '${element.parentPost?.muddaDescription}',
        //               '${element.parentPost?.user?.fullname}',
        //               '${element.parentPost?.user?.profile}',
        //               '${element.parentPost?.user?.Id}',
        //               '${element.parentPost?.Id}',
        //               '${element.parentPost?.createdAt}',
        //             ]
        //           : null);
        // });
        if (mounted) {
          setState(() {});
        }
      } else {
        _refreshController.loadComplete();
        topPage = topPage > 1 ? topPage - 1 : topPage;
      }
    });
  }

  paginationNext({required String lastReadPostID, required String type}) {
    Api.get.call(context,
        method: "post-for-mudda/index",
        param: {
          "mudda_id": muddaNewsController!.muddaPost.value.sId ??
              muddaNewsController!.muddaId.value,
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "lastPostRead": lastReadPostID,
          "posts": type,
          "page": type == 'prev' ? topPage.toString() : downPage.toString(),
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = PostForMuddaModel.fromJson(object);

      muddaNewsController!.muddaPost.value.leaders?.indexOf(Leaders(
          acceptUserDetail: AcceptUserDetail(
              sId: AppPreference().getString(PreferencesKey.userId))));
      if (result.data!.isNotEmpty) {
        muddaNewsController!.postForMuddaPath.value = result.path!;
        muddaNewsController!.postForMuddaUserPath.value = result.userpath!;
        muddaNewsController!.postForMuddaTotalUsers = result.totalUsers!;
        muddaNewsController!.postForMuddaContainerUsers =
            result.containerUsers!;
        muddaNewsController!.postForMuddaMuddaThumbnail =
            result.muddaThumbnail!;
        muddaNewsController!.postForMuddaMuddaOwner = result.muddaOwner!;
        muddaNewsController!.postForMuddaMuddaFavour = result.favour!;
        muddaNewsController!.postForMuddaMuddaOpposition = result.opposition!;
        muddaNewsController!.postForMuddaJoinRequestsAdmin =
            result.joinRequests!;
        muddaNewsController!.postForMuddapostApprovalsAdmin =
            result.postApprovals!;
        muddaNewsController!.postForMuddapostTotalNewPost =
            result.totalNewPosts!;
        //
        muddaNewsController!.postForMuddaList.insertAll(0, result.data!);

        _refreshController.refreshCompleted();
        muddaNewsController?.calAgreeDisAgreePercentage();
        muddaNewsController?.calFavourOppositionPercentage();
        // //TODO: DELETE OLD POSTS
        // DBProvider.db.deletePost("${muddaNewsController!.muddaPost.value.sId}");
        // //TODO: ADD TO LOCAL DB
        // result.data?.forEach((element) {
        //   DBProvider.db.addMuddaPostData(
        //       id: element.sId,
        //       user_id: element.userId,
        //       mudda_id: element.muddaId,
        //       post_as: element.postAs,
        //       thumbnail: element.thumbnail,
        //       title: element.title,
        //       mudda_description: element.muddaDescription,
        //       post_in: element.postIn,
        //       createdAt: element.createdAt,
        //       file:
        //           element.gallery!.isNotEmpty ? element.gallery![0].file : null,
        //       path:
        //           element.gallery!.isNotEmpty ? element.gallery![0].path : null,
        //       commentorsCount: element.commentorsCount,
        //       dislikersCount: element.dislikersCount,
        //       likersCount: element.likersCount,
        //       agreeStatus: element.agreeStatus,
        //       fullname: element.userDetail?.fullname,
        //       profile: element.userDetail?.profile,
        //       replies: element.replies,
        //       parentPost: element.parentPost != null
        //           ? [
        //               '${element.parentPost?.muddaDescription}',
        //               '${element.parentPost?.user?.fullname}',
        //               '${element.parentPost?.user?.profile}',
        //               '${element.parentPost?.user?.Id}',
        //               '${element.parentPost?.Id}',
        //               '${element.parentPost?.createdAt}',
        //             ]
        //           : null);
        // });
        if (mounted) {
          setState(() {});
        }
      } else {
        _refreshController.refreshCompleted();
        topPage = topPage > 1 ? topPage - 1 : topPage;
        downPage = downPage > 1 ? downPage - 1 : downPage;
      }
      // _getRoles(context);
    });
  }

  updateContainerData() {
    String? id;
    if (Get.parameters['id'] != null) {
      id = Get.parameters['id'];
    }
    Api.get.call(context,
        method: "mudda/container-data",
        param: {
          "muddaId": id ??
              muddaNewsController!.muddaPost.value.sId ??
              muddaNewsController!.muddaId.value,
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = ContainerData.fromJson(object);
      muddaNewsController!.postForMuddaContainerUsers =
          result.result?[0]!.containerUsers;
      muddaNewsController!.postForMuddaMuddaFavour = result.result?[0]?.favour;
      muddaNewsController!.postForMuddaMuddaOpposition =
          result.result?[0]?.opposition;
      muddaNewsController?.calAgreeDisAgreePercentage();
      muddaNewsController?.calFavourOppositionPercentage();
      // muddaNewsController!.postForMuddaMuddaThumbnail.refresh();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    muddaNewsController?.isRepliesShow.value = false;
    muddaNewsController!.isFromNotification.value = false;
    super.dispose();
  }

  void _onRefresh() async {
    paginationNext(
        lastReadPostID: "${muddaNewsController!.postForMuddaList.first.sId}",
        type: 'next');
  }

  void _onLoading() async {
    pagination(
        lastReadPostID:
            lastReadId ?? "${muddaNewsController!.postForMuddaList.last.sId}",
        type: 'prev');
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    return WillPopScope(
        child: Scaffold(
          backgroundColor: appBackground,
          // floatingActionButton: FloatingActionButton(onPressed: (){
          //   DBProvider.db.getPosts("${muddaNewsController!.muddaPost.value.sId}");
          // },child: Icon(Icons.add),),
          appBar: PreferredSize(
            child: Container(
              color: colorAppBackground,
              padding: const EdgeInsets.only(top: 8),
              child: SafeArea(
                child: Column(
                  children: [
                    Obx(
                      () => Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // var muddaId =
                                //     muddaNewsController!.muddaPost.value.sId;
                                Api.post.call(
                                  context,
                                  method: "mudda/exitContainer",
                                  isLoading: false,
                                  param: {
                                    "mudda_id":
                                        "${muddaNewsController!.isFromNotification.value ? muddaNewsController!.muddaId.value : muddaNewsController!.muddaPost.value.sId}",
                                  },
                                  onResponseSuccess: (object) {},
                                );
                                Get.back();
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setSp(8)),
                                  child: SizedBox(
                                    height: ScreenUtil().setSp(40),
                                    width: ScreenUtil().setSp(40),
                                    child: CachedNetworkImage(
                                      imageUrl: muddaNewsController!
                                                  .isFromNotification.value !=
                                              true
                                          ? "${muddaNewsController!.muddaProfilePath.value}${muddaNewsController!.muddaPost.value.thumbnail}"
                                          : "${AppPreference().getString(PreferencesKey.url)}${AppPreference().getString(PreferencesKey.mudda)}/${muddaNewsController!.postForMuddaMuddaThumbnail}",
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Text('No image'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      muddaNewsController!
                                              .isFromNotification.value
                                          ? muddaNewsController!
                                              .muddaTitle.value
                                          : muddaNewsController!
                                                      .muddaPost.value.title !=
                                                  null
                                              ? muddaNewsController!
                                                  .muddaPost.value.title!
                                              : "Title",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: size16_M_bold(
                                        textColor: const Color(0xFF202020),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () {
                                      // log("-=-=- muddaOwner -=- ${muddaNewsController!.postForMuddaMuddaOwner} =-=-=-=-=-=-");
                                      // muddaNewsController!.postForMuddaMuddaOwner == true
                                      //     ? muddaInfoDialogBoxAdmin()
                                      //     : muddaInfoDialogBox();
                                      Get.dialog(
                                        muddaNewsController!
                                                    .postForMuddaMuddaOwner !=
                                                true
                                            ? MuddaInfoDialogBox(
                                                muddaShareLink: muddaShareLink,
                                                callBack: (v) {
                                                  log('00000000000000000000000000000   ${muddaNewsController!.muddaPost.value.amIRequested}');
                                                  // muddaNewsController!
                                                  //     .muddaPost
                                                  //     .value
                                                  //     .amIRequested = null;
                                                  if (v) {
                                                    List<String> hashtags = [];
                                                    List<String> location = [];
                                                    List<String>
                                                        customLocation = [];
                                                    List<String>
                                                        locationValues = [];
                                                    List<String>
                                                        customLocationValues =
                                                        [];
                                                    List<String> gender = [];
                                                    List<String> age = [];
                                                    for (int index
                                                        in muddaNewsController!
                                                            .selectedLocation) {
                                                      location.add(
                                                          muddaNewsController!
                                                              .apiLocationList
                                                              .elementAt(
                                                                  index));
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
                                                        in muddaNewsController!
                                                            .selectedCategory) {
                                                      hashtags.add(
                                                          muddaNewsController!
                                                              .categoryList
                                                              .elementAt(
                                                                  index));
                                                    }
                                                    for (int index
                                                        in muddaNewsController!
                                                            .selectedGender) {
                                                      gender.add(
                                                          muddaNewsController!
                                                              .genderList
                                                              .elementAt(index)
                                                              .toLowerCase());
                                                    }
                                                    for (int index
                                                        in muddaNewsController!
                                                            .selectedAge) {
                                                      age.add(
                                                          muddaNewsController!
                                                              .ageList
                                                              .elementAt(
                                                                  index));
                                                    }
                                                    if (muddaNewsController!
                                                        .selectDistrict
                                                        .value
                                                        .isNotEmpty) {
                                                      customLocation.add(
                                                          muddaNewsController!
                                                              .apiLocationList
                                                              .elementAt(0));
                                                      customLocationValues.add(
                                                          muddaNewsController!
                                                              .selectDistrict
                                                              .value);
                                                    }
                                                    if (muddaNewsController!
                                                        .selectState
                                                        .value
                                                        .isNotEmpty) {
                                                      customLocation.add(
                                                          muddaNewsController!
                                                              .apiLocationList
                                                              .elementAt(1));
                                                      customLocationValues.add(
                                                          muddaNewsController!
                                                              .selectState
                                                              .value);
                                                    }
                                                    if (muddaNewsController!
                                                        .selectCountry
                                                        .value
                                                        .isNotEmpty) {
                                                      customLocation.add(
                                                          muddaNewsController!
                                                              .apiLocationList
                                                              .elementAt(2));
                                                      customLocationValues.add(
                                                          muddaNewsController!
                                                              .selectCountry
                                                              .value);
                                                    }
                                                    Map<String, dynamic> map = {
                                                      "page": page.toString(),
                                                      "user_id": AppPreference()
                                                          .getString(
                                                              PreferencesKey
                                                                  .userId),
                                                    };
                                                    if (hashtags.isNotEmpty) {
                                                      map.putIfAbsent(
                                                          "hashtags",
                                                          () => jsonEncode(
                                                              hashtags));
                                                    }
                                                    if (location.isNotEmpty) {
                                                      map.putIfAbsent(
                                                          "location_types",
                                                          () => jsonEncode(
                                                              location));
                                                    }
                                                    if (locationValues
                                                        .isNotEmpty) {
                                                      map.putIfAbsent(
                                                          "location_types_values",
                                                          () => jsonEncode(
                                                              locationValues));
                                                    }
                                                    if (customLocation
                                                        .isNotEmpty) {
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
                                                          () => jsonEncode(
                                                              gender));
                                                    }
                                                    if (age.isNotEmpty) {
                                                      map.putIfAbsent(
                                                          "age_types",
                                                          () =>
                                                              jsonEncode(age));
                                                    }
                                                    Api.get.call(context,
                                                        method: "mudda/index",
                                                        param: map,
                                                        isLoading: false,
                                                        onResponseSuccess:
                                                            (Map object) {
                                                      muddaNewsController!
                                                          .muddaPost
                                                          .value
                                                          .amIRequested = null;
                                                      log("sadsadadadad06666666666666666666666666666666666");

                                                      var result =
                                                          MuddaPostModel
                                                              .fromJson(object);
                                                      if (result
                                                          .data!.isNotEmpty) {
                                                        /* muddaNewsController!
                                                            .muddaPostList
                                                            .clear();*/
                                                        log("sadsadadadad06666666666666666666               ${muddaNewsController!.muddaPostList.length}          666666666666666");
                                                        muddaNewsController!
                                                                .muddaPostList
                                                                .value =
                                                            result.data!;
                                                        log("kkkkkkkkkkkkkkkk               ${muddaNewsController!.muddaPostList.length}          666666666666666");
                                                        // log("widget.index!               ${widget.index!}          666666666666666");

                                                        List tempList =
                                                            muddaNewsController!
                                                                .muddaPostList
                                                                .where((e) =>
                                                                    e.id ==
                                                                    muddaNewsController!
                                                                        .muddaPost
                                                                        .value
                                                                        .id)
                                                                .toList();

                                                        if (tempList
                                                            .isNotEmpty) {
                                                          muddaNewsController!
                                                                  .muddaPost
                                                                  .value =
                                                              tempList.first;
                                                        }

                                                        // muddaNewsController!
                                                        //         .muddaPost
                                                        //         .value =
                                                        //     muddaNewsController!
                                                        //             .muddaPostList[
                                                        //         widget.index!];
                                                        // muddaNewsController!
                                                        //     .muddaPost
                                                        //     .refresh();
                                                        log('0000000000000000     ${muddaNewsController!.muddaPost.value.amIRequested}');
                                                      } else {
                                                        page = page > 1
                                                            ? page - 1
                                                            : page;
                                                      }
                                                    });
                                                  }
                                                },
                                              )
                                            : MuddaInfoDialogAdmin(
                                                muddaNewsController:
                                                    muddaNewsController!,
                                                muddaShareLink: muddaShareLink,
                                              ),
                                      );
                                    },
                                    child: Image.asset(
                                      AppIcons.downArrowIcon,
                                      height: 16,
                                      width: 16,
                                      color: color606060,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: white, width: 1),
                            bottom: BorderSide(color: white, width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // TODO: APPBAR DATA
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: colorF1B008,
                                ),
                                child: Center(
                                  child: Text(
                                    muddaNewsController!
                                                    .postForMuddaMuddaOpposition ==
                                                null ||
                                            muddaNewsController
                                                    ?.disagreePercentage!
                                                    .isNaN ==
                                                true
                                        ? "-"
                                        : "${muddaNewsController?.disagreePercentage?.toStringAsFixed(2) ?? ''}%",
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(13),
                                        color: white),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setSp(60),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: const BoxDecoration(
                                color: white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (muddaNewsController?.disAgreeStatus)! > 0
                                      ? Image.asset(
                                          AppIcons.handIcon,
                                          height: 20,
                                          width: 20,
                                          color: colorF1B008,
                                        )
                                      : Image.asset(
                                          AppIcons.dislike,
                                          height: 16,
                                          width: 16,
                                          color: colorF1B008,
                                        ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${muddaNewsController?.disAgreeStatus.abs().toString()}',
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: ScreenUtil().setSp(12),
                                        color: colorF1B008),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: double.maxFinite,
                                color: appBackground,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // "2.8k",
                                      // muddaNewsController!
                                      //     .postForMuddaTotalUsers
                                      //     .toString(),
                                      muddaNewsController!
                                                  .postForMuddaTotalUsers ==
                                              null
                                          ? "-"
                                          : countNumber(double.parse(
                                              muddaNewsController!
                                                  .postForMuddaTotalUsers
                                                  .toString())),
                                      style: size12_M_normal(
                                        textColor: const Color(0xFF606060),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Image.asset(
                                      AppIcons.iconUsers,
                                      height: 16,
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: double.maxFinite,
                                color: appBackground,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      // "1.3k",
                                      // muddaNewsController!
                                      //     .postForMuddaContainerUsers
                                      //     .toString(),
                                      muddaNewsController!
                                                  .postForMuddaContainerUsers ==
                                              null
                                          ? "-"
                                          : countNumber(double.parse(
                                              muddaNewsController!
                                                  .postForMuddaContainerUsers
                                                  .toString())),
                                      style: size12_M_normal(
                                        textColor: const Color(0xFF606060),
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Image.asset(
                                      AppIcons.eyeIcon,
                                      height: 16,
                                      width: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setSp(60),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: const BoxDecoration(
                                color: white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (muddaNewsController?.agreeStatus)! > 0
                                      ? Image.asset(
                                          AppIcons.handIcon,
                                          height: 20,
                                          width: 20,
                                          color: color0060FF,
                                        )
                                      : Image.asset(
                                          AppIcons.dislike,
                                          height: 16,
                                          width: 16,
                                          color: color0060FF,
                                        ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${muddaNewsController?.agreeStatus.abs().toString()}',
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w700,
                                        fontSize: ScreenUtil().setSp(12),
                                        color: color0060FF),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: color0060FF,
                                ),
                                child: Center(
                                  child: Text(
                                    muddaNewsController!
                                                    .postForMuddaMuddaFavour ==
                                                null ||
                                            muddaNewsController
                                                    ?.agreePercentage!.isNaN ==
                                                true
                                        ? "-"
                                        : "${muddaNewsController?.agreePercentage?.toStringAsFixed(2) ?? ''}%",
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(13),
                                        color: white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            preferredSize: Size.fromHeight(ScreenUtil().setSp(84)),
          ),
          body: Column(
            children: [
              ActionTaskWidget(),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(
                      () => NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          final ScrollDirection direction =
                              notification.direction;
                          if (direction == ScrollDirection.reverse) {
                            muddaNewsController?.showFab.value = true;
                          } else if (direction == ScrollDirection.forward) {
                            muddaNewsController?.showFab.value = false;
                          }
                          return true;
                        },
                        child: muddaNewsController!.isMuddaLoading.value
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: 2,
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return LoadingView();
                                })
                            : SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                header: WaterDropHeader(),
                                footer: CustomFooter(
                                  builder:
                                      (BuildContext context, LoadStatus? mode) {
                                    Widget body;
                                    if (mode == LoadStatus.idle) {
                                      body = Text("pull up load");
                                    } else if (mode == LoadStatus.loading) {
                                      body = CupertinoActivityIndicator();
                                    } else if (mode == LoadStatus.failed) {
                                      body = Text("Load Failed!Click retry!");
                                    } else if (mode == LoadStatus.canLoading) {
                                      body = Text("release to load more");
                                    } else {
                                      body = Text("No more Data");
                                    }
                                    return Container(
                                      height: 55.0,
                                      child: Center(child: body),
                                    );
                                  },
                                ),
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                onLoading: _onLoading,
                                child: ListView.builder(
                                    controller: muddaNewsController!
                                        .muddaScrollController,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: muddaNewsController!
                                        .postForMuddaList.length,
                                    padding: EdgeInsets.only(
                                        bottom: ScreenUtil().setSp(100),
                                        top: 8),
                                    reverse: true,
                                    itemBuilder: (followersContext, index) {
                                      PostForMudda postForMudda =
                                          muddaNewsController!
                                              .postForMuddaList[index];
                                      if (index != 0 && index % 5 == 0) {
                                        return Obx(() => Column(
                                              children: [
                                                MuddaContainerAD(),
                                                postForMudda.postIn == "favour"
                                                    ? Column(
                                                        children: [
                                                          getSizedBox(
                                                              h: ScreenUtil()
                                                                  .setSp(20)),
                                                          MuddaVideoBox(
                                                              postForMudda,
                                                              muddaNewsController!
                                                                  .postForMuddaPath
                                                                  .value,
                                                              index,
                                                              muddaNewsController!
                                                                  .muddaUserProfilePath
                                                                  .value),
                                                          //TODO: favour -FIXED
                                                          // Container(
                                                          //   margin: const EdgeInsets.only(
                                                          //       left: 40, right: 16),
                                                          //   child: Row(
                                                          //     mainAxisAlignment:
                                                          //     MainAxisAlignment.spaceBetween,
                                                          //     children: [
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           muddaNewsController!
                                                          //               .isRepliesShow.value =
                                                          //           !muddaNewsController!
                                                          //               .isRepliesShow.value;
                                                          //           muddaNewsController!.height.value = Get.height * 0.4;
                                                          //           muddaNewsController!.width.value = Get.width;
                                                          //           muddaNewsController!.currentIndex.value = index;
                                                          //           setState(() {});
                                                          //         },
                                                          //         child: Column(
                                                          //           children: [
                                                          //             Row(
                                                          //               children: [
                                                          //                 SvgPicture.asset(
                                                          //                   AppIcons.icReply,
                                                          //                 ),
                                                          //                 SizedBox(width: 5),
                                                          //                 Text(
                                                          //                   postForMudda.replies ==
                                                          //                       null
                                                          //                       ? "-"
                                                          //                       : "${postForMudda.replies}",
                                                          //                   style:
                                                          //                   size12_M_regular(
                                                          //                       textColor:
                                                          //                       black),
                                                          //                 ),
                                                          //               ],
                                                          //             ),
                                                          //             Visibility(
                                                          //               child:
                                                          //               SvgPicture.asset(
                                                          //                 AppIcons.icArrowDown,
                                                          //                 color: grey,
                                                          //               ),
                                                          //               visible: muddaNewsController!
                                                          //                   .isRepliesShow.value &&
                                                          //                   muddaNewsController!.currentIndex.value == index,
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       GestureDetector(
                                                          //         onTap: () {
                                                          //           muddaNewsController!.postForMudda.value = postForMudda;
                                                          //           showModalBottomSheet(
                                                          //               context: context,
                                                          //               builder: (context) {
                                                          //                 return CommentsPost();
                                                          //               });
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //               // AppIcons.replyIcon,
                                                          //               AppIcons.iconComments,
                                                          //               height: 16,
                                                          //               width: 16,
                                                          //             ),
                                                          //             const SizedBox(width: 5),
                                                          //             Text(
                                                          //                 NumberFormat
                                                          //                     .compactCurrency(
                                                          //                   decimalDigits: 0,
                                                          //                   symbol:
                                                          //                   '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //                 ).format(postForMudda
                                                          //                     .commentorsCount),
                                                          //                 style: GoogleFonts
                                                          //                     .nunitoSans(
                                                          //                     fontWeight:
                                                          //                     FontWeight
                                                          //                         .w400,
                                                          //                     fontSize:
                                                          //                     ScreenUtil()
                                                          //                         .setSp(
                                                          //                         12),
                                                          //                     color:
                                                          //                     blackGray)),
                                                          //
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           if (AppPreference().getBool(
                                                          //               PreferencesKey.isGuest)) {
                                                          //             Get.toNamed(RouteConstants
                                                          //                 .userProfileEdit);
                                                          //           } else {
                                                          //             Api.post.call(
                                                          //               context,
                                                          //               method: "like/store",
                                                          //               isLoading: false,
                                                          //               param: {
                                                          //                 "user_id": AppPreference()
                                                          //                     .getString(
                                                          //                     PreferencesKey
                                                          //                         .interactUserId),
                                                          //                 "relative_id":
                                                          //                 postForMudda.sId,
                                                          //                 "relative_type":
                                                          //                 "PostForMudda",
                                                          //                 "status": false
                                                          //               },
                                                          //               onResponseSuccess:
                                                          //                   (object) {
                                                          //                 print(
                                                          //                     "Abhishek $object");
                                                          //               },
                                                          //             );
                                                          //             if (postForMudda
                                                          //                 .agreeStatus ==
                                                          //                 false) {
                                                          //               postForMudda.agreeStatus =
                                                          //               null;
                                                          //               postForMudda
                                                          //                   .dislikersCount =
                                                          //                   postForMudda
                                                          //                       .dislikersCount! -
                                                          //                       1;
                                                          //             } else {
                                                          //               postForMudda
                                                          //                   .dislikersCount =
                                                          //                   postForMudda
                                                          //                       .dislikersCount! +
                                                          //                       1;
                                                          //               postForMudda
                                                          //                   .likersCount = postForMudda
                                                          //                   .likersCount ==
                                                          //                   0
                                                          //                   ? postForMudda
                                                          //                   .likersCount
                                                          //                   : postForMudda
                                                          //                   .likersCount! -
                                                          //                   1;
                                                          //               postForMudda.agreeStatus =
                                                          //               false;
                                                          //             }
                                                          //             int pIndex = index;
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .removeAt(index);
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .insert(pIndex, postForMudda);
                                                          //           }
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //                 postForMudda.agreeStatus ==
                                                          //                     false
                                                          //                     ? AppIcons
                                                          //                     .dislikeFill
                                                          //                     : AppIcons.dislike,
                                                          //                 height: 16,
                                                          //                 width: 16,
                                                          //                 color: postForMudda
                                                          //                     .agreeStatus ==
                                                          //                     false
                                                          //                     ?  colorF1B008
                                                          //                     : blackGray),
                                                          //             const SizedBox(width: 5),
                                                          //             postForMudda.agreeStatus ==
                                                          //                 false
                                                          //                 ? Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.dislikersCount)} Disagree",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ?
                                                          //                   colorF1B008
                                                          //                       : blackGray),
                                                          //             )
                                                          //                 : Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.dislikersCount)}",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ?
                                                          //                   colorF1B008
                                                          //                       : blackGray),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           if (AppPreference().getBool(
                                                          //               PreferencesKey.isGuest)) {
                                                          //             Get.toNamed(RouteConstants
                                                          //                 .userProfileEdit);
                                                          //           } else {
                                                          //             Api.post.call(
                                                          //               context,
                                                          //               method: "like/store",
                                                          //               isLoading: false,
                                                          //               param: {
                                                          //                 "user_id": AppPreference()
                                                          //                     .getString(
                                                          //                     PreferencesKey
                                                          //                         .interactUserId),
                                                          //                 "relative_id":
                                                          //                 postForMudda.sId,
                                                          //                 "relative_type":
                                                          //                 "PostForMudda",
                                                          //                 "status": true
                                                          //               },
                                                          //               onResponseSuccess:
                                                          //                   (object) {},
                                                          //             );
                                                          //             if (postForMudda
                                                          //                 .agreeStatus ==
                                                          //                 true) {
                                                          //               postForMudda.agreeStatus =
                                                          //               null;
                                                          //               postForMudda.likersCount =
                                                          //                   postForMudda
                                                          //                       .likersCount! -
                                                          //                       1;
                                                          //             } else {
                                                          //               postForMudda.likersCount =
                                                          //                   postForMudda
                                                          //                       .likersCount! +
                                                          //                       1;
                                                          //               postForMudda
                                                          //                   .dislikersCount = postForMudda
                                                          //                   .dislikersCount ==
                                                          //                   0
                                                          //                   ? postForMudda
                                                          //                   .dislikersCount
                                                          //                   : postForMudda
                                                          //                   .dislikersCount! -
                                                          //                   1;
                                                          //
                                                          //               postForMudda.agreeStatus =
                                                          //               true;
                                                          //             }
                                                          //             int pIndex = index;
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .removeAt(index);
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .insert(pIndex,
                                                          //                 postForMudda);
                                                          //           }
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //                 postForMudda.agreeStatus ==
                                                          //                     true
                                                          //                     ? AppIcons
                                                          //                     .handIconFill
                                                          //                     : AppIcons.handIcon,
                                                          //                 height: 16,
                                                          //                 width: 16,
                                                          //                 color: postForMudda
                                                          //                     .agreeStatus ==
                                                          //                     true
                                                          //                     ?  color0060FF
                                                          //                     : blackGray),
                                                          //             const SizedBox(width: 5),
                                                          //             postForMudda.agreeStatus ==
                                                          //                 true
                                                          //                 ? Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.likersCount)} Agree",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? color0060FF
                                                          //                       : blackGray),
                                                          //             )
                                                          //                 : Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.likersCount)}",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ?  color0060FF
                                                          //                       : blackGray),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          getSizedBox(
                                                              h: ScreenUtil()
                                                                  .setSp(12)),
                                                          Obx(() => Visibility(
                                                                child:
                                                                    ReplyWidget(
                                                                  postForMudda:
                                                                      postForMudda,
                                                                  index: index,
                                                                ),
                                                                visible: muddaNewsController!
                                                                        .isRepliesShow
                                                                        .value &&
                                                                    muddaNewsController!
                                                                            .currentIndex
                                                                            .value ==
                                                                        index,
                                                              ))
                                                          // timeText(convertToAgo(
                                                          //     DateTime.parse(postForMudda.createdAt!))),
                                                          // getSizedBox(h: 20),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          getSizedBox(
                                                              h: ScreenUtil()
                                                                  .setSp(20)),
                                                          MuddaOppositionVideoBox(
                                                              postForMudda,
                                                              muddaNewsController!
                                                                  .postForMuddaPath
                                                                  .value,
                                                              index,
                                                              muddaNewsController!
                                                                  .muddaUserProfilePath
                                                                  .value),
                                                          // TODO: Opposition - FIXED
                                                          // Container(
                                                          //   // padding: EdgeInsets.only(
                                                          //   //     left: ScreenUtil().setSp(64),
                                                          //   //     right: ScreenUtil().setSp(19)),
                                                          //   padding: const EdgeInsets.only(
                                                          //       right: 16, left: 16),
                                                          //   margin: const EdgeInsets.only(
                                                          //       left: 0, right: 40),
                                                          //   child: Row(
                                                          //     mainAxisAlignment:
                                                          //     MainAxisAlignment.spaceBetween,
                                                          //     children: [
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           muddaNewsController!
                                                          //               .isRepliesShow.value =
                                                          //           !muddaNewsController!
                                                          //               .isRepliesShow.value;
                                                          //           muddaNewsController!.height.value = Get.height * 0.4;
                                                          //           muddaNewsController!.width.value = Get.width;
                                                          //           muddaNewsController!.currentIndex.value = index;
                                                          //           setState(() {});
                                                          //         },
                                                          //         child: Column(
                                                          //           children: [
                                                          //             Row(
                                                          //               children: [
                                                          //                 SvgPicture.asset(
                                                          //                   AppIcons.icReply,
                                                          //                 ),
                                                          //                 SizedBox(width: 5),
                                                          //                 Text(
                                                          //                   postForMudda.replies ==
                                                          //                       null
                                                          //                       ? "-"
                                                          //                       : "${postForMudda.replies}",
                                                          //                   style:
                                                          //                   size12_M_regular(
                                                          //                       textColor:
                                                          //                       black),
                                                          //                 ),
                                                          //
                                                          //               ],
                                                          //             ),
                                                          //             Visibility(
                                                          //               child:
                                                          //               SvgPicture.asset(
                                                          //                 AppIcons.icArrowDown,
                                                          //                 color: grey,
                                                          //               ),
                                                          //               visible: muddaNewsController!
                                                          //                   .isRepliesShow.value &&
                                                          //                   muddaNewsController!.currentIndex.value == index,
                                                          //             ),
                                                          //
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       GestureDetector(
                                                          //         onTap: () {
                                                          //           muddaNewsController!.postForMudda.value = postForMudda;
                                                          //           showModalBottomSheet(
                                                          //               context: context,
                                                          //               builder: (context) {
                                                          //                 return CommentsPost();
                                                          //               });
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //               // AppIcons.replyIcon,
                                                          //               AppIcons.iconComments,
                                                          //               height: 16,
                                                          //               width: 16,
                                                          //             ),
                                                          //             const SizedBox(width: 5),
                                                          //             Text(
                                                          //                 NumberFormat
                                                          //                     .compactCurrency(
                                                          //                   decimalDigits: 0,
                                                          //                   symbol:
                                                          //                   '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //                 ).format(postForMudda
                                                          //                     .commentorsCount),
                                                          //                 style: GoogleFonts
                                                          //                     .nunitoSans(
                                                          //                     fontWeight:
                                                          //                     FontWeight
                                                          //                         .w400,
                                                          //                     fontSize:
                                                          //                     ScreenUtil()
                                                          //                         .setSp(
                                                          //                         12),
                                                          //                     color:
                                                          //                     blackGray)),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           if (AppPreference().getBool(
                                                          //               PreferencesKey.isGuest)) {
                                                          //             Get.toNamed(RouteConstants
                                                          //                 .userProfileEdit);
                                                          //           } else {
                                                          //             Api.post.call(
                                                          //               context,
                                                          //               method: "like/store",
                                                          //               isLoading: false,
                                                          //               param: {
                                                          //                 "user_id": AppPreference()
                                                          //                     .getString(
                                                          //                     PreferencesKey
                                                          //                         .interactUserId),
                                                          //                 "relative_id":
                                                          //                 postForMudda.sId,
                                                          //                 "relative_type":
                                                          //                 "PostForMudda",
                                                          //                 "status": false,
                                                          //               },
                                                          //               onResponseSuccess:
                                                          //                   (object) {
                                                          //                 print(
                                                          //                     "Abhishek $object");
                                                          //               },
                                                          //             );
                                                          //             if (postForMudda
                                                          //                 .agreeStatus ==
                                                          //                 false) {
                                                          //               postForMudda.agreeStatus =
                                                          //               null;
                                                          //               postForMudda
                                                          //                   .dislikersCount =
                                                          //                   postForMudda
                                                          //                       .dislikersCount! -
                                                          //                       1;
                                                          //             } else {
                                                          //               postForMudda
                                                          //                   .dislikersCount =
                                                          //                   postForMudda
                                                          //                       .dislikersCount! +
                                                          //                       1;
                                                          //               postForMudda
                                                          //                   .likersCount = postForMudda
                                                          //                   .likersCount ==
                                                          //                   0
                                                          //                   ? postForMudda
                                                          //                   .likersCount
                                                          //                   : postForMudda
                                                          //                   .likersCount! -
                                                          //                   1;
                                                          //               ;
                                                          //               postForMudda.agreeStatus =
                                                          //               false;
                                                          //             }
                                                          //             int pIndex = index;
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .removeAt(index);
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .insert(pIndex,
                                                          //                 postForMudda);
                                                          //           }
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //                 postForMudda.agreeStatus ==
                                                          //                     false
                                                          //                     ? AppIcons
                                                          //                     .dislikeFill
                                                          //                     : AppIcons.dislike,
                                                          //                 height: 16,
                                                          //                 width: 16,
                                                          //                 color: postForMudda
                                                          //                     .agreeStatus ==
                                                          //                     false
                                                          //                     ? const Color(
                                                          //                     0xFFF1B008)
                                                          //                     : blackGray),
                                                          //             const SizedBox(width: 5),
                                                          //             postForMudda.agreeStatus ==
                                                          //                 false
                                                          //                 ? Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.dislikersCount)} Disagree",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? const Color(
                                                          //                       0xFFF1B008)
                                                          //                       : blackGray),
                                                          //             )
                                                          //                 : Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.dislikersCount)}",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? const Color(
                                                          //                       0xFFF1B008)
                                                          //                       : blackGray),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           if (AppPreference().getBool(
                                                          //               PreferencesKey.isGuest)) {
                                                          //             Get.toNamed(RouteConstants
                                                          //                 .userProfileEdit);
                                                          //           } else {
                                                          //             Api.post.call(
                                                          //               context,
                                                          //               method: "like/store",
                                                          //               isLoading: false,
                                                          //               param: {
                                                          //                 "user_id": AppPreference()
                                                          //                     .getString(
                                                          //                     PreferencesKey
                                                          //                         .interactUserId),
                                                          //                 "relative_id":
                                                          //                 postForMudda.sId,
                                                          //                 "relative_type":
                                                          //                 "PostForMudda",
                                                          //                 "status": true
                                                          //               },
                                                          //               onResponseSuccess:
                                                          //                   (object) {},
                                                          //             );
                                                          //             if (postForMudda
                                                          //                 .agreeStatus ==
                                                          //                 true) {
                                                          //               postForMudda.agreeStatus =
                                                          //               null;
                                                          //               postForMudda.likersCount =
                                                          //                   postForMudda
                                                          //                       .likersCount! -
                                                          //                       1;
                                                          //             } else {
                                                          //               postForMudda.likersCount =
                                                          //                   postForMudda
                                                          //                       .likersCount! +
                                                          //                       1;
                                                          //               postForMudda
                                                          //                   .dislikersCount = postForMudda
                                                          //                   .dislikersCount ==
                                                          //                   0
                                                          //                   ? postForMudda
                                                          //                   .dislikersCount
                                                          //                   : postForMudda
                                                          //                   .dislikersCount! -
                                                          //                   1;
                                                          //
                                                          //               postForMudda.agreeStatus =
                                                          //               true;
                                                          //             }
                                                          //             int pIndex = index;
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .removeAt(index);
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .insert(pIndex,
                                                          //                 postForMudda);
                                                          //           }
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //                 postForMudda.agreeStatus ==
                                                          //                     true
                                                          //                     ? AppIcons
                                                          //                     .handIconFill
                                                          //                     : AppIcons.handIcon,
                                                          //                 height: 16,
                                                          //                 width: 16,
                                                          //                 color: postForMudda
                                                          //                     .agreeStatus ==
                                                          //                     true
                                                          //                     ? const Color(
                                                          //                     0xFF0060FF)
                                                          //                     : blackGray),
                                                          //             const SizedBox(width: 5),
                                                          //             postForMudda.agreeStatus ==
                                                          //                 true
                                                          //                 ? Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.likersCount)} Agree",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? const Color(
                                                          //                       0xFF0060FF)
                                                          //                       : blackGray),
                                                          //             )
                                                          //                 : Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.likersCount)}",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? const Color(
                                                          //                       0xFF0060FF)
                                                          //                       : blackGray),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          getSizedBox(
                                                              h: ScreenUtil()
                                                                  .setSp(12)),
                                                          Obx(() => Visibility(
                                                                child: ReplyWidget(
                                                                    postForMudda:
                                                                        postForMudda,
                                                                    index:
                                                                        index),
                                                                visible: muddaNewsController!
                                                                        .isRepliesShow
                                                                        .value &&
                                                                    muddaNewsController!
                                                                            .currentIndex
                                                                            .value ==
                                                                        index,
                                                              )),
                                                        ],
                                                      )
                                              ],
                                            ));
                                      } else {
                                        return Obx(() => Column(
                                              children: [
                                                postForMudda.postIn == "favour"
                                                    ? Column(
                                                        children: [
                                                          getSizedBox(
                                                              h: ScreenUtil()
                                                                  .setSp(20)),
                                                          MuddaVideoBox(
                                                              postForMudda,
                                                              muddaNewsController!
                                                                  .postForMuddaPath
                                                                  .value,
                                                              index,
                                                              muddaNewsController!
                                                                  .muddaUserProfilePath
                                                                  .value),
                                                          //TODO: favour -FIXED
                                                          // Container(
                                                          //   margin: const EdgeInsets.only(
                                                          //       left: 40, right: 16),
                                                          //   child: Row(
                                                          //     mainAxisAlignment:
                                                          //     MainAxisAlignment.spaceBetween,
                                                          //     children: [
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           muddaNewsController!
                                                          //               .isRepliesShow.value =
                                                          //           !muddaNewsController!
                                                          //               .isRepliesShow.value;
                                                          //           muddaNewsController!.height.value = Get.height * 0.4;
                                                          //           muddaNewsController!.width.value = Get.width;
                                                          //           muddaNewsController!.currentIndex.value = index;
                                                          //           setState(() {});
                                                          //         },
                                                          //         child: Column(
                                                          //           children: [
                                                          //             Row(
                                                          //               children: [
                                                          //                 SvgPicture.asset(
                                                          //                   AppIcons.icReply,
                                                          //                 ),
                                                          //                 SizedBox(width: 5),
                                                          //                 Text(
                                                          //                   postForMudda.replies ==
                                                          //                       null
                                                          //                       ? "-"
                                                          //                       : "${postForMudda.replies}",
                                                          //                   style:
                                                          //                   size12_M_regular(
                                                          //                       textColor:
                                                          //                       black),
                                                          //                 ),
                                                          //               ],
                                                          //             ),
                                                          //             Visibility(
                                                          //               child:
                                                          //               SvgPicture.asset(
                                                          //                 AppIcons.icArrowDown,
                                                          //                 color: grey,
                                                          //               ),
                                                          //               visible: muddaNewsController!
                                                          //                   .isRepliesShow.value &&
                                                          //                   muddaNewsController!.currentIndex.value == index,
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       GestureDetector(
                                                          //         onTap: () {
                                                          //           muddaNewsController!.postForMudda.value = postForMudda;
                                                          //           showModalBottomSheet(
                                                          //               context: context,
                                                          //               builder: (context) {
                                                          //                 return CommentsPost();
                                                          //               });
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //               // AppIcons.replyIcon,
                                                          //               AppIcons.iconComments,
                                                          //               height: 16,
                                                          //               width: 16,
                                                          //             ),
                                                          //             const SizedBox(width: 5),
                                                          //             Text(
                                                          //                 NumberFormat
                                                          //                     .compactCurrency(
                                                          //                   decimalDigits: 0,
                                                          //                   symbol:
                                                          //                   '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //                 ).format(postForMudda
                                                          //                     .commentorsCount),
                                                          //                 style: GoogleFonts
                                                          //                     .nunitoSans(
                                                          //                     fontWeight:
                                                          //                     FontWeight
                                                          //                         .w400,
                                                          //                     fontSize:
                                                          //                     ScreenUtil()
                                                          //                         .setSp(
                                                          //                         12),
                                                          //                     color:
                                                          //                     blackGray)),
                                                          //
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           if (AppPreference().getBool(
                                                          //               PreferencesKey.isGuest)) {
                                                          //             Get.toNamed(RouteConstants
                                                          //                 .userProfileEdit);
                                                          //           } else {
                                                          //             Api.post.call(
                                                          //               context,
                                                          //               method: "like/store",
                                                          //               isLoading: false,
                                                          //               param: {
                                                          //                 "user_id": AppPreference()
                                                          //                     .getString(
                                                          //                     PreferencesKey
                                                          //                         .interactUserId),
                                                          //                 "relative_id":
                                                          //                 postForMudda.sId,
                                                          //                 "relative_type":
                                                          //                 "PostForMudda",
                                                          //                 "status": false
                                                          //               },
                                                          //               onResponseSuccess:
                                                          //                   (object) {
                                                          //                 print(
                                                          //                     "Abhishek $object");
                                                          //               },
                                                          //             );
                                                          //             if (postForMudda
                                                          //                 .agreeStatus ==
                                                          //                 false) {
                                                          //               postForMudda.agreeStatus =
                                                          //               null;
                                                          //               postForMudda
                                                          //                   .dislikersCount =
                                                          //                   postForMudda
                                                          //                       .dislikersCount! -
                                                          //                       1;
                                                          //             } else {
                                                          //               postForMudda
                                                          //                   .dislikersCount =
                                                          //                   postForMudda
                                                          //                       .dislikersCount! +
                                                          //                       1;
                                                          //               postForMudda
                                                          //                   .likersCount = postForMudda
                                                          //                   .likersCount ==
                                                          //                   0
                                                          //                   ? postForMudda
                                                          //                   .likersCount
                                                          //                   : postForMudda
                                                          //                   .likersCount! -
                                                          //                   1;
                                                          //               postForMudda.agreeStatus =
                                                          //               false;
                                                          //             }
                                                          //             int pIndex = index;
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .removeAt(index);
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .insert(pIndex, postForMudda);
                                                          //           }
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //                 postForMudda.agreeStatus ==
                                                          //                     false
                                                          //                     ? AppIcons
                                                          //                     .dislikeFill
                                                          //                     : AppIcons.dislike,
                                                          //                 height: 16,
                                                          //                 width: 16,
                                                          //                 color: postForMudda
                                                          //                     .agreeStatus ==
                                                          //                     false
                                                          //                     ?  colorF1B008
                                                          //                     : blackGray),
                                                          //             const SizedBox(width: 5),
                                                          //             postForMudda.agreeStatus ==
                                                          //                 false
                                                          //                 ? Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.dislikersCount)} Disagree",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ?
                                                          //                   colorF1B008
                                                          //                       : blackGray),
                                                          //             )
                                                          //                 : Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.dislikersCount)}",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ?
                                                          //                   colorF1B008
                                                          //                       : blackGray),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           if (AppPreference().getBool(
                                                          //               PreferencesKey.isGuest)) {
                                                          //             Get.toNamed(RouteConstants
                                                          //                 .userProfileEdit);
                                                          //           } else {
                                                          //             Api.post.call(
                                                          //               context,
                                                          //               method: "like/store",
                                                          //               isLoading: false,
                                                          //               param: {
                                                          //                 "user_id": AppPreference()
                                                          //                     .getString(
                                                          //                     PreferencesKey
                                                          //                         .interactUserId),
                                                          //                 "relative_id":
                                                          //                 postForMudda.sId,
                                                          //                 "relative_type":
                                                          //                 "PostForMudda",
                                                          //                 "status": true
                                                          //               },
                                                          //               onResponseSuccess:
                                                          //                   (object) {},
                                                          //             );
                                                          //             if (postForMudda
                                                          //                 .agreeStatus ==
                                                          //                 true) {
                                                          //               postForMudda.agreeStatus =
                                                          //               null;
                                                          //               postForMudda.likersCount =
                                                          //                   postForMudda
                                                          //                       .likersCount! -
                                                          //                       1;
                                                          //             } else {
                                                          //               postForMudda.likersCount =
                                                          //                   postForMudda
                                                          //                       .likersCount! +
                                                          //                       1;
                                                          //               postForMudda
                                                          //                   .dislikersCount = postForMudda
                                                          //                   .dislikersCount ==
                                                          //                   0
                                                          //                   ? postForMudda
                                                          //                   .dislikersCount
                                                          //                   : postForMudda
                                                          //                   .dislikersCount! -
                                                          //                   1;
                                                          //
                                                          //               postForMudda.agreeStatus =
                                                          //               true;
                                                          //             }
                                                          //             int pIndex = index;
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .removeAt(index);
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .insert(pIndex,
                                                          //                 postForMudda);
                                                          //           }
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //                 postForMudda.agreeStatus ==
                                                          //                     true
                                                          //                     ? AppIcons
                                                          //                     .handIconFill
                                                          //                     : AppIcons.handIcon,
                                                          //                 height: 16,
                                                          //                 width: 16,
                                                          //                 color: postForMudda
                                                          //                     .agreeStatus ==
                                                          //                     true
                                                          //                     ?  color0060FF
                                                          //                     : blackGray),
                                                          //             const SizedBox(width: 5),
                                                          //             postForMudda.agreeStatus ==
                                                          //                 true
                                                          //                 ? Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.likersCount)} Agree",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? color0060FF
                                                          //                       : blackGray),
                                                          //             )
                                                          //                 : Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.likersCount)}",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ?  color0060FF
                                                          //                       : blackGray),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          getSizedBox(
                                                              h: ScreenUtil()
                                                                  .setSp(12)),
                                                          Obx(() => Visibility(
                                                                child:
                                                                    ReplyWidget(
                                                                  postForMudda:
                                                                      postForMudda,
                                                                  index: index,
                                                                ),
                                                                visible: muddaNewsController!
                                                                        .isRepliesShow
                                                                        .value &&
                                                                    muddaNewsController!
                                                                            .currentIndex
                                                                            .value ==
                                                                        index,
                                                              ))
                                                          // timeText(convertToAgo(
                                                          //     DateTime.parse(postForMudda.createdAt!))),
                                                          // getSizedBox(h: 20),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          getSizedBox(
                                                              h: ScreenUtil()
                                                                  .setSp(20)),
                                                          MuddaOppositionVideoBox(
                                                              postForMudda,
                                                              muddaNewsController!
                                                                  .postForMuddaPath
                                                                  .value,
                                                              index,
                                                              muddaNewsController!
                                                                  .muddaUserProfilePath
                                                                  .value),
                                                          // TODO: Opposition - FIXED
                                                          // Container(
                                                          //   // padding: EdgeInsets.only(
                                                          //   //     left: ScreenUtil().setSp(64),
                                                          //   //     right: ScreenUtil().setSp(19)),
                                                          //   padding: const EdgeInsets.only(
                                                          //       right: 16, left: 16),
                                                          //   margin: const EdgeInsets.only(
                                                          //       left: 0, right: 40),
                                                          //   child: Row(
                                                          //     mainAxisAlignment:
                                                          //     MainAxisAlignment.spaceBetween,
                                                          //     children: [
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           muddaNewsController!
                                                          //               .isRepliesShow.value =
                                                          //           !muddaNewsController!
                                                          //               .isRepliesShow.value;
                                                          //           muddaNewsController!.height.value = Get.height * 0.4;
                                                          //           muddaNewsController!.width.value = Get.width;
                                                          //           muddaNewsController!.currentIndex.value = index;
                                                          //           setState(() {});
                                                          //         },
                                                          //         child: Column(
                                                          //           children: [
                                                          //             Row(
                                                          //               children: [
                                                          //                 SvgPicture.asset(
                                                          //                   AppIcons.icReply,
                                                          //                 ),
                                                          //                 SizedBox(width: 5),
                                                          //                 Text(
                                                          //                   postForMudda.replies ==
                                                          //                       null
                                                          //                       ? "-"
                                                          //                       : "${postForMudda.replies}",
                                                          //                   style:
                                                          //                   size12_M_regular(
                                                          //                       textColor:
                                                          //                       black),
                                                          //                 ),
                                                          //
                                                          //               ],
                                                          //             ),
                                                          //             Visibility(
                                                          //               child:
                                                          //               SvgPicture.asset(
                                                          //                 AppIcons.icArrowDown,
                                                          //                 color: grey,
                                                          //               ),
                                                          //               visible: muddaNewsController!
                                                          //                   .isRepliesShow.value &&
                                                          //                   muddaNewsController!.currentIndex.value == index,
                                                          //             ),
                                                          //
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       GestureDetector(
                                                          //         onTap: () {
                                                          //           muddaNewsController!.postForMudda.value = postForMudda;
                                                          //           showModalBottomSheet(
                                                          //               context: context,
                                                          //               builder: (context) {
                                                          //                 return CommentsPost();
                                                          //               });
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //               // AppIcons.replyIcon,
                                                          //               AppIcons.iconComments,
                                                          //               height: 16,
                                                          //               width: 16,
                                                          //             ),
                                                          //             const SizedBox(width: 5),
                                                          //             Text(
                                                          //                 NumberFormat
                                                          //                     .compactCurrency(
                                                          //                   decimalDigits: 0,
                                                          //                   symbol:
                                                          //                   '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //                 ).format(postForMudda
                                                          //                     .commentorsCount),
                                                          //                 style: GoogleFonts
                                                          //                     .nunitoSans(
                                                          //                     fontWeight:
                                                          //                     FontWeight
                                                          //                         .w400,
                                                          //                     fontSize:
                                                          //                     ScreenUtil()
                                                          //                         .setSp(
                                                          //                         12),
                                                          //                     color:
                                                          //                     blackGray)),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           if (AppPreference().getBool(
                                                          //               PreferencesKey.isGuest)) {
                                                          //             Get.toNamed(RouteConstants
                                                          //                 .userProfileEdit);
                                                          //           } else {
                                                          //             Api.post.call(
                                                          //               context,
                                                          //               method: "like/store",
                                                          //               isLoading: false,
                                                          //               param: {
                                                          //                 "user_id": AppPreference()
                                                          //                     .getString(
                                                          //                     PreferencesKey
                                                          //                         .interactUserId),
                                                          //                 "relative_id":
                                                          //                 postForMudda.sId,
                                                          //                 "relative_type":
                                                          //                 "PostForMudda",
                                                          //                 "status": false,
                                                          //               },
                                                          //               onResponseSuccess:
                                                          //                   (object) {
                                                          //                 print(
                                                          //                     "Abhishek $object");
                                                          //               },
                                                          //             );
                                                          //             if (postForMudda
                                                          //                 .agreeStatus ==
                                                          //                 false) {
                                                          //               postForMudda.agreeStatus =
                                                          //               null;
                                                          //               postForMudda
                                                          //                   .dislikersCount =
                                                          //                   postForMudda
                                                          //                       .dislikersCount! -
                                                          //                       1;
                                                          //             } else {
                                                          //               postForMudda
                                                          //                   .dislikersCount =
                                                          //                   postForMudda
                                                          //                       .dislikersCount! +
                                                          //                       1;
                                                          //               postForMudda
                                                          //                   .likersCount = postForMudda
                                                          //                   .likersCount ==
                                                          //                   0
                                                          //                   ? postForMudda
                                                          //                   .likersCount
                                                          //                   : postForMudda
                                                          //                   .likersCount! -
                                                          //                   1;
                                                          //               ;
                                                          //               postForMudda.agreeStatus =
                                                          //               false;
                                                          //             }
                                                          //             int pIndex = index;
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .removeAt(index);
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .insert(pIndex,
                                                          //                 postForMudda);
                                                          //           }
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //                 postForMudda.agreeStatus ==
                                                          //                     false
                                                          //                     ? AppIcons
                                                          //                     .dislikeFill
                                                          //                     : AppIcons.dislike,
                                                          //                 height: 16,
                                                          //                 width: 16,
                                                          //                 color: postForMudda
                                                          //                     .agreeStatus ==
                                                          //                     false
                                                          //                     ? const Color(
                                                          //                     0xFFF1B008)
                                                          //                     : blackGray),
                                                          //             const SizedBox(width: 5),
                                                          //             postForMudda.agreeStatus ==
                                                          //                 false
                                                          //                 ? Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.dislikersCount)} Disagree",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? const Color(
                                                          //                       0xFFF1B008)
                                                          //                       : blackGray),
                                                          //             )
                                                          //                 : Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.dislikersCount)}",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       false
                                                          //                       ? const Color(
                                                          //                       0xFFF1B008)
                                                          //                       : blackGray),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //       InkWell(
                                                          //         onTap: () {
                                                          //           if (AppPreference().getBool(
                                                          //               PreferencesKey.isGuest)) {
                                                          //             Get.toNamed(RouteConstants
                                                          //                 .userProfileEdit);
                                                          //           } else {
                                                          //             Api.post.call(
                                                          //               context,
                                                          //               method: "like/store",
                                                          //               isLoading: false,
                                                          //               param: {
                                                          //                 "user_id": AppPreference()
                                                          //                     .getString(
                                                          //                     PreferencesKey
                                                          //                         .interactUserId),
                                                          //                 "relative_id":
                                                          //                 postForMudda.sId,
                                                          //                 "relative_type":
                                                          //                 "PostForMudda",
                                                          //                 "status": true
                                                          //               },
                                                          //               onResponseSuccess:
                                                          //                   (object) {},
                                                          //             );
                                                          //             if (postForMudda
                                                          //                 .agreeStatus ==
                                                          //                 true) {
                                                          //               postForMudda.agreeStatus =
                                                          //               null;
                                                          //               postForMudda.likersCount =
                                                          //                   postForMudda
                                                          //                       .likersCount! -
                                                          //                       1;
                                                          //             } else {
                                                          //               postForMudda.likersCount =
                                                          //                   postForMudda
                                                          //                       .likersCount! +
                                                          //                       1;
                                                          //               postForMudda
                                                          //                   .dislikersCount = postForMudda
                                                          //                   .dislikersCount ==
                                                          //                   0
                                                          //                   ? postForMudda
                                                          //                   .dislikersCount
                                                          //                   : postForMudda
                                                          //                   .dislikersCount! -
                                                          //                   1;
                                                          //
                                                          //               postForMudda.agreeStatus =
                                                          //               true;
                                                          //             }
                                                          //             int pIndex = index;
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .removeAt(index);
                                                          //             muddaNewsController!
                                                          //                 .postForMuddaList
                                                          //                 .insert(pIndex,
                                                          //                 postForMudda);
                                                          //           }
                                                          //         },
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Image.asset(
                                                          //                 postForMudda.agreeStatus ==
                                                          //                     true
                                                          //                     ? AppIcons
                                                          //                     .handIconFill
                                                          //                     : AppIcons.handIcon,
                                                          //                 height: 16,
                                                          //                 width: 16,
                                                          //                 color: postForMudda
                                                          //                     .agreeStatus ==
                                                          //                     true
                                                          //                     ? const Color(
                                                          //                     0xFF0060FF)
                                                          //                     : blackGray),
                                                          //             const SizedBox(width: 5),
                                                          //             postForMudda.agreeStatus ==
                                                          //                 true
                                                          //                 ? Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.likersCount)} Agree",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? const Color(
                                                          //                       0xFF0060FF)
                                                          //                       : blackGray),
                                                          //             )
                                                          //                 : Text(
                                                          //               "${NumberFormat.compactCurrency(
                                                          //                 decimalDigits: 0,
                                                          //                 symbol:
                                                          //                 '', // if you want to add currency symbol then pass that in this else leave it empty.
                                                          //               ).format(postForMudda.likersCount)}",
                                                          //               style: GoogleFonts.nunitoSans(
                                                          //                   fontWeight: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? FontWeight
                                                          //                       .w700
                                                          //                       : FontWeight
                                                          //                       .w400,
                                                          //                   fontSize:
                                                          //                   ScreenUtil()
                                                          //                       .setSp(
                                                          //                       12),
                                                          //                   color: postForMudda
                                                          //                       .agreeStatus ==
                                                          //                       true
                                                          //                       ? const Color(
                                                          //                       0xFF0060FF)
                                                          //                       : blackGray),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          getSizedBox(
                                                              h: ScreenUtil()
                                                                  .setSp(12)),
                                                          Obx(() => Visibility(
                                                                child: ReplyWidget(
                                                                    postForMudda:
                                                                        postForMudda,
                                                                    index:
                                                                        index),
                                                                visible: muddaNewsController!
                                                                        .isRepliesShow
                                                                        .value &&
                                                                    muddaNewsController!
                                                                            .currentIndex
                                                                            .value ==
                                                                        index,
                                                              )),
                                                        ],
                                                      )
                                              ],
                                            ));
                                      }
                                    }),
                              ),
                      ),
                    ),
                    Positioned(
                        bottom: 120,
                        right: 16,
                        child: Obx(() => Visibility(
                              visible:
                                  muddaNewsController!.isShowArrowDown.value,
                              child: AnimatedOpacity(
                                opacity: muddaNewsController
                                            ?.isShowArrowDown.value ==
                                        true
                                    ? 1
                                    : 0,
                                duration: duration,
                                child: GestureDetector(
                                    onTap: () {
                                      muddaNewsController!.muddaScrollController
                                          .animateTo(
                                              muddaNewsController!
                                                  .muddaScrollController
                                                  .position
                                                  .minScrollExtent,
                                              duration:
                                                  const Duration(seconds: 2),
                                              curve: Curves.fastOutSlowIn);
                                    },
                                    child: SvgPicture.asset(
                                      AppIcons.icDownArrow,
                                      height: 24,
                                      width: 25,
                                    )),
                              ),
                            ))),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                height: 20,
                                width: 40,
                              ),
                              AnimatedSlide(
                                duration: duration,
                                offset:
                                    muddaNewsController?.showFab.value == true
                                        ? Offset.zero
                                        : const Offset(0, 2),
                                child: AnimatedOpacity(
                                  duration: duration,
                                  opacity:
                                      muddaNewsController?.showFab.value == true
                                          ? 1
                                          : 0,
                                  child: Container(
                                    height: 55,
                                    width: 55,
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (AppPreference()
                                            .getBool(PreferencesKey.isGuest)) {
                                          updateProfileDialog(context);
                                        } else {
                                          muddaNewsController!
                                              .clickPlusIconForum();
                                          Get.toNamed(
                                              RouteConstants.uploadPostScreen);
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        AppIcons.icPlus,
                                        height: 32,
                                        width: 32,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0XFFf89f27),
                                            Color(0XFFf4e2b4),
                                            Color(0XFFf89f27),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.30),
                                            offset: const Offset(0, 3),
                                            blurRadius: 4,
                                          )
                                        ],
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: white, width: 1)),
                                  ),
                                ),
                              ),
                              muddaNewsController?.muddaPost.value.isInvolved !=
                                      null
                                  ? AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      width: muddaNewsController!.showFab.value
                                          ? 50
                                          : 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          _chatController?.userId =
                                              muddaNewsController!
                                                      .isFromNotification.value
                                                  ? muddaNewsController!
                                                      .muddaId.value
                                                  : Get.parameters['id'];
                                          _chatController?.chatId =
                                              muddaNewsController
                                                  ?.postMudda.value.chatId;
                                          _chatController?.userName =
                                              muddaNewsController!
                                                      .isFromNotification.value
                                                  ? muddaNewsController!
                                                      .muddaTitle.value
                                                  : muddaNewsController!
                                                              .muddaPost
                                                              .value
                                                              .title !=
                                                          null
                                                      ? muddaNewsController!
                                                          .muddaPost
                                                          .value
                                                          .title!
                                                      : "Title";
                                          _chatController?.profile =
                                              muddaNewsController!
                                                  .postForMuddaMuddaThumbnail;
                                          _chatController?.isUserBlock.value =
                                              false;
                                          _chatController?.index.value = 0;
                                          Get.toNamed(
                                              RouteConstants.muddaChatPage,
                                              arguments: {
                                                'members': muddaNewsController
                                                                ?.muddaPost
                                                                .value
                                                                .isInvolved!
                                                                .joinerType ==
                                                            "creator" ||
                                                        muddaNewsController
                                                                ?.muddaPost
                                                                .value
                                                                .isInvolved!
                                                                .joinerType ==
                                                            "leader" ||
                                                        muddaNewsController
                                                                ?.muddaPost
                                                                .value
                                                                .isInvolved!
                                                                .joinerType ==
                                                            "initial_leader"
                                                    ? muddaNewsController
                                                            ?.muddaPost
                                                            .value
                                                            .favourCount ??
                                                        0
                                                    : muddaNewsController
                                                            ?.muddaPost
                                                            .value
                                                            .oppositionCount ??
                                                        0
                                              });
                                        },
                                        child: Container(
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            AppIcons.circleChat2Tab,
                                            height: 20,
                                            width: 22,
                                            color: white,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                color606060.withOpacity(0.75),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              bottomLeft: Radius.circular(16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 20,
                                      width: 40,
                                    ),
                            ],
                          )),
                    ),
                    if (muddaNewsController!.postForMuddapostTotalNewPost !=
                        null)
                      muddaNewsController!.postForMuddapostTotalNewPost > 0
                          ? Positioned(
                              bottom: 4,
                              left: 0,
                              right: 0,
                              child: Obx(() => AnimatedSlide(
                                    duration: duration,
                                    offset:
                                        muddaNewsController?.showFab.value ==
                                                true
                                            ? Offset.zero
                                            : const Offset(2, 0),
                                    child: AnimatedOpacity(
                                      duration: duration,
                                      opacity:
                                          muddaNewsController?.showFab.value ==
                                                  true
                                              ? 1
                                              : 0,
                                      child: InkWell(
                                        onTap: () =>
                                            muddaNewsController!.fetchNewPost(),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 153,
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: color0060FF,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.30),
                                                      offset:
                                                          const Offset(0, 3),
                                                      blurRadius: 4,
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  border: Border.all(
                                                      color: white, width: 1)),
                                              child: muddaNewsController!
                                                      .isFetchNewPost.value
                                                  ? const CircularProgressIndicator(
                                                      backgroundColor: white)
                                                  : Text(
                                                      '${muddaNewsController!.postForMuddapostTotalNewPost} new posts',
                                                      style: size12_M_regular(),
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            )
                          : const SizedBox(),
                    // Positioned(
                    //   bottom: 30,
                    //   child: Obx(() => AnimatedSlide(
                    //     duration: duration,
                    //     offset: muddaNewsController?.showFab.value==true ? Offset.zero : Offset(2, 0),
                    //     child: AnimatedOpacity(
                    //       duration: duration,
                    //       opacity: muddaNewsController?.showFab.value==true ? 1 : 0,
                    //       child: Container(
                    //         height: 40,
                    //         width: 50,
                    //         alignment: Alignment.center,
                    //         child: GestureDetector(
                    //           onTap: () {
                    //             if (AppPreference().getBool(PreferencesKey.isGuest)) {
                    //               Get.toNamed(RouteConstants.userProfileEdit);
                    //             } else {
                    //               Get.toNamed(RouteConstants.uploadPostScreen);
                    //             }
                    //           },
                    //           child: Image.asset(
                    //             AppIcons.plusMinusIcon,
                    //             height: 25,
                    //             width: 25,
                    //           ),
                    //         ),
                    //         decoration: BoxDecoration(
                    //           color: color606060.withOpacity(0.75),
                    //           borderRadius: const BorderRadius.only(
                    //             topLeft: Radius.circular(16),
                    //             bottomLeft: Radius.circular(16),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   )),
                    // ),
                    // Visibility(
                    //   visible: muddaNewsController!.roleList.isNotEmpty,
                    //   child: Positioned(
                    //     bottom: ScreenUtil().setSp(90),
                    //     child: Column(
                    //       children: [
                    //         Obx(
                    //               () => InkWell(
                    //             onTap: () {
                    //               showRolesDialog(context);
                    //             },
                    //             child: muddaNewsController!
                    //                 .selectedRole.value.user !=
                    //                 null
                    //                 ? muddaNewsController!
                    //                 .selectedRole.value.user!.profile !=
                    //                 null
                    //                 ? CachedNetworkImage(
                    //               imageUrl:
                    //               "${muddaNewsController!.roleProfilePath.value}${muddaNewsController!.selectedRole.value.user!.profile}",
                    //               imageBuilder:
                    //                   (context, imageProvider) =>
                    //                   Container(
                    //                     width: ScreenUtil().setSp(42),
                    //                     height: ScreenUtil().setSp(42),
                    //                     decoration: BoxDecoration(
                    //                       color: colorWhite,
                    //                       border: Border.all(
                    //                         width: ScreenUtil().setSp(1),
                    //                         color: buttonBlue,
                    //                       ),
                    //                       borderRadius: BorderRadius.all(
                    //                           Radius.circular(ScreenUtil().setSp(
                    //                               21)) //                 <--- border radius here
                    //                       ),
                    //                       image: DecorationImage(
                    //                           image: imageProvider,
                    //                           fit: BoxFit.cover),
                    //                     ),
                    //                   ),
                    //               placeholder: (context, url) =>
                    //                   CircleAvatar(
                    //                     backgroundColor: lightGray,
                    //                     radius: ScreenUtil().setSp(21),
                    //                   ),
                    //               errorWidget: (context, url, error) =>
                    //                   CircleAvatar(
                    //                     backgroundColor: lightGray,
                    //                     radius: ScreenUtil().setSp(21),
                    //                   ),
                    //             )
                    //                 : Container(
                    //               height: ScreenUtil().setSp(42),
                    //               width: ScreenUtil().setSp(42),
                    //               decoration: BoxDecoration(
                    //                 border: Border.all(
                    //                   color: darkGray,
                    //                 ),
                    //                 shape: BoxShape.circle,
                    //               ),
                    //               child: Center(
                    //                 child: Text(
                    //                     muddaNewsController!.selectedRole
                    //                         .value.user!.fullname![0]
                    //                         .toUpperCase(),
                    //                     style: GoogleFonts.nunitoSans(
                    //                         fontWeight: FontWeight.w400,
                    //                         fontSize:
                    //                         ScreenUtil().setSp(16),
                    //                         color: black)),
                    //               ),
                    //             )
                    //                 : AppPreference()
                    //                 .getString(
                    //                 PreferencesKey.interactProfile)
                    //                 .isNotEmpty
                    //                 ? CachedNetworkImage(
                    //               imageUrl:
                    //               "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.interactProfile)}",
                    //               imageBuilder:
                    //                   (context, imageProvider) =>
                    //                   Container(
                    //                     width: ScreenUtil().setSp(42),
                    //                     height: ScreenUtil().setSp(42),
                    //                     decoration: BoxDecoration(
                    //                       color: colorWhite,
                    //                       border: Border.all(
                    //                         width: ScreenUtil().setSp(1),
                    //                         color: buttonBlue,
                    //                       ),
                    //                       borderRadius: BorderRadius.all(
                    //                           Radius.circular(ScreenUtil().setSp(
                    //                               21)) //                 <--- border radius here
                    //                       ),
                    //                       image: DecorationImage(
                    //                           image: imageProvider,
                    //                           fit: BoxFit.cover),
                    //                     ),
                    //                   ),
                    //               placeholder: (context, url) =>
                    //                   CircleAvatar(
                    //                     backgroundColor: lightGray,
                    //                     radius: ScreenUtil().setSp(21),
                    //                   ),
                    //               errorWidget: (context, url, error) =>
                    //                   CircleAvatar(
                    //                     backgroundColor: lightGray,
                    //                     radius: ScreenUtil().setSp(21),
                    //                   ),
                    //             )
                    //                 : Container(
                    //               height: ScreenUtil().setSp(42),
                    //               width: ScreenUtil().setSp(42),
                    //               decoration: BoxDecoration(
                    //                 border: Border.all(
                    //                   color: darkGray,
                    //                 ),
                    //                 shape: BoxShape.circle,
                    //               ),
                    //               child: Center(
                    //                 child: Text(
                    //                     AppPreference()
                    //                         .getString(PreferencesKey
                    //                         .fullName)[0]
                    //                         .toUpperCase(),
                    //                     style: GoogleFonts.nunitoSans(
                    //                         fontWeight: FontWeight.w400,
                    //                         fontSize:
                    //                         ScreenUtil().setSp(16),
                    //                         color: black)),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         getSizedBox(h: 5),
                    //         Text("Interacting as",
                    //             style: GoogleFonts.nunitoSans(
                    //                 fontWeight: FontWeight.w400,
                    //                 fontSize: ScreenUtil().setSp(10),
                    //                 color: Colors.red,
                    //                 fontStyle: FontStyle.italic)),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          Api.post.call(
            context,
            method: "mudda/exitContainer",
            isLoading: false,
            param: {
              "mudda_id":
                  "${muddaNewsController!.isFromNotification.value ? muddaNewsController!.muddaId.value : muddaNewsController!.muddaPost.value.sId}",
            },
            onResponseSuccess: (object) {},
          );
          Navigator.pop(context, true);
          return true;
        });
  }

  _getRoles(BuildContext context) async {
    Api.get.call(context,
        method: "user/my-roles",
        param: {
          "page": rolePage.toString(),
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "interactModal": "CommentPost"
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = UserRolesModel.fromJson(object);
      if (rolePage == 1) {
        muddaNewsController!.roleList.clear();
      }
      if (result.data!.isNotEmpty) {
        muddaNewsController!.roleProfilePath.value = result.path!;
        muddaNewsController!.roleList.addAll(result.data!);
        Role role = Role();
        role.user = User();
        role.user!.profile = AppPreference().getString(PreferencesKey.profile);
        role.user!.fullname = "Self";
        role.user!.sId = AppPreference().getString(PreferencesKey.userId);
        muddaNewsController!.roleList.add(role);
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
                    itemCount: muddaNewsController!.commentRoleList.length,
                    itemBuilder: (followersContext, index) {
                      Role role = muddaNewsController!.commentRoleList[index];
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

  showJoinDialog(BuildContext context) {
    return showDialog(
      context: Get.context as BuildContext,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            color: white,
            padding: EdgeInsets.only(
                top: ScreenUtil().setSp(24),
                left: ScreenUtil().setSp(24),
                right: ScreenUtil().setSp(24),
                bottom: ScreenUtil().setSp(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: ScreenUtil().setSp(25),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: ScreenUtil().setSp(8)),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: grey)),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: grey)),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: grey),
                        )),
                    hint: Text("Join Favour",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(12),
                            color: buttonBlue)),
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(12),
                        color: buttonBlue),
                    items: <String>[
                      "Join Normal",
                      "Join Anonymous",
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                fontSize: ScreenUtil().setSp(12),
                                color: black)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (AppPreference().getBool(PreferencesKey.isGuest)) {
                        updateProfileDialog(context);
                      } else {
                        muddaNewsController!.selectJoinFavour.value = newValue!;
                        Api.post.call(
                          context,
                          method: "request-to-user/store",
                          param: {
                            "user_id": AppPreference()
                                .getString(PreferencesKey.userId),
                            "request_to_user_id": muddaNewsController!
                                .muddaPost.value.leaders![0].userId,
                            "joining_content_id":
                                muddaNewsController!.muddaPost.value.sId,
                            "requestModalPath":
                                muddaNewsController!.muddaProfilePath.value,
                            "requestModal": "RealMudda",
                            "request_type": "leader",
                            "user_identity":
                                newValue == "Join Normal" ? "1" : "0",
                          },
                          onResponseSuccess: (object) {
                            print("JOIN:::$object");
                            MuddaPost muddaPost =
                                muddaNewsController!.muddaPost.value;
                            muddaPost.amIRequested =
                                MyReaction.fromJson(object['data']);
                            muddaNewsController!.muddaPost.value = MuddaPost();
                            muddaNewsController!.muddaPost.value = muddaPost;
                            Get.back();
                          },
                        );
                      }
                    },
                  ),
                ),
                getSizedBox(h: ScreenUtil().setSp(20)),
                SizedBox(
                  height: ScreenUtil().setSp(25),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: ScreenUtil().setSp(8)),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: grey)),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: grey)),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: grey),
                        )),
                    hint: Text("Join Opposition",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(12),
                            color: buttonYellow)),
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(12),
                        color: buttonYellow),
                    items: <String>[
                      "Join Normal",
                      "Join Anonymous",
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunitoSans(
                                fontWeight: FontWeight.w400,
                                fontSize: ScreenUtil().setSp(12),
                                color: black)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (AppPreference().getBool(PreferencesKey.isGuest)) {
                        updateProfileDialog(context);
                      } else {
                        muddaNewsController!.selectJoinFavour.value = newValue!;
                        Api.post.call(
                          context,
                          method: "request-to-user/store",
                          param: {
                            "user_id": AppPreference()
                                .getString(PreferencesKey.userId),
                            "request_to_user_id": muddaNewsController!
                                .muddaPost.value.leaders![0].userId,
                            "joining_content_id":
                                muddaNewsController!.muddaPost.value.sId,
                            "requestModalPath":
                                muddaNewsController!.muddaProfilePath.value,
                            "requestModal": "RealMudda",
                            "request_type": "opposition",
                            "user_identity":
                                newValue == "Join Normal" ? "1" : "0",
                          },
                          onResponseSuccess: (object) {
                            MuddaPost muddaPost =
                                muddaNewsController!.muddaPost.value;
                            muddaPost.isInvolved =
                                MyReaction.fromJson(object['data']);
                            muddaNewsController!.muddaPost.value = MuddaPost();
                            muddaNewsController!.muddaPost.value = muddaPost;
                            Get.back();
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
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

  timeText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getSizedBox(w: 10),
        Text(text, style: size10_M_normal(textColor: Colors.grey)),
        getSizedBox(w: 10),
      ],
    );
  }

  textMuddaBox(PostForMudda postForMudda) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          postForMudda.postIn == "opposition"
              ? Container(
                  width: Get.width,
                  decoration: const BoxDecoration(
                    color: yellowColorsOpacity,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              postForMudda.muddaDescription != null
                                  ? postForMudda.muddaDescription!
                                  : "",
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                reportPostDialogBox(Get.context as BuildContext,
                                    muddaNewsController!.muddaPost.value.sId!);
                              },
                              child: const Icon(Icons.more_vert_outlined))
                        ],
                      ),
                      getSizedBox(h: 40)
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  searchBoxTextFiled() {
    return showDialog(
      context: Get.context as BuildContext,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                height: 30,
                width: 300,
                color: Colors.white,
                child: Material(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFf7f7f7),
                      border: Border.all(color: colorGrey),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: size13_M_normal(textColor: color606060),
                            cursorHeight: 15,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(bottom: 15, left: 15),
                              hintStyle:
                                  size13_M_normal(textColor: color606060),
                              hintText: "Search",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Image.asset(
                          AppIcons.searchIcon,
                          height: 18,
                          width: 18,
                        ),
                        getSizedBox(w: 10)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  reportMuddaDialogBox(BuildContext context, String muddaId) {
    String? muddaShareLink = muddaNewsController?.muddaShareLink.toString();
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.5),
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Container(
              height: 169,
              width: 168,
              color: Colors.white,
              child: Material(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    commonPostText(
                        text: "Report",
                        color: colorGrey,
                        size: 13,
                        onPressed: () {
                          Get.back();
                          reportDialogBox(
                              context, muddaId, false, false, false);
                        }),
                    cDivider(margin: 60),
                    commonPostText(
                        text: "Share",
                        color: colorGrey,
                        size: 13,
                        onPressed: () {
                          // CreateMyDynamicLinksClass()
                          //     .createDynamicLink(
                          //         true, '/muddaDetailsScreen?id=$muddaId')
                          //     .then((value) {

                          Share.share(
                              "Hi,Join me on Mudda App to improve our world with creative thoughts & topics $muddaShareLink");
                          Get.back();
                          // });
                          // Share.share(
                          //   '${Const.shareUrl}mudda/$muddaId',
                          // );
                        }),
                    cDivider(margin: 60),
                    commonPostText(
                        text: "Settings",
                        color: colorGrey,
                        size: 13,
                        onPressed: () {
                          Get.back();
                        }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

final controller = CarouselController();

muddaGalleryDialog(
    BuildContext context, List<Gallery> list, String path, int index) {
  VideoController videoController = VideoController();
  PageController? popUpPageController;
  popUpPageController = PageController(keepPage: true, initialPage: index);
  bool isOnPageHorizontalTurning = false;
  int currentHorizontal = index;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          // insetPadding: EdgeInsets.only(
          //     top: ScreenUtil().setSp((ScreenUtil().screenHeight / 3) / 2),
          //     bottom: ScreenUtil().setSp((ScreenUtil().screenHeight / 3) / 2),
          //     left: ScreenUtil().setWidth(26),
          //     right: ScreenUtil().setWidth(26)),
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(builder: (context, setStates) {
            return Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Get.back();
                //   },
                //   child: const Spacer()),
                Expanded(
                    flex: 2,
                    child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          color: Colors.transparent,
                        ))),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: CarouselSlider.builder(
                      carouselController: controller,
                      options: CarouselOptions(
                        initialPage: index,
                        height: Get.height * 0.6,
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) => setStates(() {
                          currentHorizontal = index;
                        }),
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index, realIndex) {
                        Gallery mediaModelData = list[index];
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            !mediaModelData.file!.contains(".mp4")
                                ? CachedNetworkImage(
                                    imageUrl: "$path${mediaModelData.file!}",
                                    fit: BoxFit.fitWidth)
                                : GestureDetector(
                                    onLongPressUp: () {
                                      setStates(() {
                                        isOnPageHorizontalTurning = false;
                                      });
                                    },
                                    onLongPress: () {
                                      setStates(() {
                                        isOnPageHorizontalTurning = true;
                                      });
                                    },
                                    onTap: () {
                                      /*setStates(() {
                                                    isDialOpen.value = false;
                                                    if (visibilityTag) {
                                                      visibilityTag = false;
                                                    }
                                                    hideShowTag = !hideShowTag;
                                                  });*/
                                    },
                                    child: VideoPlayerScreen(
                                        mediaModelData.file!,
                                        path,
                                        index,
                                        currentHorizontal,
                                        0,
                                        0,
                                        true,
                                        videoController,
                                        isOnPageHorizontalTurning),
                                  ),
                            // Align(
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(bottom: 10),
                            //     child: SmoothPageIndicator(
                            //       onDotClicked: (value) {
                            //         print('dot clicked $value');
                            //         if (value == 0) {
                            //           popUpPageController!.previousPage(
                            //               duration: Duration(seconds: 1),
                            //               curve: Curves.bounceIn);
                            //         }
                            //         popUpPageController!.nextPage(
                            //             duration: Duration(seconds: 1),
                            //             curve: Curves.bounceIn);
                            //         setStates(() {
                            //           popUpPageController = PageController(
                            //               keepPage: true, initialPage: value);
                            //           //
                            //         });
                            //         //   setStates(() {
                            //         //
                            //         // });
                            //       },
                            //       controller: popUpPageController!,
                            //       count: list.length,
                            //       axisDirection: Axis.horizontal,
                            //       effect: const SlideEffect(
                            //           spacing: 10.0,
                            //           radius: 3.0,
                            //           dotWidth: 6.0,
                            //           dotHeight: 6.0,
                            //           paintStyle: PaintingStyle.stroke,
                            //           strokeWidth: 1.5,
                            //           dotColor: white,
                            //           activeDotColor: lightRed),
                            //     ),
                            //   ),
                            //   alignment: Alignment(0, 1),
                            // )
                          ],
                        );
                      }),
                ),
                Expanded(
                    flex: 2,
                    child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          color: Colors.transparent,
                        ))),
                // GestureDetector(
                //     onTap: () {
                //       Get.back();
                //     },
                //     child: const Spacer()),

                AnimatedSmoothIndicator(
                    onDotClicked: (index) {
                      controller.animateToPage(index);
                    },
                    activeIndex: currentHorizontal,
                    count: list.length,
                    effect: CustomizableEffect(
                      activeDotDecoration: DotDecoration(
                        width: 12.0,
                        height: 3.0,
                        color: Colors.amber,
                        // rotationAngle: 180,
                        // verticalOffset: -10,
                        borderRadius: BorderRadius.circular(24),
                        dotBorder: const DotBorder(
                          padding: 1,
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                      dotDecoration: DotDecoration(
                        width: 12.0,
                        height: 3.0,
                        // color: lightRed,
                        dotBorder: const DotBorder(
                          padding: 0,
                          width: 0.5,
                          color: Colors.white,
                        ),
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(2),
                        //     topRight: Radius.circular(16),
                        //     bottomLeft: Radius.circular(16),
                        //     bottomRight: Radius.circular(2)),
                        borderRadius: BorderRadius.circular(16),
                        // verticalOffset: 0,
                      ),
                      // spacing: 6.0,
                      // activeColorOverride: (i) => colors[i],
                      inActiveColorOverride: (i) => white,
                    )
                    // const SlideEffect(
                    //     spacing: 10.0,
                    //     radius: 3.0,
                    //     dotWidth: 6.0,
                    //     dotHeight: 6.0,
                    //     paintStyle: PaintingStyle.stroke,
                    //     strokeWidth: 1.5,
                    //     dotColor: white,
                    //     activeDotColor: lightRed),
                    )
              ],
            );
          }),
          // insetPadding: EdgeInsets.only(
          //     top: ScreenUtil().setSp(
          //         (ScreenUtil().screenHeight - ScreenUtil().setSp(480)) / 2),
          //     bottom: ScreenUtil().setSp(
          //         (ScreenUtil().screenHeight - ScreenUtil().setSp(480)) / 2),
          //     left: ScreenUtil().setSp(
          //         (ScreenUtil().screenWidth - ScreenUtil().setSp(330)) / 2),
          //     right: ScreenUtil().setSp(
          //         (ScreenUtil().screenWidth - ScreenUtil().setSp(330)) / 2)),
          // child: StatefulBuilder(
          //   builder: (BuildContext context, StateSetter setStates) {
          //     PageController famePageController;
          //     famePageController =
          //         PageController(keepPage: true, initialPage: index);
          //     famePageController.addListener(() {
          //       if (isOnPageHorizontalTurning &&
          //           famePageController.page ==
          //               famePageController.page!.roundToDouble()) {
          //         setStates(() {
          //           currentHorizontal = famePageController.page!.toInt();
          //           isOnPageHorizontalTurning = false;
          //         });
          //       } else if (!isOnPageHorizontalTurning &&
          //           currentHorizontal.toDouble() != famePageController.page) {
          //         if ((currentHorizontal.toDouble() - famePageController.page!)
          //                 .abs() >
          //             0.1) {
          //           setStates(() {
          //             isOnPageHorizontalTurning = true;
          //           });
          //         }
          //       }
          //     });
          //     return Column(
          //       children: [
          //         Stack(
          //           children: [
          //             Container(
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.all(
          //                       Radius.circular(ScreenUtil().setSp(8)))),
          //               child: SizedBox(
          //                 height: MediaQuery.of(context).size.height / 2,
          //                 child: PageView.builder(
          //                   controller: famePageController,
          //                   pageSnapping: true,
          //                   scrollDirection: Axis.horizontal,
          //                   allowImplicitScrolling: true,
          //                   itemCount: list.length,
          //                   itemBuilder: (horizontalContext, ind) {
          //                     Gallery mediaModelData = list[ind];
          //                     return Stack(
          //                       alignment: Alignment.center,
          //                       children: [
          //                         !mediaModelData.file!.contains(".mp4")
          //                             ? CachedNetworkImage(
          //                                 imageUrl:
          //                                     "$path${mediaModelData.file!}",
          //                                 imageBuilder:
          //                                     (context, imageProvider) =>
          //                                         Container(
          //                                   decoration: BoxDecoration(
          //                                     borderRadius: BorderRadius.all(
          //                                         Radius.circular(
          //                                             ScreenUtil().setSp(8))),
          //                                     image: DecorationImage(
          //                                         image: imageProvider,
          //                                         fit: BoxFit.fitWidth),
          //                                   ),
          //                                 ),
          //                               )
          //                             : GestureDetector(
          //                                 onLongPressUp: () {
          //                                   setStates(() {
          //                                     isOnPageHorizontalTurning = false;
          //                                   });
          //                                 },
          //                                 onLongPress: () {
          //                                   setStates(() {
          //                                     isOnPageHorizontalTurning = true;
          //                                   });
          //                                 },
          //                                 onTap: () {
          //                                   /*setStates(() {
          //                                 isDialOpen.value = false;
          //                                 if (visibilityTag) {
          //                                   visibilityTag = false;
          //                                 }
          //                                 hideShowTag = !hideShowTag;
          //                               });*/
          //                                 },
          //                                 child: VideoPlayerScreen(
          //                                     mediaModelData.file!,
          //                                     path,
          //                                     ind,
          //                                     currentHorizontal,
          //                                     0,
          //                                     0,
          //                                     true,
          //                                     videoController,
          //                                     isOnPageHorizontalTurning),
          //                               ),
          //                       ],
          //                     );
          //                   },
          //                   onPageChanged: (value) async {
          //                     setStates(() {
          //                       popUpPageController = PageController(
          //                           keepPage: true, initialPage: value);
          //                     });
          //                   },
          //                 ),
          //               ),
          //             ),
          //
          //             // Positioned(
          //             //     top: 8,
          //             //     right: 10,
          //             //     child: GestureDetector(
          //             //   onTap: (){
          //             //     Get.back();
          //             //   },
          //             //     child: Container(
          //             //     decoration: const BoxDecoration(
          //             //       shape: BoxShape.circle,
          //             //     ),
          //             //     child: const Icon(Icons.cancel, color: black, size: 30,),),)),
          //           ],
          //         ),
          //         const Spacer(),
          //         Align(
          //           child: Padding(
          //             padding: const EdgeInsets.only(bottom: 10),
          //             child: SmoothPageIndicator(
          //               controller: popUpPageController!,
          //               count: list.length,
          //               axisDirection: Axis.horizontal,
          //               effect: const SlideEffect(
          //                   spacing: 10.0,
          //                   radius: 3.0,
          //                   dotWidth: 6.0,
          //                   dotHeight: 6.0,
          //                   paintStyle: PaintingStyle.stroke,
          //                   strokeWidth: 1.5,
          //                   dotColor: white,
          //                   activeDotColor: lightRed),
          //             ),
          //           ),
          //           alignment: Alignment(0, 1),
          //         ),
          //       ],
          //     );
          //   },
          // ),
        );
      });
}

muddaVideoDialog(
    BuildContext context, List<Gallery> list, String path, int index) {
  VideoController videoController = VideoController();
  PageController? popUpPageController;
  popUpPageController = PageController(keepPage: true, initialPage: index);
  bool isOnPageHorizontalTurning = false;
  int currentHorizontal = list[index].file!.contains(".mp4") ? index : 0;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 4,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.only(
              top: ScreenUtil().setSp((ScreenUtil().screenHeight / 3) / 2),
              bottom: ScreenUtil().setSp((ScreenUtil().screenHeight / 3) / 2),
              left: ScreenUtil().setWidth(26),
              right: ScreenUtil().setWidth(26)),
          // insetPadding: EdgeInsets.only(
          //     top: ScreenUtil().setSp(
          //         (ScreenUtil().screenHeight - ScreenUtil().setSp(480)) / 2),
          //     bottom: ScreenUtil().setSp(
          //         (ScreenUtil().screenHeight - ScreenUtil().setSp(480)) / 2),
          //     left: ScreenUtil().setSp(
          //         (ScreenUtil().screenWidth - ScreenUtil().setSp(330)) / 2),
          //     right: ScreenUtil().setSp(
          //         (ScreenUtil().screenWidth - ScreenUtil().setSp(330)) / 2)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              PageController famePageController;
              famePageController =
                  PageController(keepPage: true, initialPage: index);
              famePageController.addListener(() {
                if (isOnPageHorizontalTurning &&
                    famePageController.page ==
                        famePageController.page!.roundToDouble()) {
                  setStates(() {
                    currentHorizontal = famePageController.page!.toInt();
                    isOnPageHorizontalTurning = false;
                  });
                } else if (!isOnPageHorizontalTurning &&
                    currentHorizontal.toDouble() != famePageController.page) {
                  if ((currentHorizontal.toDouble() - famePageController.page!)
                          .abs() >
                      0.1) {
                    setStates(() {
                      isOnPageHorizontalTurning = true;
                    });
                  }
                }
              });
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setSp(16)))),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: PageView.builder(
                        controller: famePageController,
                        pageSnapping: true,
                        scrollDirection: Axis.horizontal,
                        allowImplicitScrolling: true,
                        itemCount: list.length,
                        itemBuilder: (horizontalContext, ind) {
                          Gallery mediaModelData = list[ind];
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              !mediaModelData.file!.contains(".mp4")
                                  ? CachedNetworkImage(
                                      imageUrl: "$path${mediaModelData.file!}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setSp(8))),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onLongPressUp: () {
                                        setStates(() {
                                          isOnPageHorizontalTurning = false;
                                        });
                                      },
                                      onLongPress: () {
                                        setStates(() {
                                          isOnPageHorizontalTurning = true;
                                        });
                                      },
                                      onTap: () {
                                        /*setStates(() {
                                        isDialOpen.value = false;
                                        if (visibilityTag) {
                                          visibilityTag = false;
                                        }
                                        hideShowTag = !hideShowTag;
                                      });*/
                                      },
                                      child: VideoPlayerScreen(
                                          mediaModelData.file!,
                                          path,
                                          ind,
                                          currentHorizontal,
                                          0,
                                          0,
                                          true,
                                          videoController,
                                          isOnPageHorizontalTurning),
                                    ),
                            ],
                          );
                        },
                        onPageChanged: (value) async {
                          setStates(() {
                            popUpPageController = PageController(
                                keepPage: true, initialPage: value);
                          });
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SmoothPageIndicator(
                        controller: popUpPageController!,
                        count: list.length,
                        axisDirection: Axis.horizontal,
                        effect: const SlideEffect(
                            spacing: 10.0,
                            radius: 3.0,
                            dotWidth: 6.0,
                            dotHeight: 6.0,
                            paintStyle: PaintingStyle.stroke,
                            strokeWidth: 1.5,
                            dotColor: Colors.white,
                            activeDotColor: lightRed),
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                ],
              );
            },
          ),
        );
      });
}
