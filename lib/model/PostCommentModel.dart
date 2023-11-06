import 'package:mudda/model/PostForMuddaModel.dart';

class PostCommentModel {
  int? status;
  String? message;
  List<Comments>? data;
  String? path;

  PostCommentModel({this.status, this.message, this.data, this.path});

  PostCommentModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Comments>[];
      json['data'].forEach((v) {
        data!.add(Comments.fromJson(v));
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
