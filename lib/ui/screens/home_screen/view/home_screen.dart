import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/size_config.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/CategoryListModel.dart';
import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/PlaceModel.dart';
import 'package:mudda/model/QuotePostModel.dart';
import 'package:mudda/model/UserRolesModel.dart';
import 'package:mudda/model/UserSetting.dart';
import 'package:mudda/ui/screens/circle_chat/services/services.dart';
import 'package:mudda/ui/screens/edit_profile/controller/user_profile_update_controller.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/home_screen/widget/component/hot_mudda_post.dart';
import 'package:mudda/ui/screens/home_screen/widget/following_mudda.dart';
import 'package:mudda/ui/screens/home_screen/widget/muddaunderapproval.dart';
import 'package:mudda/ui/screens/home_screen/widget/hot_mudda.dart';
import 'package:mudda/ui/screens/home_screen/widget/support_mudda.dart';
import 'package:mudda/ui/screens/home_screen/widget/tab_screens/search_screen/search_screen.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:showcaseview/showcaseview.dart';

// import 'package:uni_links/uni_links.dart';
import '../../../../core/local/DatabaseProvider.dart';
import '../../../../model/RecentDataModel.dart';
import '../../../shared/home_app_bar_actions.dart';
import '../../muddabuzz_screen/view/mudda_buzz_feed.dart';
import '../../other_user_profile/controller/ChatController.dart';
import '../../profile_screen/controller/profile_controller.dart';
import '../../splash_screen/controller/splash_controller.dart';
import '../widget/show_case_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
        builder: Builder(builder: (context) => const StageHome()));
  }
}

class StageHome extends StatefulWidget {
  const StageHome({Key? key}) : super(key: key);

  @override
  _StageHomeState createState() => _StageHomeState();
}

