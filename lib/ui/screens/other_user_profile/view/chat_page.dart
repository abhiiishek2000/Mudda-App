import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/local/DatabaseProvider.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/ui/screens/circle_chat/view/chat_loading_view.dart';
import 'package:mudda/ui/screens/other_user_profile/controller/ChatController.dart';
import 'package:mudda/ui/screens/other_user_profile/model/chat_api_response.dart';
import 'package:mudda/ui/screens/other_user_profile/model/chat_model.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';
import 'package:mudda/core/utils/text_style.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../core/utils/color.dart';
import '../../../../core/utils/time_convert.dart';
import '../model/user_chat_list_model.dart';

class ChatPageScreen extends StatefulWidget {
  const ChatPageScreen({Key? key}) : super(key: key);

  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  ChatController chatController = Get.put(ChatController());
  ScrollController chatScrollController = ScrollController();
  String message = '';
  final List<Chat> tempList = [];
  int pages = 1;
  int nextPage = 1;
  String? lastChatId;
  String? firstChatId;

  @override
  void initState() {
    chatController.connectAndListen();
    AppPreference appPreference = AppPreference();
    String userId = appPreference.getString(PreferencesKey.userId);

    if (chatController.chatId == null) {
    } else {
      getMessages(context);
    }
    chatScrollController.addListener(() {
      if (chatScrollController.position.maxScrollExtent ==
          chatScrollController.position.pixels) {
        getPreviousMessages(context);
      } else if (chatScrollController.position.minScrollExtent ==
          chatScrollController.position.pixels) {
        getNextMessages(context);
      } else if (chatScrollController.offset >
          chatScrollController.position.minScrollExtent + Get.height * 0.5) {
        chatController.isArrowIconShow.value = true;
      } else {
        chatController.isArrowIconShow.value = false;
      }
    });
    super.initState();
  }

