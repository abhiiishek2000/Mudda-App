import 'package:flutter/foundation.dart';

class CategoryListModel {
  int? status;
  String? message;
  List<Category>? data;
  String? path;

  CategoryListModel({this.status, this.message, this.data, this.path});

  CategoryListModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Category>[];
      json['data'].forEach((v) {
        data!.add(new Category.fromJson(v));
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

class Category {
  String? sId;
  String? name;
  String? type;
  Null? icon;
  int? status;
  Null? createdBy;
  Null? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  UserInterest? userInterest;
  String? id;

  Category(
      {this.sId,
        this.name,
        this.type,
        this.icon,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.userInterest,
        this.id});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    type = json['type'];
    icon = json['icon'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    userInterest = json['userInterest'] != null
        ? UserInterest.fromJson(json['userInterest'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['icon'] = this.icon;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.userInterest != null) {
      data['userInterest'] = this.userInterest!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class UserInterest {
  String? sId;
  String? userId;
  String? categoryId;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  UserInterest(
      {this.sId,
        this.userId,
        this.categoryId,
        this.status,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.id});

  UserInterest.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    categoryId = json['categoryId'];
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
    data['userId'] = this.userId;
    data['categoryId'] = this.categoryId;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}

