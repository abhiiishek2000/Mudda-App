import 'package:mudda/model/MuddaPostModel.dart';

class MembersDataModel {
  int? status;
  String? message;
  List<MemberModel>? data;
  String? path;

  MembersDataModel({this.status, this.message, this.data, this.path});

  MembersDataModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MemberModel>[];
      json['data'].forEach((v) {
        data!.add(MemberModel.fromJson(v));
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

class MemberModel {
  String? sId;
  String? userId;
  String? organizationId;
  String? organizationType;
  String? position;
  String? role;
  bool? placeUp;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? amIFollowing;
  AcceptUserDetail? user;
  int? countFollowers;

  MemberModel(
      {this.sId,
        this.userId,
        this.organizationId,
        this.organizationType,
        this.status,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.user,
        this.position,
        this.role,
        this.countFollowers,
        this.placeUp,
      this.amIFollowing});

  MemberModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    organizationId = json['organization_id'];
    organizationType = json['organization_type'];
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
    position = json['position'];
    iV = json['__v'];
    user = json['user'] != null ? AcceptUserDetail.fromJson(json['user']) : null;
    countFollowers = json['count_followers'];
    placeUp = json['placeUp'];
    amIFollowing = json['amIFollowing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['organization_id'] = this.organizationId;
    data['organization_type'] = this.organizationType;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['placeUp'] = this.placeUp;
    data['amIFollowing'] = this.amIFollowing;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['count_followers'] = this.countFollowers;
    return data;
  }
}