  void animateToLatest() {
    chatScrollController.animateTo(
        chatScrollController.position.minScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
  }

  void fetchNewMessages() {
    if (chatController.messageCount.value > 20) {
      chatScrollController
          .animateTo(chatScrollController.position.minScrollExtent,
              duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn)
          .then((value) {
        AppPreference appPreference = AppPreference();
        String userId = appPreference.getString(PreferencesKey.userId);
        DBProvider.db.deleteIndivitualChatById(chatController.chatId!);
        chatController.messageList.clear();
        chatController.isLoading.value = true;
        Api.get.call(context,
            method: "chats/${chatController.chatId}/messages",
            param: {'page': '1'},
            isLoading: false, onResponseSuccess: (Map object) async {
          chatController.isLoading.value = false;
          var result = ChatApiResponse.fromJson(object);
          result.result?.messages?.forEach((element) {
            DBProvider.db.addMessages(
              userId: "${element?.data?.senderId}",
              chatId: "${element?.data?.chatId}",
              isSend: element?.data?.senderId == chatController.userId
                  ? true
                  : false,
              lastChatId: "${element?.data?.Id}",
              message: "${element?.data?.body?.message}",
              type: 'messages',
              category: 'message',
              createdAt: '${element?.data?.createdAt}',
              ids: "${chatController.userId}-$userId",
              isGroup: false,
            );
          });
          List<Chat> tempList =
              await DBProvider.db.getChats("${chatController.userId}-$userId");
          chatController.messageList.clear();
          for (int i = 0; i < tempList.length; i++) {
            Chat result2 = tempList[i];
            Chat message = Chat(
              isSend: result2.isSend,
              isGroup: result2.isGroup,
              category: result2.category,
              chatId: result2.chatId,
              msgId: result2.msgId,
              lastChatId: result2.lastChatId,
              message: result2.message,
              userId: result2.userId,
              ids: result2.ids,
              type: result2.type,
              time: result2.time,
            );
            message.isHeader = i == tempList.length - 1 ||
                (result2.date != tempList[i + 1].date);
            message.timeStamp = result2.date;
            chatController.messageList.add(message);
          }
        });
      });
      chatController.messageCount.value = 0;
    }
  }

  void getMessageCount(String lastMessageTime, {required bool isUpdateCount}) {
    Api.get.call(context,
        method: "chats/messageCount",
        param: {
          'lastReadTime': lastMessageTime,
          'chatId': '${chatController.chatId}'
        },
        isLoading: false, onResponseSuccess: (Map object) async {
      chatController.messageCount.value = object['result'];
      if (isUpdateCount) {
      } else {
        if (chatController.messageCount.value > 0) {
          getAfterMessages(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    return Obx(() => WillPopScope(
        child: Scaffold(
          backgroundColor: colorAppBackground,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            chatController.clearList();
                            chatController.isFromRequest.value = false;
                            UserChatListResultChats chats = chatController
                                .userChatList[chatController.index.value];
                            chats.isNewMessage = false;
                            chatController.userChatList
                                .removeAt(chatController.index.value);
                            chatController.userChatList
                                .insert(chatController.index.value, chats);
                            chatController.disconnect();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                        if(chatController.userName == 'Kalz Studios') Hero(
                          tag: 'Kalz Studios',
                          child: SvgPicture.asset(AppIcons.icMuddaSupport),
                        )else
                        chatController.profile != null
                            ? Hero(
                                tag: '${chatController.profile}',
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      "${AppPreference().getString(PreferencesKey.url)}${AppPreference().getString(PreferencesKey.user)}/${chatController.profile}"),
                                ),
                              )
                            : CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Text(
                                  chatController.userName != null
                                      ? chatController.userName!
                                          .substring(0, 1)
                                          .toUpperCase()
                                      : '',
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              chatController.userName == 'Kalz Studios'? 'Mudda Support Center':  chatController.userName ?? '',
                              style: size18_M_normal(textColor: Colors.black),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.more_vert_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: 1,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                height: Get.height,
                width: Get.width,
              ),
              chatController.isLoading.value
                  ? ListView.separated(
                      itemCount: 16,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 8);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return ChatLoadingView();
                      })
                  : ListView.builder(
                      controller: chatScrollController,
                      reverse: true,
                      itemCount: chatController.messageList.length,
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(90)),
                      itemBuilder: (context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Visibility(
                                  child: Text(chatController
                                              .messageList[index] !=
                                          null
                                      ? "${chatController.messageList[index].timeStamp}"
                                      : "",style:  size12_M_normal(
                                      textColor: colorA0A0A0),),
                                  visible: chatController
                                      .messageList[index].isHeader!),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    chatController.messageList[index].userId ==
                                                chatController.userId &&
                                            chatController.messageList[index]
                                                    .isSend ==
                                                1
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.end,
                                children: [
                                  if (chatController
                                              .messageList[index].userId ==
                                          chatController.userId &&
                                      chatController
                                              .messageList[index].isSend ==
                                          1)
                                    Expanded(
                                        child: recieveMessage(
                                            chatController.profile != null
                                                ? "${AppPreference().getString(PreferencesKey.url)}${AppPreference().getString(PreferencesKey.user)}/${chatController.profile}"
                                                : null,
                                            "${chatController.userName}",
                                            "${chatController.messageList[index].message}",
                                            "${chatController.messageList[index].time}"))
                                  else if (chatController
                                          .messageList[index].isSend ==
                                      0)
                                    Expanded(
                                        child: sendMessage(
                                            "${chatController.messageList[index].message}",
                                            "${chatController.messageList[index].time}"))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(() => Visibility(
                                  child: Column(
                                    children: [
                                      const Divider(color: white, thickness: 1),
                                      Text(
                                        "Last Read",
                                        style: size12_M_normal(
                                            textColor: colorA0A0A0),
                                      ),
                                    ],
                                  ),
                                  visible:
                                      chatController.messageCount.value > 0 &&
                                              chatController.messageList[index]
                                                      .isLastRead !=
                                                  null
                                          ? chatController
                                              .messageList[index].isLastRead!
                                          : false))
                            ],
                          ),
                        );
                      }),
              Obx(() => Visibility(
                    visible: chatController.isArrowIconShow.value,
                    child: Positioned(
                      bottom: 120,
                      right: 16,
                      child: AnimatedOpacity(
                        duration: duration,
                        opacity: chatController.isArrowIconShow.value ? 1 : 0,
                        child: GestureDetector(
                            onTap: () => animateToLatest(),
                            child: SvgPicture.asset(
                                AppIcons.icDownArrowForPagination)),
                      ),
                    ),
                  )),
              Positioned(
                bottom: 80,
                right: 0,
                left: 0,
                child: Obx(() => chatController.messageCount.value > 20
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () => fetchNewMessages(),
                            child: Container(
                              height: 30,
                              width: Get.width * 0.5,
                              decoration: BoxDecoration(
                                color: buttonBlue,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.arrow_downward,
                                      color: white, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${chatController.messageCount.value} new messages',
                                    style: size12_M_regular(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox()),
              ),
              Obx(() => Visibility(
                    visible: chatController.isUserBlock.value == true,
                    child: Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'You had block this user. Unblock to start chatting',
                            style: size12_M_normal(textColor: colorFF2121),
                          ),
                          TextButton(
                              onPressed: () {
                                _showUnBlockDialog(
                                        context, "${chatController.userId}")
                                    .then((value) => {});
                              },
                              child: const Text('Unblock'))
                        ],
                      ),
                    ),
                  )),
              Obx(() => Visibility(
                    visible: chatController.isFromRequest.value == false &&
                        chatController.isUserBlock.value == false,
                    child: Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: colorGrey),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorGrey.withOpacity(.16),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: TextFormField(
                                style: GoogleFonts.nunitoSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtil().setSp(15),
                                    color: color606060),
                                cursorHeight: 15,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 4,
                                controller: chatController.msgController,
                                textInputAction: TextInputAction.send,
                                onFieldSubmitted: (v) {
                                  if (chatController
                                      .msgController.text.isNotEmpty) {
                                    chatController.sendMessage(
                                        chatController.msgController.text,
                                        chatController.userId ?? '',
                                        "${chatController.chatId}");
                                    if (chatController.userChatList.length >
                                        0) {
                                      chatController.userChatDetails.value =
                                          chatController.userChatList[
                                              chatController.index.value];
                                      UserChatListResultChatsLastMessage
                                          message = chatController
                                              .userChatList[
                                                  chatController.index.value]
                                              .lastMessage!;
                                      message.body!.message =
                                          chatController.msgController.text;
                                      message.createdAt =
                                          DateTime.now().toString();
                                      message.timeStamp = message.caldate;
                                      message.time = message.caltime;
                                      chatController
                                          .userChatList[
                                              chatController.index.value]
                                          .lastMessage = message;
                                      chatController.userChatList
                                          .removeAt(chatController.index.value);
                                      chatController.userChatList.insert(0,
                                          chatController.userChatDetails.value);
                                      chatController.msgController.clear();
                                    }
                                    chatController.msgController.clear();
                                  }
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  hintStyle:
                                      size13_M_normal(textColor: color606060),
                                  hintText: "Type your message",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (chatController
                                  .msgController.text.isNotEmpty) {
                                chatController.sendMessage(
                                    chatController.msgController.text,
                                    chatController.userId ?? '',
                                    "${chatController.chatId}");
                                if (chatController.userChatList.length > 0) {
                                  chatController.userChatDetails.value =
                                      chatController.userChatList[
                                          chatController.index.value];
                                  UserChatListResultChatsLastMessage message =
                                      chatController
                                          .userChatList[
                                              chatController.index.value]
                                          .lastMessage!;
                                  message.body!.message =
                                      chatController.msgController.text;
                                  message.createdAt = DateTime.now().toString();
                                  message.timeStamp = message.caldate;
                                  message.time = message.caltime;
                                  chatController
                                      .userChatList[chatController.index.value]
                                      .lastMessage = message;
                                  chatController.userChatList
                                      .removeAt(chatController.index.value);
                                  chatController.userChatList.insert(
                                      0, chatController.userChatDetails.value);
                                  chatController.msgController.clear();
                                }
                                chatController.msgController.clear();
                              }
                            },
                            icon: Image.asset(
                              AppIcons.rightSizeArrow,
                              color: colorGrey,
                              height: 20,
                              width: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              Obx(() => Visibility(
                    visible: chatController.isFromRequest.value &&
                        chatController.isUserBlock.value == false,
                    child: Positioned(
                      bottom: 50,
                      left: 100,
                      right: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Api.post.call(
                                context,
                                method:
                                    "chats/requests/${chatController.chatId}/action",
                                isLoading: true,
                                param: {"accept": true},
                                onResponseSuccess: (object) {
                                  chatController.userRequestList
                                      .removeAt(chatController.index.value);
                                  chatController.isFromRequest.value = false;
                                },
                              );
                            },
                            child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFf7f7f7),
                                  border: Border.all(color: colorGrey),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorGrey.withOpacity(.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                    const BoxShadow(
                                      color: colorAppBackground,
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, -2),
                                    )
                                  ],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: const Center(child: Text("Accept")),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              Api.post.call(
                                context,
                                method:
                                    "chats/requests/${chatController.chatId}/action",
                                isLoading: true,
                                param: {"accept": false},
                                onResponseSuccess: (object) {
                                  chatController.isFromRequest.value = false;
                                  chatController.userRequestList
                                      .removeAt(chatController.index.value);
                                  Get.back();
                                },
                              );
                            },
                            child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFf7f7f7),
                                  border: Border.all(color: colorGrey),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorGrey.withOpacity(.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                    const BoxShadow(
                                      color: colorAppBackground,
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, -2),
                                    )
                                  ],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: const Center(child: Text("Ignore")),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
        onWillPop: () async {
          chatController.clearList();
          chatController.disconnect();
          chatController.isFromRequest.value = false;
          UserChatListResultChats chats =
              chatController.userChatList[chatController.index.value];
          chats.isNewMessage = false;
          chatController.userChatList.removeAt(chatController.index.value);
          chatController.userChatList.insert(chatController.index.value, chats);
          Navigator.pop(context, true);
          return true;
        }));
  }

  Future<bool?> _showUnBlockDialog(BuildContext context, String userId) async {
    final chatController = Get.put(ChatController());
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
                  chatController.isUserBlock.value = false;
                  UserChatListResultChats chats =
                      chatController.userChatList[chatController.index.value];
                  chats.chatDetails![0].isUserBlocked = false;
                  chatController.userChatList[chatController.index.value] =
                      chats;
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

  reportMuddaDialogBox(BuildContext context, String muddaId) {
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
                          chatController.clearList();
                          Get.back();
                        }),
                    cDivider(margin: 60),
                    commonPostText(
                        text: "Share",
                        color: colorGrey,
                        size: 13,
                        onPressed: () {}),
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

  void getMessages(BuildContext context) async {
    AppPreference appPreference = AppPreference();
    String userId = appPreference.getString(PreferencesKey.userId);
    List<Chat> tempList =
        await DBProvider.db.getChats("${chatController.userId}-$userId");
    if (tempList.length == 0) {
      chatController.isLoading.value = true;
      Api.get.call(context,
          method: "chats/${chatController.chatId}/messages",
          param: {'page': '1'},
          isLoading: false, onResponseSuccess: (Map object) async {
        chatController.isLoading.value = false;
        var result = ChatApiResponse.fromJson(object);
        result.result?.messages?.forEach((element) {
          DBProvider.db.addMessages(
            userId: "${element?.data?.senderId}",
            chatId: "${element?.data?.chatId}",
            isSend:
                element?.data?.senderId == chatController.userId ? true : false,
            lastChatId: "${element?.data?.Id}",
            message: "${element?.data?.body?.message}",
            type: 'messages',
            category: 'message',
            createdAt: '${element?.data?.createdAt}',
            ids: "${chatController.userId}-$userId",
            isGroup: false,
          );
        });
        List<Chat> tempList =
            await DBProvider.db.getChats("${chatController.userId}-$userId");
        chatController.messageList.clear();
        for (int i = 0; i < tempList.length; i++) {
          Chat result2 = tempList[i];
          Chat message = Chat(
            isSend: result2.isSend,
            isGroup: result2.isGroup,
            category: result2.category,
            chatId: result2.chatId,
            msgId: result2.msgId,
            lastChatId: result2.lastChatId,
            message: result2.message,
            userId: result2.userId,
            ids: result2.ids,
            type: result2.type,
            time: result2.time,
          );
          message.isHeader = i == tempList.length - 1 ||
              (result2.date != tempList[i + 1].date);
          message.timeStamp = result2.date;
          chatController.messageList.add(message);
        }
      });
    } else {
      chatController.messageList.clear();
      for (int i = 0; i < tempList.length; i++) {
        Chat result2 = tempList[i];
        Chat message = Chat(
          isSend: result2.isSend,
          isGroup: result2.isGroup,
          category: result2.category,
          chatId: result2.chatId,
          msgId: result2.msgId,
          lastChatId: result2.lastChatId,
          message: result2.message,
          userId: result2.userId,
          ids: result2.ids,
          type: result2.type,
          time: result2.time,
        );
        message.isHeader =
            i == tempList.length - 1 || (result2.date != tempList[i + 1].date);
        message.timeStamp = result2.date;
        if (i == 0) {
          message.isLastRead = true;
        }
        chatController.messageList.add(message);
      }
      getMessageCount(chatController.messageList.first.time!,
          isUpdateCount: false);
    }
  }

  void getPreviousMessages(BuildContext context) {
    AppPreference appPreference = AppPreference();

    String userId = appPreference.getString(PreferencesKey.userId);
    if (chatController.messageList.last.time == null) {
      return;
    } else if (lastChatId == null) {
      log('first block');
      lastChatId = '${chatController.messageList.last.time}';
      setState(() {});
      Api.get.call(context,
          method: "chats/${chatController.chatId}/messages",
          param: {
            "page": pages.toString(),
            "lastReadMessage": lastChatId,
            'messages': "prev"
          },
          isLoading: false, onResponseSuccess: (Map object) async {
        var result = ChatApiResponse.fromJson(object);
        pages++;
        if (result.result!.messages!.isNotEmpty) {
          tempList.clear();
          for (var element in result.result!.messages!) {
            tempList.add(Chat(
              isSend: element?.data?.senderId == chatController.userId ? 1 : 0,
              type: 'messages',
              category: 'message',
              userId: "${element?.data?.senderId}",
              chatId: "${element?.data?.chatId}",
              lastChatId: "${element?.data?.Id}",
              message: "${element?.data?.body?.message}",
              time: '${element?.data?.createdAt}',
              ids: "${chatController.userId}-$userId",
              isGroup: 0,
            ));
            DBProvider.db.addMessages(
              userId: "${element?.data?.senderId}",
              chatId: "${element?.data?.chatId}",
              lastChatId: "${element?.data?.Id}",
              isSend: element?.data?.senderId == chatController.userId
                  ? true
                  : false,
              message: "${element?.data?.body?.message}",
              type: 'messages',
              category: 'message',
              createdAt: '${element?.data?.createdAt}',
              ids: "${chatController.userId}-$userId",
              isGroup: false,
            );
          }
          for (int i = 0; i < tempList.length; i++) {
            Chat result2 = tempList[i];
            Chat message = Chat(
              isSend: result2.isSend,
              isGroup: result2.isGroup,
              category: result2.category,
              chatId: result2.chatId,
              msgId: result2.msgId,
              lastChatId: result2.lastChatId,
              message: result2.message,
              userId: result2.userId,
              ids: result2.ids,
              type: result2.type,
              time: result2.time,
            );
            message.isHeader = i == tempList.length - 1 ||
                (result2.date != tempList[i + 1].date);
            message.timeStamp = result2.date;
            chatController.messageList.add(message);
          }
        } else {
          pages = pages > 1 ? pages - 1 : pages;
        }
      });
    } else {
      log('second block');
      Api.get.call(context,
          method: "chats/${chatController.chatId}/messages",
          param: {
            "page": pages.toString(),
            "lastReadMessage": lastChatId,
            'messages': "prev"
          },
          isLoading: false, onResponseSuccess: (Map object) async {
        var result = ChatApiResponse.fromJson(object);
        pages++;
        if (result.result!.messages!.isNotEmpty) {
          tempList.clear();
          for (var element in result.result!.messages!) {
            tempList.add(Chat(
              isSend: element?.data?.senderId == chatController.userId ? 1 : 0,
              type: 'messages',
              category: 'message',
              userId: "${element?.data?.senderId}",
              chatId: "${element?.data?.chatId}",
              lastChatId: "${element?.data?.Id}",
              message: "${element?.data?.body?.message}",
              time: '${element?.data?.createdAt}',
              ids: "${chatController.userId}-$userId",
              isGroup: 0,
            ));
            DBProvider.db.addMessages(
              userId: "${element?.data?.senderId}",
              chatId: "${element?.data?.chatId}",
              lastChatId: "${element?.data?.Id}",
              isSend: element?.data?.senderId == chatController.userId
                  ? true
                  : false,
              message: "${element?.data?.body?.message}",
              type: 'messages',
              category: 'message',
              createdAt: '${element?.data?.createdAt}',
              ids: "${chatController.userId}-$userId",
              isGroup: false,
            );
          }
          for (int i = 0; i < tempList.length; i++) {
            Chat result2 = tempList[i];
            Chat message = Chat(
              isSend: result2.isSend,
              isGroup: result2.isGroup,
              category: result2.category,
              chatId: result2.chatId,
              msgId: result2.msgId,
              lastChatId: result2.lastChatId,
              message: result2.message,
              userId: result2.userId,
              ids: result2.ids,
              type: result2.type,
              time: result2.time,
            );
            message.isHeader = i == tempList.length - 1 ||
                (result2.date != tempList[i + 1].date);
            message.timeStamp = result2.date;
            chatController.messageList.add(message);
          }
        } else {
          pages = pages > 1 ? pages - 1 : pages;
        }
      });
    }
  }

  void getNextMessages(BuildContext context) {
    AppPreference appPreference = AppPreference();

    String userId = appPreference.getString(PreferencesKey.userId);
    if (chatController.messageList.first.time == null) {
      return;
    } else if (firstChatId == null) {
      log('first block');
      log('${chatController.messageList.first.message}');
      firstChatId = '${chatController.messageList.first.time}';
      setState(() {});
      Api.get.call(context,
          method: "chats/${chatController.chatId}/messages",
          param: {
            "page": nextPage.toString(),
            "lastReadMessage": firstChatId,
            'messages': "next"
          },
          isLoading: false, onResponseSuccess: (Map object) async {
        var result = ChatApiResponse.fromJson(object);
        nextPage++;
        if (result.result!.messages!.isNotEmpty) {
          tempList.clear();
          for (var element in result.result!.messages!) {
            tempList.add(Chat(
              isSend: element?.data?.senderId == chatController.userId ? 1 : 0,
              type: 'messages',
              category: 'message',
              userId: "${element?.data?.senderId}",
              chatId: "${element?.data?.chatId}",
              lastChatId: "${element?.data?.Id}",
              message: "${element?.data?.body?.message}",
              time: '${element?.data?.createdAt}',
              ids: "${chatController.userId}-$userId",
              isGroup: 0,
            ));
            DBProvider.db.addMessages(
              userId: "${element?.data?.senderId}",
              chatId: "${element?.data?.chatId}",
              lastChatId: "${element?.data?.Id}",
              isSend: element?.data?.senderId == chatController.userId
                  ? true
                  : false,
              message: "${element?.data?.body?.message}",
              type: 'messages',
              category: 'message',
              createdAt: '${element?.data?.createdAt}',
              ids: "${chatController.userId}-$userId",
              isGroup: false,
            );
          }
          for (int i = 0; i < tempList.length; i++) {
            Chat result2 = tempList[i];
            Chat message = Chat(
              isSend: result2.isSend,
              isGroup: result2.isGroup,
              category: result2.category,
              chatId: result2.chatId,
              msgId: result2.msgId,
              lastChatId: result2.lastChatId,
              message: result2.message,
              userId: result2.userId,
              ids: result2.ids,
              type: result2.type,
              time: result2.time,
            );
            message.isHeader = i == tempList.length - 1 ||
                (result2.date != tempList[i + 1].date);
            message.timeStamp = result2.date;
            chatController.messageList.add(message);
            chatController.messageList
                .sort((Chat a, Chat b) => b.time!.compareTo(a.time!));
            getMessageCount(chatController.messageList.first.time!,
                isUpdateCount: true);
          }
        } else {
          nextPage = nextPage > 1 ? nextPage - 1 : nextPage;
        }
      });
    } else {
      log('second block');
      log('${chatController.messageList.first.message}');
      Api.get.call(context,
          method: "chats/${chatController.chatId}/messages",
          param: {
            "page": nextPage.toString(),
            "lastReadMessage": firstChatId,
            'messages': "next"
          },
          isLoading: false, onResponseSuccess: (Map object) async {
        var result = ChatApiResponse.fromJson(object);
        nextPage++;
        if (result.result!.messages!.isNotEmpty) {
          tempList.clear();
          for (var element in result.result!.messages!) {
            tempList.add(Chat(
              isSend: element?.data?.senderId == chatController.userId ? 1 : 0,
              type: 'messages',
              category: 'message',
              userId: "${element?.data?.senderId}",
              chatId: "${element?.data?.chatId}",
              lastChatId: "${element?.data?.Id}",
              message: "${element?.data?.body?.message}",
              time: '${element?.data?.createdAt}',
              ids: "${chatController.userId}-$userId",
              isGroup: 0,
            ));
            DBProvider.db.addMessages(
              userId: "${element?.data?.senderId}",
              chatId: "${element?.data?.chatId}",
              lastChatId: "${element?.data?.Id}",
              isSend: element?.data?.senderId == chatController.userId
                  ? true
                  : false,
              message: "${element?.data?.body?.message}",
              type: 'messages',
              category: 'message',
              createdAt: '${element?.data?.createdAt}',
              ids: "${chatController.userId}-$userId",
              isGroup: false,
            );
          }
          for (int i = 0; i < tempList.length; i++) {
            Chat result2 = tempList[i];
            Chat message = Chat(
              isSend: result2.isSend,
              isGroup: result2.isGroup,
              category: result2.category,
              chatId: result2.chatId,
              msgId: result2.msgId,
              lastChatId: result2.lastChatId,
              message: result2.message,
              userId: result2.userId,
              ids: result2.ids,
              type: result2.type,
              time: result2.time,
            );
            message.isHeader = i == tempList.length - 1 ||
                (result2.date != tempList[i + 1].date);
            message.timeStamp = result2.date;
            chatController.messageList.add(message);
            chatController.messageList
                .sort((Chat a, Chat b) => b.time!.compareTo(a.time!));
            getMessageCount(chatController.messageList.first.time!,
                isUpdateCount: true);
          }
        } else {
          nextPage = nextPage > 1 ? nextPage - 1 : nextPage;
        }
      });
    }
  }

  void getAfterMessages(BuildContext context) {
    AppPreference appPreference = AppPreference();
    String userId = appPreference.getString(PreferencesKey.userId);
    Api.get.call(context,
        method: "chats/${chatController.chatId}/messages",
        param: {
          "page": '1',
          "lastReadMessage": "${chatController.messageList.first.time}",
          'messages': "next"
        },
        isLoading: false, onResponseSuccess: (Map object) async {
      var result = ChatApiResponse.fromJson(object);
      if (result.result!.messages!.isNotEmpty) {
        tempList.clear();
        for (var element in result.result!.messages!) {
          tempList.add(Chat(
            isSend: element?.data?.senderId == chatController.userId ? 1 : 0,
            type: 'messages',
            category: 'message',
            userId: "${element?.data?.senderId}",
            chatId: "${element?.data?.chatId}",
            lastChatId: "${element?.data?.Id}",
            message: "${element?.data?.body?.message}",
            time: '${element?.data?.createdAt}',
            ids: "${chatController.userId}-$userId",
            isGroup: 0,
          ));
          DBProvider.db.addMessages(
            userId: "${element?.data?.senderId}",
            chatId: "${element?.data?.chatId}",
            lastChatId: "${element?.data?.Id}",
            isSend:
                element?.data?.senderId == chatController.userId ? true : false,
            message: "${element?.data?.body?.message}",
            type: 'messages',
            category: 'message',
            createdAt: '${element?.data?.createdAt}',
            ids: "${chatController.userId}-$userId",
            isGroup: false,
          );
        }
        for (int i = 0; i < tempList.length; i++) {
          Chat result2 = tempList[i];
          Chat message = Chat(
            isSend: result2.isSend,
            isGroup: result2.isGroup,
            category: result2.category,
            chatId: result2.chatId,
            msgId: result2.msgId,
            lastChatId: result2.lastChatId,
            message: result2.message,
            userId: result2.userId,
            ids: result2.ids,
            type: result2.type,
            time: result2.time,
          );
          message.isHeader = i == tempList.length - 1 ||
              (result2.date != tempList[i + 1].date);
          message.timeStamp = result2.date;
          chatController.messageList.add(message);
          chatController.messageList
              .sort((Chat a, Chat b) => b.time!.compareTo(a.time!));
        }
      }
    });
  }

  Widget sendMessage(String messageContain, String time) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    messageContain,
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w400,
                        fontSize: ScreenUtil().setSp(15),
                        color: const Color(0xff000000)),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 4.sp,
        ),
        Text(TimeConvert.Ttime(time),
            style: size10_M_normal(textColor: colorGrey)),
      ],
    );
  }

  Widget recieveMessage(
      String? imgUrl, String userName, String messageContain, String time) {
    return Column(
      children: [
        Row(
          children: [
            imgUrl != null
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(imgUrl),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Text(
                      userName.substring(0, 1).toUpperCase(),
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              messageContain,
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: ScreenUtil().setSp(15),
                                  color: const Color(0xff000000)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.sp,
                  ),
                  Text(TimeConvert.Ttime(time),
                      style: size10_M_normal(textColor: colorGrey)),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
