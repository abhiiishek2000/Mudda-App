import 'package:mudda/model/MuddaPostModel.dart';

import 'UserSuggestionsModel.dart';

class UserJoinLeadersModel {
  int? status;
  String? message;
  List<JoinLeader>? data;
  String? path;

  UserJoinLeadersModel({this.status, this.message, this.data, this.path});

  UserJoinLeadersModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <JoinLeader>[];
      json['data'].forEach((v) {
        data!.add(JoinLeader.fromJson(v));
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

class JoinLeader {
  String? sId;
  String? userId;
  String? requestToUserId;
  String? joiningContentId;
  String? acceptType;
  String? joinerType;
  int? userIdentity;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  AcceptUserDetail? user;

  JoinLeader(
      {this.sId,
        this.userId,
        this.requestToUserId,
        this.joiningContentId,
        this.acceptType,
        this.joinerType,
        this.userIdentity,
        this.status,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.user});

  JoinLeader.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    requestToUserId = json['request_to_user_id'];
    joiningContentId = json['joining_content_id'];
    acceptType = json['accept_type'];
    joinerType = json['joiner_type'];
    userIdentity = json['user_identity'];
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    user = json['request_user'] != null ? AcceptUserDetail.fromJson(json['request_user']) : json['user'] != null ? AcceptUserDetail.fromJson(json['user']): json['userDetail'] != null ? AcceptUserDetail.fromJson(json['userDetail']):null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['request_to_user_id'] = this.requestToUserId;
    data['joining_content_id'] = this.joiningContentId;
    data['accept_type'] = this.acceptType;
    data['joiner_type'] = this.joinerType;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.user != null) {
      data['request_user'] = this.user!.toJson();
    }
    return data;
  }
}

