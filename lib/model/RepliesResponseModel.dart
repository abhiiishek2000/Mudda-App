


import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'PostForMuddaModel.dart';

class RepliesResponseModelResultUserDetail {

  String? Id;
  String? fullname;
  String? username;
  String? userType;
  String? profileType;
  String? organizationType;
  String? email;
  String? password;
  String? mobileNo;
  String? countryCode;
  String? otp;
  String? otpTime;
  int? isOtpVerified;
  String? emailVerifiedAt;
  String? profile;
  String? registrationDocument;
  String? isGovtRegister;
  String? profession;
  int? muddaCount;
  String? description;
  dynamic category;
  String? age;
  String? gender;
  String? orgAddress;
  String? location;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? latitude;
  String? longitude;
  String? socialId;
  String? socialPic;
  String? socialToken;
  String? registerType;
  String? firebaseToken;
  String? referralCode;
  String? referBy;
  int? isProfileVerified;
  String? verificationVideo;
  int? status;
  int? wallet;
  int? walletWining;
  int? isWithdrawAllow;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? V;

  RepliesResponseModelResultUserDetail({
    this.Id,
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
    this.V,
  });
  RepliesResponseModelResultUserDetail.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    fullname = json['fullname']?.toString();
    username = json['username']?.toString();
    userType = json['user_type']?.toString();
    profileType = json['profile_type']?.toString();
    organizationType = json['organization_type']?.toString();
    email = json['email']?.toString();
    password = json['password']?.toString();
    mobileNo = json['mobile_no']?.toString();
    countryCode = json['country_code']?.toString();
    otp = json['otp']?.toString();
    otpTime = json['otp_time']?.toString();
    isOtpVerified = json['is_otp_verified']?.toInt();
    emailVerifiedAt = json['email_verified_at']?.toString();
    profile = json['profile']?.toString();
    registrationDocument = json['registration_document']?.toString();
    isGovtRegister = json['is_govt_register']?.toString();
    profession = json['profession']?.toString();
    muddaCount = json['mudda_count']?.toInt();
    description = json['description']?.toString();
    age = json['age']?.toString();
    gender = json['gender']?.toString();
    orgAddress = json['org_address']?.toString();
    location = json['location']?.toString();
    city = json['city']?.toString();
    state = json['state']?.toString();
    country = json['country']?.toString();
    zipcode = json['zipcode']?.toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    socialId = json['social_id']?.toString();
    socialPic = json['social_pic']?.toString();
    socialToken = json['social_token']?.toString();
    registerType = json['register_type']?.toString();
    firebaseToken = json['firebase_token']?.toString();
    referralCode = json['referral_code']?.toString();
    referBy = json['refer_by']?.toString();
    isProfileVerified = json['isProfileVerified']?.toInt();
    verificationVideo = json['verification_video']?.toString();
    status = json['status']?.toInt();
    wallet = json['wallet']?.toInt();
    walletWining = json['wallet_wining']?.toInt();
    isWithdrawAllow = json['is_withdraw_allow']?.toInt();
    createdBy = json['created_by']?.toString();
    updatedBy = json['updated_by']?.toString();
    deleted = json['deleted'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    V = json['__v']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['fullname'] = fullname;
    data['username'] = username;
    data['user_type'] = userType;
    data['profile_type'] = profileType;
    data['organization_type'] = organizationType;
    data['email'] = email;
    data['password'] = password;
    data['mobile_no'] = mobileNo;
    data['country_code'] = countryCode;
    data['otp'] = otp;
    data['otp_time'] = otpTime;
    data['is_otp_verified'] = isOtpVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['profile'] = profile;
    data['registration_document'] = registrationDocument;
    data['is_govt_register'] = isGovtRegister;
    data['profession'] = profession;
    data['mudda_count'] = muddaCount;
    data['description'] = description;
    data['age'] = age;
    data['gender'] = gender;
    data['org_address'] = orgAddress;
    data['location'] = location;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['zipcode'] = zipcode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['social_id'] = socialId;
    data['social_pic'] = socialPic;
    data['social_token'] = socialToken;
    data['register_type'] = registerType;
    data['firebase_token'] = firebaseToken;
    data['referral_code'] = referralCode;
    data['refer_by'] = referBy;
    data['isProfileVerified'] = isProfileVerified;
    data['verification_video'] = verificationVideo;
    data['status'] = status;
    data['wallet'] = wallet;
    data['wallet_wining'] = walletWining;
    data['is_withdraw_allow'] = isWithdrawAllow;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['deleted'] = deleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = V;
    return data;
  }
}
class RepliesResponseModelResultDislikerUser {

