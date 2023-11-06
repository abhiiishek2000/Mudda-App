import 'package:mudda/model/MuddaPostModel.dart';
import 'package:mudda/model/UserJoinLeadersModel.dart';

class LeadersDataModel {
  int? status;
  String? message;
  List<Leaders>? data;
  DataMudda? dataMudda;
  String? path;

  LeadersDataModel(
      {this.status, this.message, this.data, this.dataMudda, this.path});

  LeadersDataModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Leaders>[];
      json['data'].forEach((v) {
        data!.add(Leaders.fromJson(v));
      });
    }
    dataMudda = json['dataMudda'] != null
        ? DataMudda.fromJson(json['dataMudda'])
        : null;
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.dataMudda != null) {
      data['dataMudda'] = this.dataMudda!.toJson();
    }
    data['path'] = this.path;
    return data;
  }
}

class DataMudda {
  String? sId;
  String? userId;
  String? postAs;
  String? thumbnail;
  String? title;
  String? initialScope;
  String? muddaDescription;
  List<String>? hashtags;
  String? area;
  String? landmark;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? latitude;
  String? longitude;
  String? audienceGender;
  String? audienceAge;
  int? isVerify;
  String? verifyBy;
  int? status;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? favourCount;
  int? oppositionCount;
  JoinLeader? creator;
  JoinLeader? oppositionLeader;
  MuddaMuddebaaz? muddebaaz;
  LeadershipModelDataMuddaInviteData? inviteData;
  // InviteDataInviteData? inviteData;
  String? id;

  DataMudda(
      {this.sId,
      this.userId,
      this.postAs,
      this.thumbnail,
      this.title,
      this.initialScope,
      this.muddaDescription,
      this.hashtags,
      this.area,
      this.landmark,
      this.city,
      this.state,
      this.country,
      this.zipcode,
      this.latitude,
      this.longitude,
      this.audienceGender,
      this.audienceAge,
      this.isVerify,
      this.verifyBy,
      this.status,
      this.createdBy,
      this.updatedBy,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.favourCount,
      this.oppositionCount,
      this.creator,
      this.muddebaaz,
      this.oppositionLeader,
      this.inviteData,
      this.id});

  DataMudda.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    postAs = json['post_as'];
    thumbnail = json['thumbnail'];
    title = json['title'];
    initialScope = json['initial_scope'];
    muddaDescription = json['mudda_description'];
    hashtags = json['hashtags'].cast<String>();
    area = json['area'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    audienceGender = json['audience_gender'];
    audienceAge = json['audience_age'];
    isVerify = json['isVerify'];
    verifyBy = json['verify_by'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    favourCount = json['favourCount'];
    oppositionCount = json['oppositionCount'];
    creator =
        json['creator'] != null ? JoinLeader.fromJson(json['creator']) : null;
    muddebaaz = json['muddebaaz'] != null
        ? MuddaMuddebaaz.fromJson(json['muddebaaz'])
        : null;
    inviteData = (json['inviteData'] != null)
        ? LeadershipModelDataMuddaInviteData.fromJson(json['inviteData'])
        : null;
    oppositionLeader = json['oppositionLeader'] != null
        ? JoinLeader.fromJson(json['oppositionLeader'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['post_as'] = this.postAs;
    data['thumbnail'] = this.thumbnail;
    data['title'] = this.title;
    data['initial_scope'] = this.initialScope;
    data['mudda_description'] = this.muddaDescription;
    data['hashtags'] = this.hashtags;
    data['area'] = this.area;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zipcode'] = this.zipcode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['audience_gender'] = this.audienceGender;
    data['audience_age'] = this.audienceAge;
    data['isVerify'] = this.isVerify;
    data['verify_by'] = this.verifyBy;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['favourCount'] = this.favourCount;
    data['oppositionCount'] = this.oppositionCount;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    if (this.muddebaaz != null) {
      data['muddebaaz'] = this.muddebaaz!.toJson();
    }
    if (inviteData != null) {
      data['inviteData'] = inviteData!.toJson();
    }

    data['oppositionLeader'] = this.oppositionLeader;

    data['id'] = this.id;
    return data;
  }
}

class Creator {
  String? sId;
  String? userId;
  String? requestToUserId;
  String? joiningContentId;
  String? acceptType;
  String? joinerType;
  int? userIdentity;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  Creator(
      {this.sId,
      this.userId,
      this.requestToUserId,
      this.joiningContentId,
      this.acceptType,
      this.joinerType,
      this.userIdentity,
      this.status,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.id});

  Creator.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    requestToUserId = json['request_to_user_id'];
    joiningContentId = json['joining_content_id'];
    acceptType = json['accept_type'];
    joinerType = json['joiner_type'];
    userIdentity = json['user_identity'];
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
    data['user_id'] = this.userId;
    data['request_to_user_id'] = this.requestToUserId;
    data['joining_content_id'] = this.joiningContentId;
    data['accept_type'] = this.acceptType;
    data['joiner_type'] = this.joinerType;
    data['user_identity'] = this.userIdentity;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}

class MuddaMuddebaaz {
  List<MuddaMuddebaazFavour>? favour;
  List<MuddaMuddebaazOpposition>? opposition;

  MuddaMuddebaaz({
    this.favour,
    this.opposition,
  });
  MuddaMuddebaaz.fromJson(Map<String, dynamic> json) {
    if (json['favour'] != null) {
      final v = json['favour'];
      final arr0 = <MuddaMuddebaazFavour>[];
      v.forEach((v) {
        arr0.add(MuddaMuddebaazFavour.fromJson(v));
      });
      favour = arr0;
    }
    if (json['opposition'] != null) {
      final v = json['opposition'];
      final arr0 = <MuddaMuddebaazOpposition>[];
      v.forEach((v) {
        arr0.add(MuddaMuddebaazOpposition.fromJson(v));
      });
      opposition = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (favour != null) {
      final v = favour;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v.toJson());
      });
      data['favour'] = arr0;
    }
    if (opposition != null) {
      final v = opposition;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v.toJson());
      });
      data['opposition'] = arr0;
    }
    return data;
  }
}

