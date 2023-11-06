class MuddaOfflinePost {
  String? id;
  String ?user_id;
  String? mudda_id;
  String? post_as;
  String ?thumbnail;
  String? title;
  String ?mudda_description;
  String? post_in;
  String ?createdAt;
  String? path;
  String? file;
  int ?commentorsCount;
  int? likersCount;
  int ?dislikersCount;
  int? agreeStatus;
  int? hostSpot;
  bool? followStatus;
  String ?fullname;
  String? profile;
  int? replies;
  List<String>? parentPost;

  MuddaOfflinePost({
    this.id,
    this.user_id,
    this.mudda_id,
    this.post_as,
    this.thumbnail,
    this.title,
    this.mudda_description,
    this.post_in,
    this.createdAt,
    this.file,
    this.path,
    this.commentorsCount,
    this.likersCount,
    this.dislikersCount,
    this.agreeStatus,
    this.fullname,
    this.profile,
    this.hostSpot=0,
    this.replies,
    this.parentPost,
    this.followStatus=false,
  });
  MuddaOfflinePost.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    user_id = map['user_id'];
    mudda_id = map['mudda_id'];
    post_as = map['post_as'];
    thumbnail = map['thumbnail'];
    title = map['title'];
    mudda_description = map['mudda_description'];
    post_in = map['post_in'];
    createdAt = map['createdAt'];
    file = map['file'];
    path = map['path'];
    commentorsCount = map['commentorsCount'];
    likersCount = map['likersCount'];
    dislikersCount = map['dislikersCount'];
    agreeStatus = map['agreeStatus'];
    fullname = map['fullname'];
    profile = map['profile'];
    replies = map['replies'];
    parentPost = map['parentPost'];

  }




  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "_id": id,
      "user_id": user_id,
      'mudda_id':mudda_id,
      'post_as':post_as,
      'thumbnail' : thumbnail,
      'title' : title,
      'mudda_description':mudda_description,
      'post_in':post_in,
      'createdAt':createdAt,
      'file' : file,
      'path':path,
      'commentorsCount':commentorsCount,
      'likersCount':likersCount,
      'dislikersCount':dislikersCount,
      'agreeStatus':agreeStatus,
      'fullname' : fullname,
      'profile' : profile,
      'replies':replies,
      'parentPost':parentPost
    };
    return map;
  }
}
