/// status : 1
/// message : "data deleted successfully"
/// data : {"_id":"636a422d76a1027264533e84","user_id":"6368e20fb2e3ef83311bb0f6","relative_id":"6368f5d15ead52af4e1ba355","relative_type":"PostForMudda","comment_type":"favour","commentText":"Testing","user_identity":1,"status":1,"discardedBy":null,"discardedDate":null,"deleted":true,"createdAt":"2022-11-08T11:49:01.592Z","updatedAt":"2022-11-08T17:10:00.741Z","__v":0,"id":"636a422d76a1027264533e84"}

class DeleteCommentModel {
  DeleteCommentModel({
      num? status, 
      String? message, 
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  DeleteCommentModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? _status;
  String? _message;
  Data? _data;
DeleteCommentModel copyWith({  num? status,
  String? message,
  Data? data,
}) => DeleteCommentModel(  status: status ?? _status,
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

/// _id : "636a422d76a1027264533e84"
/// user_id : "6368e20fb2e3ef83311bb0f6"
/// relative_id : "6368f5d15ead52af4e1ba355"
/// relative_type : "PostForMudda"
/// comment_type : "favour"
/// commentText : "Testing"
/// user_identity : 1
/// status : 1
/// discardedBy : null
/// discardedDate : null
/// deleted : true
/// createdAt : "2022-11-08T11:49:01.592Z"
/// updatedAt : "2022-11-08T17:10:00.741Z"
/// __v : 0
/// id : "636a422d76a1027264533e84"

class Data {
  Data({
      String? id, 
      String? userId, 
      String? relativeId, 
      String? relativeType, 
      String? commentType, 
      String? commentText, 
      num? userIdentity, 
      num? status, 
      dynamic discardedBy, 
      dynamic discardedDate, 
      bool? deleted, 
      String? createdAt, 
      String? updatedAt, 
      num? v,}){
    _id = id;
    _userId = userId;
    _relativeId = relativeId;
    _relativeType = relativeType;
    _commentType = commentType;
    _commentText = commentText;
    _userIdentity = userIdentity;
    _status = status;
    _discardedBy = discardedBy;
    _discardedDate = discardedDate;
    _deleted = deleted;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _v = v;
    _id = id;
}

  Data.fromJson(dynamic json) {
    _id = json['_id'];
    _userId = json['user_id'];
    _relativeId = json['relative_id'];
    _relativeType = json['relative_type'];
    _commentType = json['comment_type'];
    _commentText = json['commentText'];
    _userIdentity = json['user_identity'];
    _status = json['status'];
    _discardedBy = json['discardedBy'];
    _discardedDate = json['discardedDate'];
    _deleted = json['deleted'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _v = json['__v'];
    _id = json['id'];
  }
  String? _userId;
  String? _relativeId;
  String? _relativeType;
  String? _commentType;
  String? _commentText;
  num? _userIdentity;
  num? _status;
  dynamic _discardedBy;
  dynamic _discardedDate;
  bool? _deleted;
  String? _createdAt;
  String? _updatedAt;
  num? _v;
  String? _id;
Data copyWith({  String? id,
  String? userId,
  String? relativeId,
  String? relativeType,
  String? commentType,
  String? commentText,
  num? userIdentity,
  num? status,
  dynamic discardedBy,
  dynamic discardedDate,
  bool? deleted,
  String? createdAt,
  String? updatedAt,
  num? v,
}) => Data(  id: id ?? _id,
  userId: userId ?? _userId,
  relativeId: relativeId ?? _relativeId,
  relativeType: relativeType ?? _relativeType,
  commentType: commentType ?? _commentType,
  commentText: commentText ?? _commentText,
  userIdentity: userIdentity ?? _userIdentity,
  status: status ?? _status,
  discardedBy: discardedBy ?? _discardedBy,
  discardedDate: discardedDate ?? _discardedDate,
  deleted: deleted ?? _deleted,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  v: v ?? _v,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get relativeId => _relativeId;
  String? get relativeType => _relativeType;
  String? get commentType => _commentType;
  String? get commentText => _commentText;
  num? get userIdentity => _userIdentity;
  num? get status => _status;
  dynamic get discardedBy => _discardedBy;
  dynamic get discardedDate => _discardedDate;
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
    map['comment_type'] = _commentType;
    map['commentText'] = _commentText;
    map['user_identity'] = _userIdentity;
    map['status'] = _status;
    map['discardedBy'] = _discardedBy;
    map['discardedDate'] = _discardedDate;
    map['deleted'] = _deleted;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['__v'] = _v;
    map['id'] = _id;
    return map;
  }

}