  String? Id;
  String? fullname;
  String? username;
  String? userType;
  String? profileType;
  String? organizationType;
  String? email;
  String? password;
  String? mobileNo;
  String? countryCode;
  String? otp;
  String? otpTime;
  int? isOtpVerified;
  String? emailVerifiedAt;
  String? profile;
  String? registrationDocument;
  String? isGovtRegister;
  String? profession;
  int? muddaCount;
  String? description;
  dynamic category;
  String? age;
  String? gender;
  String? orgAddress;
  String? location;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? latitude;
  String? longitude;
  String? socialId;
  String? socialPic;
  String? socialToken;
  String? registerType;
  String? firebaseToken;
  String? referralCode;
  String? referBy;
  int? isProfileVerified;
  String? verificationVideo;
  int? status;
  int? wallet;
  int? walletWining;
  int? isWithdrawAllow;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? V;

  RepliesResponseModelResultDislikerUser({
    this.Id,
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
    this.V,
  });
  RepliesResponseModelResultDislikerUser.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    fullname = json['fullname']?.toString();
    username = json['username']?.toString();
    userType = json['user_type']?.toString();
    profileType = json['profile_type']?.toString();
    organizationType = json['organization_type']?.toString();
    email = json['email']?.toString();
    password = json['password']?.toString();
    mobileNo = json['mobile_no']?.toString();
    countryCode = json['country_code']?.toString();
    otp = json['otp']?.toString();
    otpTime = json['otp_time']?.toString();
    isOtpVerified = json['is_otp_verified']?.toInt();
    emailVerifiedAt = json['email_verified_at']?.toString();
    profile = json['profile']?.toString();
    registrationDocument = json['registration_document']?.toString();
    isGovtRegister = json['is_govt_register']?.toString();
    profession = json['profession']?.toString();
    muddaCount = json['mudda_count']?.toInt();
    description = json['description']?.toString();
    age = json['age']?.toString();
    gender = json['gender']?.toString();
    orgAddress = json['org_address']?.toString();
    location = json['location']?.toString();
    city = json['city']?.toString();
    state = json['state']?.toString();
    country = json['country']?.toString();
    zipcode = json['zipcode']?.toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    socialId = json['social_id']?.toString();
    socialPic = json['social_pic']?.toString();
    socialToken = json['social_token']?.toString();
    registerType = json['register_type']?.toString();
    firebaseToken = json['firebase_token']?.toString();
    referralCode = json['referral_code']?.toString();
    referBy = json['refer_by']?.toString();
    isProfileVerified = json['isProfileVerified']?.toInt();
    verificationVideo = json['verification_video']?.toString();
    status = json['status']?.toInt();
    wallet = json['wallet']?.toInt();
    walletWining = json['wallet_wining']?.toInt();
    isWithdrawAllow = json['is_withdraw_allow']?.toInt();
    createdBy = json['created_by']?.toString();
    updatedBy = json['updated_by']?.toString();
    deleted = json['deleted'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    V = json['__v']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['fullname'] = fullname;
    data['username'] = username;
    data['user_type'] = userType;
    data['profile_type'] = profileType;
    data['organization_type'] = organizationType;
    data['email'] = email;
    data['password'] = password;
    data['mobile_no'] = mobileNo;
    data['country_code'] = countryCode;
    data['otp'] = otp;
    data['otp_time'] = otpTime;
    data['is_otp_verified'] = isOtpVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['profile'] = profile;
    data['registration_document'] = registrationDocument;
    data['is_govt_register'] = isGovtRegister;
    data['profession'] = profession;
    data['mudda_count'] = muddaCount;
    data['description'] = description;
    data['age'] = age;
    data['gender'] = gender;
    data['org_address'] = orgAddress;
    data['location'] = location;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['zipcode'] = zipcode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['social_id'] = socialId;
    data['social_pic'] = socialPic;
    data['social_token'] = socialToken;
    data['register_type'] = registerType;
    data['firebase_token'] = firebaseToken;
    data['referral_code'] = referralCode;
    data['refer_by'] = referBy;
    data['isProfileVerified'] = isProfileVerified;
    data['verification_video'] = verificationVideo;
    data['status'] = status;
    data['wallet'] = wallet;
    data['wallet_wining'] = walletWining;
    data['is_withdraw_allow'] = isWithdrawAllow;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['deleted'] = deleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = V;
    return data;
  }
}

