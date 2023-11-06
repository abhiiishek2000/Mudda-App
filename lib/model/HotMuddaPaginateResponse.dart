import 'package:mudda/model/MuddaPostModel.dart';

class MuddaPostResult {


  List<MuddaPost>? data;
  int? status;
  String? path;
  String? userpath;
  bool? notifications;

  MuddaPostResult({
    this.data,
    this.status,
    this.path,
    this.userpath,
    this.notifications,
  });
  MuddaPostResult.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <MuddaPost>[];
      v.forEach((v) {
        arr0.add(MuddaPost.fromJson(v));
      });
      this.data = arr0;
    }
    status = json['status']?.toInt();
    path = json['path']?.toString();
    userpath = json['userpath']?.toString();
    notifications = json['notifications'];
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
    data['status'] = status;
    data['path'] = path;
    data['userpath'] = userpath;
    data['notifications'] = notifications;
    return data;
  }
}

class MuddaPostNew {


  MuddaPostResult? result;
  String? message;
  bool? success;
  int? status;

  MuddaPostNew({
    this.result,
    this.message,
    this.success,
    this.status,
  });
  MuddaPostNew.fromJson(Map<dynamic, dynamic> json) {
    result = (json['result'] != null) ? MuddaPostResult.fromJson(json['result']) : null;
    message = json['message']?.toString();
    success = json['success'];
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
    return data;
  }
}
