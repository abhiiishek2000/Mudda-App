class NotificationModel {
  int? status;
  String? message;
  List<NotificationData>? data;
  String? path;

  NotificationModel({this.status, this.message, this.data, this.path});

  NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
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

class NotificationData {
  String? sId;
  String? storeId;
  String? targetId;
  String? type;
  String? action;
  String? body;
  String? title;
  String? data;
  String? postType;
  String? orgName;
  String? source;
  String? sourceId;
  String? sourceMedia;
  String? sourceType;
  String? targetMedia;
  String? targetMediaPath;
  String? userId;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  String? durationTime;
  int? iV;
  String? id;
  int? isVerify;

  NotificationData(
      {this.sId,
      this.storeId,
      this.targetId,
      this.type,
      this.action,
      this.body,
      this.title,
      this.data,
      this.postType,
      this.source,
      this.sourceId,
      this.sourceMedia,
      this.sourceType,
      this.targetMedia,
      this.targetMediaPath,
      this.userId,
      this.orgName,
      this.status,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.durationTime,
      this.iV,
      this.isVerify,
      this.id});

  NotificationData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    storeId = json['storeId'];
    targetId = json['targetId'];
    type = json['type'];
    action = json['action'];
    body = json['body'];
    data = json['data'];
    title = json['title'];
    orgName = json['orgName'];
    postType = json['postType'];
    source = json['source'];
    sourceId = json['sourceId'];
    sourceMedia = json['sourceMedia'];
    sourceType = json['sourceType'];
    targetMedia = json['targetMedia'];
    targetMediaPath = json['targetMediaPath'];
    userId = json['userId'];
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
    isVerify = json['isVerify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['storeId'] = this.storeId;
    data['targetId'] = this.targetId;
    data['type'] = this.type;
    data['action'] = this.action;
    data['body'] = this.body;
    data['data'] = this.data;
    data['title'] = this.title;
    data['orgName'] = this.orgName;
    data['postType'] = this.postType;
    data['source'] = this.source;
    data['sourceId'] = this.sourceId;
    data['sourceMedia'] = this.sourceMedia;
    data['sourceType'] = this.sourceType;
    data['targetMedia'] = this.targetMedia;
    data['targetMediaPath'] = this.targetMediaPath;
    data['userId'] = this.userId;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    data['isVerify'] = this.isVerify;
    return data;
  }
}
