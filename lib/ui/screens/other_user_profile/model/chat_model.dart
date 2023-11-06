import 'package:intl/intl.dart';

class Chat {
  int? isGroup;
  String? ids;
  String? message;
  String? type;
  String? category;
  String? chatId;
  String? userId;
  String? time;
  int? isSend;
  String? msgId;
  bool? isHeader;
  String? lastChatId;
  String? timeStamp;
  bool? isLastRead;

  Chat({
    this.isGroup,
    this.message,
    this.type,
    this.category,
    this.chatId,
    this.userId,
    this.isSend,
    this.lastChatId,
    this.time,
    this.ids,
    this.isHeader,
    this.isLastRead,
    this.msgId,
  });

  Chat.fromMap(Map<String, dynamic> map) {
    isGroup = map['isGroup'];
    message = map['message'];
    type = map['type'];
    time = map['createdAt'];
    category = map['category'];
    chatId = map['chatId'];
    isSend = map['isSend'];
    userId = map['userId'];
    lastChatId = map['lastChatId'];
    ids = map['ids'];
    msgId = map['msgId'];
  }

  String get date {
    String dateTime = DateFormat("EEE dd MMM yy").format(DateTime.parse(time!));
    String today = DateFormat("EEE dd MMM yy").format(DateTime.now());
    return dateTime == today ? "Today" : dateTime;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "isGroup": isGroup,
      "message": message,
      'type': type,
      'category': category,
      'chatId': chatId,
      'userId': userId,
      'lastChatId': lastChatId,
      '_id': ids,
      'msgId': msgId,
      'isSend': isSend,
      'createdAt': time
    };
    return map;
  }
}



class OrgChat {
  int? isGroup;
  String? ids;
  String? fullname;
  String? userName;
  String? userProfile;
  String? activity;
  String? message;
  String? type;
  String? category;
  String? chatId;
  String? userId;
  String? time;
  int? isSend;
  String? msgId;
  bool? isHeader;
  String? lastChatId;
  String? timeStamp;
  bool? isLastRead;

  OrgChat({
    this.isGroup,
    this.message,
    this.fullname,
    this.userProfile,
    this.userName,
    this.activity,
    this.type,
    this.category,
    this.chatId,
    this.userId,
    this.isSend,
    this.lastChatId,
    this.time,
    this.ids,
    this.isHeader,
    this.msgId,
    this.isLastRead,
  });

  OrgChat.fromMap(Map<String, dynamic> map) {
    isGroup = map['isGroup'];
    message = map['message'];
    userName = map['userName'];
    activity = map['activity'];
    userProfile = map['userProfile'];
    fullname= map['fullName'];
    type = map['type'];
    time = map['createdAt'];
    category = map['category'];
    chatId = map['chatId'];
    isSend = map['isSend'];
    userId = map['userId'];
    lastChatId = map['lastChatId'];
    ids = map['ids'];
    msgId = map['msgId'];
  }

  String get date {
    String dateTime = DateFormat("EEE dd MMM yy").format(DateTime.parse(time!));
    String today = DateFormat("EEE dd MMM yy").format(DateTime.now());
    return dateTime == today ? "Today" : dateTime;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>
    {
      "isGroup": isGroup,
      "message": message,
      'userName':userName,
      'userProfile': userProfile,
      'fullName': fullname,
      'activity': activity,
      'type': type,
      'category': category,
      'chatId': chatId,
      'userId': userId,
      'lastChatId': lastChatId,
      '_id': ids,
      'msgId': msgId,
      'isSend': isSend,
      'createdAt': time
    };
    return map;
  }
}