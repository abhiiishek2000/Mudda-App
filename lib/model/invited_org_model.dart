// To parse this JSON data, do
//
//     final invitedOrgModel = invitedOrgModelFromJson(jsonString);

import 'dart:convert';

InvitedOrgModel invitedOrgModelFromJson(String str) => InvitedOrgModel.fromJson(json.decode(str));

String invitedOrgModelToJson(InvitedOrgModel data) => json.encode(data.toJson());

  class InvitedOrgModel {
  InvitedOrgModel({
    this.status,
    this.message,
    this.data,
    this.path,
    this.invitedCount
  });

  int? status;
  int? invitedCount;
  String? message;
  List<InvitedOrg>? data;
  String? path;

  factory InvitedOrgModel.fromJson(Map<String, dynamic> json) => InvitedOrgModel(
    status: json["status"] == null ? null : json["status"],
    invitedCount: json["inviteCount"] == null ? null : json["inviteCount"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<InvitedOrg>.from(json["data"].map((x) => InvitedOrg.fromJson(x))),
    path: json["path"] == null ? null : json["path"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "inviteCount": invitedCount == null ? null : invitedCount,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    "path": path == null ? null : path,
  };
}

class InvitedOrg {
  InvitedOrg({
    this.id,
    this.userId,
    this.requestToUserId,
    this.joiningContentId,
    this.requestType,
    this.userIdentity,
    this.status,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.user,
  });

  String? id;
  UserId? userId;
  String? requestToUserId;
  dynamic joiningContentId;
  RequestType? requestType;
  int? userIdentity;
  int? status;
  bool? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  User? user;

  factory InvitedOrg.fromJson(Map<String, dynamic> json) => InvitedOrg(
    id: json["_id"] == null ? null : json["_id"],
    userId: json["user_id"] == null ? null : userIdValues.map![json["user_id"]],
    requestToUserId: json["request_to_user_id"] == null ? null : json["request_to_user_id"],
    joiningContentId: json["joining_content_id"],
    requestType: json["request_type"] == null ? null : requestTypeValues.map![json["request_type"]],
    userIdentity: json["user_identity"] == null ? null : json["user_identity"],
    status: json["status"] == null ? null : json["status"],
    deleted: json["deleted"] == null ? null : json["deleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"] == null ? null : json["__v"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "user_id": userId == null ? null : userIdValues.reverse[userId],
    "request_to_user_id": requestToUserId == null ? null : requestToUserId,
    "joining_content_id": joiningContentId,
    "request_type": requestType == null ? null : requestTypeValues.reverse[requestType],
    "user_identity": userIdentity == null ? null : userIdentity,
    "status": status == null ? null : status,
    "deleted": deleted == null ? null : deleted,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "__v": v == null ? null : v,
    "user": user == null ? null : user!.toJson(),
  };
}

enum RequestType { INVITE }

final requestTypeValues = EnumValues({
  "invite": RequestType.INVITE
});

class User {
  User({
    this.id,
    this.fullname,
    this.username,
    this.userType,
    this.profileType,
    this.organizationType,
    this.email,
    this.password,
    this.mobileNo,
    this.countryCode,
    this.otp,
    this.otpTime,
    this.isOtpVerified,
    this.emailVerifiedAt,
    this.profile,
    this.registrationDocument,
    this.isGovtRegister,
    this.profession,
    this.muddaCount,
    this.description,
    this.category,
    this.age,
    this.gender,
    this.orgAddress,
    this.location,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.latitude,
    this.longitude,
    this.socialId,
    this.socialPic,
    this.socialToken,
    this.registerType,
    this.firebaseToken,
    this.referralCode,
    this.referBy,
    this.isProfileVerified,
    this.verificationVideo,
    this.status,
    this.wallet,
    this.walletWining,
    this.isWithdrawAllow,
    this.createdBy,
    this.updatedBy,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.blockedBy,
    this.blockedTill,
    this.isBlocked,
  });

  String? id;
  String? fullname;
  String? username;
  UserType? userType;
  ProfileType? profileType;
  dynamic organizationType;
  String? email;
  dynamic password;
  String? mobileNo;
  String? countryCode;
  dynamic otp;
  dynamic otpTime;
  int? isOtpVerified;
  dynamic emailVerifiedAt;
  String? profile;
  dynamic registrationDocument;
  dynamic isGovtRegister;
  String? profession;
  int? muddaCount;
  String? description;
  List<dynamic>? category;
  String? age;
  Gender? gender;
  dynamic orgAddress;
  dynamic location;
  String? city;
  String? state;
  String? country;
  dynamic zipcode;
  dynamic latitude;
  dynamic longitude;
  String? socialId;
  String? socialPic;
  String? socialToken;
  RegisterType? registerType;
  dynamic firebaseToken;
  String? referralCode;
  String? referBy;
  int? isProfileVerified;
  String? verificationVideo;
  int? status;
  int? wallet;
  int? walletWining;
  int? isWithdrawAllow;
  dynamic createdBy;
  dynamic updatedBy;
  bool? deleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  dynamic blockedBy;
  dynamic blockedTill;
  bool? isBlocked;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"] == null ? null : json["_id"],
    fullname: json["fullname"] == null ? null : json["fullname"],
    username: json["username"] == null ? null : json["username"],
    userType: json["user_type"] == null ? null : userTypeValues.map![json["user_type"]],
    profileType: json["profile_type"] == null ? null : profileTypeValues.map![json["profile_type"]],
    organizationType: json["organization_type"],
    email: json["email"] == null ? null : json["email"],
    password: json["password"],
    mobileNo: json["mobile_no"] == null ? null : json["mobile_no"],
    countryCode: json["country_code"] == null ? null : json["country_code"],
    otp: json["otp"],
    otpTime: json["otp_time"],
    isOtpVerified: json["is_otp_verified"] == null ? null : json["is_otp_verified"],
    emailVerifiedAt: json["email_verified_at"],
    profile: json["profile"] == null ? null : json["profile"],
    registrationDocument: json["registration_document"],
    isGovtRegister: json["is_govt_register"],
    profession: json["profession"] == null ? null : json["profession"],
    muddaCount: json["mudda_count"] == null ? null : json["mudda_count"],
    description: json["description"] == null ? null : json["description"],
    category: json["category"] == null ? null : List<dynamic>.from(json["category"].map((x) => x)),
    age: json["age"] == null ? null : json["age"],
    gender: json["gender"] == null ? null : genderValues.map![json["gender"]],
    orgAddress: json["org_address"],
    location: json["location"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    country: json["country"] == null ? null : json["country"],
    zipcode: json["zipcode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    socialId: json["social_id"] == null ? null : json["social_id"],
    socialPic: json["social_pic"] == null ? null : json["social_pic"],
    socialToken: json["social_token"] == null ? null : json["social_token"],
    registerType: json["register_type"] == null ? null : registerTypeValues.map![json["register_type"]],
    firebaseToken: json["firebase_token"],
    referralCode: json["referral_code"] == null ? null : json["referral_code"],
    referBy: json["refer_by"] == null ? null : json["refer_by"],
    isProfileVerified: json["isProfileVerified"] == null ? null : json["isProfileVerified"],
    verificationVideo: json["verification_video"] == null ? null : json["verification_video"],
    status: json["status"] == null ? null : json["status"],
    wallet: json["wallet"] == null ? null : json["wallet"],
    walletWining: json["wallet_wining"] == null ? null : json["wallet_wining"],
    isWithdrawAllow: json["is_withdraw_allow"] == null ? null : json["is_withdraw_allow"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deleted: json["deleted"] == null ? null : json["deleted"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"] == null ? null : json["__v"],
    blockedBy: json["blockedBy"],
    blockedTill: json["blockedTill"],
    isBlocked: json["isBlocked"] == null ? null : json["isBlocked"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id == null ? null : id,
    "fullname": fullname == null ? null : fullname,
    "username": username == null ? null : username,
    "user_type": userType == null ? null : userTypeValues.reverse[userType],
    "profile_type": profileType == null ? null : profileTypeValues.reverse[profileType],
    "organization_type": organizationType,
    "email": email == null ? null : email,
    "password": password,
    "mobile_no": mobileNo == null ? null : mobileNo,
    "country_code": countryCode == null ? null : countryCode,
    "otp": otp,
    "otp_time": otpTime,
    "is_otp_verified": isOtpVerified == null ? null : isOtpVerified,
    "email_verified_at": emailVerifiedAt,
    "profile": profile == null ? null : profile,
    "registration_document": registrationDocument,
    "is_govt_register": isGovtRegister,
    "profession": profession == null ? null : profession,
    "mudda_count": muddaCount == null ? null : muddaCount,
    "description": description == null ? null : description,
    "category": category == null ? null : List<dynamic>.from(category!.map((x) => x)),
    "age": age == null ? null : age,
    "gender": gender == null ? null : genderValues.reverse[gender],
    "org_address": orgAddress,
    "location": location,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "country": country == null ? null : country,
    "zipcode": zipcode,
    "latitude": latitude,
    "longitude": longitude,
    "social_id": socialId == null ? null : socialId,
    "social_pic": socialPic == null ? null : socialPic,
    "social_token": socialToken == null ? null : socialToken,
    "register_type": registerType == null ? null : registerTypeValues.reverse[registerType],
    "firebase_token": firebaseToken,
    "referral_code": referralCode == null ? null : referralCode,
    "refer_by": referBy == null ? null : referBy,
    "isProfileVerified": isProfileVerified == null ? null : isProfileVerified,
    "verification_video": verificationVideo == null ? null : verificationVideo,
    "status": status == null ? null : status,
    "wallet": wallet == null ? null : wallet,
    "wallet_wining": walletWining == null ? null : walletWining,
    "is_withdraw_allow": isWithdrawAllow == null ? null : isWithdrawAllow,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted": deleted == null ? null : deleted,
    "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
    "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
    "__v": v == null ? null : v,
    "blockedBy": blockedBy,
    "blockedTill": blockedTill,
    "isBlocked": isBlocked == null ? null : isBlocked,
  };
}

enum Gender { NULL, MALE, FEMALE }

final genderValues = EnumValues({
  "Female": Gender.FEMALE,
  "Male": Gender.MALE,
  "null": Gender.NULL
});

enum ProfileType { PUBLIC }

final profileTypeValues = EnumValues({
  "public": ProfileType.PUBLIC
});

enum RegisterType { GOOGLE, APP }

final registerTypeValues = EnumValues({
  "app": RegisterType.APP,
  "google": RegisterType.GOOGLE
});

enum UserType { USER }

final userTypeValues = EnumValues({
  "user": UserType.USER
});

enum UserId { THE_63468716_AED059_A9050_B192_B }

final userIdValues = EnumValues({
  "63468716aed059a9050b192b": UserId.THE_63468716_AED059_A9050_B192_B
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
