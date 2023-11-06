import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/constant/route_constants.dart';
import 'package:mudda/core/local/DatabaseProvider.dart';
import 'package:mudda/core/utils/color.dart';
import 'package:mudda/core/utils/text_style.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/UserRequestList.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/other_user_profile/controller/ChatController.dart';
import '../../../../core/preferences/preference_manager.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../shared/home_app_bar_actions.dart';
import '../../other_user_profile/model/user_chat_list_model.dart';

class CircleChatScreen extends StatefulWidget {
  const CircleChatScreen({Key? key}) : super(key: key);

  @override
  State<CircleChatScreen> createState() => _CircleChatScreenState();
}

class _CircleChatScreenState extends State<CircleChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  ChatController? _chatController;
  ScrollController chatScrollController = ScrollController();
  ScrollController requestScrollController = ScrollController();
  MuddaNewsController muddaNewsController = Get.find<MuddaNewsController>();
  static LocalStorage storage = LocalStorage('chatList');
  int page = 1;
  int rePage = 1;

  @override
  void initState() {
    _chatController = Get.find<ChatController>();
    tabController = TabController(
      length: 1,
      vsync: this,
    );

    chatScrollController.addListener(() {
      if (chatScrollController.position.maxScrollExtent ==
          chatScrollController.position.pixels) {
        page++;
        _chatPaginate();
      }
    });
    requestScrollController.addListener(() {
      if (requestScrollController.position.maxScrollExtent ==
          requestScrollController.position.pixels) {
        rePage++;
        requestPaginate();
      }
    });
    tabController.addListener(() {
      print(tabController.index);
      if (tabController.index == 0) {
        getPostFromCache();
        // _getChatList();
      } else if (tabController.index == 1) {
        getRequestList();
      }
    });
    // _getChatList();
    getPostFromCache();
    getRequestList();
    super.initState();
  }

  _getChatList() async {
    _chatController!.isLoadingChat.value = true;

    Api.get.call(context,
        method: "chats/me",
        param: {
          'page': '$page',
          "lastReadNotification":
              AppPreference().getString(PreferencesKey.notificationId) == ''
                  ? null
                  : AppPreference().getString(PreferencesKey.notificationId)
        },
        isLoading: false,
        onProgress: (double progress) {},
        onResponseSuccess: (Map object) async {
      _chatController!.isLoadingChat.value = false;
      var result = UserChatList.fromJson(object);
      muddaNewsController.isNotiAvailaable.value =
          result.notifications ?? false;
      if (result.result != null) {
        _chatController!.userChatList.clear();
        for (var element in result.result!.chats!) {
          UserChatListResultChats chats = element;
          if (element.lastMessage != null) {
            if (chats.chatDetails![0].category == 'conversation') {
              String? lastReadChatId =
                  await DBProvider.db.getLastChats(element.chatId!);
              if (lastReadChatId != null) {
                if (lastReadChatId != element.lastMessage!.Id &&
                    element.lastMessage!.sender![0]!.Id !=
                        AppPreference().getString(PreferencesKey.userId)) {
                  chats.isNewMessage = true;
                } else {
                  chats.isNewMessage = false;
                }
              } else {
                chats.isNewMessage = false;
              }
            } else {
              String? lastReadChatId =
                  await DBProvider.db.getOrgLastChats(element.chatId!);
              if (lastReadChatId != null) {
                if (lastReadChatId != element.lastMessage!.Id &&
                    element.lastMessage!.sender![0]!.Id !=
                        AppPreference().getString(PreferencesKey.userId)) {
                  chats.isNewMessage = true;
                } else {
                  chats.isNewMessage = false;
                }
              } else {
                chats.isNewMessage = false;
              }
            }
          } else {
            chats.isNewMessage = true;
          }
          _chatController?.userChatList.add(chats);
        }
        // _chatController?.userChatList.addAll(result.result!.chats!);
        savePost(result);
      }
    });
  }

  void savePost(UserChatList userChatList) async {
    await storage.ready;
    storage.setItem("chatList", userChatList);
  }

  void getPostFromCache() async {
    await storage.ready;
    Map<String, dynamic>? data = storage.getItem('chatList');
    if (data == null) {
      _getChatList();
    } else {
      UserChatList userChatList = UserChatList.fromJson(data);
      userChatList.fromCache = true; //to indicate post is pulled from cache
      _chatController?.userChatList.clear();
      _chatController?.userChatList.addAll(userChatList.result!.chats!);
      _getChatList();
    }
  }

  void getRequestList() {
    Api.get.call(context,
        method: "chats/requests",
        param: {
          'page': '$page',
          "lastReadNotification":
              AppPreference().getString(PreferencesKey.notificationId) == ''
                  ? null
                  : AppPreference().getString(PreferencesKey.notificationId)
        },
        isLoading: false, onResponseSuccess: (Map object) {
      var result = UserRequestList.fromJson(object);
      muddaNewsController.isNotiAvailaable.value =
          result.notifications ?? false;
      if (result.result != null) {
        _chatController!.userRequestList.clear();
        _chatController?.userRequestList.addAll(result.result!.data!);
      }
    });
  }

  void requestPaginate() {
    Api.get.call(context,
        method: "chats/requests",
        param: {'page': '$rePage'},
        isLoading: false, onResponseSuccess: (Map object) {
      var result = UserRequestList.fromJson(object);
      if (result.result != null) {
        _chatController?.userRequestList.addAll(result.result!.data!);
      }
    });
  }

  void _chatPaginate() {
    Api.get.call(context,
        method: "chats/me",
        param: {
          'page': '$page',
        },
        isLoading: false, onResponseSuccess: (Map object) async{
      var result = UserChatList.fromJson(object);
      if (result.result != null) {
        for (var element in result.result!.chats!) {
          UserChatListResultChats chats = element;
          if (element.lastMessage != null) {
            if (chats.chatDetails![0].category == 'conversation') {
              String? lastReadChatId =
                  await DBProvider.db.getLastChats(element.chatId!);
              if (lastReadChatId != null) {
                if (lastReadChatId != element.lastMessage!.Id &&
                    element.lastMessage!.sender![0]!.Id !=
                        AppPreference().getString(PreferencesKey.userId)) {
                  chats.isNewMessage = true;
                } else {
                  chats.isNewMessage = false;
                }
              } else {
                chats.isNewMessage = false;
              }
            } else {
              String? lastReadChatId =
                  await DBProvider.db.getOrgLastChats(element.chatId!);
              if (lastReadChatId != null) {
                if (lastReadChatId != element.lastMessage!.Id &&
                    element.lastMessage!.sender![0]!.Id !=
                        AppPreference().getString(PreferencesKey.userId)) {
                  chats.isNewMessage = true;
                } else {
                  chats.isNewMessage = false;
                }
              } else {
                chats.isNewMessage = false;
              }
            }
          } else {
            chats.isNewMessage = true;
          }
          _chatController?.userChatList.add(chats);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAppBackground,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorAppBackground,
        elevation: 0,
        leading: Obx(() => GestureDetector(
              onTap: () {
                Get.toNamed(RouteConstants.notificationScreen);
              },
              child: Center(
                child: SizedBox(
                    height: ScreenUtil().setHeight(25),
                    width: ScreenUtil().setHeight(23),
                    child: Stack(children: [
                      SvgPicture.asset(AppIcons.bellIcon,
                          width: 19,
                          height: 19,
                          fit: BoxFit.fill,
                          color: blackGray),
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
        title: Text(
          "Network",
          style: size18_M_semiBold(textColor: colorDarkBlack),
        ),
        actions: const [HomeAppBarActions()],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 40,
                    child: TabBar(
                      controller: tabController,
                      indicatorColor: Colors.transparent,
                      labelColor: const Color(0xff3e3e3e),
                      labelPadding: const EdgeInsets.only(right: 20),
                      onTap: (int index) {
                        _chatController!.isRequestSelected.value = false;
                        _getChatList();
                      },
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        // Tab(
                        //   icon: Image.asset(
                        //     tabController.index == 0
                        //         ? AppIcons.circleChat1Tab
                        //         : AppIcons.circleChat1,
                        //     height: 20,
                        //     width: 20,
                        //   ),
                        //   child: Container(
                        //     width: 50,
                        //     height: 1,
                        //     color: tabController.index == 0
                        //         ? colorDarkBlack
                        //         : colorWhite,
                        //   ),
                        // ),

                        Obx(() => Tab(
                              icon: Text('Chats',
                                  style: size14_M_bold(
                                      textColor: tabController.index == 0 &&
                                              _chatController!.isRequestSelected
                                                      .value ==
                                                  false
                                          ? const Color(0xff31393C)
                                          : Colors.grey)),
                              child: Container(
                                width: 50,
                                height: 1,
                                color: tabController.index == 0 &&
                                        _chatController!
                                                .isRequestSelected.value ==
                                            false
                                    ? colorDarkBlack
                                    : colorWhite,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Obx(() => Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          _chatController!.isRequestSelected.value = true;
                          getRequestList();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Requests",
                                    style: size12_M_normal(
                                        textColor: _chatController!
                                                    .isRequestSelected.value ==
                                                true
                                            ? colorDarkBlack
                                            : Colors.grey)),
                                // CircleAvatar(
                                //   radius: 9,
                                //   backgroundColor: Colors.blueAccent,
                                //   child: Text("9",
                                //       style:
                                //           size10_M_normal(textColor: Colors.white)),
                                // )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 1,
                              width: 60,
                              color: _chatController!.isRequestSelected.value ==
                                      true
                                  ? colorDarkBlack
                                  : Colors.white,
                            )
                          ],
                        ),
                      ),
                    )),
                const SizedBox(
                  width: 15,
                ),
              ]),
              Obx(() => Expanded(
                    child: TabBarView(children: [
                      _chatController!.isRequestSelected.value != true
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  if (_chatController!.isLoadingChat.value) ...[
                                    const LinearProgressIndicator(),
                                    const SizedBox(height: 4),
                                    const Center(
                                        child: Text('Updating chats...')),
                                    const SizedBox(height: 4),
                                  ],
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                      child:
                                          Obx(() =>
                                              _chatController!
                                                      .userChatList.isNotEmpty
                                                  ? RefreshIndicator(
                                                      onRefresh: () {
                                                        page = 1;

                                                        return _getChatList();
                                                      },
                                                      child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          controller:
                                                              chatScrollController,
                                                          itemCount:
                                                              _chatController!
                                                                  .userChatList
                                                                  .length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const AlwaysScrollableScrollPhysics(),
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15,
                                                                  right: 15,
                                                                  bottom: 15),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            _chatController!
                                                                    .userChatDetails
                                                                    .value =
                                                                _chatController!
                                                                        .userChatList[
                                                                    index];
                                                            if (_chatController!
                                                                    .userChatDetails
                                                                    .value
                                                                    .lastMessage !=
                                                                null) {
                                                              UserChatListResultChatsLastMessage
                                                                  message =
                                                                  _chatController!
                                                                      .userChatList[
                                                                          index]
                                                                      .lastMessage!;
                                                              message.timeStamp =
                                                                  message
                                                                      .caldate;
                                                              message.time =
                                                                  message
                                                                      .caltime;
                                                            } else {}

                                                            return Column(
                                                              children: [
                                                                if (_chatController!
                                                                        .userChatDetails
                                                                        .value
                                                                        .chatDetails![
                                                                            0]
                                                                        .category ==
                                                                    'org')
                                                                  InkWell(
                                                                    onTap: () {
                                                                      _chatController?.userId = _chatController!
                                                                          .userChatList[
                                                                              index]
                                                                          .chatDetails![
                                                                              0]
                                                                          .orgId;
                                                                      _chatController?.chatId = _chatController!
                                                                          .userChatList[
                                                                              index]
                                                                          .chatId;
                                                                      _chatController?.userName = _chatController!
                                                                          .userChatList[
                                                                              index]
                                                                          .chatDetails![
                                                                              0]
                                                                          .title;
                                                                      _chatController?.profile = _chatController!
                                                                          .userChatList[
                                                                              index]
                                                                          .orgThumbnail;
                                                                      _chatController?.isUserBlock.value = _chatController!
                                                                          .userChatList[
                                                                              index]
                                                                          .chatDetails![
                                                                              0]
                                                                          .isUserBlocked!;
                                                                      _chatController
                                                                          ?.index
                                                                          .value = index;
                                                                      Get.toNamed(
                                                                          RouteConstants
                                                                              .orgChatPage,
                                                                          arguments: {
                                                                            'members':
                                                                                _chatController!.userChatList[index].orgMemberCount ?? 0
                                                                          });
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          if (_chatController!.userChatDetails.value.chatDetails !=
                                                                              null)
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                _chatController!.userChatDetails.value.orgThumbnail != null
                                                                                    ? ClipRRect(
                                                                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                        child: SizedBox(
                                                                                            height: 44,
                                                                                            width: 44,
                                                                                            child: Hero(
                                                                                              tag: '${_chatController!.userChatDetails.value.orgThumbnail}',
                                                                                              child: CachedNetworkImage(
                                                                                                imageUrl: '${AppPreference().getString(PreferencesKey.url)}${AppPreference().getString(PreferencesKey.user)}/${_chatController!.userChatDetails.value.orgThumbnail}',
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                            )))
                                                                                    : ClipRRect(
                                                                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                        child: Container(
                                                                                            height: 44,
                                                                                            width: 44,
                                                                                            color: white,
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                _chatController!.userChatDetails.value.chatDetails![0].title != null ? _chatController!.userChatDetails.value.chatDetails![0].title![0].toUpperCase() : '',
                                                                                                style: GoogleFonts.nunitoSans(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ))),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      if (_chatController!.userChatDetails.value.chatDetails != null)
                                                                                        Text(
                                                                                          _chatController!.userChatDetails.value.chatDetails![0].title ?? 'Org Name',
                                                                                          style: size14_M_bold(textColor: colorDarkBlack),
                                                                                        )
                                                                                      else
                                                                                        Text(
                                                                                          'Org Name',
                                                                                          style: size14_M_bold(textColor: colorDarkBlack),
                                                                                        ),
                                                                                      if (_chatController!.userChatDetails.value.lastMessage != null)
                                                                                        Text(
                                                                                          _chatController!.userChatDetails.value.lastMessage!.body!.message ?? '',
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: size12_M_normal(textColor: Colors.black),
                                                                                        )
                                                                                      else
                                                                                        Text(
                                                                                          'Tap to start chat',
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: GoogleFonts.nunitoSans(
                                                                                            fontSize: 12,
                                                                                            color: blackGray,
                                                                                            fontStyle: FontStyle.italic,
                                                                                          ),
                                                                                        ),
                                                                                      SizedBox(height: 8.h),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          SvgPicture.asset(
                                                                                            AppIcons.orgIcon,
                                                                                            height: 16,
                                                                                            width: 21,
                                                                                          ),
                                                                                          SizedBox(width: 4.h),
                                                                                          Text(
                                                                                            '- ${_chatController!.userChatDetails.value.orgMemberCount ?? ''}',
                                                                                            style: size12_M_normal(textColor: black),
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                if (_chatController!.userChatDetails.value.lastMessage != null)
                                                                                  Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      Text(
                                                                                        _chatController!.userChatDetails.value.lastMessage!.timeStamp ?? '',
                                                                                        style: size10_M_normal(textColor: Colors.black),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 8,
                                                                                      ),
                                                                                      _chatController!.userChatList[index].isNewMessage == true ? const CircleAvatar(radius: 5, backgroundColor: Colors.blueAccent) : const SizedBox(),
                                                                                      const SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        _chatController!.userChatDetails.value.lastMessage!.time ?? '',
                                                                                        style: size12_M_normal(textColor: Colors.grey),
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                              ],
                                                                            )
                                                                          else
                                                                            Container(),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 40),
                                                                            child:
                                                                                Container(
                                                                              height: 1,
                                                                              color: Colors.white,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                else if (_chatController!
                                                                        .userChatDetails
                                                                        .value
                                                                        .chatDetails![
                                                                            0]
                                                                        .category ==
                                                                    'mudda')
                                                                  InkWell(
                                                                    onTap: () {
                                                                      _chatController?.userId = _chatController!
                                                                          .userChatList[
                                                                              index]
                                                                          .chatDetails![
                                                                              0]
                                                                          .muddaId;
                                                                      _chatController?.chatId = _chatController!
                                                                          .userChatList[
                                                                              index]
                                                                          .chatId;
                                                                      _chatController?.userName = _chatController!
                                                                          .userChatList[
                                                                              index]
                                                                          .chatDetails![
                                                                              0]
                                                                          .title;
                                                                      _chatController?.profile = _chatController!
                                                                          .userChatList[
                                                                              index]
                                                                          .muddaThumbnail;
                                                                      _chatController?.isUserBlock.value = _chatController!
                                                                          .userChatList[
                                                                              index]
                                                                          .chatDetails![
                                                                              0]
                                                                          .isUserBlocked!;
                                                                      _chatController
                                                                          ?.index
                                                                          .value = index;
                                                                      Get.toNamed(
                                                                          RouteConstants
                                                                              .muddaChatPage,
                                                                          arguments: {
                                                                            'members': _chatController?.userChatList[index].chatDetails?[0].muddaCat == 'favour'
                                                                                ? _chatController!.userChatList[index].favourCount ?? 0
                                                                                : _chatController!.userChatList[index].oppositionCount ?? 0
                                                                          });
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          if (_chatController!.userChatDetails.value.chatDetails !=
                                                                              null)
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                _chatController!.userChatDetails.value.muddaThumbnail != null
                                                                                    ? ClipRRect(
                                                                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                        child: SizedBox(
                                                                                            height: 44,
                                                                                            width: 44,
                                                                                            child: Hero(
                                                                                              tag: '${_chatController!.userChatDetails.value.muddaThumbnail}',
                                                                                              child: CachedNetworkImage(
                                                                                                imageUrl: '${AppPreference().getString(PreferencesKey.url)}${AppPreference().getString(PreferencesKey.mudda)}/${_chatController!.userChatDetails.value.muddaThumbnail}',
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                            )))
                                                                                    : ClipRRect(
                                                                                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                        child: Container(
                                                                                            height: 44,
                                                                                            width: 44,
                                                                                            color: white,
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                _chatController!.userChatDetails.value.chatDetails![0].title != null ? _chatController!.userChatDetails.value.chatDetails![0].title![0].toUpperCase() : '',
                                                                                                style: GoogleFonts.nunitoSans(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ))),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      if (_chatController!.userChatDetails.value.chatDetails != null)
                                                                                        Text(
                                                                                          _chatController!.userChatDetails.value.chatDetails![0].title ?? 'Mudda Name',
                                                                                          style: size14_M_bold(textColor: colorDarkBlack),
                                                                                        )
                                                                                      else
                                                                                        Text(
                                                                                          'Mudda Name',
                                                                                          style: size14_M_bold(textColor: colorDarkBlack),
                                                                                        ),
                                                                                      if (_chatController!.userChatDetails.value.lastMessage != null)
                                                                                        Text(
                                                                                          _chatController!.userChatDetails.value.lastMessage!.body!.message ?? '',
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: size12_M_normal(textColor: Colors.black),
                                                                                        )
                                                                                      else
                                                                                        Text(
                                                                                          'Tap to start chat',
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: GoogleFonts.nunitoSans(
                                                                                            fontSize: 12,
                                                                                            color: blackGray,
                                                                                            fontStyle: FontStyle.italic,
                                                                                          ),
                                                                                        ),
                                                                                      SizedBox(height: 8.h),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          _chatController?.userChatList[index].chatDetails?[0].muddaCat == 'favour'
                                                                                              ? Container(
                                                                                                  decoration: BoxDecoration(color: white, shape: BoxShape.circle, border: Border.all(color: color0060FF, width: 1)),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Image.asset(
                                                                                                      AppIcons.handIcon,
                                                                                                      height: 9,
                                                                                                      width: 15,
                                                                                                      color: color0060FF,
                                                                                                    ),
                                                                                                  ),
                                                                                                )
                                                                                              : Container(
                                                                                                  decoration: BoxDecoration(color: white, shape: BoxShape.circle, border: Border.all(color: colorF1B008, width: 1)),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Image.asset(
                                                                                                      AppIcons.dislike,
                                                                                                      height: 10,
                                                                                                      width: 10,
                                                                                                      color: colorF1B008,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                          SizedBox(width: 4.h),
                                                                                          Text(
                                                                                            '- ${_chatController?.userChatList[index].chatDetails?[0].muddaCat == 'favour' ? _chatController!.userChatDetails.value.favourCount ?? '' : _chatController!.userChatDetails.value.oppositionCount}',
                                                                                            style: size12_M_normal(textColor: black),
                                                                                          )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                if (_chatController!.userChatDetails.value.lastMessage != null)
                                                                                  Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      Text(
                                                                                        _chatController!.userChatDetails.value.lastMessage!.timeStamp ?? '',
                                                                                        style: size10_M_normal(textColor: Colors.black),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 8,
                                                                                      ),
                                                                                      _chatController!.userChatList[index].isNewMessage ? const CircleAvatar(radius: 5, backgroundColor: Colors.blueAccent) : const SizedBox(),
                                                                                      const SizedBox(
                                                                                        height: 5,
                                                                                      ),
                                                                                      Text(
                                                                                        _chatController!.userChatDetails.value.lastMessage!.time ?? '',
                                                                                        style: size12_M_normal(textColor: Colors.grey),
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                              ],
                                                                            )
                                                                          else
                                                                            Container(),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 40),
                                                                            child:
                                                                                Container(
                                                                              height: 1,
                                                                              color: Colors.white,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                else
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (_chatController!
                                                                              .userChatList[index]
                                                                              .chatDetails![0]
                                                                              .category ==
                                                                          "conversation") {
                                                                        _chatController?.userId = _chatController!
                                                                            .userChatList[index]
                                                                            .chatDetails![0]
                                                                            .userDetails!
                                                                            .Id;
                                                                        _chatController?.chatId = _chatController!
                                                                            .userChatList[index]
                                                                            .chatId;
                                                                        _chatController?.userName = _chatController!
                                                                            .userChatList[index]
                                                                            .chatDetails![0]
                                                                            .userDetails!
                                                                            .fullname;
                                                                        _chatController?.profile = _chatController!
                                                                            .userChatList[index]
                                                                            .chatDetails![0]
                                                                            .userDetails!
                                                                            .profile;
                                                                        _chatController?.isUserBlock.value = _chatController!
                                                                            .userChatList[index]
                                                                            .chatDetails![0]
                                                                            .isUserBlocked!;
                                                                        _chatController
                                                                            ?.index
                                                                            .value = index;
                                                                        Get.toNamed(
                                                                            RouteConstants.chatPage);
                                                                      } else if (_chatController!
                                                                              .userChatList[index]
                                                                              .chatDetails![0]
                                                                              .category ==
                                                                          "admin") {
                                                                        _chatController?.userId = _chatController!
                                                                            .userChatList[index]
                                                                            .chatDetails![0]
                                                                            .userDetails!
                                                                            .Id;
                                                                        _chatController?.chatId = _chatController!
                                                                            .userChatList[index]
                                                                            .chatId;
                                                                        _chatController?.userName = _chatController!
                                                                            .userChatList[index]
                                                                            .chatDetails![0]
                                                                            .userDetails!
                                                                            .fullname;
                                                                        _chatController?.profile = _chatController!
                                                                            .userChatList[index]
                                                                            .chatDetails![0]
                                                                            .userDetails!
                                                                            .profile;
                                                                        _chatController?.muddaId = _chatController!
                                                                            .userChatList[index]
                                                                            .chatDetails![0]
                                                                            .muddaId;
                                                                        _chatController
                                                                            ?.isFromChat
                                                                            .value = true;

                                                                        Get.toNamed(
                                                                            RouteConstants.raisingMuddaChatPage);
                                                                      }
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          if (_chatController!.userChatDetails.value.chatDetails !=
                                                                              null)
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                if(_chatController!.userChatDetails.value.chatDetails![0].userDetails!.fullname == 'Kalz Studios') Hero(
                                                                                  tag: 'Kalz Studios',
                                                                                  child: SvgPicture.asset(AppIcons.icMuddaSupport),
                                                                                ) else
                                                                                _chatController!.userChatDetails.value.chatDetails![0].userDetails!.profile != null
                                                                                    ? Hero(
                                                                                        tag: '${_chatController!.userChatDetails.value.chatDetails![0].userDetails!.profile}',
                                                                                        child: CircleAvatar(
                                                                                          radius: 20,
                                                                                          backgroundImage: NetworkImage('${AppPreference().getString(PreferencesKey.url)}${AppPreference().getString(PreferencesKey.user)}/${_chatController!.userChatDetails.value.chatDetails![0].userDetails!.profile}'),
                                                                                        ),
                                                                                      )
                                                                                    : CircleAvatar(
                                                                                        radius: 20,
                                                                                        backgroundColor: Colors.white,
                                                                                        child: Text(
                                                                                          _chatController!.userChatDetails.value.chatDetails![0].userDetails!.fullname != null ? _chatController!.userChatDetails.value.chatDetails![0].userDetails!.fullname![0].toUpperCase() : '',
                                                                                          style: GoogleFonts.nunitoSans(
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.w700,
                                                                                            color: Colors.black,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Expanded(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      if (_chatController!.userChatDetails.value.chatDetails != null && _chatController!.userChatDetails.value.chatDetails![0].userDetails!.fullname!=null)
                                                                                        Text(
                                                                                          _chatController!.userChatDetails.value.chatDetails![0].userDetails!.fullname =='Kalz Studios' ? 'Mudda Support Center': _chatController!.userChatDetails.value.chatDetails![0].userDetails!.fullname!,
                                                                                          style: size14_M_bold(textColor: colorDarkBlack),
                                                                                        )
                                                                                      else
                                                                                        Text(
                                                                                          'Username',
                                                                                          style: size14_M_bold(textColor: colorDarkBlack),
                                                                                        ),
                                                                                      if (_chatController!.userChatDetails.value.lastMessage != null)
                                                                                        Text(
                                                                                          _chatController!.userChatDetails.value.lastMessage!.body!.message ?? '',
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: size12_M_normal(textColor: Colors.black),
                                                                                        )
                                                                                      else
                                                                                        Text(
                                                                                          'Tap to start chat',
                                                                                          maxLines: 2,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: GoogleFonts.nunitoSans(
                                                                                            fontSize: 12,
                                                                                            color: blackGray,
                                                                                            fontStyle: FontStyle.italic,
                                                                                          ),
                                                                                        ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Text(
                                                                                      _chatController!.userChatDetails.value.lastMessage!.timeStamp ?? '',
                                                                                      style: size10_M_normal(textColor: Colors.black),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 8,
                                                                                    ),
                                                                                    _chatController!.userChatList[index].isNewMessage ? const CircleAvatar(radius: 5, backgroundColor: Colors.blueAccent) : const SizedBox(),
                                                                                    const SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      _chatController!.userChatDetails.value.lastMessage!.time ?? '',
                                                                                      style: size12_M_normal(textColor: Colors.grey),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            )
                                                                          else
                                                                            Container(),
                                                                          const SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 40),
                                                                            child:
                                                                                Container(
                                                                              height: 1,
                                                                              color: Colors.white,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                              ],
                                                            );
                                                          }),
                                                    )
                                                  : const Center(
                                                      child: Text(
                                                          'No chats found')))),
                                ])
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                      child: Obx(() =>
                                          _chatController!
                                                  .userRequestList.isNotEmpty
                                              ? ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: _chatController!
                                                      .userRequestList.length,
                                                  controller:
                                                      requestScrollController,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  padding: const EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      bottom: 15),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    _chatController!
                                                            .userRequestDetails
                                                            .value =
                                                        _chatController!
                                                                .userRequestList[
                                                            index];
                                                    if (_chatController!
                                                            .userRequestList[
                                                                index]
                                                            .lastMessage !=
                                                        null) {
                                                      UserRequestListResultDataLastMessage
                                                          message =
                                                          _chatController!
                                                              .userRequestList[
                                                                  index]
                                                              .lastMessage!;
                                                      message.timeStamp =
                                                          message.caldate;
                                                      message.time =
                                                          message.caltime;
                                                    }
                                                    return InkWell(
                                                      onTap: () {
                                                        _chatController
                                                                ?.userId =
                                                            _chatController!
                                                                .userRequestList[
                                                                    index]
                                                                .chatDetails![0]
                                                                .userDetails!
                                                                .Id;
                                                        _chatController
                                                                ?.chatId =
                                                            _chatController!
                                                                .userRequestList[
                                                                    index]
                                                                .chatId;
                                                        _chatController
                                                                ?.userName =
                                                            _chatController!
                                                                .userRequestList[
                                                                    index]
                                                                .chatDetails![0]
                                                                .userDetails!
                                                                .fullname;
                                                        _chatController
                                                                ?.profile =
                                                            _chatController!
                                                                .userRequestList[
                                                                    index]
                                                                .chatDetails![0]
                                                                .userDetails!
                                                                .profile;
                                                        _chatController
                                                            ?.isFromRequest
                                                            .value = true;
                                                        _chatController?.index
                                                            .value = index;
                                                        Get.toNamed(
                                                            RouteConstants
                                                                .chatPage);
                                                      },
                                                      child: Column(
                                                        children: [
                                                          if (_chatController!
                                                                  .userChatDetails
                                                                  .value
                                                                  .chatDetails !=
                                                              null)
                                                            Row(
                                                              children: [
                                                                _chatController!
                                                                            .userRequestDetails
                                                                            .value
                                                                            .chatDetails![0]
                                                                            .userDetails!
                                                                            .profile !=
                                                                        null
                                                                    ? CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundImage:
                                                                            NetworkImage('${AppPreference().getString(PreferencesKey.url)}${AppPreference().getString(PreferencesKey.user)}/${_chatController!.userRequestDetails.value.chatDetails![0].userDetails!.profile}'),
                                                                      )
                                                                    : CircleAvatar(
                                                                        radius:
                                                                            20,
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        child:
                                                                            Text(
                                                                          _chatController!
                                                                              .userRequestDetails
                                                                              .value
                                                                              .chatDetails![0]
                                                                              .userDetails!
                                                                              .fullname![0]
                                                                              .toUpperCase(),
                                                                          style:
                                                                              GoogleFonts.nunitoSans(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        _chatController!.userRequestDetails.value.chatDetails![0].userDetails!.fullname ??
                                                                            'Username',
                                                                        style: size14_M_bold(
                                                                            textColor:
                                                                                colorGrey),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          children: [
                                                                            // TextSpan(
                                                                            //   text: "Nirmal: ",
                                                                            //   style:
                                                                            //   size12_M_extraBold(
                                                                            //       textColor:
                                                                            //       Colors
                                                                            //           .black),
                                                                            // ),
                                                                            if (_chatController!.userChatDetails.value.lastMessage !=
                                                                                null)
                                                                              TextSpan(
                                                                                text: _chatController!.userChatDetails.value.lastMessage!.body!.message ?? '',
                                                                                style: size12_M_normal(textColor: Colors.black),
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    _chatController!.userRequestDetails.value.lastMessage !=
                                                                            null
                                                                        ? Text(
                                                                            _chatController!.userRequestDetails.value.lastMessage!.timeStamp ??
                                                                                '',
                                                                            style:
                                                                                size10_M_normal(textColor: Colors.black),
                                                                          )
                                                                        : Text(
                                                                            '',
                                                                            style:
                                                                                size10_M_normal(textColor: Colors.black),
                                                                          ),
                                                                    const SizedBox(
                                                                      height:
                                                                          12,
                                                                    ),
                                                                    // CircleAvatar(
                                                                    //   radius: 7,
                                                                    //   backgroundColor:
                                                                    //   Colors.blueAccent,
                                                                    //   child: Text("9",
                                                                    //       style: size09_M_semibold(
                                                                    //           textColor:
                                                                    //           Colors.white)),
                                                                    // ),
                                                                    _chatController!.userRequestDetails.value.lastMessage !=
                                                                            null
                                                                        ? Text(
                                                                            _chatController!.userRequestDetails.value.lastMessage!.time ??
                                                                                '',
                                                                            style:
                                                                                size12_M_normal(textColor: Colors.grey),
                                                                          )
                                                                        : Text(
                                                                            '',
                                                                            style:
                                                                                size12_M_normal(textColor: Colors.grey),
                                                                          )
                                                                  ],
                                                                )
                                                              ],
                                                            )
                                                          else
                                                            const SizedBox(),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 40),
                                                            child: Container(
                                                              height: 1,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  })
                                              : const Center(
                                                  child: Text(
                                                      'No requests found')))),
                                ]),

                      // SingleChildScrollView(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.only(left: 15),
                      //         child: Text(
                      //           "Channels",
                      //           style: size14_M_bold(
                      //             textColor: colorGrey,
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         height: 10,
                      //       ),
                      //       Column(
                      //         children: List.generate(
                      //           20,
                      //           (index) => Padding(
                      //               padding: const EdgeInsets.only(
                      //                   left: 15, right: 15, bottom: 15),
                      //               child: GestureDetector(
                      //                 onTap: () {
                      //                   Get.toNamed(
                      //                       RouteConstants.stageLiveCommentsLeaders);
                      //                 },
                      //                 child: index % 2 == 0
                      //                     ? Column(
                      //                         children: [
                      //                           Row(
                      //                             children: [
                      //                               CircleAvatar(
                      //                                 radius: 20,
                      //                                 backgroundImage:
                      //                                     AssetImage(AppIcons.dummyImage),
                      //                               ),
                      //                               SizedBox(
                      //                                 width: 10,
                      //                               ),
                      //                               Expanded(
                      //                                 child: Column(
                      //                                   crossAxisAlignment:
                      //                                       CrossAxisAlignment.start,
                      //                                   children: [
                      //                                     Text(
                      //                                       "Mehar Rana Pujta",
                      //                                       style: size14_M_bold(
                      //                                           textColor: colorGrey),
                      //                                     ),
                      //                                     RichText(
                      //                                       text: TextSpan(
                      //                                         children: [
                      //                                           TextSpan(
                      //                                             text: "Nirmal: ",
                      //                                             style:
                      //                                                 size12_M_extraBold(
                      //                                                     textColor:
                      //                                                         Colors
                      //                                                             .black),
                      //                                           ),
                      //                                           TextSpan(
                      //                                             text:
                      //                                                 "Hey Please connect with me. I have a lot to ...",
                      //                                             style: size12_M_normal(
                      //                                                 textColor:
                      //                                                     Colors.black),
                      //                                           ),
                      //                                         ],
                      //                                       ),
                      //                                     )
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               SizedBox(
                      //                                 width: 10,
                      //                               ),
                      //                               Column(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment.spaceBetween,
                      //                                 children: [
                      //                                   Text(
                      //                                     "Today",
                      //                                     style: size10_M_normal(
                      //                                         textColor: Colors.black),
                      //                                   ),
                      //                                   SizedBox(
                      //                                     height: 5,
                      //                                   ),
                      //                                   CircleAvatar(
                      //                                     radius: 7,
                      //                                     backgroundColor:
                      //                                         Colors.blueAccent,
                      //                                     child: Text("9",
                      //                                         style: size09_M_semibold(
                      //                                             textColor:
                      //                                                 Colors.white)),
                      //                                   ),
                      //                                   SizedBox(
                      //                                     height: 5,
                      //                                   ),
                      //                                   Text(
                      //                                     "23.45",
                      //                                     style: size12_M_normal(
                      //                                         textColor: Colors.grey),
                      //                                   )
                      //                                 ],
                      //                               )
                      //                             ],
                      //                           ),
                      //                           SizedBox(
                      //                             height: 5,
                      //                           ),
                      //                           Padding(
                      //                             padding:
                      //                                 const EdgeInsets.only(left: 40),
                      //                             child: Container(
                      //                               height: 1,
                      //                               color: Colors.white,
                      //                             ),
                      //                           )
                      //                         ],
                      //                       )
                      //                     : Column(
                      //                         children: [
                      //                           Row(
                      //                             children: [
                      //                               ClipRRect(
                      //                                 borderRadius: BorderRadius.all(
                      //                                     Radius.circular(5)),
                      //                                 child: Container(
                      //                                     height: 44,
                      //                                     width: 44,
                      //                                     child: Image.asset(
                      //                                         AppIcons.dummyImage)),
                      //                               ),
                      //                               SizedBox(
                      //                                 width: 10,
                      //                               ),
                      //                               Expanded(
                      //                                 child: Column(
                      //                                   crossAxisAlignment:
                      //                                       CrossAxisAlignment.start,
                      //                                   children: [
                      //                                     Text(
                      //                                       "Boycott China Mudda Live Stage",
                      //                                       style: size14_M_bold(
                      //                                           textColor: colorGrey),
                      //                                     ),
                      //                                     RichText(
                      //                                       text: TextSpan(
                      //                                         children: [
                      //                                           TextSpan(
                      //                                             text: "Nirmal: ",
                      //                                             style:
                      //                                                 size12_M_extraBold(
                      //                                                     textColor:
                      //                                                         Colors
                      //                                                             .black),
                      //                                           ),
                      //                                           TextSpan(
                      //                                             text:
                      //                                                 "Hey Please connect with me. I have a lot to ...",
                      //                                             style: size12_M_normal(
                      //                                                 textColor:
                      //                                                     Colors.black),
                      //                                           ),
                      //                                         ],
                      //                                       ),
                      //                                     )
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                               Column(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment.spaceBetween,
                      //                                 children: [
                      //                                   Text(
                      //                                     "Today",
                      //                                     style: size10_M_normal(
                      //                                         textColor: Colors.black),
                      //                                   ),
                      //                                   SizedBox(
                      //                                     height: 5,
                      //                                   ),
                      //                                   Row(
                      //                                     children: [
                      //                                       Text(
                      //                                         "500",
                      //                                         style: size12_M_normal(
                      //                                             textColor: Colors.grey),
                      //                                       ),
                      //                                       Icon(
                      //                                         Icons.message,
                      //                                         size: 20,
                      //                                         color: Colors.grey,
                      //                                       )
                      //                                     ],
                      //                                   ),
                      //                                   SizedBox(
                      //                                     height: 5,
                      //                                   ),
                      //                                   Text(
                      //                                     "23.45",
                      //                                     style: size12_M_normal(
                      //                                         textColor: Colors.grey),
                      //                                   )
                      //                                 ],
                      //                               )
                      //                             ],
                      //                           ),
                      //                           SizedBox(
                      //                             height: 5,
                      //                           ),
                      //                           Padding(
                      //                             padding:
                      //                                 const EdgeInsets.only(left: 40),
                      //                             child: Container(
                      //                               height: 1,
                      //                               color: Colors.white,
                      //                             ),
                      //                           )
                      //                         ],
                      //                       ),
                      //               )),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ], controller: tabController),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 40,
                        width: 50,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(AppIcons.icMudda,
                            height: 20, width: 16, color: Colors.white),
                        decoration: BoxDecoration(
                          color: color606060.withOpacity(0.75),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.toNamed(RouteConstants.createChannel);
                    //   },
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(6),
                    //       child: Image.asset(AppIcons.plusIcon),
                    //     ),
                    //     decoration: const BoxDecoration(
                    //         color: Colors.amber,
                    //         shape: BoxShape.circle,
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: color606060,
                    //             blurRadius: 2.0,
                    //             spreadRadius: 0.0,
                    //             offset: const Offset(
                    //               0.0,
                    //               3.0,
                    //             ),
                    //           ),
                    //         ]),
                    //   ),
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.back();
                    //   },
                    //   child: Container(
                    //     height: 40,
                    //     width: 50,
                    //     alignment: Alignment.center,
                    //     child: SvgPicture.asset(AppIcons.icMudda,
                    //         height: 20, width: 16, color: Colors.white),
                    //     decoration: BoxDecoration(
                    //       color: color606060.withOpacity(0.75),
                    //       borderRadius: const BorderRadius.only(
                    //         topLeft: Radius.circular(16),
                    //         bottomLeft: Radius.circular(16),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
