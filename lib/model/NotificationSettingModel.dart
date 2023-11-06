class NotificationSettingModel {
  int? status;
  String? message;
  List<NotificationSetting>? data;
  String? path;

  NotificationSettingModel({this.status, this.message, this.data, this.path});

  NotificationSettingModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationSetting>[];
      json['data'].forEach((v) { data!.add(NotificationSetting.fromJson(v)); });
    }
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    return data;
  }
}

class NotificationSetting {
  String? sId;
  String? notificationTypeId;
  String? userId;
  int? iV;
  String? createdAt;
  bool? deleted;
  int? status;
  String? updatedAt;
  NotificationType? notificationType;
  String? id;

  NotificationSetting({this.sId, this.notificationTypeId, this.userId, this.iV, this.createdAt, this.deleted, this.status, this.updatedAt, this.notificationType, this.id});

  NotificationSetting.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    notificationTypeId = json['notificationTypeId'];
    userId = json['userId'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    deleted = json['deleted'];
    status = json['status'];
    updatedAt = json['updatedAt'];
    notificationType = json['notificationType'] != null ? new NotificationType.fromJson(json['notificationType']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['notificationTypeId'] = this.notificationTypeId;
    data['userId'] = this.userId;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['deleted'] = this.deleted;
    data['status'] = this.status;
    data['updatedAt'] = this.updatedAt;
    if (this.notificationType != null) {
      data['notificationType'] = this.notificationType!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class NotificationType {
  String? sId;
  String? name;
  String? icon;
  int? defaultValue;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  NotificationType({this.sId, this.name, this.icon, this.defaultValue, this.status, this.deleted, this.createdAt, this.updatedAt, this.iV, this.id});

NotificationType.fromJson(Map<String, dynamic> json) {
sId = json['_id'];
name = json['name'];
icon = json['icon'];
defaultValue = json['default'];
status = json['status'];
deleted = json['deleted'];
createdAt = json['createdAt'];
updatedAt = json['updatedAt'];
iV = json['__v'];
id = json['id'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['_id'] = this.sId;
  data['name'] = this.name;
  data['icon'] = this.icon;
  data['default'] = this.defaultValue;
  data['status'] = this.status;
  data['deleted'] = this.deleted;
  data['createdAt'] = this.createdAt;
  data['updatedAt'] = this.updatedAt;
  data['__v'] = this.iV;
  data['id'] = this.id;
  return data;
}
}
