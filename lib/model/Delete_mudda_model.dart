/// status : 1
/// message : "data deleted successfully"
/// data : {"acknowledged":true,"modifiedCount":0,"upsertedId":null,"upsertedCount":0,"matchedCount":0}

class DeleteMuddaModel {
  DeleteMuddaModel({
      num? status, 
      String? message, 
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  DeleteMuddaModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? _status;
  String? _message;
  Data? _data;
DeleteMuddaModel copyWith({  num? status,
  String? message,
  Data? data,
}) => DeleteMuddaModel(  status: status ?? _status,
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

/// acknowledged : true
/// modifiedCount : 0
/// upsertedId : null
/// upsertedCount : 0
/// matchedCount : 0

class Data {
  Data({
      bool? acknowledged, 
      num? modifiedCount, 
      dynamic upsertedId, 
      num? upsertedCount, 
      num? matchedCount,}){
    _acknowledged = acknowledged;
    _modifiedCount = modifiedCount;
    _upsertedId = upsertedId;
    _upsertedCount = upsertedCount;
    _matchedCount = matchedCount;
}

  Data.fromJson(dynamic json) {
    _acknowledged = json['acknowledged'];
    _modifiedCount = json['modifiedCount'];
    _upsertedId = json['upsertedId'];
    _upsertedCount = json['upsertedCount'];
    _matchedCount = json['matchedCount'];
  }
  bool? _acknowledged;
  num? _modifiedCount;
  dynamic _upsertedId;
  num? _upsertedCount;
  num? _matchedCount;
Data copyWith({  bool? acknowledged,
  num? modifiedCount,
  dynamic upsertedId,
  num? upsertedCount,
  num? matchedCount,
}) => Data(  acknowledged: acknowledged ?? _acknowledged,
  modifiedCount: modifiedCount ?? _modifiedCount,
  upsertedId: upsertedId ?? _upsertedId,
  upsertedCount: upsertedCount ?? _upsertedCount,
  matchedCount: matchedCount ?? _matchedCount,
);
  bool? get acknowledged => _acknowledged;
  num? get modifiedCount => _modifiedCount;
  dynamic get upsertedId => _upsertedId;
  num? get upsertedCount => _upsertedCount;
  num? get matchedCount => _matchedCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['acknowledged'] = _acknowledged;
    map['modifiedCount'] = _modifiedCount;
    map['upsertedId'] = _upsertedId;
    map['upsertedCount'] = _upsertedCount;
    map['matchedCount'] = _matchedCount;
    return map;
  }

}