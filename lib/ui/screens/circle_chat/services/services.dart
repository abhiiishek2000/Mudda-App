import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudda/core/local/DatabaseProvider.dart';
import 'package:mudda/ui/screens/other_user_profile/controller/ChatController.dart';
import '../../../../core/preferences/preference_manager.dart';
import '../../../../core/preferences/preferences_key.dart';
import '../../../../dio/Api/Api.dart';
import '../../other_user_profile/model/user_chat_list_model.dart';

class ChatService extends GetxController {
  RxBool isAvailable = false.obs;

  Future<bool> isNewMessageAvailable(
      BuildContext context, ChatController _chatController) async {
    Api.get.call(context,
        method: "chats/me",
        param: {
          'page': '1',
          "lastReadNotification":
              AppPreference().getString(PreferencesKey.notificationId) == ''
                  ? null
                  : AppPreference().getString(PreferencesKey.notificationId)
        },
        isLoading: false,
        onProgress: (double progress) {},
        onResponseSuccess: (Map object) async {
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
                  isAvailable.value = true;
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
                  isAvailable.value = true;
                } else {
                  chats.isNewMessage = false;
                }
              } else {
                chats.isNewMessage = false;
              }
            }
          }
        }
      }
    });
    return isAvailable.value;
  }
}
