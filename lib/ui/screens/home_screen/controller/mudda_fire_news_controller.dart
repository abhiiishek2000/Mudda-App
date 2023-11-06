import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/local/DatabaseProvider.dart';
import 'package:mudda/model/CategoryListModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/PlaceModel.dart';
import 'package:mudda/model/PostForMuddaModel.dart';
import 'package:mudda/model/RepliesResponseModel.dart';
import 'package:mudda/model/UserProfileModel.dart';
import 'package:mudda/model/UserRolesModel.dart';
import 'package:mudda/ui/shared/AdHelper.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mudda/ui/shared/create_dynamic_link.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:video_trimmer/video_trimmer.dart';
import '../../../../core/preferences/preference_manager.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../dio/api/api.dart';
import '../../../../model/MuddaDetails.dart';
import '../../../../model/QuotePostModel.dart';
import '../../../../model/UserSuggestionsModel.dart';
import '../../profile_screen/controller/profile_controller.dart';

class MuddaNewsController extends GetxController
    with GetTickerProviderStateMixin {
  final Trimmer trimmer = Trimmer();
  final GlobalKey globalKeyOne = GlobalKey();
  final GlobalKey globalKeyTwo = GlobalKey();
  final GlobalKey globalKeyThree = GlobalKey();
  final GlobalKey globalKeyFour = GlobalKey();
  late AnimationController animationController;
  late Animation<double> animation;
  final GlobalKey globalKeyFive = GlobalKey();
  RxBool muddaDescripation = false.obs;
  final muddaScrollController = ScrollController();
  final homeScrollController = ScrollController();
  final AppPreference _appPreference = AppPreference();
  final profileController = Get.put(ProfileController());
  RxBool muddaAction = true.obs;
  RxBool isLoading = false.obs;
  RxString muddaId = ''.obs;
  RxString muddaTitle = ''.obs;
  RxDouble dragPosition = 0.0.obs;
  RxInt currentHotMuddaIndex = 0.obs;
  RxBool isFront = true.obs;

  RxBool isFromOtherProfile = false.obs;
  RxBool isDismissWalkthrough = false.obs;
  RxBool isDismissActionTask = false.obs;
  RxBool isOpenForm = false.obs;
  RxBool isSupport = false.obs;
  RxBool isPlusIcon = false.obs;
  RxBool isLiked = false.obs;
  RxBool isReplied = false.obs;
  RxBool isClickedPlusIcon = false.obs;
  RxBool isFromNotification = false.obs;
  RxInt notificationIndex = 0.obs;
  RxBool isMuddaLoading = false.obs;
  RxBool isNotiAvailaable = false.obs;
  RxBool isRemind = false.obs;
  RxBool isHotMuddaLoading = false.obs;
  RxString inviteType = ''.obs;
  RxBool isShowArrowDown = false.obs;
  RxBool isSupportedMuddaLoading = false.obs;
  RxBool isFollowingMuddaLoading = false.obs;
  RxBool isFetchNewPost = false.obs;
  RxBool isPaginateTop = false.obs;
  RxBool isPaginateBottom = false.obs;
  RxInt unapprovedMuddaCount = 0.obs;
  RxInt pIndex = 0.obs;
  RxInt currentMuddaIndex = 0.obs;
  RxBool isUploadingPost = false.obs;
  RxBool isUploadFailed = false.obs;
  RxBool isUploadSuccess = false.obs;
  RxBool showFab = true.obs;
  RxBool visible = false.obs;
  RxString test = 'ok'.obs;
  RxBool isPaginate = true.obs;
  RxInt pageIndex = 0.obs;
  RxBool isRepliesShow = false.obs;
  RxBool isRecentRepliesShow = false.obs;
  RxBool isRepliesShowInSeeAll = false.obs;
  RxDouble height = 0.0.obs;
  RxDouble width = 0.0.obs;
  bool muddaUpdate = true;
  bool loadMore = false;
  RxInt muddaActionIndex = 0.obs;
  RxString initialScope = ''.obs;
  RxInt isSelectComment = 0.obs;
  RxInt isSelectRole = 0.obs;
  RxInt currentIndex = 0.obs;
  RxInt currentRecentIndex = 0.obs;
  RxString muddaProfilePath = ''.obs;
  RxString muddaUserProfilePath = ''.obs;
  RxString postForMuddaPath = ''.obs;
  RxString postForMuddaUserPath = ''.obs;
  var postForMuddaTotalUsers;
  var postForMuddaContainerUsers;
  var postForMuddaMuddaThumbnail;
  var postForMuddaMuddaTitle;
  var postForMuddaMuddaOwner;
  var postForMuddaMuddaFavour;
  var postForMuddaMuddaOpposition;
  var postForMuddaJoinRequestsAdmin;
  var postForMuddapostTotalNewPost;
  var postForMuddapostApprovalsAdmin;
  TabController? commentController;
  TabController? muddaRepliesController;
  late TabController tabController;
  double? agreePercentage;
  double favourPercentage = 0.0;
  int disAgreeStatus = 0;
  int agreeStatus = 0;
  double oppositionPercentage = 0.0;
  double? disagreePercentage;
  RxString postIn = 'favour'.obs;
  RxString quotePostType = 'quote'.obs;
  RxString selectedFavourRole = '1'.obs;
  RxString selectedOppositionRole = '1'.obs;
  RxBool postAnynymous = false.obs;
  RxBool isShowGuide = false.obs;
  RxBool isActionTaskShown = false.obs;
  RxString descriptionValue = ''.obs;
  RxString titleValue = ''.obs;
  RxInt replies = 0.obs;
  RxString comment = ''.obs;
  RxList<String> uploadPhotoVideos = List<String>.from([""]).obs;
  RxBool selectedWorld = false.obs;
  RxList<int> selectedLocation = List<int>.from([]).obs;
  RxInt selectedMuddaFilter = 2.obs;
  RxList<int> selectedCategory = List<int>.from([]).obs;
  RxList<int> selectedGender = List<int>.from([]).obs;
  RxList<int> selectedAge = List<int>.from([]).obs;
  RxInt leaderBoardIndex = 0.obs;
  RxInt followerIndex = 0.obs;
  RxInt updateIndex = 0.obs;
  RxInt postForMuddaIndex = 0.obs;
  RxString selectDistrict = ''.obs;
  RxString selectState = ''.obs;
  RxString selectCountry = ''.obs;
  RxString muddaShareLink = ''.obs;
  RxString selectJoinFavour = 'Join Normal'.obs;
  RxList<String> districtList = List<String>.from([]).obs;
  RxList<Place> stateList = List<Place>.from([]).obs;

  RxList<Place> stateListOne = List<Place>.from([]).obs;
  RxList<Place> countryList = List<Place>.from([]).obs;
  RxList<String> categoryList = List<String>.from([]).obs;
  RxList<Category> quoteCategoryList = List<Category>.from([]).obs;
  Rx<MuddaPost> muddaPost = MuddaPost().obs;
  Rx<PostForMudda> repliesData = PostForMudda().obs;
  Rx<AcceptUserDetail> acceptUserDetail = AcceptUserDetail().obs;
  Rx<RepliesResponseModelResultUserDetail> repliesUserDetail =
      RepliesResponseModelResultUserDetail().obs;
  Rx<PostForMudda> postForMudda = PostForMudda().obs;
  Rx<Quote> quotesOrActivity = Quote().obs;
  Rx<Comments> commentDetails = Comments().obs;
  Rx<MuddaDetailsData> muddaDetails = MuddaDetailsData().obs;
  Rx<Role> selectedRole = Role().obs;
  RxBool isAdsLoaded = false.obs;
  RxBool isContainerAdsLoaded = false.obs;
  RxString roleProfilePath = ''.obs;
  RxList<MuddaPost> muddaPostList = List<MuddaPost>.from([]).obs;
  RxList<PostForMudda> repliesList = List<PostForMudda>.from([]).obs;
  RxList<MuddaPost> shareMuddaPostList = List<MuddaPost>.from([]).obs;
  RxList<MuddaPost> waitingMuddaPostList = List<MuddaPost>.from([]).obs;
  RxList<MuddaPost> unapproveMuddaList = List<MuddaPost>.from([]).obs;
  RxList<MuddaPost> supportMuddaPostList = List<MuddaPost>.from([]).obs;
  RxList<MuddaPost> followingMuddaPostList = List<MuddaPost>.from([]).obs;
  RxList<PostForMudda> postForMuddaList = List<PostForMudda>.from([]).obs;
  RxList<PostForMudda> seeAllRepliesList = List<PostForMudda>.from([]).obs;
  RxList<Comments> postForMuddaCommentsList = List<Comments>.from([]).obs;
  RxList<Role> roleList = List<Role>.from([]).obs;
  RxList<Role> uploadRoleList = List<Role>.from([]).obs;
  RxList<Role> uploadQuoteRoleList = List<Role>.from([]).obs;
  RxList<Role> commentRoleList = List<Role>.from([]).obs;
  Rx<PostForMuddaModel> postMudda = PostForMuddaModel().obs;

  List<String> ageList = [
    "18-25",
    "25-40",
    "40-60",
    "60+",
    // "All",
  ];

  List<String> genderList = [
    "Male",
    "Female",
    // "All",
  ];

  List<String> locationList = [
    "Your District",
    "Your State",
    "Your Country",
    "World",
  ];
  List<FilterList> muddaFilterList = [
    FilterList(AppIcons.follower, "Following"),
    FilterList(AppIcons.supported, "Supporting"),
  ];

  List<String> apiLocationList = [
    "district",
    "state",
    "country",
    "world",
  ];


  @override
  void onInit() {
    super.onInit();
    commentController = TabController(vsync: this, length: 2);
    muddaRepliesController = TabController(length: 2, vsync: this);
    // stateList.sort((a,b)=>a.state!.compareTo(b.state!));
    tabController = TabController(
      length: 3,
      vsync: this,
    );

    tabController.addListener(() {
      print("muddaNewsController.tabController.index${tabController.index}");
      if (tabController.index == 2) {
        isFromOtherProfile.value = false;
        unapproveMuddaList.clear();
        isFromOtherProfile.value = false;
        isFromNotification.value = false;
        Api.get.call(Get.context as BuildContext,
            method: "mudda/my-engagement",
            param: {
              "page": "1",
              "isVerify": "0",
              "user_id": AppPreference().getString(PreferencesKey.userId)
            },
            isLoading: false, onResponseSuccess: (Map object) {
          waitingMuddaPostList.clear();
          var result = MuddaPostModel.fromJson(object);
          isNotiAvailaable.value = result.notifications ?? false;
          if (result.data!.isNotEmpty) {
            muddaProfilePath.value = result.path!;
            muddaUserProfilePath.value = result.userpath!;
            waitingMuddaPostList.addAll(result.data!);
          }
        });
      } else if (tabController.index == 1) {
        getProfile();
        // profileController.isLoading.value = true;
        // Api.get.call(Get.context as BuildContext,
        //     method: "quote-or-activity/index",
        //     param: {"page": "1"},
        //     isLoading: false, onResponseSuccess: (Map object) {
        //       profileController.isLoading.value = false;
        //       var result = QuotePostModel.fromJson(object);
        //       if (result.data!.isNotEmpty) {
        //         profileController.quotePostList.clear();
        //         profileController.quotePostPath.value = result.path!;
        //         profileController.quoteProfilePath.value = result.userpath!;
        //         profileController.quotePostList.addAll(result.data!);
        //       } else {
        //       }
        //     });
        // isSupportedMuddaLoading.value = true;
        // Api.get.call(Get.context as BuildContext,
        //     method: "mudda/my-engagement",
        //     param: {
        //       "page": "1",
        //       "filterType": "support",
        //       "user_id": AppPreference().getString(PreferencesKey.userId)
        //     },
        //     isLoading: false, onResponseSuccess: (Map object) {
        //   isSupportedMuddaLoading.value = false;
        //   var result = MuddaPostModel.fromJson(object);
        //   isNotiAvailaable.value = result.notifications ?? false;
        //   if (result.data!.isNotEmpty) {
        //     muddaProfilePath.value = result.path!;
        //     muddaUserProfilePath.value = result.userpath!;
        //     supportMuddaPostList.clear();
        //     supportMuddaPostList.addAll(result.data!);
        //   } else {
        //     isSupportedMuddaLoading.value = false;
        //   }
        // });
      } else if (tabController.index == 2) {
        isFollowingMuddaLoading.value = true;
        // Api.get.call(Get.context as BuildContext,
        //     method: "mudda/my-engagement",
        //     param: {
        //       "page": "1",
        //       "filterType": "follow",
        //       "user_id": AppPreference().getString(PreferencesKey.userId)
        //     },
        //     isLoading: false, onResponseSuccess: (Map object) {
        //   var result = MuddaPostModel.fromJson(object);
        //   isNotiAvailaable.value = result.notifications ?? false;
        //   isFollowingMuddaLoading.value = false;
        //   if (result.data!.isNotEmpty) {
        //     muddaProfilePath.value = result.path!;
        //     muddaUserProfilePath.value = result.userpath!;
        //     followingMuddaPostList.clear();
        //     followingMuddaPostList.addAll(result.data!);
        //   } else {
        //     isFollowingMuddaLoading.value = false;
        //   }
        // });
      }
    });
  }

  //TODO: CALCULATE AGREE % & DISAGREE %
  void calAgreeDisAgreePercentage() {
    int totalVote = postForMuddaMuddaFavour['totalAgree'] +
        postForMuddaMuddaFavour['totalDisagree'] +
        postForMuddaMuddaOpposition['totalAgree'] +
        postForMuddaMuddaOpposition['totalDisagree'];
    agreePercentage = (((postForMuddaMuddaFavour['totalAgree'] +
                postForMuddaMuddaOpposition['totalDisagree']) /
            totalVote) *
        100);
    disagreePercentage = (((postForMuddaMuddaFavour['totalDisagree'] +
                postForMuddaMuddaOpposition['totalAgree']) /
            totalVote) *
        100);
    agreeStatus = postForMuddaMuddaFavour['totalAgree'] -
        postForMuddaMuddaFavour['totalDisagree'];
    disAgreeStatus = postForMuddaMuddaOpposition['totalAgree'] -
        postForMuddaMuddaOpposition['totalDisagree'];
  }

  // TODO: CALCULATE FAVOUR PERCENTAGE
  void calFavourOppositionPercentage() {
    int totalFavVote = postForMuddaMuddaFavour['totalAgree'] +
        postForMuddaMuddaFavour['totalDisagree'];
    int totalOpVote = postForMuddaMuddaOpposition['totalAgree'] +
        postForMuddaMuddaOpposition['totalDisagree'];
    favourPercentage =
        ((postForMuddaMuddaFavour['totalAgree'] / totalFavVote) * 100);
    oppositionPercentage =
        ((postForMuddaMuddaOpposition['totalAgree'] / totalOpVote) * 100);
  }

  void updateData() {
    muddaUpdate = !muddaUpdate;
    update();
  }

  // TODO: UPLOAD MUDDA POST

  void uploadMuddaPost(dio.FormData formData) {
    muddaScrollController
        .animateTo(muddaScrollController.position.minScrollExtent,
            duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn)
        .then((value) => {upLoadFunction(formData)});
  }

  void upLoadFunction(dio.FormData formData) {
    try {
      postForMuddaList.insert(
          0, PostForMudda(isUploading: true, postIn: postIn.value));
      Api.uploadPost.call(Get.context!,
          method: "post-for-mudda/store",
          param: formData,
          isLoading: false, onResponseSuccess: (Map object) {
        isUploadSuccess.value = true;
        postForMuddaList.removeAt(0);
        var snackBar = const SnackBar(
          content: Text('Uploaded'),
        );
        ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
        postForMuddaList.insert(0, PostForMudda.fromJson(object['data']));
      });
    } catch (e) {
      var snackBar = const SnackBar(
        content: Text('Uploading failed'),
      );
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
      isUploadFailed.value = true;
      postForMuddaList.removeAt(0);
    }
  }

  void updateMuddaIndex(int index) {
    currentMuddaIndex.value = index;
    String? id = postForMuddaList.elementAt(index).sId;
    print('======>$id');
    // DBProvider.db.addMuddaPostId(muddaId: , id: id)
  }

  void fetchRecentPost(String? muddaId) async {
    isMuddaLoading.value = true;
    Api.get.call(Get.context!,
        method: "post-for-mudda/index",
        param: {
          "mudda_id": muddaId ?? muddaPost.value.sId,
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "page": '1',
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = PostForMuddaModel.fromJson(object);

      if (result.data!.isNotEmpty) {
        isPaginate.value = true;
        postForMuddaPath.value = result.path!;
        postForMuddaUserPath.value = result.userpath!;
        postForMuddaTotalUsers = result.totalUsers!;
        postForMuddaContainerUsers = result.containerUsers!;
        postForMuddaMuddaThumbnail = result.muddaThumbnail!;
        postForMuddaMuddaTitle = result.muddaThumbnail!;
        postForMuddaMuddaOwner = result.muddaOwner!;
        postForMuddaMuddaFavour = result.favour!;
        postForMuddaMuddaOpposition = result.opposition!;
        postForMuddaJoinRequestsAdmin = result.joinRequests!;
        postForMuddapostApprovalsAdmin = result.postApprovals!;
        postForMuddapostTotalNewPost = result.totalNewPosts!;
        postForMuddaList.clear();
        isMuddaLoading.value = false;
        postForMuddaList.addAll(result.data!);
        calAgreeDisAgreePercentage();
        calFavourOppositionPercentage();
        CreateMyDynamicLinksClass()
            .createDynamicLink(true, '/muddaDetailsScreen?id=$muddaId')
            .then((value) => muddaShareLink = '$value' as RxString);
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

      } else {
        agreeStatus = 0;
        disAgreeStatus = 0;
        disagreePercentage = 0.0;
        agreePercentage = 0.0;
        postForMuddaTotalUsers = null;
        postForMuddaContainerUsers = null;
        isMuddaLoading.value = false;
      }
    });
  }

  void fetchNewPost() async {
    muddaScrollController
        .animateTo(muddaScrollController.position.minScrollExtent,
            duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn)
        .then((value) => {
              isFetchNewPost.value = true,
              isMuddaLoading.value = true,
              Api.get.call(Get.context!,
                  method: "post-for-mudda/index",
                  param: {
                    "mudda_id": muddaPost.value.sId,
                    "user_id": AppPreference().getString(PreferencesKey.userId),
                    "page": '1',
                  },
                  isLoading: false, onResponseSuccess: (Map object) {
                var result = PostForMuddaModel.fromJson(object);

                if (result.data!.isNotEmpty) {
                  isPaginate.value = true;
                  postForMuddaPath.value = result.path!;
                  postForMuddaUserPath.value = result.userpath!;
                  postForMuddaTotalUsers = result.totalUsers!;
                  postForMuddaContainerUsers = result.containerUsers!;
                  postForMuddaMuddaThumbnail = result.muddaThumbnail!;
                  postForMuddaMuddaOwner = result.muddaOwner!;
                  postForMuddaMuddaFavour = result.favour!;
                  postForMuddaMuddaOpposition = result.opposition!;
                  postForMuddaJoinRequestsAdmin = result.joinRequests!;
                  postForMuddapostApprovalsAdmin = result.postApprovals!;
                  postForMuddapostTotalNewPost = result.totalNewPosts!;
                  postForMuddaList.clear();
                  isFetchNewPost.value = false;
                  isMuddaLoading.value = false;
                  postForMuddaList.addAll(result.data!);
                  calAgreeDisAgreePercentage();
                  calFavourOppositionPercentage();

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

                } else {
                  agreeStatus = 0;
                  disAgreeStatus = 0;
                  disagreePercentage = 0.0;
                  agreePercentage = 0.0;
                  postForMuddaTotalUsers = null;
                  postForMuddaContainerUsers = null;
                }
              })
            });
  }

  void change() {
    isNotiAvailaable.value = true;
    update();
  }

  void showUserGuide(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(context).startShowCase(
            [globalKeyOne, globalKeyTwo, globalKeyFive, globalKeyFour]));
  }

  void fetchUnapproveMudda(BuildContext context, String muddaId) {
    Api.get.call(context,
        method: "mudda/mudda_byId",
        param: {"_id": muddaId},
        isLoading: false, onResponseSuccess: (Map object) {
      var result = MuddaPostModel.fromJson(object);
      if (result.data!.isNotEmpty) {
        unapproveMuddaList.clear();
        muddaProfilePath.value = result.path!;
        muddaUserProfilePath.value = result.userpath!;
        unapproveMuddaList.addAll(result.data!);
      }
    });
  }

  void dismissWalkthrough() {
    AppPreference _appPreference = AppPreference();
    _appPreference.setBool(PreferencesKey.firstTimeUser, false);
    isDismissWalkthrough.value = true;
  }
  void dismissActionTask() {
    AppPreference _appPreference = AppPreference();
    _appPreference.setBool(PreferencesKey.dismissActionTask, true);
    isDismissActionTask.value = true;
  }
  void support() {
    _appPreference.setBool(PreferencesKey.isSupport, true);
    isSupport.value = true;
    changeCountStatus();
  }


  void openForm() {
    _appPreference.setBool(PreferencesKey.isOpenForm, true);
    isOpenForm.value = true;
    changeCountStatus();
  }

  void clickPlusIcon() {
    _appPreference.setBool(PreferencesKey.isPlusIcon, true);
    isPlusIcon.value = true;
    changeCountStatus();
  }
  void agreeDisagreePost() {
    _appPreference.setBool(PreferencesKey.isLiked, true);
    isLiked.value = true;
    changeStatusActionTask();
  }


  void repliedPost() {
    _appPreference.setBool(PreferencesKey.isReplied, true);
    isReplied.value = true;
    changeStatusActionTask();
  }

  void clickPlusIconForum() {
    _appPreference.setBool(PreferencesKey.isClickedPlusIcon, true);
    isClickedPlusIcon.value = true;
    changeStatusActionTask();
  }
  void changeCountStatus() {
    // String countString = _appPreference.getString(PreferencesKey.actionCount);
    // int count = int.parse(countString);
    if(AppPreference().getBool(PreferencesKey.isSupport) &&  AppPreference().getBool(PreferencesKey.isOpenForm) &&  AppPreference().getBool(PreferencesKey.isPlusIcon)){
      dismissWalkthrough();
      isDismissWalkthrough.value = true;
    } else if(!AppPreference().getBool(PreferencesKey.firstTimeUser)){
      isDismissWalkthrough.value = true;
    } else {
      isDismissWalkthrough.value = false;
      isPlusIcon.value = false;
      isOpenForm.value = false;
      isSupport.value = false;
    }

  }
  void changeStatusActionTask() {
    // String countString = _appPreference.getString(PreferencesKey.actionCount);
    // int count = int.parse(countString);
    if(AppPreference().getBool(PreferencesKey.isLiked) &&  AppPreference().getBool(PreferencesKey.isReplied) &&  AppPreference().getBool(PreferencesKey.isClickedPlusIcon)){
      dismissActionTask();
      isDismissActionTask.value = true;
    }  else if(AppPreference().getBool(PreferencesKey.dismissActionTask)){
      isDismissActionTask.value = true;
    }else {
      isDismissActionTask.value = false;
      isLiked.value = false;
      isReplied.value = false;
      isClickedPlusIcon.value = false;
    }

  }
  getProfile() {
    Api.get.call(Get.context as BuildContext,
        method: "user/${AppPreference().getString(PreferencesKey.userId)}",
        param: {
          "_id": AppPreference().getString(PreferencesKey.userId),
        },
        isLoading: false, onResponseSuccess: (Map object) {
          log("-=-=- object $object");
          var result = UserProfileModel.fromJson(object);
          AppPreference().setString(PreferencesKey.countFollowing,
              result.data!.countFollowing.toString());
          profileController.countFollowing.value =
              result.data!.countFollowing.toString();
          if (result.data!.countFollowing == 0) {

          }
        });
  }

  @override
  void onClose() {
    trimmer.dispose();
    uploadPhotoVideos.clear();
    super.onClose();
  }
}

class FilterList{
  FilterList(this.icon,this.title);
  String icon;
  String title;
}