class MuddebaazOppositionUser {
  String? Id;
  String? fullname;
  String? profile;

  MuddebaazOppositionUser({
    this.Id,
    this.fullname,
    this.profile,
  });
  MuddebaazOppositionUser.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    fullname = json['fullname']?.toString();
    profile = json['profile']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['fullname'] = fullname;
    data['profile'] = profile;
    return data;
  }
}

class MuddaMuddebaazOpposition {
  String? Id;
  int? days;
  String? createdAt;
  String? updatedAt;
  MuddebaazOppositionUser? user;

  MuddaMuddebaazOpposition({
    this.Id,
    this.days,
    this.createdAt,
    this.updatedAt,
    this.user,
  });
  MuddaMuddebaazOpposition.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    days = json['days']?.toInt();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    user = (json['user'] != null)
        ? MuddebaazOppositionUser.fromJson(json['user'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['days'] = days;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class MuddebaazFavourUser {
  String? Id;
  String? fullname;
  String? profile;

  MuddebaazFavourUser({
    this.Id,
    this.fullname,
    this.profile,
  });
  MuddebaazFavourUser.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    fullname = json['fullname']?.toString();
    profile = json['profile']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['fullname'] = fullname;
    data['profile'] = profile;
    return data;
  }
}

class MuddaMuddebaazFavour {
  String? Id;
  int? days;
  String? createdAt;
  String? updatedAt;
  MuddebaazFavourUser? user;

  MuddaMuddebaazFavour({
    this.Id,
    this.days,
    this.createdAt,
    this.updatedAt,
    this.user,
  });
  MuddaMuddebaazFavour.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    days = json['days']?.toInt();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    user = (json['user'] != null)
        ? MuddebaazFavourUser.fromJson(json['user'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['days'] = days;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class InviteDataInviteData {
/*
{
  "_id": "62ed0681d62cb72ed2feef88",
  "user_id": "62d2a2282c71d2a627481d96",
  "request_to_user_id": "62e9d981f6c80f9c906ac0e1",
  "joining_content_id": "62d4ff51e69a889c68453e12",
  "request_type": "initial_leader",
  "user_identity": 1,
  "status": 1,
  "deleted": false,
  "createdAt": "2022-08-05T12:01:05.196Z",
  "updatedAt": "2022-08-05T12:01:05.196Z",
  "__v": 0
}
*/

  String? Id;
  String? userId;
  String? requestToUserId;
  String? joiningContentId;
  String? requestType;
  int? userIdentity;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? V;

  InviteDataInviteData({
    this.Id,
    this.userId,
    this.requestToUserId,
    this.joiningContentId,
    this.requestType,
    this.userIdentity,
    this.status,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.V,
  });
  InviteDataInviteData.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    userId = json['user_id']?.toString();
    requestToUserId = json['request_to_user_id']?.toString();
    joiningContentId = json['joining_content_id']?.toString();
    requestType = json['request_type']?.toString();
    userIdentity = json['user_identity']?.toInt();
    status = json['status']?.toInt();
    deleted = json['deleted'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    V = json['__v']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['user_id'] = userId;
    data['request_to_user_id'] = requestToUserId;
    data['joining_content_id'] = joiningContentId;
    data['request_type'] = requestType;
    data['user_identity'] = userIdentity;
    data['status'] = status;
    data['deleted'] = deleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = V;
    return data;
  }
}

class LeadershipModelDataMuddaInviteData {
/*
{
  "_id": "62ed0681d62cb72ed2feef88",
  "user_id": "62d2a2282c71d2a627481d96",
  "request_to_user_id": "62e9d981f6c80f9c906ac0e1",
  "joining_content_id": "62d4ff51e69a889c68453e12",
  "request_type": "initial_leader",
  "user_identity": 1,
  "status": 1,
  "deleted": false,
  "createdAt": "2022-08-05T12:01:05.196Z",
  "updatedAt": "2022-08-05T12:01:05.196Z",
  "__v": 0
}
*/

  String? Id;
  String? userId;
  String? requestToUserId;
  String? joiningContentId;
  String? requestType;
  int? userIdentity;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? V;

  LeadershipModelDataMuddaInviteData({
    this.Id,
    this.userId,
    this.requestToUserId,
    this.joiningContentId,
    this.requestType,
    this.userIdentity,
    this.status,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.V,
  });
  LeadershipModelDataMuddaInviteData.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    userId = json['user_id']?.toString();
    requestToUserId = json['request_to_user_id']?.toString();
    joiningContentId = json['joining_content_id']?.toString();
    requestType = json['request_type']?.toString();
    userIdentity = json['user_identity']?.toInt();
    status = json['status']?.toInt();
    deleted = json['deleted'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    V = json['__v']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['user_id'] = userId;
    data['request_to_user_id'] = requestToUserId;
    data['joining_content_id'] = joiningContentId;
    data['request_type'] = requestType;
    data['user_identity'] = userIdentity;
    data['status'] = status;
    data['deleted'] = deleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = V;
    return data;
  }
}