class RepliesResponseModelResultDisliker {


  String? Id;
  String? userId;
  String? relativeId;
  String? relativeType;
  bool? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? V;
  RepliesResponseModelResultDislikerUser? user;

  RepliesResponseModelResultDisliker({
    this.Id,
    this.userId,
    this.relativeId,
    this.relativeType,
    this.status,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.V,
    this.user,
  });
  RepliesResponseModelResultDisliker.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    userId = json['user_id']?.toString();
    relativeId = json['relative_id']?.toString();
    relativeType = json['relative_type']?.toString();
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    V = json['__v']?.toInt();
    user = (json['user'] != null) ? RepliesResponseModelResultDislikerUser.fromJson(json['user']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['user_id'] = userId;
    data['relative_id'] = relativeId;
    data['relative_type'] = relativeType;
    data['status'] = status;
    data['deleted'] = deleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = V;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class RepliesResponseModelResultLikerUser {


  String? Id;
  String? fullname;
  String? username;
  String? userType;
  String? profileType;
  String? organizationType;
  String? email;
  String? password;
  String? mobileNo;
  String? countryCode;
  String? otp;
  String? otpTime;
  int? isOtpVerified;
  String? emailVerifiedAt;
  String? profile;
  String? registrationDocument;
  String? isGovtRegister;
  String? profession;
  int? muddaCount;
  String? description;
  dynamic category;
  String? age;
  String? gender;
  String? orgAddress;
  String? location;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? latitude;
  String? longitude;
  String? socialId;
  String? socialPic;
  String? socialToken;
  String? registerType;
  String? firebaseToken;
  String? referralCode;
  String? referBy;
  int? isProfileVerified;
  String? verificationVideo;
  int? status;
  int? wallet;
  int? walletWining;
  int? isWithdrawAllow;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? V;

  RepliesResponseModelResultLikerUser({
    this.Id,
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
    this.V,
  });
  RepliesResponseModelResultLikerUser.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    fullname = json['fullname']?.toString();
    username = json['username']?.toString();
    userType = json['user_type']?.toString();
    profileType = json['profile_type']?.toString();
    organizationType = json['organization_type']?.toString();
    email = json['email']?.toString();
    password = json['password']?.toString();
    mobileNo = json['mobile_no']?.toString();
    countryCode = json['country_code']?.toString();
    otp = json['otp']?.toString();
    otpTime = json['otp_time']?.toString();
    isOtpVerified = json['is_otp_verified']?.toInt();
    emailVerifiedAt = json['email_verified_at']?.toString();
    profile = json['profile']?.toString();
    registrationDocument = json['registration_document']?.toString();
    isGovtRegister = json['is_govt_register']?.toString();
    profession = json['profession']?.toString();
    muddaCount = json['mudda_count']?.toInt();
    description = json['description']?.toString();
    age = json['age']?.toString();
    gender = json['gender']?.toString();
    orgAddress = json['org_address']?.toString();
    location = json['location']?.toString();
    city = json['city']?.toString();
    state = json['state']?.toString();
    country = json['country']?.toString();
    zipcode = json['zipcode']?.toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    socialId = json['social_id']?.toString();
    socialPic = json['social_pic']?.toString();
    socialToken = json['social_token']?.toString();
    registerType = json['register_type']?.toString();
    firebaseToken = json['firebase_token']?.toString();
    referralCode = json['referral_code']?.toString();
    referBy = json['refer_by']?.toString();
    isProfileVerified = json['isProfileVerified']?.toInt();
    verificationVideo = json['verification_video']?.toString();
    status = json['status']?.toInt();
    wallet = json['wallet']?.toInt();
    walletWining = json['wallet_wining']?.toInt();
    isWithdrawAllow = json['is_withdraw_allow']?.toInt();
    createdBy = json['created_by']?.toString();
    updatedBy = json['updated_by']?.toString();
    deleted = json['deleted'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    V = json['__v']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['fullname'] = fullname;
    data['username'] = username;
    data['user_type'] = userType;
    data['profile_type'] = profileType;
    data['organization_type'] = organizationType;
    data['email'] = email;
    data['password'] = password;
    data['mobile_no'] = mobileNo;
    data['country_code'] = countryCode;
    data['otp'] = otp;
    data['otp_time'] = otpTime;
    data['is_otp_verified'] = isOtpVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['profile'] = profile;
    data['registration_document'] = registrationDocument;
    data['is_govt_register'] = isGovtRegister;
    data['profession'] = profession;
    data['mudda_count'] = muddaCount;
    data['description'] = description;
    data['age'] = age;
    data['gender'] = gender;
    data['org_address'] = orgAddress;
    data['location'] = location;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['zipcode'] = zipcode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['social_id'] = socialId;
    data['social_pic'] = socialPic;
    data['social_token'] = socialToken;
    data['register_type'] = registerType;
    data['firebase_token'] = firebaseToken;
    data['referral_code'] = referralCode;
    data['refer_by'] = referBy;
    data['isProfileVerified'] = isProfileVerified;
    data['verification_video'] = verificationVideo;
    data['status'] = status;
    data['wallet'] = wallet;
    data['wallet_wining'] = walletWining;
    data['is_withdraw_allow'] = isWithdrawAllow;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['deleted'] = deleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = V;
    return data;
  }
}

class RepliesResponseModelResultLiker {
  String? Id;
  String? userId;
  String? relativeId;
  String? relativeType;
  bool? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? V;
  RepliesResponseModelResultLikerUser? user;

  RepliesResponseModelResultLiker({
    this.Id,
    this.userId,
    this.relativeId,
    this.relativeType,
    this.status,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.V,
    this.user,
  });
  RepliesResponseModelResultLiker.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    userId = json['user_id']?.toString();
    relativeId = json['relative_id']?.toString();
    relativeType = json['relative_type']?.toString();
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    V = json['__v']?.toInt();
    user = (json['user'] != null) ? RepliesResponseModelResultLikerUser.fromJson(json['user']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['user_id'] = userId;
    data['relative_id'] = relativeId;
    data['relative_type'] = relativeType;
    data['status'] = status;
    data['deleted'] = deleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = V;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class RepliesResponseModelResultComments {

  String? Id;
  String? userId;
  String? relativeId;
  String? relativeType;
  String? commentType;
  String? commentText;
  int? userIdentity;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? V;

  RepliesResponseModelResultComments({
    this.Id,
    this.userId,
    this.relativeId,
    this.relativeType,
    this.commentType,
    this.commentText,
    this.userIdentity,
    this.status,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.V,
  });
  RepliesResponseModelResultComments.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    userId = json['user_id']?.toString();
    relativeId = json['relative_id']?.toString();
    relativeType = json['relative_type']?.toString();
    commentType = json['comment_type']?.toString();
    commentText = json['commentText']?.toString();
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
    data['relative_id'] = relativeId;
    data['relative_type'] = relativeType;
    data['comment_type'] = commentType;
    data['commentText'] = commentText;
    data['user_identity'] = userIdentity;
    data['status'] = status;
    data['deleted'] = deleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = V;
    return data;
  }
}

class RepliesResponseModelResultGallery {


  String? Id;
  String? userId;
  String? relativeId;
  String? relativeType;
  String? file;
  String? path;
  int? status;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? V;

  RepliesResponseModelResultGallery({
    this.Id,
    this.userId,
    this.relativeId,
    this.relativeType,
    this.file,
    this.path,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.V,
  });
  RepliesResponseModelResultGallery.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    userId = json['user_id']?.toString();
    relativeId = json['relative_id']?.toString();
    relativeType = json['relative_type']?.toString();
    file = json['file']?.toString();
    path = json['path']?.toString();
    status = json['status']?.toInt();
    createdBy = json['created_by']?.toString();
    updatedBy = json['updated_by']?.toString();
    deleted = json['deleted'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
    V = json['__v']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['user_id'] = userId;
    data['relative_id'] = relativeId;
    data['relative_type'] = relativeType;
    data['file'] = file;
    data['path'] = path;
    data['status'] = status;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['deleted'] = deleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = V;
    return data;
  }
}



class RepliesResponseModel {

  List<PostForMudda>? result;
  String? message;
  bool? success;
  int? status;

  RepliesResponseModel({
    this.result,
    this.message,
    this.success,
    this.status,
  });
  RepliesResponseModel.fromJson(Map<dynamic, dynamic> json) {
    if (json['result'] != null) {
      final v = json['result'];
      final arr0 = <PostForMudda>[];
      v.forEach((v) {
        arr0.add(PostForMudda.fromJson(v));
      });
      result = arr0;
    }
    message = json['message']?.toString();
    success = json['success'];
    status = json['status']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (result != null) {
      final v = result;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v.toJson());
      });
      data['result'] = arr0;
    }
    data['message'] = message;
    data['success'] = success;
    data['status'] = status;
    return data;
  }
}
