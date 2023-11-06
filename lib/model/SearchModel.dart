import 'package:mudda/model/MuddaPostModel.dart';

class SearchModel {
  int? status;
  String? message;
  List<MuddaPost>? mudda;
  List<AcceptUserDetail>? userdata;
  List<AcceptUserDetail>? orgData;
  String? path;
  String? userpath;

  SearchModel(
      {this.status,
        this.message,
        this.mudda,
        this.userdata,
        this.orgData,
        this.path,
        this.userpath});

  SearchModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['mudda'] != null) {
      mudda = <MuddaPost>[];
      json['mudda'].forEach((v) {
        mudda!.add(MuddaPost.fromJson(v));
      });
    }
    if (json['userdata'] != null) {
      userdata = <AcceptUserDetail>[];
      json['userdata'].forEach((v) {
        userdata!.add(AcceptUserDetail.fromJson(v));
      });
    }
    if (json['orgData'] != null) {
      orgData = <AcceptUserDetail>[];
      json['orgData'].forEach((v) {
        orgData!.add(AcceptUserDetail.fromJson(v));
      });
    }
    path = json['path'];
    userpath = json['userpath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.mudda != null) {
      data['mudda'] = this.mudda!.map((v) => v.toJson()).toList();
    }
    if (this.userdata != null) {
      data['userdata'] = this.userdata!.map((v) => v.toJson()).toList();
    }
    if (this.orgData != null) {
      data['orgData'] = this.orgData!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    data['userpath'] = this.userpath;
    return data;
  }
}


class TrendingUserModel {
  int? status;
  String? message;
  List<MuddaPost>? mudda;
  List<AcceptUserDetail>? userdata;
  List<AcceptUserDetail>? orgData;
  String? path;
  String? userpath;

  TrendingUserModel(
      {this.status,
        this.message,
        this.mudda,
        this.userdata,
        this.orgData,
        this.path,
        this.userpath});

  TrendingUserModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userpath = json['userpath'];
    if (json['mudda'] != null) {
      mudda = <MuddaPost>[];
      json['mudda'].forEach((v) {
        mudda!.add(MuddaPost.fromJson(v));
      });
    }
    if (json['data'] != null) {
      userdata = <AcceptUserDetail>[];
      json['data'].forEach((v) {
        userdata!.add(AcceptUserDetail.fromJson(v));
      });
    }
    if (json['orgData'] != null) {
      orgData = <AcceptUserDetail>[];
      json['orgData'].forEach((v) {
        orgData!.add(AcceptUserDetail.fromJson(v));
      });
    }
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.mudda != null) {
      data['mudda'] = this.mudda!.map((v) => v.toJson()).toList();
    }
    if (this.userdata != null) {
      data['data'] = this.userdata!.map((v) => v.toJson()).toList();
    }
    if (this.orgData != null) {
      data['orgData'] = this.orgData!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    data['userpath'] = this.userpath;
    return data;
  }
}

