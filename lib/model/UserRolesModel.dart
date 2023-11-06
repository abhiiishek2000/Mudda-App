class UserRolesModel {
  int? status;
  String? message;
  List<Role>? data;
  String? path;

  UserRolesModel({this.status, this.message, this.data, this.path});

  UserRolesModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Role>[];
      json['data'].forEach((v) {
        data!.add(Role.fromJson(v));
      });
    }
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    return data;
  }
}

class Role {
  String? sId;
  String? userId;
  String? organizationId;
  String? organizationType;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? position;
  String? role;
  User? user;

  Role(
      {this.sId,
        this.userId,
        this.organizationId,
        this.organizationType,
        this.status,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.position,
        this.role,
        this.user});

  Role.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    organizationId = json['organization_id'];
    organizationType = json['organization_type'];
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    position = json['position'];
    role = json['role'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['organization_id'] = this.organizationId;
    data['organization_type'] = this.organizationType;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['position'] = this.position;
    data['role'] = this.role;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? sId;
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
  List<String>? category;
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
  int? status;
  int? wallet;
  int? walletWining;
  int? isWithdrawAllow;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  User(
      {this.sId,
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
        this.status,
        this.wallet,
        this.walletWining,
        this.isWithdrawAllow,
        this.createdBy,
        this.updatedBy,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullname = json['fullname'];
    username = json['username'];
    userType = json['user_type'];
    profileType = json['profile_type'];
    organizationType = json['organization_type'];
    email = json['email'];
    password = json['password'];
    mobileNo = json['mobile_no'];
    countryCode = json['country_code'];
    otp = json['otp'];
    otpTime = json['otp_time'];
    isOtpVerified = json['is_otp_verified'];
    emailVerifiedAt = json['email_verified_at'];
    profile = json['profile'];
    registrationDocument = json['registration_document'];
    isGovtRegister = json['is_govt_register'];
    profession = json['profession'];
    muddaCount = json['mudda_count'];
    description = json['description'];
    category = json['category'].cast<String>();
    age = json['age'];
    gender = json['gender'];
    orgAddress = json['org_address'];
    location = json['location'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    socialId = json['social_id'];
    socialPic = json['social_pic'];
    socialToken = json['social_token'];
    registerType = json['register_type'];
    firebaseToken = json['firebase_token'];
    referralCode = json['referral_code'];
    referBy = json['refer_by'];
    status = json['status'];
    wallet = json['wallet'];
    walletWining = json['wallet_wining'];
    isWithdrawAllow = json['is_withdraw_allow'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullname'] = this.fullname;
    data['username'] = this.username;
    data['user_type'] = this.userType;
    data['profile_type'] = this.profileType;
    data['organization_type'] = this.organizationType;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobile_no'] = this.mobileNo;
    data['country_code'] = this.countryCode;
    data['otp'] = this.otp;
    data['otp_time'] = this.otpTime;
    data['is_otp_verified'] = this.isOtpVerified;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['profile'] = this.profile;
    data['registration_document'] = this.registrationDocument;
    data['is_govt_register'] = this.isGovtRegister;
    data['profession'] = this.profession;
    data['mudda_count'] = this.muddaCount;
    data['description'] = this.description;
    data['category'] = this.category;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['org_address'] = this.orgAddress;
    data['location'] = this.location;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zipcode'] = this.zipcode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['social_id'] = this.socialId;
    data['social_pic'] = this.socialPic;
    data['social_token'] = this.socialToken;
    data['register_type'] = this.registerType;
    data['firebase_token'] = this.firebaseToken;
    data['referral_code'] = this.referralCode;
    data['refer_by'] = this.referBy;
    data['status'] = this.status;
    data['wallet'] = this.wallet;
    data['wallet_wining'] = this.walletWining;
    data['is_withdraw_allow'] = this.isWithdrawAllow;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
