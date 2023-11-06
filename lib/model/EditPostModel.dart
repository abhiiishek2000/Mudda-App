/// status : 1
/// message : "data updated successfully"
/// data : {"parentId":null,"_id":"6339c6f42b2817bcef439d10","user_id":"62e9d981f6c80f9c906ac0e1","mudda_id":"6312ff04dc5a91a041e42622","post_as":"user","thumbnail":"","title":null,"mudda_description":"updated post","hashtags":[],"post_in":"opposition","isVerify":0,"verify_by":null,"status":1,"created_by":null,"updated_by":null,"deleted":false,"createdAt":"2022-10-02T17:14:28.609Z","updatedAt":"2022-11-28T07:04:39.345Z","__v":0,"gallery":[{"_id":"6339c6f42b2817bcef439d12","user_id":"62e9d981f6c80f9c906ac0e1","relative_id":"6339c6f42b2817bcef439d10","relative_type":"PostForMudda","file":"1664730868377.jpg","path":"uploads/post-for-mudda/","status":1,"created_by":null,"updated_by":null,"deleted":false,"createdAt":"2022-10-02T17:14:28.619Z","updatedAt":"2022-10-02T17:14:28.619Z","__v":0}],"id":"6339c6f42b2817bcef439d10"}
/// path : "https://mudda-dev.s3.ap-south-1.amazonaws.com/post-for-mudda/"

class EditPostModel {
  EditPostModel({
      num? status, 
      String? message, 
      EditPost? data,
      String? path,}){
    _status = status;
    _message = message;
    _data = data;
    _path = path;
}

  EditPostModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? EditPost.fromJson(json['data']) : null;
    _path = json['path'];
  }
  num? _status;
  String? _message;
  EditPost? _data;
  String? _path;
EditPostModel copyWith({  num? status,
  String? message,
  EditPost? data,
  String? path,
}) => EditPostModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
  path: path ?? _path,
);
  num? get status => _status;
  String? get message => _message;
  EditPost? get data => _data;
  String? get path => _path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['path'] = _path;
    return map;
  }

}

/// parentId : null
/// _id : "6339c6f42b2817bcef439d10"
/// user_id : "62e9d981f6c80f9c906ac0e1"
/// mudda_id : "6312ff04dc5a91a041e42622"
/// post_as : "user"
/// thumbnail : ""
/// title : null
/// mudda_description : "updated post"
/// hashtags : []
/// post_in : "opposition"
/// isVerify : 0
/// verify_by : null
/// status : 1
/// created_by : null
/// updated_by : null
/// deleted : false
/// createdAt : "2022-10-02T17:14:28.609Z"
/// updatedAt : "2022-11-28T07:04:39.345Z"
/// __v : 0
/// gallery : [{"_id":"6339c6f42b2817bcef439d12","user_id":"62e9d981f6c80f9c906ac0e1","relative_id":"6339c6f42b2817bcef439d10","relative_type":"PostForMudda","file":"1664730868377.jpg","path":"uploads/post-for-mudda/","status":1,"created_by":null,"updated_by":null,"deleted":false,"createdAt":"2022-10-02T17:14:28.619Z","updatedAt":"2022-10-02T17:14:28.619Z","__v":0}]
/// id : "6339c6f42b2817bcef439d10"

class EditPost {
  EditPost({
      dynamic parentId, 
      String? id, 
      String? userId, 
      String? muddaId, 
      String? postAs, 
      String? thumbnail, 
      dynamic title, 
      String? muddaDescription, 
      List<dynamic>? hashtags, 
      String? postIn, 
      num? isVerify, 
      dynamic verifyBy, 
      num? status, 
      dynamic createdBy, 
      dynamic updatedBy, 
      bool? deleted, 
      String? createdAt, 
      String? updatedAt, 
      num? v, 
      List<Gallery>? gallery, 
      }){
    _parentId = parentId;
    _id = id;
    _userId = userId;
    _muddaId = muddaId;
    _postAs = postAs;
    _thumbnail = thumbnail;
    _title = title;
    _muddaDescription = muddaDescription;
    _hashtags = hashtags;
    _postIn = postIn;
    _isVerify = isVerify;
    _verifyBy = verifyBy;
    _status = status;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _deleted = deleted;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _gallery = gallery;
    _id = id;
}

