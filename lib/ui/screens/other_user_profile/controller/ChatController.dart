import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/const/const.dart';
import 'package:mudda/core/preferences/preference_manager.dart';
import 'package:mudda/core/preferences/preferences_key.dart';
import 'package:mudda/model/SupportChatOfflineModel.dart';
import 'package:mudda/ui/screens/other_user_profile/model/user_chat_list_model.dart';
import 'package:socket_io_client/socket_io_client.dart'  as IO;
import '../../../../model/UserRequestList.dart';
import '../../../../model/support_chat.dart';
import '../model/chat_model.dart';

class ChatController extends GetxController {
  static late IO.Socket socket;
  RxList<Chat> messageList = <Chat>[].obs;
  RxList<OrgChat> orgMessageList = <OrgChat>[].obs;
  RxBool isLoadingChat = false.obs;
  RxBool isLoading = false.obs;
  RxBool isArrowIconShow = false.obs;
  RxBool isRequestSelected = false.obs;
  RxBool isFromRequest = false.obs;
  RxBool isFromChat = false.obs;
  RxInt index = 0.obs;
  String? userName;
  String? profile;
  RxBool isUserBlock=false.obs;
  String? userId;
  String? muddaId;
  String? chatId;
  RxInt messageCount = 0.obs;
  RxList<SupportOfflineChat> adminMessageList = <SupportOfflineChat>[].obs;
  RxList<UserChatListResultChats> userChatList = <UserChatListResultChats>[].obs;
  Rx<UserChatListResultChats> userChatDetails =UserChatListResultChats().obs;
  RxList<UserRequestListResultData> userRequestList = <UserRequestListResultData>[].obs;
  Rx<UserRequestListResultData> userRequestDetails =UserRequestListResultData().obs;
  Rx<SupportChatResultData> admin = SupportChatResultData().obs;
  RxInt page = 1.obs;
  TextEditingController msgController = TextEditingController();



  void sendMessage(String message, String userId, String chatId) {
    AppPreference appPreference = AppPreference();
    socket.emit(
      'sendMessage',
      {
        "isGroup": false,
        "body": {
          "type": "message",
          "message": message
        },
        "category": "conversation",
        "chatId": chatId == 'null' ? null : chatId,
        "userId": userId
      },
    );

    messageList.insert(
        0,
        Chat(
          isGroup: 0,
          userId: userId,
          isSend: 0,
          time: DateTime.now().toLocal().toString(),
          message: message,
          type: 'message',
          chatId: chatId,
          isHeader: false,
          category: 'conservation',
        ));

    update();
  }

  void connectAndListen() {
    AppPreference appPreference = AppPreference();

    socket = IO.io(
        Const.shareUrl,
        IO.OptionBuilder()
            .enableReconnection()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .setExtraHeaders({
          'Authorization': appPreference.getString(PreferencesKey.userToken),
        }).build());


    socket.connect();

    socket.onConnect((_) {
      print('connect');
    });
    print('connect:::${socket.connected}');

    socket.onDisconnect((_) {
      print("disconnect");
    });

    socket.onConnectError((data) {
      print("ConnectError:::$data");
      socket.connect();
    });
    socket.onError((data) {
      print("Error:::$data");
    });
    socket.onConnectTimeout((data) {
      print("ConnectTimeout:::$data");
      socket.connect();
    });
    socket.on('receiveMessage', (data) {
      print("receiveMessage:::$data");
      data.forEach((v) {
        messageList.insert(0,Chat(
          isGroup: 0,
          userId: v['senderId'],
          isSend: 1,
          lastChatId: v['_id'],
          message: v['body']['message'],
          type: "message",
          isHeader: false,
          time: DateTime.now().toLocal().toString(),
          chatId: v['chatId'],
          category: 'conservation',
        ));

      });
    });
  }

  void clearList(){
    messageList.clear();
    adminMessageList.clear();
    print('data cleared');
    update();
  }

  void disconnect(){
    socket.dispose();
    socket.destroy();
    socket.close();
    socket.disconnect();
  }


}