class _StageHomeState extends State<StageHome> with TickerProviderStateMixin {
  late TabController tabController2;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  double tabIconHeight = 20;
  double tabIconWidth = 30;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  MuddaNewsController muddaNewsController = Get.put(MuddaNewsController());
  ProfileController profileController = Get.put(ProfileController());
  ChatController chatController = Get.put(ChatController());
  ChatService chatService = Get.put(ChatService());
  int rolePage = 1;
  ScrollController roleController = ScrollController();
  UserProfileUpdateController? userProfileUpdateController;
  DateTime? currentBackPressTime;

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {});
      AppUpdateInfo _updateInfo = info;
      if (_updateInfo != null &&
          _updateInfo.updateAvailability ==
              UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate()
            .catchError((e) => showSnack(e.toString()));
      }
    }).catchError((e) {
      // showSnack(e.toString());
    });
  }

  @override
  void initState() {
    print('m in');
    super.initState();
    checkForUpdate();
    // ignore: unused_local_variable

    FirebaseAnalytics.instance.logEvent(name: "home_screen");

//  FirebaseAnalytics().setCurrentScreen(screenName: 'Example1');

    userProfileUpdateController = Get.find<UserProfileUpdateController>();
    tabController2 = TabController(length: 1, vsync: this, initialIndex: 0);

    tabController2.addListener(() {
      if (tabController2.index == 1) {
        muddaNewsController.isHotMuddaLoading.value = true;
        Api.get.call(context,
            method: "mudda/index",
            param: {
              "user_id": AppPreference().getString(PreferencesKey.userId)
            },
            isLoading: true, onResponseSuccess: (Map object) {
          var result = MuddaPostModel.fromJson(object);
          muddaNewsController.isNotiAvailaable.value =
              result.notifications ?? false;
          muddaNewsController.isHotMuddaLoading.value = false;
          if (result.data!.isNotEmpty) {
            muddaNewsController.muddaProfilePath.value = result.path!;
            muddaNewsController.muddaUserProfilePath.value = result.userpath!;
            muddaNewsController.muddaPostList.clear();
            muddaNewsController.muddaPostList.addAll(result.data!);
          } else {
            muddaNewsController.isHotMuddaLoading.value = false;
          }
        });
      }
    });

    muddaNewsController.isHotMuddaLoading.value = true;
    Api.get.call(context,
        method: "mudda/index",
        param: {"user_id": AppPreference().getString(PreferencesKey.userId)},
        isLoading: false, onResponseSuccess: (Map object) {
      var result = MuddaPostModel.fromJson(object);
      muddaNewsController.isNotiAvailaable.value =
          result.notifications ?? false;
      muddaNewsController.isHotMuddaLoading.value = false;
      if (result.data!.isNotEmpty) {
        muddaNewsController.muddaProfilePath.value = result.path!;
        muddaNewsController.muddaUserProfilePath.value = result.userpath!;
        muddaNewsController.muddaPostList.clear();
        muddaNewsController.muddaPostList.addAll(result.data!);
        // muddaNewsController.muddaPostList.forEach((element) async{
        //
        //   log('========ok0');
        //
        //   List<RecentDataOffline> temp = await DBProvider.db.getRecentData("${element.sId}");
        //
        //   double inDebate=0.0;
        //
        //   if(temp.isEmpty || temp.length==0){
        //
        //     log('========ok1');
        //
        //     int totalVote = element.favour['totalAgree'] + element.favour['totalDisagree'] + element.opposition['totalAgree'] + element.opposition['totalDisagree'];
        //     double agreePercentage = (((element.favour['totalAgree'] + element.opposition['totalDisagree'])/totalVote)*100);
        //     double disagreePercentage = (((element.favour['totalDisagree'] + element.opposition['totalAgree'])/totalVote)*100);
        //     inDebate = agreePercentage - disagreePercentage;
        //     DBProvider.db.addRecentData(muddaId: element.sId!, leadersCount: "${element.leadersCount}", totalPost: "${element.totalPost}", support: "${element.support}", inDebate: inDebate.toStringAsFixed(2));
        //
        //   }else{
        //
        //     log('========ok2');
        //
        //     double supportDiff =  ((element.support)!  - int.parse("${temp[0].support}") / int.parse("${temp[0].support}")) * 100;
        //     int newLeaderDiff = (element.leadersCount)! - int.parse("${temp[0].leadersCount}");
        //     int newTotalPostDiff = (element.totalPost)! - int.parse("${temp[0].totalPost}");
        //     double inDebateDiff = inDebate - double.parse("${temp[0].inDebate}");
        //     MuddaPost muddaPost = element;
        //     muddaPost.supportDiff= supportDiff;
        //     muddaPost.newLeaderDiff= newLeaderDiff;
        //     muddaPost.newPostDiff = newTotalPostDiff;
        //     muddaPost.inDebte= inDebateDiff;
        //     muddaNewsController.muddaPostList.add(muddaPost);
        //   }
        // });

      } else {
        muddaNewsController.isHotMuddaLoading.value = false;
      }
      _getRoles(context);
    });

    if (muddaNewsController.isShowGuide.value == true) {
      // muddaNewsController.showUserGuide(context);
      // muddaNewsController.isShowGuide.value = false;
      AppPreference().setBool(PreferencesKey.firstTimeUser, true);
      AppPreference().setBool(PreferencesKey.isOpenForm, false);
      AppPreference().setBool(PreferencesKey.isSupport, false);
      AppPreference().setBool(PreferencesKey.isPlusIcon, false);
      AppPreference().setBool(PreferencesKey.isLiked, false);
      AppPreference().setBool(PreferencesKey.isReplied, false);
      AppPreference().setBool(PreferencesKey.isClickedPlusIcon, false);
      AppPreference().setBool(PreferencesKey.dismissActionTask, false);
      muddaNewsController.isShowGuide.value = false;
    }
    muddaNewsController.changeCountStatus();
    muddaNewsController.changeStatusActionTask();
    chatService.isNewMessageAvailable(context, chatController);
    roleController.addListener(() {
      if (roleController.position.maxScrollExtent ==
          roleController.position.pixels) {
        rolePage++;
        _getRoles(context);
      }
    });
  }

  Future<bool> onWillPop() {
    if (muddaNewsController.tabController.index == 0) {
      DateTime now = DateTime.now();
      print(muddaNewsController.tabController.index.toString());
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "press exit again");
        return Future.value(false);
      }
      return Future.value(true);
    } else {
      muddaNewsController.tabController.index = 0;
      return Future.value(false);
    }
  }

  @override
  void dispose() {
    // muddaNewsController.globalKeyFour.currentState!.dispose();
    // muddaNewsController.globalKeyOne.currentState!.dispose();
    // muddaNewsController.globalKeyThree.currentState!.dispose();
    // muddaNewsController.globalKeyFour.currentState!.dispose();
    // muddaNewsController.globalKeyFive.currentState!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorAppBackground,
      resizeToAvoidBottomInset: false,
      // ShowCaseView(
//         globalKey: muddaNewsController.globalKeyFour,
//         title: 'To create your own Mudda',
//         title: 'To create your own Mudda',
//         description: 'Click on the Plus Icon',
      floatingActionButton: Obx(
        () => AnimatedSlide(
          offset: muddaNewsController.showFab.value
              ? Offset.zero
              : const Offset(0, 2),
          child: FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: () {
              if (AppPreference().getBool(PreferencesKey.isGuest)) {
                updateProfileDialog(context);
              } else if (muddaNewsController.tabController.index == 1) {
                Get.toNamed(RouteConstants.uploadQuoteActivityScreen);
              } else {
                muddaNewsController.clickPlusIcon();
                muddaNewsController.muddaPost.value = MuddaPost();
                Get.toNamed(RouteConstants.raisingMudda);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0XFFf89f27),
                    Color(0XFFf4e2b4),
                    Color(0XFFf89f27),
                  ],
                ),
              ),
              child: const Icon(
                CupertinoIcons.add,
                size: 46,
              ),
            ),
          ),
          duration: const Duration(milliseconds: 300),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorAppBackground,
        elevation: 0,
        leading: Obx(() => GestureDetector(
              onTap: () {
                Get.toNamed(RouteConstants.notificationScreen);
              },
              child: Center(
                child: Container(
                    height: ScreenUtil().setHeight(25),
                    width: ScreenUtil().setHeight(23),
                    child: Stack(children: [
                      SvgPicture.asset(
                        AppIcons.bellIcon,
                        width: 19,
                        height: 19,
                        fit: BoxFit.fill,
                        color: blackGray,
                      ),
                      if (muddaNewsController.isNotiAvailaable.value)
                        Align(
                            alignment: Alignment.topRight,
                            child: Container(
                                height: 6,
                                width: 6,
                                decoration: const BoxDecoration(
                                    color: buttonBlue, shape: BoxShape.circle)))
                    ])),
              ),
            )),
        title: Obx(() => GestureDetector(
              onTap: () {
                if (muddaNewsController.tabController.index == 1) {
                  profileController.scrollToTop();
                } else {
                  muddaNewsController.homeScrollController.animateTo(
                      //go to top of scroll
                      0, //scroll offset to go
                      duration: const Duration(milliseconds: 500),
                      //duration of scroll
                      curve: Curves.fastOutSlowIn //scroll type
                      );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: muddaNewsController.showFab.value ? 0 : 15,
                    child: muddaNewsController.tabController.index == 1
                        ? SvgPicture.asset(AppIcons.icMuddebazz,
                            height: ScreenUtil().setSp(15),
                            width: ScreenUtil().setSp(15),
                            color: const Color(0xff3e3e3e))
                        : SvgPicture.asset(AppIcons.fireIcon,
                            height: ScreenUtil().setSp(15),
                            width: ScreenUtil().setSp(15),
                            color: const Color(0xff3e3e3e)),
                  ),
                  SizedBox(width: muddaNewsController.showFab.value ? 0 : 6),
                  Tab(
                    icon: Text(
                        muddaNewsController.tabController.index == 1
                            ? "Muddebaaz"
                            : "Mudda",
                        style: tabController2.index == 1
                            ? size18_M_semiBold(textColor: colorDarkBlack)
                            : size18_M_semiBold(textColor: colorDarkBlack)),
                  ),
                ],
              ),
            )),
        actions: const [HomeAppBarActions()],
      ),
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(60),
      //   child: SafeArea(
      //     child: Column(
      //       mainAxisSize: MainAxisSize.max,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         SizedBox(
      //           height: ScreenUtil().setHeight(40),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Obx(() => GestureDetector(
      //                 onTap: () {
      //                   Get.toNamed(
      //                       RouteConstants.notificationScreen);
      //                 },
      //                 child: Container(
      //                     margin: const EdgeInsets.only(left: 16.0),
      //                     height: ScreenUtil().setHeight(25),
      //                     width: ScreenUtil().setHeight(23),
      //                     child: Stack(children: [
      //                       SvgPicture.asset(
      //                         AppIcons.bellIcon,
      //                         width: 26,
      //                         height: 26,
      //                         fit: BoxFit.fill,
      //                         color:blackGray
      //                       ),
      //                       if (muddaNewsController
      //                           .isNotiAvailaable.value)
      //                         Align(
      //                             alignment: Alignment.topRight,
      //                             child: Container(
      //                                 height: 6,
      //                                 width: 6,
      //                                 decoration: const BoxDecoration(
      //                                     color: buttonBlue,
      //                                     shape: BoxShape.circle)))
      //                     ])),
      //               )),
      //               const Spacer(),
      //               Expanded(
      //                 flex: 2,
      //                 child:
      //                     /*Tab(
      //                       icon: Row(
      //                         children: [
      //                           Text("",
      //                               style: tabController2.index == 0
      //                                   ? size18_M_semiBold(
      //                                       textColor: colorDarkBlack)
      //                                   : size15_M_semibold(
      //                                       textColor: colorDarkBlack)),
      //                           */ /*Hs(width: 8.w),
      //                           Image.asset(
      //                             AppIcons.micIcon,
      //                           )*/ /*
      //                         ],
      //                       ),
      //                     ),*/
      //                     Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Obx(() => GestureDetector(
      //                           onTap: () {
      //                             muddaNewsController.muddaScrollController.animateTo( //go to top of scroll
      //                             0,  //scroll offset to go
      //                             duration: Duration(milliseconds: 500), //duration of scroll
      //                             curve:Curves.fastOutSlowIn //scroll type
      //                         );
      //                           },
      //                           child: AnimatedContainer(
      //                             duration: const Duration(milliseconds: 200),
      //                             height: muddaNewsController.showFab.value
      //                                 ? 0
      //                                 : 15,
      //                             child: muddaNewsController
      //                                         .tabController.index ==
      //                                     1
      //                                 ? SvgPicture.asset(AppIcons.icMuddebazz,
      //                                     height: ScreenUtil().setSp(15),
      //                                     width: ScreenUtil().setSp(15),
      //                                     color: const Color(0xff3e3e3e))
      //                                 : SvgPicture.asset(AppIcons.fireIcon,
      //                                     height: ScreenUtil().setSp(15),
      //                                     width: ScreenUtil().setSp(15),
      //                                     color: const Color(0xff3e3e3e)),
      //                           ),
      //                         )),
      //                     SizedBox(
      //                         width: muddaNewsController.showFab.value ? 6 : 0),
      //                     Tab(
      //                       icon: Text(
      //                           muddaNewsController.tabController.index == 1
      //                               ? "Muddebaaz"
      //                               : "Mudda",
      //                           style: tabController2.index == 1
      //                               ? size18_M_semiBold(
      //                                   textColor: colorDarkBlack)
      //                               : size18_M_semiBold(
      //                                   textColor: colorDarkBlack)),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               const HomeAppBarActions(),
      //               // Expanded(
      //               //   child: Row(
      //               //     mainAxisAlignment: MainAxisAlignment.end,
      //               //     crossAxisAlignment: CrossAxisAlignment.center,
      //               //     children: [
      //               //
      //               //       Padding(
      //               //         padding: const EdgeInsets.only(
      //               //             top: 8, right: 10, left: 20),
      //               //         child: GestureDetector(
      //               //           onTap: () {
      //               //
      //               //           },
      //               //           child: Image.asset(AppIcons.profileIcon),
      //               //         ),
      //               //       ),
      //               //     ],
      //               //   ),
      //               // ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Column(
          children: [
            Obx(() => AnimatedContainer(
                  height: muddaNewsController.showFab.value ? 35 : 0,
                  duration: const Duration(milliseconds: 500),
                  transform: muddaNewsController.showFab.value
                      ? Matrix4.translationValues(0, 0, 0)
                      : Matrix4.translationValues(0, -10, 0),
                  child: AnimatedOpacity(
                    opacity: muddaNewsController.showFab.value ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: ScreenUtil().setSp(45),
                            child: TabBar(
                              onTap: (index) {
                                setState(() {});
                              },
                              padding: EdgeInsets.zero,
                              indicatorPadding: EdgeInsets.zero,
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              indicatorWeight: 0,
                              indicator: const UnderlineTabIndicator(
                                borderSide: BorderSide(width: 1),
                              ),
                              labelStyle: GoogleFonts.nunitoSans(
                                  fontSize: ScreenUtil().setSp(12),
                                  fontWeight: FontWeight.w800),
                              unselectedLabelStyle: GoogleFonts.nunitoSans(
                                  fontSize: ScreenUtil().setSp(12),
                                  fontWeight: FontWeight.w400),
                              controller: muddaNewsController.tabController,
                              indicatorColor: white,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: const Color(0xff3e3e3e),
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(
                                  icon: SvgPicture.asset(AppIcons.fireIcon,
                                      height: ScreenUtil().setSp(15),
                                      width: ScreenUtil().setSp(15),
                                      color: muddaNewsController
                                                  .tabController.index ==
                                              0
                                          ? const Color(0xff3e3e3e)
                                          : Colors.grey),
                                  iconMargin: const EdgeInsets.only(bottom: 5),
                                ),
                                Tab(
                                  icon: SvgPicture.asset(AppIcons.icMuddebazz,
                                      height: ScreenUtil().setSp(16),
                                      width: ScreenUtil().setSp(16),
                                      color: muddaNewsController
                                                  .tabController.index ==
                                              1
                                          ? const Color(0xff3e3e3e)
                                          : Colors.grey),
                                  iconMargin: const EdgeInsets.only(bottom: 5),
                                ),
                                // Tab(
                                //   icon: SvgPicture.asset(AppIcons.follower,
                                //       height: ScreenUtil().setSp(15),
                                //       width: ScreenUtil().setSp(15),
                                //       color:
                                //           muddaNewsController.tabController.index == 2
                                //               ? const Color(0xff3e3e3e)
                                //               : Colors.grey),
                                //   iconMargin: const EdgeInsets.only(bottom: 5),
                                // ),
                                Tab(
                                  icon: SvgPicture.asset(
                                      AppIcons.under_approval,
                                      height: ScreenUtil().setSp(16),
                                      width: ScreenUtil().setSp(16),
                                      color: muddaNewsController
                                                  .tabController.index ==
                                              2
                                          ? const Color(0xff3e3e3e)
                                          : Colors.grey),
                                  iconMargin: const EdgeInsets.only(bottom: 5),
                                ),

                                // ShowCaseView(
                                //   globalKey:  muddaNewsController.globalKeyThree,
                                //   title:
                                //       'You will find all your ‘Under Approval Muddas’ here',
                                //   description:
                                //       'Invite minimum required leaders to bring your Mudda to Public',
                                //   child: Tab(
                                //     icon: SvgPicture.asset(AppIcons.under_approval,
                                //         height: ScreenUtil().setSp(15),
                                //         width: ScreenUtil().setSp(15),
                                //         color:
                                //             muddaNewsController.tabController.index == 3
                                //                 ? const Color(0xff3e3e3e)
                                //                 : Colors.grey),
                                //     iconMargin: const EdgeInsets.only(bottom: 5),
                                //   ),
                                // ),
                                // Tab(
                                //   icon: SvgPicture.asset(AppIcons.search,
                                //       height: ScreenUtil().setSp(15),
                                //       width: ScreenUtil().setSp(15),
                                //       color:
                                //           muddaNewsController.tabController.index == 4
                                //               ? const Color(0xff3e3e3e)
                                //               : Colors.grey),
                                //   iconMargin: const EdgeInsets.only(bottom: 5),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (muddaNewsController.tabController.index ==
                                  1) {
                                muddebazzFilterDialogBox(
                                    context, profileController);
                              } else {
                                categoryDialogBox(context, muddaNewsController,
                                    userProfileUpdateController!);
                              }
                            },
                            icon: SvgPicture.asset(
                              "assets/svg/filter.svg",
                            ))
                      ],
                    ),
                  ),
                )),
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: muddaNewsController.showFab.value
                    ? ScreenUtil().setSp(15)
                    : ScreenUtil().setSp(3),
              ),
            ),
            NotificationListener<UserScrollNotification>(
              onNotification: (notif) {
                if (notif.direction == ScrollDirection.forward) {
                  muddaNewsController.showFab.value = true;
                  Future.delayed(const Duration(milliseconds: 300), () {
                    muddaNewsController.visible.value =
                        true; // Prints after 1 second.
                  });
                } else if (notif.direction == ScrollDirection.reverse) {
                  muddaNewsController.showFab.value = false;
                  Future.delayed(const Duration(milliseconds: 200), () {
                    muddaNewsController.visible.value =
                        false; // Prints after 1 second.
                  });
                }
                return true;
              },
              child: Expanded(
                child: Stack(
                  children: [
                    TabBarView(
                      children: [
                        TabBarView(
                          children: [
                            MuddaFireNews(
                              globaleKey: muddaNewsController.globalKeyOne,
                              globaleKey1: muddaNewsController.globalKeyTwo,
                              globalKey2: muddaNewsController.globalKeyFive,
                            ),
                            const MuddaBuzzFeedScreen(),
                            // FollowingMudda(),
                            const MuddaUnderApproval(),
                            // const SearchScreen()
                          ],
                          controller: muddaNewsController.tabController,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ],
                      controller: tabController2,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Obx(
                          //       ()=> Visibility(
                          //     visible:muddaNewsController.roleList.isNotEmpty,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.end,
                          //       children: [
                          //         Column(
                          //           children: [
                          //             Obx(
                          //                   ()=> InkWell(
                          //                 onTap: (){
                          //                   showRolesDialog(context);
                          //                 },
                          //                 child: muddaNewsController.selectedRole.value.user != null ?muddaNewsController.selectedRole.value.user!.profile != null ?CachedNetworkImage(
                          //                   imageUrl: "${muddaNewsController.roleProfilePath.value}${muddaNewsController.selectedRole.value.user!.profile}",
                          //                   imageBuilder: (context, imageProvider) => Container(
                          //                     width: ScreenUtil().setSp(42),
                          //                     height: ScreenUtil().setSp(42),
                          //                     decoration: BoxDecoration(
                          //                       color: colorWhite,
                          //                       border: Border.all(
                          //                         width: ScreenUtil().setSp(1),
                          //                         color: buttonBlue,
                          //                       ),
                          //                       borderRadius: BorderRadius.all(
                          //                           Radius.circular(ScreenUtil().setSp(21)) //                 <--- border radius here
                          //                       ),
                          //                       image: DecorationImage(
                          //                           image: imageProvider, fit: BoxFit.cover),
                          //                     ),
                          //                   ),
                          //                   placeholder: (context, url) => CircleAvatar(
                          //                     backgroundColor: lightGray,
                          //                     radius: ScreenUtil().setSp(21),
                          //                   ),
                          //                   errorWidget: (context, url, error) => CircleAvatar(
                          //                     backgroundColor: lightGray,
                          //                     radius: ScreenUtil().setSp(21),
                          //                   ),
                          //                 ):Container(
                          //                   height: ScreenUtil().setSp(42),
                          //                   width: ScreenUtil().setSp(42),
                          //                   decoration: BoxDecoration(
                          //                     border: Border.all(
                          //                       color: darkGray,
                          //                     ),
                          //                     shape: BoxShape.circle,
                          //                   ),
                          //                   child: Center(
                          //                     child: Text(muddaNewsController.selectedRole.value.user!.fullname![0].toUpperCase(),
                          //                         style: GoogleFonts.nunitoSans(
                          //                             fontWeight: FontWeight.w400,
                          //                             fontSize: ScreenUtil().setSp(16),
                          //                             color: black)),
                          //                   ),
                          //                 ):AppPreference().getString(PreferencesKey.interactProfile).isNotEmpty ?CachedNetworkImage(
                          //                   imageUrl: "${AppPreference().getString(PreferencesKey.profilePath)}${AppPreference().getString(PreferencesKey.interactProfile)}",
                          //                   imageBuilder: (context, imageProvider) => Container(
                          //                     width: ScreenUtil().setSp(42),
                          //                     height: ScreenUtil().setSp(42),
                          //                     decoration: BoxDecoration(
                          //                       color: colorWhite,
                          //                       border: Border.all(
                          //                         width: ScreenUtil().setSp(1),
                          //                         color: buttonBlue,
                          //                       ),
                          //                       borderRadius: BorderRadius.all(
                          //                           Radius.circular(ScreenUtil().setSp(21)) //                 <--- border radius here
                          //                       ),
                          //                       image: DecorationImage(
                          //                           image: imageProvider, fit: BoxFit.cover),
                          //                     ),
                          //                   ),
                          //                   placeholder: (context, url) => CircleAvatar(
                          //                     backgroundColor: lightGray,
                          //                     radius: ScreenUtil().setSp(21),
                          //                   ),
                          //                   errorWidget: (context, url, error) => CircleAvatar(
                          //                     backgroundColor: lightGray,
                          //                     radius: ScreenUtil().setSp(21),
                          //                   ),
                          //                 ):Container(
                          //                   height: ScreenUtil().setSp(42),
                          //                   width: ScreenUtil().setSp(42),
                          //                   decoration: BoxDecoration(
                          //                     border: Border.all(
                          //                       color: darkGray,
                          //                     ),
                          //                     shape: BoxShape.circle,
                          //                   ),
                          //                   child: Center(
                          //                     child: Text(AppPreference().getString(PreferencesKey.fullName)[0].toUpperCase(),
                          //                         style: GoogleFonts.nunitoSans(
                          //                             fontWeight: FontWeight.w400,
                          //                             fontSize: ScreenUtil().setSp(16),
                          //                             color: black)),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //             getSizedBox(h: ScreenUtil().setSp(30)),
                          //           ],
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          Obx(
                            () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 40,
                                    width: muddaNewsController.showFab.value
                                        ? 50
                                        : 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                            RouteConstants.searchScreen);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          AppIcons.searchIcon,
                                          height: 20,
                                          width: 22,
                                          color: white,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color606060.withOpacity(0.75),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(16),
                                            bottomRight: Radius.circular(16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     Get.toNamed(RouteConstants.circleChat);
                                  //   },
                                  //   child: Container(
                                  //     height: 40,
                                  //     width: 50,
                                  //     alignment: Alignment.center,
                                  //     child: Image.asset(AppIcons.leftSideIcon),
                                  //     decoration: BoxDecoration(
                                  //       color: color606060.withOpacity(0.75),
                                  //       borderRadius: const BorderRadius.only(
                                  //         topRight: Radius.circular(16),
                                  //         bottomRight: Radius.circular(16),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  const Spacer(),
                                  // ShowCaseView(
                                  //   globalKey: globalKeyFour,
                                  //   title: 'To create your own Mudda',
                                  //   description: 'Click on the Plus Icon',
                                  //   child: GestureDetector(
                                  //     onTap: () {
                                  //       if (AppPreference().getBool(PreferencesKey.isGuest)) {
                                  //         Get.toNamed(RouteConstants.userProfileEdit);
                                  //       } else {
                                  //         muddaNewsController.muddaPost.value = MuddaPost();
                                  //         Get.toNamed(RouteConstants.raisingMudda);
                                  //       }
                                  //     },
                                  //     child: Container(
                                  //       alignment: Alignment.center,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(16),
                                  //         child: Image.asset(AppIcons.plusIcon),
                                  //       ),
                                  //       decoration: const BoxDecoration(
                                  //           color: Colors.amber,
                                  //           shape: BoxShape.circle,
                                  //           boxShadow: [
                                  //             BoxShadow(
                                  //               color: color606060,
                                  //               blurRadius: 2.0,
                                  //               spreadRadius: 0.0,
                                  //               offset: Offset(
                                  //                 0.0,
                                  //                 3.0,
                                  //               ),
                                  //             ),
                                  //           ]),
                                  //     ),
                                  //   ),
                                  // ),
                                  const Spacer(),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: muddaNewsController.showFab.value
                                        ? 50
                                        : 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(RouteConstants.circleChat);
                                        // Get.toNamed(RouteConstants.muddaBuzzFeed);
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
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
                                          Obx(() => chatService.isAvailable.value?Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              height: 12,
                                              width: 12,
                                              decoration: const BoxDecoration(
                                                color: buttonBlue,
                                                  shape: BoxShape.circle),
                                            ),
                                          ):const SizedBox())
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getRoles(BuildContext context) async {
    Api.get.call(context,
        method: "user/my-roles",
        param: {
          "page": rolePage.toString(),
          "user_id": AppPreference().getString(PreferencesKey.userId)
        },
        isLoading: true, onResponseSuccess: (Map object) {
      var result = UserRolesModel.fromJson(object);
      if (rolePage == 1) {
        muddaNewsController.roleList.clear();
      }
      if (result.data!.isNotEmpty) {
        muddaNewsController.roleProfilePath.value = result.path!;
        muddaNewsController.roleList.addAll(result.data!);
        Role role = Role();
        role.user = User();
        role.user!.profile = AppPreference().getString(PreferencesKey.profile);
        role.user!.fullname = "Self";
        role.user!.sId = AppPreference().getString(PreferencesKey.userId);
        muddaNewsController.roleList.add(role);
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
                    itemCount: muddaNewsController.roleList.length,
                    itemBuilder: (followersContext, index) {
                      Role role = muddaNewsController.roleList[index];
                      return InkWell(
                        onTap: () {
                          muddaNewsController.selectedRole.value = role;
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
                                            "${muddaNewsController.roleProfilePath}${role.user!.profile}",
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
}

categoryDialogBox(BuildContext context, MuddaNewsController muddaNewsController,
    UserProfileUpdateController userProfileUpdateController) {
  muddaNewsController.tabController.index = 0;
  Api.get.call(context,
      method: "country/location",
      param: {
        "search": "",
        "page": "1",
        "search_type": "country",
      },
      isLoading: false, onResponseSuccess: (Map object) {
    var result = PlaceModel.fromJson(object);
    muddaNewsController.countryList.clear();
    muddaNewsController.countryList.addAll(result.data!);
    Api.get.call(context,
        method: "category/index",
        param: {
          "search": "",
          "page": "1",
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = CategoryListModel.fromJson(object);
      muddaNewsController.categoryList.clear();
      for (Category category in result.data!) {
        muddaNewsController.categoryList.add(category.name!);
      }
    });
  });
  return showDialog(
    context: Get.context as BuildContext,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Dialog(
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(
            left: 0, right: 0, bottom: 0, top: ScreenUtil().setSp(85)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          color: colorAppBackground,
          padding: EdgeInsets.only(
              top: ScreenUtil().setSp(12),
              left: ScreenUtil().setSp(24),
              right: ScreenUtil().setSp(24),
              bottom: ScreenUtil().setSp(24)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Text("Your Engagements",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(12),
                            color: black))),
                SizedBox(
                  height: ScreenUtil().setSp(2),
                ),
                Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(4)),
                    child: Row(
                      children: List.generate(
                        muddaNewsController.muddaFilterList.length,
                        (index) => Obx(() => GestureDetector(
                              onTap: () {
                                muddaNewsController.selectedMuddaFilter.value =
                                    index;
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                margin: const EdgeInsets.only(right: 5.0),
                                decoration: BoxDecoration(
                                  color: muddaNewsController
                                              .selectedMuddaFilter.value ==
                                          index
                                      ? darkGray
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: lightGray,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      muddaNewsController
                                          .muddaFilterList[index].icon,
                                      color: muddaNewsController
                                                  .selectedMuddaFilter.value ==
                                              index
                                          ? white
                                          : null,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      muddaNewsController
                                          .muddaFilterList[index].title,
                                      style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(12),
                                        color: muddaNewsController
                                                    .selectedMuddaFilter
                                                    .value ==
                                                index
                                            ? white
                                            : lightGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    )),
                SizedBox(
                  height: ScreenUtil().setSp(20),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Text("Location Filter",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(12),
                            color: black))),
                SizedBox(
                  height: ScreenUtil().setSp(2),
                ),
                Text("Quick Selection",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(10),
                        color: buttonYellow,
                        fontStyle: FontStyle.italic)),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(4)),
                  child: GroupButton(
                    textPadding: EdgeInsets.only(
                        left: ScreenUtil().setSp(8),
                        right: ScreenUtil().setSp(8)),
                    runSpacing: ScreenUtil().setSp(9),
                    groupingType: GroupingType.wrap,
                    spacing: ScreenUtil().setSp(5),
                    crossGroupAlignment: CrossGroupAlignment.start,
                    buttonHeight: ScreenUtil().setSp(24),
                    isRadio: false,
                    direction: Axis.horizontal,
                    onSelected: (index, ageSelected) {
                      print("INDEX:::${index}:::SELECTED:::${ageSelected}");
                      /*if(index == 3){
                          if(ageSelected){
                            muddaNewsController.selectedLocation.clear();
                            muddaNewsController.selectedWorld.value = true;
                            muddaNewsController.selectedLocation.add(index);
                          }else{
                            muddaNewsController.selectedWorld.value = false;
                          }
                        }else{
                          muddaNewsController.selectedWorld.value = false;
                        }*/
                      if (ageSelected &&
                          !muddaNewsController.selectedLocation
                              .contains(index)) {
                        muddaNewsController.selectedLocation.add(index);
                      } else if (!ageSelected &&
                          muddaNewsController.selectedLocation
                              .contains(index)) {
                        muddaNewsController.selectedLocation.remove(index);
                      }
                    },
                    selectedButtons: muddaNewsController.selectedLocation,
                    buttons: muddaNewsController.locationList,
                    selectedTextStyle: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(12),
                      color: Colors.white,
                    ),
                    unselectedTextStyle: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w400,
                      fontSize: ScreenUtil().setSp(12),
                      color: lightGray,
                    ),
                    selectedColor: darkGray,
                    unselectedColor: Colors.transparent,
                    selectedBorderColor: lightGray,
                    unselectedBorderColor: lightGray,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().radius(15)),
                    selectedShadow: const <BoxShadow>[
                      BoxShadow(color: Colors.transparent)
                    ],
                    unselectedShadow: const <BoxShadow>[
                      BoxShadow(color: Colors.transparent)
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(20),
                ),
                Text("Custom Selection",
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(10),
                        color: buttonBlue,
                        fontStyle: FontStyle.italic)),
                Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setSp(10)),
                          child: Wrap(
                            children: [
                              DropdownButton<Place>(
                                isExpanded: true,
                                hint: Text(
                                    muddaNewsController
                                            .selectCountry.value.isEmpty
                                        ? "Country"
                                        : muddaNewsController
                                            .selectCountry.value,
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(10),
                                        color: darkGray)),
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtil().setSp(10),
                                    color: darkGray),
                                items: muddaNewsController.countryList
                                    .map((Place value) {
                                  return DropdownMenuItem<Place>(
                                    value: value,
                                    child: Text(value.country!,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(14),
                                            color: darkGray)),
                                  );
                                }).toList(),
                                onChanged: (Place? newValue) {
                                  muddaNewsController.selectCountry.value =
                                      newValue!.country!;

                                  muddaNewsController.selectState.value =
                                      "State";
                                  muddaNewsController.selectDistrict.value =
                                      "District";
                                  Api.get.call(context,
                                      method: "country/location",
                                      param: {
                                        "search": "",
                                        "page": "1",
                                        "search_type": "state",
                                        "depend_type": "country",
                                        "depend_value": newValue.country!,
                                      },
                                      isLoading: false,
                                      onResponseSuccess: (Map object) {
                                    var result = PlaceModel.fromJson(object);
                                    muddaNewsController.stateList.clear();
                                    muddaNewsController.stateList
                                        .addAll(result.data!);
                                    muddaNewsController.stateList.sort(
                                        (a, b) => a.state!.compareTo(b.state!));
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setSp(10),
                              right: ScreenUtil().setSp(10)),
                          child: Wrap(
                            children: [
                              DropdownButton<Place>(
                                isExpanded: true,
                                hint: Text(
                                    muddaNewsController
                                            .selectState.value.isEmpty
                                        ? "State"
                                        : muddaNewsController.selectState.value,
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(10),
                                        color: darkGray)),
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtil().setSp(10),
                                    color: darkGray),
                                items: muddaNewsController.stateList
                                    .map((Place value) {
                                  return DropdownMenuItem<Place>(
                                    value: value,
                                    child: Text(value.state!,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(14),
                                            color: darkGray)),
                                  );
                                }).toList(),
                                onChanged: (Place? newValue) {
                                  muddaNewsController.selectState.value =
                                      newValue!.state!;
                                  muddaNewsController.selectDistrict.value =
                                      "District";
                                  Api.get.call(context,
                                      method: "country/location",
                                      param: {
                                        "search": "",
                                        "page": "1",
                                        "search_type": "district",
                                        "depend_type": "state",
                                        "depend_value": newValue.state!,
                                      },
                                      isLoading: false,
                                      onResponseSuccess: (Map object) {
                                    var result = PlaceModel.fromJson(object);
                                    muddaNewsController.districtList.clear();
                                    for (Place category in result.data!) {
                                      muddaNewsController.districtList
                                          .add(category.district!);
                                      muddaNewsController.districtList
                                          .sort((a, b) => a.compareTo(b));
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.only(right: ScreenUtil().setSp(10)),
                          child: Wrap(
                            children: [
                              DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                    muddaNewsController
                                            .selectDistrict.value.isEmpty
                                        ? "District"
                                        : muddaNewsController
                                            .selectDistrict.value,
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(10),
                                        color: darkGray)),
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtil().setSp(10),
                                    color: darkGray),
                                items: muddaNewsController.districtList
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.nunitoSans(
                                            fontWeight: FontWeight.w400,
                                            fontSize: ScreenUtil().setSp(14),
                                            color: darkGray)),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  muddaNewsController.selectDistrict.value =
                                      newValue!;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(20),
                ),
                Divider(
                  height: ScreenUtil().setSp(1),
                  color: white,
                ),
                SizedBox(
                  height: ScreenUtil().setSp(12),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Text("Category Filter",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(12),
                            color: black))),
                Obx(
                  () => Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
                    child: GroupButton(
                      textPadding: EdgeInsets.only(
                          left: ScreenUtil().setSp(8),
                          right: ScreenUtil().setSp(8)),
                      runSpacing: ScreenUtil().setSp(9),
                      groupingType: GroupingType.wrap,
                      spacing: ScreenUtil().setSp(5),
                      crossGroupAlignment: CrossGroupAlignment.start,
                      buttonHeight: ScreenUtil().setSp(24),
                      isRadio: false,
                      direction: Axis.horizontal,
                      selectedButtons: muddaNewsController.selectedCategory,
                      onSelected: (index, ageSelected) {
                        if (ageSelected &&
                            !muddaNewsController.selectedCategory
                                .contains(index)) {
                          muddaNewsController.selectedCategory.add(index);
                        } else if (!ageSelected &&
                            muddaNewsController.selectedCategory
                                .contains(index)) {
                          muddaNewsController.selectedCategory.remove(index);
                        }
                      },
                      buttons: muddaNewsController.categoryList.value,
                      selectedTextStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(12),
                        color: Colors.white,
                      ),
                      unselectedTextStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(12),
                        color: lightGray,
                      ),
                      selectedColor: darkGray,
                      unselectedColor: Colors.transparent,
                      selectedBorderColor: lightGray,
                      unselectedBorderColor: lightGray,
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().radius(15)),
                      selectedShadow: const <BoxShadow>[
                        BoxShadow(color: Colors.transparent)
                      ],
                      unselectedShadow: const <BoxShadow>[
                        BoxShadow(color: Colors.transparent)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setSp(20),
                ),
                Divider(
                  height: ScreenUtil().setSp(1),
                  color: white,
                ),
                SizedBox(
                  height: ScreenUtil().setSp(11),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Text("Additional",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(12),
                            color: black))),
                SizedBox(
                  height: ScreenUtil().setSp(12),
                ),
                Row(
                  children: [
                    Text("Gender:",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(10),
                            color: black)),
                    SizedBox(
                      width: ScreenUtil().setSp(8),
                    ),
                    GroupButton(
                      textPadding: EdgeInsets.only(
                          left: ScreenUtil().setSp(8),
                          right: ScreenUtil().setSp(8)),
                      runSpacing: ScreenUtil().setSp(9),
                      groupingType: GroupingType.wrap,
                      spacing: ScreenUtil().setSp(5),
                      crossGroupAlignment: CrossGroupAlignment.start,
                      buttonHeight: ScreenUtil().setSp(24),
                      isRadio: false,
                      direction: Axis.horizontal,
                      selectedButtons: muddaNewsController.selectedGender,
                      onSelected: (index, ageSelected) {
                        if (ageSelected &&
                            !muddaNewsController.selectedGender
                                .contains(index)) {
                          muddaNewsController.selectedGender.add(index);
                        } else if (!ageSelected &&
                            muddaNewsController.selectedGender
                                .contains(index)) {
                          muddaNewsController.selectedGender.remove(index);
                        }
                      },
                      buttons: muddaNewsController.genderList,
                      selectedTextStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(12),
                        color: Colors.white,
                      ),
                      unselectedTextStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(12),
                        color: lightGray,
                      ),
                      selectedColor: darkGray,
                      unselectedColor: Colors.transparent,
                      selectedBorderColor: lightGray,
                      unselectedBorderColor: lightGray,
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().radius(15)),
                      selectedShadow: const <BoxShadow>[
                        BoxShadow(color: Colors.transparent)
                      ],
                      unselectedShadow: const <BoxShadow>[
                        BoxShadow(color: Colors.transparent)
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setSp(14),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Text("Age:",
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(10),
                            color: black)),
                    SizedBox(
                      width: ScreenUtil().setSp(8),
                    ),
                    GroupButton(
                      textPadding: EdgeInsets.only(
                          left: ScreenUtil().setSp(0),
                          right: ScreenUtil().setSp(0)),
                      runSpacing: ScreenUtil().setSp(9),
                      groupingType: GroupingType.wrap,
                      spacing: ScreenUtil().setSp(5),
                      crossGroupAlignment: CrossGroupAlignment.start,
                      buttonHeight: ScreenUtil().setSp(24),
                      isRadio: false,
                      direction: Axis.horizontal,
                      selectedButtons: muddaNewsController.selectedAge,
                      onSelected: (index, ageSelected) {
                        if (ageSelected &&
                            !muddaNewsController.selectedAge.contains(index)) {
                          muddaNewsController.selectedAge.add(index);
                        } else if (!ageSelected &&
                            muddaNewsController.selectedAge.contains(index)) {
                          muddaNewsController.selectedAge.remove(index);
                        }
                      },
                      buttons: muddaNewsController.ageList,
                      selectedTextStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(12),
                        color: Colors.white,
                      ),
                      unselectedTextStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(12),
                        color: lightGray,
                      ),
                      selectedColor: darkGray,
                      unselectedColor: Colors.transparent,
                      selectedBorderColor: lightGray,
                      unselectedBorderColor: lightGray,
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().radius(15)),
                      selectedShadow: const <BoxShadow>[
                        BoxShadow(color: Colors.transparent)
                      ],
                      unselectedShadow: const <BoxShadow>[
                        BoxShadow(color: Colors.transparent)
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        List<String> hashtags = [];
                        List<String> location = [];
                        List<String> customLocation = [];
                        List<String> locationValues = [];
                        List<String> customLocationValues = [];
                        List<String> gender = [];
                        List<String> age = [];
                        for (int index
                            in muddaNewsController.selectedLocation) {
                          location.add(muddaNewsController.apiLocationList
                              .elementAt(index));
                          if (index == 0) {
                            locationValues.add(
                                AppPreference().getString(PreferencesKey.city));
                          } else if (index == 1) {
                            locationValues.add(AppPreference()
                                .getString(PreferencesKey.state));
                          } else if (index == 2) {
                            locationValues.add(AppPreference()
                                .getString(PreferencesKey.country));
                          } else {
                            locationValues.add("");
                          }
                        }
                        for (int index
                            in muddaNewsController.selectedCategory) {
                          hashtags.add(muddaNewsController.categoryList
                              .elementAt(index));
                        }
                        for (int index in muddaNewsController.selectedGender) {
                          gender.add(muddaNewsController.genderList
                              .elementAt(index)
                              .toLowerCase());
                        }
                        for (int index in muddaNewsController.selectedAge) {
                          age.add(muddaNewsController.ageList.elementAt(index));
                        }
                        if (muddaNewsController
                            .selectDistrict.value.isNotEmpty) {
                          customLocation.add(
                              muddaNewsController.apiLocationList.elementAt(0));
                          customLocationValues
                              .add(muddaNewsController.selectDistrict.value);
                        }
                        if (muddaNewsController.selectState.value.isNotEmpty) {
                          customLocation.add(
                              muddaNewsController.apiLocationList.elementAt(1));
                          customLocationValues
                              .add(muddaNewsController.selectState.value);
                        }
                        if (muddaNewsController
                            .selectCountry.value.isNotEmpty) {
                          customLocation.add(
                              muddaNewsController.apiLocationList.elementAt(2));
                          customLocationValues
                              .add(muddaNewsController.selectCountry.value);
                        }
                        Map<String, dynamic> map = {
                          "user_id":
                              AppPreference().getString(PreferencesKey.userId),
                        };
                        if (hashtags.isNotEmpty) {
                          map.putIfAbsent(
                              "hashtags", () => jsonEncode(hashtags));
                        }
                        if (location.isNotEmpty) {
                          map.putIfAbsent(
                              "location_types", () => jsonEncode(location));
                        }
                        if (locationValues.isNotEmpty) {
                          map.putIfAbsent("location_types_values",
                              () => jsonEncode(locationValues));
                        }
                        if (customLocation.isNotEmpty) {
                          map.putIfAbsent("custom_location_types",
                              () => jsonEncode(customLocation));
                        }
                        if (customLocationValues.isNotEmpty) {
                          map.putIfAbsent("custom_location_types_values",
                              () => jsonEncode(customLocationValues));
                        }
                        if (gender.isNotEmpty) {
                          map.putIfAbsent(
                              "gender_types", () => jsonEncode(gender));
                        }
                        if (age.isNotEmpty) {
                          map.putIfAbsent("age_types", () => jsonEncode(age));
                        }
                        if (muddaNewsController.selectedMuddaFilter.value !=
                            2) {
                          map['filterType'] =
                              muddaNewsController.selectedMuddaFilter.value == 0
                                  ? 'follow'
                                  : muddaNewsController
                                              .selectedMuddaFilter.value ==
                                          1
                                      ? 'support'
                                      : '';
                        }
                        Api.get.call(context,
                            method: "mudda/index",
                            param: map,
                            isLoading: true, onResponseSuccess: (Map object) {
                          var result = MuddaPostModel.fromJson(object);
                          if (result.data!.isNotEmpty) {
                            muddaNewsController.muddaProfilePath.value =
                                result.path!;
                            muddaNewsController.muddaUserProfilePath.value =
                                result.userpath!;
                            muddaNewsController.muddaPostList.clear();
                            muddaNewsController.muddaPostList
                                .addAll(result.data!);
                            Get.back();
                          } else {
                            showDialog<void>(
                              context: Get.context!,
                              barrierDismissible: false,
                              // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(result.message!,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setSp(28)),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              width: ScreenUtil().setSp(70),
                              height: ScreenUtil().setSp(25),
                              margin: EdgeInsets.only(
                                  right: ScreenUtil().setSp(17),
                                  top: ScreenUtil().setSp(2.5),
                                  bottom: ScreenUtil().setSp(2.5)),
                              decoration: BoxDecoration(
                                color: colorWhite,
                                border: Border.all(color: color606060),
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(8)),
                              ),
                              child: Center(
                                child: Text("Apply",
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(12),
                                        color: black)),
                              ),
                            ),
                            Positioned(
                              right: 1,
                              child: Container(
                                alignment: Alignment.center,
                                height: ScreenUtil().setSp(30),
                                width: ScreenUtil().setSp(30),
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorWhite,
                                    border: Border.all(color: color606060)),
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setSp(42),
                    ),
                    GestureDetector(
                      onTap: () {
                        muddaNewsController.selectedLocation.clear();
                        muddaNewsController.selectedCategory.clear();
                        muddaNewsController.selectedGender.clear();
                        muddaNewsController.selectedAge.clear();
                        muddaNewsController.selectDistrict.value = "";
                        muddaNewsController.selectState.value = "";
                        muddaNewsController.selectCountry.value = "";
                        Api.get.call(context,
                            method: "mudda/index",
                            param: {
                              "user_id": AppPreference()
                                  .getString(PreferencesKey.userId),
                            },
                            isLoading: true, onResponseSuccess: (Map object) {
                          var result = MuddaPostModel.fromJson(object);
                          muddaNewsController.muddaProfilePath.value =
                              result.path!;
                          muddaNewsController.muddaUserProfilePath.value =
                              result.userpath!;
                          muddaNewsController.muddaPostList.clear();
                          muddaNewsController.muddaPostList
                              .addAll(result.data!);
                          Get.back();
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setSp(28)),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              width: ScreenUtil().setSp(70),
                              height: ScreenUtil().setSp(25),
                              margin: EdgeInsets.only(
                                  right: ScreenUtil().setSp(17),
                                  top: ScreenUtil().setSp(2.5),
                                  bottom: ScreenUtil().setSp(2.5)),
                              decoration: BoxDecoration(
                                color: colorWhite,
                                border: Border.all(color: color606060),
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setSp(8)),
                              ),
                              child: Center(
                                child: Text("Reset",
                                    style: GoogleFonts.nunitoSans(
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(12),
                                        color: black)),
                              ),
                            ),
                            Positioned(
                              right: 1,
                              child: Container(
                                alignment: Alignment.center,
                                height: ScreenUtil().setSp(30),
                                width: ScreenUtil().setSp(30),
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorWhite,
                                    border: Border.all(color: color606060)),
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

muddebazzFilterDialogBox(
    BuildContext context, ProfileController profileController) {
  return showDialog(
    context: Get.context as BuildContext,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Dialog(
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(
            left: 0, right: 0, bottom: 0, top: ScreenUtil().setSp(85)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          color: colorAppBackground,
          padding: EdgeInsets.only(
              top: ScreenUtil().setSp(12),
              left: ScreenUtil().setSp(24),
              right: ScreenUtil().setSp(24),
              bottom: ScreenUtil().setSp(24)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text('Filter by:',
                        style: size12_M_normal(textColor: blackGray))),
                SizedBox(height: 12.h),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        profileController.isSelectedQoute.value = 1;
                      },
                      child: Obx(() => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  profileController.isSelectedQoute.value == 1
                                      ? const Color(0xff606060)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: blackGray, width: 1),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.icQoutes,
                                  height: 14.h,
                                  color:
                                      profileController.isSelectedQoute.value ==
                                              1
                                          ? white
                                          : blackGray,
                                ),
                                SizedBox(width: 6.w),
                                Text('Quotes',
                                    style: size14_M_normal(
                                        textColor: profileController
                                                    .isSelectedQoute.value ==
                                                1
                                            ? white
                                            : blackGray)),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: () {
                        profileController.isSelectedQoute.value = 2;
                      },
                      child: Obx(() => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  profileController.isSelectedQoute.value == 2
                                      ? const Color(0xff606060)
                                      : Colors.transparent,
                              border: Border.all(color: blackGray, width: 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.activityIcon,
                                  height: 14.h,
                                  color:
                                      profileController.isSelectedQoute.value ==
                                              2
                                          ? white
                                          : blackGray,
                                ),
                                SizedBox(width: 6.w),
                                Text('Activities',
                                    style: size14_M_normal(
                                        textColor: profileController
                                                    .isSelectedQoute.value ==
                                                2
                                            ? white
                                            : blackGray)),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                const Divider(color: white, thickness: 1),
                SizedBox(height: 22.h),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (profileController.isSelectedQoute.value == 1) {
                          profileController.filterQuote();
                          Get.back();
                        } else if (profileController.isSelectedQoute.value ==
                            2) {
                          profileController.filterActivities();
                          Get.back();
                        }
                      },
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            width: ScreenUtil().setSp(70),
                            height: ScreenUtil().setSp(25),
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setSp(17),
                                top: ScreenUtil().setSp(2.5),
                                bottom: ScreenUtil().setSp(2.5)),
                            decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(color: color606060),
                              borderRadius:
                                  BorderRadius.circular(ScreenUtil().setSp(8)),
                            ),
                            child: Center(
                              child: Text("Apply",
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(12),
                                      color: black)),
                            ),
                          ),
                          Positioned(
                            right: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: ScreenUtil().setSp(30),
                              width: ScreenUtil().setSp(30),
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorWhite,
                                  border: Border.all(color: color606060)),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 42.w),
                    GestureDetector(
                      onTap: () {
                        profileController.getReset();
                        Get.back();
                      },
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            width: ScreenUtil().setSp(70),
                            height: ScreenUtil().setSp(25),
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setSp(17),
                                top: ScreenUtil().setSp(2.5),
                                bottom: ScreenUtil().setSp(2.5)),
                            decoration: BoxDecoration(
                              color: colorWhite,
                              border: Border.all(color: color606060),
                              borderRadius:
                                  BorderRadius.circular(ScreenUtil().setSp(8)),
                            ),
                            child: Center(
                              child: Text("Reset",
                                  style: GoogleFonts.nunitoSans(
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(12),
                                      color: black)),
                            ),
                          ),
                          Positioned(
                            right: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: ScreenUtil().setSp(30),
                              width: ScreenUtil().setSp(30),
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorWhite,
                                  border: Border.all(color: color606060)),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
              ],
            ),
          ),
        ),
      );
    },
  );
}