  EditPost.fromJson(dynamic json) {
    _parentId = json['parentId'];
    _id = json['_id'];
    _userId = json['user_id'];
    _muddaId = json['mudda_id'];
    _postAs = json['post_as'];
    _thumbnail = json['thumbnail'];
    _title = json['title'];
    _muddaDescription = json['mudda_description'];
    // if (json['hashtags'] != null) {
    //   _hashtags = [];
    //   json['hashtags'].forEach((v) {
    //     _hashtags?.add(Dynamic.fromJson(v));
    //   });
    // }
    _postIn = json['post_in'];
    _isVerify = json['isVerify'];
    _verifyBy = json['verify_by'];
    _status = json['status'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'];
    _deleted = json['deleted'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    if (json['gallery'] != null) {
      _gallery = [];
      json['gallery'].forEach((v) {
        _gallery?.add(Gallery.fromJson(v));
      });
    }
    _id = json['id'];
  }
  dynamic _parentId;
  String? _id;
  String? _userId;
  String? _muddaId;
  String? _postAs;
  String? _thumbnail;
  dynamic _title;
  String? _muddaDescription;
  List<dynamic>? _hashtags;
  String? _postIn;
  num? _isVerify;
  dynamic _verifyBy;
  num? _status;
  dynamic _createdBy;
  dynamic _updatedBy;
  bool? _deleted;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  List<Gallery>? _gallery;

EditPost copyWith({  dynamic parentId,
  String? id,
  String? userId,
  String? muddaId,
  String? postAs,
  String? thumbnail,
  dynamic title,
  String? muddaDescription,
  List<dynamic>? hashtags,
  String? postIn,
  num? isVerify,
  dynamic verifyBy,
  num? status,
  dynamic createdBy,
  dynamic updatedBy,
  bool? deleted,
  String? createdAt,
  String? updatedAt,
  num? v,
  List<Gallery>? gallery,

}) => EditPost(  parentId: parentId ?? _parentId,
  id: id ?? _id,
  userId: userId ?? _userId,
  muddaId: muddaId ?? _muddaId,
  postAs: postAs ?? _postAs,
  thumbnail: thumbnail ?? _thumbnail,
  title: title ?? _title,
  muddaDescription: muddaDescription ?? _muddaDescription,
  hashtags: hashtags ?? _hashtags,
  postIn: postIn ?? _postIn,
  isVerify: isVerify ?? _isVerify,
  verifyBy: verifyBy ?? _verifyBy,
  status: status ?? _status,
  createdBy: createdBy ?? _createdBy,
  updatedBy: updatedBy ?? _updatedBy,
  deleted: deleted ?? _deleted,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
  gallery: gallery ?? _gallery,

);
  dynamic get parentId => _parentId;
  String? get id => _id;
  String? get userId => _userId;
  String? get muddaId => _muddaId;
  String? get postAs => _postAs;
  String? get thumbnail => _thumbnail;
  dynamic get title => _title;
  String? get muddaDescription => _muddaDescription;
  List<dynamic>? get hashtags => _hashtags;
  String? get postIn => _postIn;
  num? get isVerify => _isVerify;
  dynamic get verifyBy => _verifyBy;
  num? get status => _status;
  dynamic get createdBy => _createdBy;
  dynamic get updatedBy => _updatedBy;
  bool? get deleted => _deleted;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;
  List<Gallery>? get gallery => _gallery;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['parentId'] = _parentId;
    map['_id'] = _id;
    map['user_id'] = _userId;
    map['mudda_id'] = _muddaId;
    map['post_as'] = _postAs;
    map['thumbnail'] = _thumbnail;
    map['title'] = _title;
    map['mudda_description'] = _muddaDescription;
    if (_hashtags != null) {
      map['hashtags'] = _hashtags?.map((v) => v.toJson()).toList();
    }
    map['post_in'] = _postIn;
    map['isVerify'] = _isVerify;
    map['verify_by'] = _verifyBy;
    map['status'] = _status;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['deleted'] = _deleted;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    if (_gallery != null) {
      map['gallery'] = _gallery?.map((v) => v.toJson()).toList();
    }
    map['id'] = _id;
    return map;
  }

}

/// _id : "6339c6f42b2817bcef439d12"
/// user_id : "62e9d981f6c80f9c906ac0e1"
/// relative_id : "6339c6f42b2817bcef439d10"
/// relative_type : "PostForMudda"
/// file : "1664730868377.jpg"
/// path : "uploads/post-for-mudda/"
/// status : 1
/// created_by : null
/// updated_by : null
/// deleted : false
/// createdAt : "2022-10-02T17:14:28.619Z"
/// updatedAt : "2022-10-02T17:14:28.619Z"
/// __v : 0

class Gallery {
  Gallery({
      String? id, 
      String? userId, 
      String? relativeId, 
      String? relativeType, 
      String? file, 
      String? path, 
      num? status, 
      dynamic createdBy, 
      dynamic updatedBy, 
      bool? deleted, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _userId = userId;
    _relativeId = relativeId;
    _relativeType = relativeType;
    _file = file;
    _path = path;
    _status = status;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _deleted = deleted;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
}

  Gallery.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['user_id'];
    _relativeId = json['relative_id'];
    _relativeType = json['relative_type'];
    _file = json['file'];
    _path = json['path'];
    _status = json['status'];
    _createdBy = json['created_by'];
    _updatedBy = json['updated_by'];
    _deleted = json['deleted'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
  }
  String? _id;
  String? _userId;
  String? _relativeId;
  String? _relativeType;
  String? _file;
  String? _path;
  num? _status;
  dynamic _createdBy;
  dynamic _updatedBy;
  bool? _deleted;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Gallery copyWith({  String? id,
  String? userId,
  String? relativeId,
  String? relativeType,
  String? file,
  String? path,
  num? status,
  dynamic createdBy,
  dynamic updatedBy,
  bool? deleted,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Gallery(  id: id ?? _id,
  userId: userId ?? _userId,
  relativeId: relativeId ?? _relativeId,
  relativeType: relativeType ?? _relativeType,
  file: file ?? _file,
  path: path ?? _path,
  status: status ?? _status,
  createdBy: createdBy ?? _createdBy,
  updatedBy: updatedBy ?? _updatedBy,
  deleted: deleted ?? _deleted,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get relativeId => _relativeId;
  String? get relativeType => _relativeType;
  String? get file => _file;
  String? get path => _path;
  num? get status => _status;
  dynamic get createdBy => _createdBy;
  dynamic get updatedBy => _updatedBy;
  bool? get deleted => _deleted;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['user_id'] = _userId;
    map['relative_id'] = _relativeId;
    map['relative_type'] = _relativeType;
    map['file'] = _file;
    map['path'] = _path;
    map['status'] = _status;
    map['created_by'] = _createdBy;
    map['updated_by'] = _updatedBy;
    map['deleted'] = _deleted;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    return map;
  }

}