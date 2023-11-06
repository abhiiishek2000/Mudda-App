/// status : 1
/// message : "data deleted successfully"
/// data : {"_id":"6381f25bc72d6f7fa952b722","user_id":"6381c3cd421a9a9a839fa57b","mudda_id":"62eb331af6c80f9c906b0043","post_as":"user","thumbnail":null,"title":null,"mudda_description":"Hii","hashtags":[],"post_in":"favour","isVerify":1,"verify_by":null,"status":1,"created_by":null,"updated_by":null,"parentId":null,"deleted":true,"createdAt":"2022-11-26T11:02:51.800Z","updatedAt":"2022-11-26T12:52:41.108Z","__v":0,"id":"6381f25bc72d6f7fa952b722"}

class DeletePostModel {
  DeletePostModel({
      num? status, 
      String? message, 
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  DeletePostModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? _status;
  String? _message;
  Data? _data;
DeletePostModel copyWith({  num? status,
  String? message,
  Data? data,
}) => DeletePostModel(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  num? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// _id : "6381f25bc72d6f7fa952b722"
/// user_id : "6381c3cd421a9a9a839fa57b"
/// mudda_id : "62eb331af6c80f9c906b0043"
/// post_as : "user"
/// thumbnail : null
/// title : null
/// mudda_description : "Hii"
/// hashtags : []
/// post_in : "favour"
/// isVerify : 1
/// verify_by : null
/// status : 1
/// created_by : null
/// updated_by : null
/// parentId : null
/// deleted : true
/// createdAt : "2022-11-26T11:02:51.800Z"
/// updatedAt : "2022-11-26T12:52:41.108Z"
/// __v : 0
/// id : "6381f25bc72d6f7fa952b722"

class Data {
  Data({
      String? id, 
      String? userId, 
      String? muddaId, 
      String? postAs, 
      dynamic thumbnail, 
      dynamic title, 
      String? muddaDescription, 
      List<dynamic>? hashtags, 
      String? postIn, 
      num? isVerify, 
      dynamic verifyBy, 
      num? status, 
      dynamic createdBy, 
      dynamic updatedBy, 
      dynamic parentId, 
      bool? deleted, 
      String? createdAt, 
      String? updatedAt, 
      num? v, }){
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
    _parentId = parentId;
    _deleted = deleted;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _id = id;
}

  Data.fromJson(dynamic json) {
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
    _parentId = json['parentId'];
    _deleted = json['deleted'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _id = json['id'];
  }
  String? _id;
  String? _userId;
  String? _muddaId;
  String? _postAs;
  dynamic _thumbnail;
  dynamic _title;
  String? _muddaDescription;
  List<dynamic>? _hashtags;
  String? _postIn;
  num? _isVerify;
  dynamic _verifyBy;
  num? _status;
  dynamic _createdBy;
  dynamic _updatedBy;
  dynamic _parentId;
  bool? _deleted;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
Data copyWith({  String? id,
  String? userId,
  String? muddaId,
  String? postAs,
  dynamic thumbnail,
  dynamic title,
  String? muddaDescription,
  List<dynamic>? hashtags,
  String? postIn,
  num? isVerify,
  dynamic verifyBy,
  num? status,
  dynamic createdBy,
  dynamic updatedBy,
  dynamic parentId,
  bool? deleted,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Data(  id: id ?? _id,
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
  parentId: parentId ?? _parentId,
  deleted: deleted ?? _deleted,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get muddaId => _muddaId;
  String? get postAs => _postAs;
  dynamic get thumbnail => _thumbnail;
  dynamic get title => _title;
  String? get muddaDescription => _muddaDescription;
  List<dynamic>? get hashtags => _hashtags;
  String? get postIn => _postIn;
  num? get isVerify => _isVerify;
  dynamic get verifyBy => _verifyBy;
  num? get status => _status;
  dynamic get createdBy => _createdBy;
  dynamic get updatedBy => _updatedBy;
  dynamic get parentId => _parentId;
  bool? get deleted => _deleted;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  num? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
    map['parentId'] = _parentId;
    map['deleted'] = _deleted;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['id'] = _id;
    return map;
  }

}