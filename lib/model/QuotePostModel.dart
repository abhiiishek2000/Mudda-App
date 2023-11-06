import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/PostForMuddaModel.dart';
import 'UserProfileModel.dart';

class QuotePostModel {
  int? status;
  String? message;
  List<Quote>? data;
  String? path;
  String? userpath;

  QuotePostModel(
      {this.status, this.message, this.data, this.path, this.userpath});

  QuotePostModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Quote>[];
      json['data'].forEach((v) {
        data!.add(Quote.fromJson(v));
      });
    }
    path = json['path'];
    userpath = json['userpath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    data['userpath'] = this.userpath;
    return data;
  }
}

class Quote {
  String? sId;
  String? userId;
  String? thumbnail;
  String? title;
  String? description;
  List<String>? hashtags;
  String? postOf;
  int? isVerify;
  String? verifyBy;
  int? status;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Gallery>? gallery;
  // List<Null>? comments;
  int? commentorsCount;
  // List<Null>? liker;
  int? likersCount;
  int? reQuote;
  // List<Null>? disliker;
  int? dislikersCount;
  int? currentHorizontal;
  AcceptUserDetail? user;
  int? isUserBlocked;
  AmILiked? amILiked;
  String? id;

  Quote(
      {this.sId,
      this.userId,
      this.thumbnail,
      this.title,
      this.description,
      this.hashtags,
      this.postOf,
      this.isVerify,
      this.verifyBy,
      this.status,
      this.createdBy,
      this.updatedBy,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.gallery,
      this.commentorsCount,
      this.reQuote,
      this.likersCount,
      this.dislikersCount,
      this.user,
      this.amILiked,
        this.isUserBlocked,
      this.currentHorizontal,
      this.id});

  Quote.fromJson(Map<dynamic, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    thumbnail = json['thumbnail'];
    title = json['title'];
    description = json['description'];
    hashtags = json['hashtags'] != null ? json['hashtags'].cast<String>() : [];
    postOf = json['post_of'];
    isVerify = json['isVerify'];
    verifyBy = json['verify_by'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['gallery'] != null) {
      gallery = <Gallery>[];
      json['gallery'].forEach((v) {
        gallery!.add(new Gallery.fromJson(v));
      });
    }
    /*if (json['comments'] != null) {
      comments = <Null>[];
      json['comments'].forEach((v) {
        comments!.add(new Null.fromJson(v));
      });
    }*/
    commentorsCount = json['commentorsCount'] ?? 0;
    /*if (json['liker'] != null) {
      liker = <Null>[];
      json['liker'].forEach((v) {
        liker!.add(new Null.fromJson(v));
      });
    }*/
    likersCount = json['likersCount'] ?? 0;
    currentHorizontal = json['currentHorizontal'] ?? 0;
    reQuote = json['reQuote'] ?? 0;
    dislikersCount = json['dislikersCount'];
    user = json['user'] != null ? AcceptUserDetail.fromJson(json['user']) : null;
    isUserBlocked = json['isUserBlocked'] ?? 0;
    amILiked = json['amILiked'] != null ? AmILiked.fromJson(json['amILiked']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['thumbnail'] = this.thumbnail;
    data['title'] = this.title;
    data['description'] = this.description;
    data['hashtags'] = this.hashtags;
    data['post_of'] = this.postOf;
    data['isVerify'] = this.isVerify;
    data['verify_by'] = this.verifyBy;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.gallery != null) {
      data['gallery'] = this.gallery!.map((v) => v.toJson()).toList();
    }
    // if (this.comments != null) {
    //   data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    // }
    data['commentorsCount'] = this.commentorsCount;
    // if (this.liker != null) {
    //   data['liker'] = this.liker!.map((v) => v.toJson()).toList();
    // }
    data['likersCount'] = this.likersCount;
    // if (this.disliker != null) {
    //   data['disliker'] = this.disliker!.map((v) => v.toJson()).toList();
    // }
    data['dislikersCount'] = this.dislikersCount;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['isUserBlocked'] = this.isUserBlocked;
    data['id'] = this.id;
    return data;
  }
}
class AmILiked {
  String? sId;
  String? userId;
  String? relativeId;
  String? relativeType;
  bool? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  AmILiked(
      {this.sId,
        this.userId,
        this.relativeId,
        this.relativeType,
        this.status,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.id});

  AmILiked.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    relativeId = json['relative_id'];
    relativeType = json['relative_type'];
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['relative_id'] = this.relativeId;
    data['relative_type'] = this.relativeType;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
