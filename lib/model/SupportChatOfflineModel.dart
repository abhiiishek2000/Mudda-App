

import 'package:intl/intl.dart';

class SupportOfflineChat {
  String? ids;
  String? message;
  String? type;
  String? chatId;
  String? userId;
  String? time;
  String? lastChatId;
  int? isSend;
  String? msgId;
  bool? isHeader;
  String? timeStamp;

  SupportOfflineChat({
    this.message,
    this.type,
    this.chatId,
    this.userId,
    this.isSend,
    this.time,
    this.ids,
    this.lastChatId,
    this.isHeader,
    this.msgId,
  });
  SupportOfflineChat.fromMap(Map<String, dynamic> map) {
    message = map['message'];
    type = map['type'];
    time = map['createdAt'];
    chatId = map['chatId'];
    isSend = map['isSend'];
    lastChatId = map['lastChatId'];
    userId = map['userId'];
    ids = map['ids'];
    msgId = map['msgId'];
  }

  String get date {
    String dateTime = DateFormat("EEE dd MMM yy").format(DateTime.parse(time!));
    String today = DateFormat("EEE dd MMM yy").format(DateTime.now());
    return dateTime == today ?"Today":dateTime;
  }


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{"message": message,'lastChatId':lastChatId,'type':type,'chatId' : chatId,'userId' : userId,'_id':ids,'isSend':isSend,'createdAt':time};
    return map;
  }
}
