
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class UserRequestListResultDataLastMessageSender {

  String? Id;
  String? fullname;
  String? profile;

  UserRequestListResultDataLastMessageSender({
    this.Id,
    this.fullname,
    this.profile,
  });
  UserRequestListResultDataLastMessageSender.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    fullname = json['fullname']?.toString();
    profile = json['profile']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['fullname'] = fullname;
    data['profile'] = profile;
    return data;
  }
}

class UserRequestListResultDataLastMessageBody {

  String? type;
  String? message;

  UserRequestListResultDataLastMessageBody({
    this.type,
    this.message,
  });
  UserRequestListResultDataLastMessageBody.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    message = json['message']?.toString();
    }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['message'] = message;
    return data;
  }
}

class UserRequestListResultDataLastMessage {
  String? Id;
  UserRequestListResultDataLastMessageBody? body;
  String? quote;
  String? chatId;
  String? timeStamp;
  String? time;
  String? createdAt;
  String? updatedAt;
  List<UserRequestListResultDataLastMessageSender?>? sender;

  UserRequestListResultDataLastMessage({
    this.Id,
    this.body,
    this.quote,
    this.chatId,
    this.timeStamp,
    this.time,
    this.createdAt,
    this.updatedAt,
    this.sender,
  });
  String get caldate {
    String dateTime = DateFormat("EEE dd MMM yy").format(DateTime.parse(createdAt!));
    String today = DateFormat("EEE dd MMM yy").format(DateTime.now());
    return dateTime == today ?"Today":dateTime;
  }
  String get caltime {
    String time = Jiffy(createdAt!).Hm;
    return time;
  }
  UserRequestListResultDataLastMessage.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    body = (json['body'] != null) ? UserRequestListResultDataLastMessageBody.fromJson(json['body']) : null;
    quote = json['quote']?.toString();
    chatId = json['chatId']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    if (json['sender'] != null) {
    final v = json['sender'];
    final arr0 = <UserRequestListResultDataLastMessageSender>[];
    v.forEach((v) {
    arr0.add(UserRequestListResultDataLastMessageSender.fromJson(v));
    });
    sender = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    data['quote'] = quote;
    data['chatId'] = chatId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (sender != null) {
    final v = sender;
    final arr0 = [];
    v!.forEach((v) {
    arr0.add(v!.toJson());
    });
    data['sender'] = arr0;
    }
    return data;
  }
}

class UserRequestListResultDataChatDetailsUserDetails {


  String? Id;
  String? fullname;
  String? profile;

  UserRequestListResultDataChatDetailsUserDetails({
    this.Id,
    this.fullname,
    this.profile,
  });
  UserRequestListResultDataChatDetailsUserDetails.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    fullname = json['fullname']?.toString();
    profile = json['profile']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['fullname'] = fullname;
    data['profile'] = profile;
    return data;
  }
}

class UserRequestListResultDataChatDetails {


  String? Id;
  String? title;
  bool? isGroup;
  String? category;
  bool? isClosed;
  String? muddaId;
  String? orgId;
  String? stageId;
  int? groupLimit;
  String? icon;
  String? muddaCat;
  String? createdAt;
  String? updatedAt;
  UserRequestListResultDataChatDetailsUserDetails? userDetails;

  UserRequestListResultDataChatDetails({
    this.Id,
    this.title,
    this.isGroup,
    this.category,
    this.isClosed,
    this.muddaId,
    this.orgId,
    this.stageId,
    this.groupLimit,
    this.icon,
    this.muddaCat,
    this.createdAt,
    this.updatedAt,
    this.userDetails,
  });
  UserRequestListResultDataChatDetails.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    title = json['title']?.toString();
    isGroup = json['isGroup'];
    category = json['category']?.toString();
    isClosed = json['isClosed'];
    muddaId = json['muddaId']?.toString();
    orgId = json['orgId']?.toString();
    stageId = json['stageId']?.toString();
    groupLimit = json['groupLimit']?.toInt();
    icon = json['icon']?.toString();
    muddaCat = json['muddaCat']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    userDetails = (json['userDetails'] != null) ? UserRequestListResultDataChatDetailsUserDetails.fromJson(json['userDetails']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['title'] = title;
    data['isGroup'] = isGroup;
    data['category'] = category;
    data['isClosed'] = isClosed;
    data['muddaId'] = muddaId;
    data['orgId'] = orgId;
    data['stageId'] = stageId;
    data['groupLimit'] = groupLimit;
    data['icon'] = icon;
    data['muddaCat'] = muddaCat;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (userDetails != null) {
      data['userDetails'] = userDetails!.toJson();
    }
    return data;
  }
}

class UserRequestListResultData {


  String? Id;
  String? chatId;
  String? userId;
  String? role;
  String? timeStamp;
  String? time;
  String? joinDate;
  String? createdAt;
  String? updatedAt;
  List<UserRequestListResultDataChatDetails>? chatDetails;
  UserRequestListResultDataLastMessage? lastMessage;
  int? totalMessages;

  UserRequestListResultData({
    this.Id,
    this.chatId,
    this.userId,
    this.role,
    this.time,
    this.timeStamp,
    this.joinDate,
    this.createdAt,
    this.updatedAt,
    this.chatDetails,
    this.lastMessage,
    this.totalMessages,
  });

  UserRequestListResultData.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    chatId = json['chatId']?.toString();
    userId = json['userId']?.toString();
    role = json['role']?.toString();
    joinDate = json['joinDate']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    if (json['chatDetails'] != null) {
      final v = json['chatDetails'];
      final arr0 = <UserRequestListResultDataChatDetails>[];
      v.forEach((v) {
        arr0.add(UserRequestListResultDataChatDetails.fromJson(v));
      });
      chatDetails = arr0;
    }
    lastMessage = (json['lastMessage'] != null) ? UserRequestListResultDataLastMessage.fromJson(json['lastMessage']) : null;
    totalMessages = json['totalMessages']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['chatId'] = chatId;
    data['userId'] = userId;
    data['role'] = role;
    data['joinDate'] = joinDate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (chatDetails != null) {
      final v = chatDetails;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v.toJson());
      });
      data['chatDetails'] = arr0;
    }
    if (lastMessage != null) {
      data['lastMessage'] = lastMessage!.toJson();
    }
    data['totalMessages'] = totalMessages;
    return data;
  }
}

class UserRequestListResult {


  List<UserRequestListResultData>? data;
  int? count;

  UserRequestListResult({
    this.data,
    this.count,
  });
  UserRequestListResult.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <UserRequestListResultData>[];
      v.forEach((v) {
        arr0.add(UserRequestListResultData.fromJson(v));
      });
      this.data = arr0;
    }
    count = json['count']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v.toJson());
      });
      data['data'] = arr0;
    }
    data['count'] = count;
    return data;
  }
}

class UserRequestList {


  UserRequestListResult? result;
  String? message;
  bool? success;
  bool? notifications;
  int? status;

  UserRequestList({
    this.result,
    this.message,
    this.success,
    this.notifications,
    this.status,
  });
  UserRequestList.fromJson(Map<dynamic, dynamic> json) {
    result = (json['result'] != null) ? UserRequestListResult.fromJson(json['result']) : null;
    message = json['message']?.toString();
    success = json['success'];
    if(json['notifications']!=null){
      notifications = json['notifications'];
    }

    status = json['status']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['message'] = message;
    data['success'] = success;
    data['status'] = status;
    if(notifications !=null){
      data['notifications'] = notifications;
    }
    return data;
  }
}
