
class SupportChatResultDataUser {

  String? Id;
  String? name;

  SupportChatResultDataUser({
    this.Id,
    this.name,
  });
  SupportChatResultDataUser.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    name = json['name']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['name'] = name;
    return data;
  }
}

class SupportChatResultDataBody {
/*
{
  "type": "message",
  "message": "This is test suggestion - 1"
}
*/

  String? type;
  String? message;

  SupportChatResultDataBody({
    this.type,
    this.message,
  });
  SupportChatResultDataBody.fromJson(Map<String, dynamic> json) {
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

class SupportChatResultData {

  String? Id;
  String? senderId;
  SupportChatResultDataBody? body;
  String? chatId;
  String? createdAt;
  String? updatedAt;
  List<SupportChatResultDataUser?>? user;
  String? type;

  SupportChatResultData({
    this.Id,
    this.senderId,
    this.body,
    this.chatId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.type,
  });
  SupportChatResultData.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    senderId = json['senderId']?.toString();
    body = (json['body'] != null) ? SupportChatResultDataBody.fromJson(json['body']) : null;
    chatId = json['chatId']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    if (json['user'] != null) {
      final v = json['user'];
      final arr0 = <SupportChatResultDataUser>[];
      v.forEach((v) {
        arr0.add(SupportChatResultDataUser.fromJson(v));
      });
      user = arr0;
    }
    type = json['type']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['senderId'] = senderId;
    if (body != null) {
      data['body'] = body!.toJson();
    }
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

class SupportChatResult {


  SupportChatResultData? data;

  SupportChatResult({
    this.data,
  });
  SupportChatResult.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null) ? SupportChatResultData.fromJson(json['data']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SupportChat {


  List<SupportChatResult>? result;
  String? message;
  bool? success;
  int? status;

  SupportChat({
    this.result,
    this.message,
    this.success,
    this.status,
  });
  SupportChat.fromJson(Map<dynamic, dynamic> json) {
    if (json['result'] != null) {
      final v = json['result'];
      final arr0 = <SupportChatResult>[];
      v.forEach((v) {
        arr0.add(SupportChatResult.fromJson(v));
      });
      result = arr0;
    }
    message = json['message']?.toString();
    success = json['success'];
    status = json['status']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (result != null) {
      final v = result;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v.toJson());
      });
      data['result'] = arr0;
    }
    data['message'] = message;
    data['success'] = success;
    data['status'] = status;
    return data;
  }
}
