import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mudda/core/constant/app_colors.dart';
import 'package:mudda/core/constant/app_icons.dart';
import 'package:mudda/core/local/DatabaseProvider.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/dio/api/api.dart';
import 'package:mudda/model/support_chat.dart';
import 'package:mudda/ui/screens/home_screen/controller/mudda_fire_news_controller.dart';
import 'package:mudda/ui/screens/other_user_profile/controller/ChatController.dart';
import 'package:mudda/ui/shared/report_post_dialog_box.dart';
import 'package:mudda/core/utils/text_style.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/time_convert.dart';
import '../../../../model/SupportChatOfflineModel.dart';


class RaisingMuddaChatScreen extends GetView<ChatController> {
  RaisingMuddaChatScreen({Key? key}) : super(key: key);
  ChatController chatController = Get.put(ChatController());
  MuddaNewsController muddaNewsController = Get.put(MuddaNewsController());
  ScrollController chatScrollController = ScrollController();
  String message = '';
  int pages = 1;

  @override
  Widget build(BuildContext context) {

    if (chatController.chatId == null) {
    } else {
      getMessages(context);
    }
    chatScrollController.addListener(() {
      if (chatScrollController.position.maxScrollExtent ==
          chatScrollController.position.pixels) {
        getPreviousMessages(context);
      }
    });

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            chatController.clearList();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Text(
                            chatController.userName!
                                .substring(0, 1)
                                .toUpperCase(),
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              chatController.userName ?? '',
                              style: size18_M_normal(textColor: Colors.black),
                            ),
                          ],
                        ),
                        Spacer(),
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
              ListView.builder(
                  controller: chatScrollController,
                  reverse: true,
                  itemCount: chatController.adminMessageList.length,
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(90)),
                  itemBuilder: (context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Visibility(child: Text(chatController.adminMessageList[index].timeStamp != null ? "${chatController.adminMessageList[index].timeStamp}" : ""),
                              visible: chatController.adminMessageList[index].isHeader!),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: chatController.adminMessageList[index].userId == AppPreference().getString(PreferencesKey.userId)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (chatController
                                  .adminMessageList[index].userId == AppPreference().getString(PreferencesKey.userId))
                                Expanded(
                                    child: sendMessage(
                                        "${chatController.adminMessageList[index].message}",
                                        "${chatController.adminMessageList[index].time}"))
                              else Expanded(child: recieveMessage("${chatController.adminMessageList[index].message}", "${chatController.adminMessageList[index].time}"))
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  }),
              Positioned(
                left: 30,
                right: 30,
                bottom: 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                style: size13_M_normal(textColor: color606060),
                                cursorHeight: 15,
                                controller: chatController.msgController,
                                textInputAction: TextInputAction.send,
                                onFieldSubmitted: (v) {
                                  sendMessageApi(context,chatController.msgController.text);
                                  chatController.msgController.clear();
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 15, left: 15),
                                  hintStyle:
                                  size13_M_normal(textColor: color606060),
                                  hintText: "Type your message",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            getSizedBox(w: 10)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessageApi(context,chatController.msgController.text);
                        chatController.msgController.clear();
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
              // Positioned(
              //   bottom: 100,
              //   left: 100,
              //   right: 100,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Container(
              //           height: 35,
              //           decoration: BoxDecoration(
              //             color: const Color(0xFFf7f7f7),
              //             border: Border.all(color: colorGrey),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: colorGrey.withOpacity(.5),
              //                 spreadRadius: 2,
              //                 blurRadius: 5,
              //                 offset: const Offset(0, 2),
              //               ),
              //               const BoxShadow(
              //                 color: colorAppBackground,
              //                 spreadRadius: 2,
              //                 blurRadius: 5,
              //                 offset: Offset(0, -2),
              //               )
              //             ],
              //             borderRadius: const BorderRadius.all(
              //               Radius.circular(5),
              //             ),
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 10),
              //             child: Center(child: Text("Accept")),
              //           )),
              //       Container(
              //           height: 35,
              //           decoration: BoxDecoration(
              //             color: const Color(0xFFf7f7f7),
              //             border: Border.all(color: colorGrey),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: colorGrey.withOpacity(.5),
              //                 spreadRadius: 2,
              //                 blurRadius: 5,
              //                 offset: const Offset(0, 2),
              //               ),
              //               const BoxShadow(
              //                 color: colorAppBackground,
              //                 spreadRadius: 2,
              //                 blurRadius: 5,
              //                 offset: Offset(0, -2),
              //               )
              //             ],
              //             borderRadius: const BorderRadius.all(
              //               Radius.circular(5),
              //             ),
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 10),
              //             child: Center(child: Text("Ignore")),
              //           )),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
        onWillPop: () async {
          chatController.clearList();
          Navigator.pop(context, true);
          return true;
        }));
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
    List<SupportOfflineChat> tempList =
    await DBProvider.db.getAdminChats("${chatController.chatId}");


    if(tempList.length==0)
    {
      Api.get.call(context,
          method: "chats/admin-messages",
          param: {
            'muddaId': chatController.isFromChat.value ?chatController.muddaId: muddaNewsController.muddaPost.value.sId,
          },
          isLoading: true, onResponseSuccess: (Map object) async {
            var result = SupportChat.fromJson(object);
            result.result?.forEach((element) {
              DBProvider.db.addAdminMessages(
                userId: "${element.data?.senderId}",
                chatId: "${element.data?.chatId}",
                isSend: element.data?.senderId == chatController.userId ? true : false,
                lastChatId: "${element.data?.Id}",
                message: "${element.data?.body?.message}",
                type: 'messages',
                createdAt: '${element.data?.createdAt}',
                ids: "${chatController.userId}-$userId",
              );
            });
            List<SupportOfflineChat> tempList =
            await DBProvider.db.getAdminChats("${chatController.chatId}");
            chatController.adminMessageList.clear();
            for (int i = 0; i < tempList.length; i++) {
              SupportOfflineChat result2 = tempList[i];
              SupportOfflineChat message = SupportOfflineChat(
                isSend: result2.isSend,
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
              chatController.adminMessageList.add(message);
            }
          });
    }
    else{
      chatController.adminMessageList.clear();
      for (int i = 0; i < tempList.length; i++) {

        SupportOfflineChat result2 = tempList[i];
        SupportOfflineChat message = SupportOfflineChat(
          isSend: result2.isSend,
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
        chatController.adminMessageList.add(message);
      }
      Api.get.call(context,
          method: "chats/admin-messages",
          param: {
            'muddaId': chatController.isFromChat.value ?chatController.muddaId: muddaNewsController.muddaPost.value.sId,
          },
          isLoading: false, onResponseSuccess: (Map object) async {
            var result = SupportChat.fromJson(object);
            result.result?.forEach((element) {
              DBProvider.db.addAdminMessages(
                userId: "${element.data?.senderId}",
                chatId: "${element.data?.chatId}",
                isSend: element.data?.senderId == chatController.userId ? true : false,
                lastChatId: "${element.data?.Id}",
                message: "${element.data?.body?.message}",
                type: 'messages',
                createdAt: '${element.data?.createdAt}',
                ids: "${chatController.userId}-$userId",
              );
            });
            List<SupportOfflineChat> tempList =
            await DBProvider.db.getAdminChats("${chatController.chatId}");
            chatController.adminMessageList.clear();
            for (int i = 0; i < tempList.length; i++) {
              SupportOfflineChat result2 = tempList[i];
              SupportOfflineChat message = SupportOfflineChat(
                isSend: result2.isSend,
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
              chatController.adminMessageList.add(message);
            }
          });
    }

  }
  void getPreviousMessages(BuildContext context) {
    AppPreference appPreference = AppPreference();

    String userId = appPreference.getString(PreferencesKey.userId);
    chatController.adminMessageList.last.lastChatId == null
        ? null
        : Api.get.call(context,
        method: "chats/admin-messages",
        param: {
          "page": '1',
          'muddaId': chatController.isFromChat.value ?chatController.muddaId: muddaNewsController.muddaPost.value.sId,
          "lastReadMessage": chatController.adminMessageList.last.lastChatId,
          'messages': "prev"
        },
        isLoading: false, onResponseSuccess: (Map object) async {
          var result = SupportChat.fromJson(object);
          if (result.result!.isNotEmpty) {
            result.result?.forEach((element) {
              DBProvider.db.addAdminMessages(
                userId: "${element.data?.senderId}",
                chatId: "${element.data?.chatId}",
                lastChatId: "${element.data?.Id}",
                isSend:
                element.data?.senderId == chatController.userId ? true : false,
                message: "${element.data?.body?.message}",
                type: 'messages',
                createdAt: '${element.data?.createdAt}',
                ids: "${chatController.userId}-$userId",
              );
            });
            List<SupportOfflineChat> tempList =
            await DBProvider.db.getAdminChats("${chatController.chatId}");
            chatController.adminMessageList.clear();
            for (int i = 0; i < tempList.length; i++) {
              SupportOfflineChat result2 = tempList[i];
              SupportOfflineChat message = SupportOfflineChat(
                isSend: result2.isSend,
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
              chatController.adminMessageList.add(message);
            }
          }
        });
  }
  void sendMessageApi(BuildContext context, String msg){
    Api.post.call(
      context,
      method: "chats/sendMessage",
      isLoading: false,
      param: {
        "chatId":
        "${chatController.admin.value.chatId ?? chatController.chatId}",
        "type":"message",
        "message":msg
      },
      onResponseSuccess: (object) {
        print('Message sent');
        AppPreference appPreference = AppPreference();
        String userId = appPreference.getString(PreferencesKey.userId);
        chatController.adminMessageList.insert(0, SupportOfflineChat(
          userId: userId,
          isSend: 0,
          time: DateTime.now().toLocal().toString(),
          message: msg,
          type: 'message',
          chatId: chatController.admin.value.chatId,
          isHeader: false,
        ));
      },
    );
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
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(messageContain),
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
  Widget recieveMessage(String messageContain, String time) {
    return  Column(
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
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(messageContain),
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
}