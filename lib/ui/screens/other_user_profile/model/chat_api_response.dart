class ChatApiResponseResultMessagesDataUser {


  String? Id;
  String? fullname;
  String? profile;
  String? username;

  ChatApiResponseResultMessagesDataUser({
    this.Id,
    this.fullname,
    this.profile,
    this.username,
  });
  ChatApiResponseResultMessagesDataUser.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    fullname = json['fullname']?.toString();
    profile = json['profile']?.toString();
    username = json['username']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['fullname'] = fullname;
    data['profile'] = profile;
    data['username'] = username;
    return data;
  }
}

class ChatApiResponseResultMessagesDataBody {


  String? type;
  String? message;


  ChatApiResponseResultMessagesDataBody({
    this.type,
    this.message,
  });
  ChatApiResponseResultMessagesDataBody.fromJson(Map<String, dynamic> json) {
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

class ChatApiResponseResultMessagesData {
/*
{
  "_id": "633a99e22b2817bcef43c354",
  "senderId": "6336a21cb552d25ee12434f4",
  "body": {
    "type": "message",
    "message": "hii",
    "media": [
      null
    ]
  },
  "quote": null,
  "chatId": "63380e996ff3727329ba98c7",
  "tags": [
    null
  ],
  "createdAt": "2022-10-03T08:14:26.174Z",
  "updatedAt": "2022-10-03T08:14:26.174Z",
  "user": [
    {
      "_id": "6336a21cb552d25ee12434f4",
      "fullname": "Abhishek Kumar",
      "profile": "1664526575732.jpg"
    }
  ],
  "type": "message"
}
*/

  String? Id;
  String? senderId;
  String? activity;
  ChatApiResponseResultMessagesDataBody? body;
  String? quote;
  String? chatId;
  String? createdAt;
  String? updatedAt;
  List<ChatApiResponseResultMessagesDataUser?>? user;
  String? type;

  ChatApiResponseResultMessagesData({
    this.Id,
    this.senderId,
    this.activity,
    this.body,
    this.quote,
    this.chatId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.type,
  });
  ChatApiResponseResultMessagesData.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    senderId = json['senderId']?.toString();
    activity = json['activity']?.toString();
    body = (json['body'] != null) ? ChatApiResponseResultMessagesDataBody.fromJson(json['body']) : null;
    quote = json['quote']?.toString();
    chatId = json['chatId']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    if (json['user'] != null) {
    final v = json['user'];
    final arr0 = <ChatApiResponseResultMessagesDataUser>[];
    v.forEach((v) {
    arr0.add(ChatApiResponseResultMessagesDataUser.fromJson(v));
    });
    user = arr0;
    }
    type = json['type']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['senderId'] = senderId;
    data['activity'] = activity;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    data['quote'] = quote;
    data['chatId'] = chatId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) {
    final v = user;
    final arr0 = [];
    v!.forEach((v) {
    arr0.add(v!.toJson());
    });
    data['user'] = arr0;
    }
    data['type'] = type;
    return data;
  }
}

class ChatApiResponseResultMessages {


  ChatApiResponseResultMessagesData? data;

  ChatApiResponseResultMessages({
    this.data,
  });
  ChatApiResponseResultMessages.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null) ? ChatApiResponseResultMessagesData.fromJson(json['data']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ChatApiResponseResult {

  List<ChatApiResponseResultMessages?>? messages;
  int? count;

  ChatApiResponseResult({
    this.messages,
    this.count,
  });
  ChatApiResponseResult.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      final v = json['messages'];
      final arr0 = <ChatApiResponseResultMessages>[];
      v.forEach((v) {
        arr0.add(ChatApiResponseResultMessages.fromJson(v));
      });
      messages = arr0;
    }
    count = json['count']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (messages != null) {
      final v = messages;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['messages'] = arr0;
    }
    data['count'] = count;
    return data;
  }
}

class ChatApiResponse {


  ChatApiResponseResult? result;
  String? message;
  bool? success;

  ChatApiResponse({
    this.result,
    this.message,
    this.success,
  });
  ChatApiResponse.fromJson(Map<dynamic, dynamic> json) {
    result = (json['result'] != null) ? ChatApiResponseResult.fromJson(json['result']) : null;
    message = json['message']?.toString();
    success = json['success'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}
