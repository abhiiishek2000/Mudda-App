import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mudda/model/LeadersDataModel.dart';
import 'package:mudda/model/PostForMuddaModel.dart';

class MuddaPostModel {
  int? status;
  String? message;
  List<MuddaPost>? data;
  String? path;
  String? userpath;
  bool? notifications;

  // dynamic totalUsers;
  // dynamic containerUsers;
  // dynamic supportPercentage;
  // dynamic muddaThumbnail;
  // dynamic muddaOwner;
  // dynamic favour;
  // dynamic opposition;

  MuddaPostModel({
    this.status,
    this.message,
    this.data,
    this.path,
    this.notifications,
    this.userpath,
    // this.totalUsers,
    // this.containerUsers,
    // this.supportPercentage,
    // this.muddaThumbnail,
    // this.muddaOwner,
    // this.favour,
    // this.opposition,
  });

  MuddaPostModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MuddaPost>[];
      json['data'].forEach((v) {
        data!.add(MuddaPost.fromJson(v));
      });
    }
    path = json['path'];
    userpath = json['userpath'];
    if (json['notifications'] != null) {
      notifications = json['notifications'];
    }

    // totalUsers = json['totalUsers'];
    // containerUsers = json['containerUsers'];
    // supportPercentage = json['supportPercentage'];
    // muddaThumbnail = json['muddaThumbnail'];
    // muddaOwner = json['muddaOwner'];
    // favour = json['favour'];
    // opposition = json['opposition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.notifications != null) {
      data['notifications'] = this.notifications;
    }
    data['path'] = this.path;
    data['userpath'] = this.userpath;

    // data['totalUsers'] = this.totalUsers;
    // data['containerUsers'] = this.containerUsers;
    // data['supportPercentage'] = this.supportPercentage;
    // data['muddaThumbnail'] = this.muddaThumbnail;
    // data['muddaOwner'] = this.muddaOwner;
    // data['favour'] = this.favour;
    // data['opposition'] = this.opposition;
    return data;
  }
}

class MuddaPost {
  String? sId;
  String? userId;
  String? postAs;
  String? thumbnail;
  String? title;
  String? initialScope;
  String? muddaDescription;
  List<String>? hashtags;
  List<String>? uniquePlaces;
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
  List<Gallery>? gallery;
  List<Leaders>? leaders;
  int? leadersCount;
  int? joinersCount;
  int? inviteCount;
  int? requestsCount;
  AfterMe? afterMe;
  List<MyReaction>? myReaction;
  MyReaction? isInvolved;
  MyReaction? amIRequested;
  bool? mySupport;
  int? amIfollowing;
  int? support;
  int? totalVote;
  int? totalPost;
  int? totalFavourPost;
  int? favourCount;
  int? oppositionCount;
  int? uniqueCity;
  int? uniqueState;
  int? uniqueCountry;
  dynamic favour;
  dynamic opposition;
  double? supportDiff;
  int? newLeaderDiff;
  int? newPostDiff;
  double? inDebte;
  int? amIjoined;
  String? id;
  bool? muddaDescripation = false;
  bool? muddaAction = true;
  bool? isAdsLoaded = false;
  LeadershipModelDataMuddaInviteData? favourInvite;
  LeadershipModelDataMuddaInviteData? oppositionInvite;
  NativeAd? ad;

  MuddaPost(
      {this.sId,
      this.userId,
      this.postAs,
      this.thumbnail,
      this.title,
      this.initialScope,
      this.muddaDescription,
      this.hashtags,
      this.uniquePlaces,
      this.area,
      this.landmark,
      this.city,
      this.state,
      this.supportDiff,
      this.newLeaderDiff,
      this.inDebte,
      this.newPostDiff,
      this.country,
      this.zipcode,
      this.latitude,
      this.longitude,
      this.audienceGender,
      this.audienceAge,
      this.favour,
      this.opposition,
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
      this.leaders,
      this.leadersCount,
      this.joinersCount,
      this.inviteCount,
      this.requestsCount,
      this.afterMe,
      this.myReaction,
      this.isInvolved,
      this.amIRequested,
      this.mySupport,
      this.amIfollowing,
      this.support,
      this.totalVote,
      this.totalPost,
      this.totalFavourPost,
      this.favourCount,
      this.oppositionCount,
      this.uniqueCity,
      this.uniqueState,
      this.uniqueCountry,
      this.amIjoined,
      this.favourInvite,
      this.oppositionInvite,
      this.id});

  MuddaPost.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    postAs = json['post_as'];
    thumbnail = json['thumbnail'];
    title = json['title'];
    initialScope = json['initial_scope'];
    muddaDescription = json['mudda_description'] ?? "";
    hashtags = json['hashtags'].cast<String>();
    uniquePlaces =
        json['uniquePlaces'] != null ? json['uniquePlaces'].cast<String>() : [];
    area = json['area'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    favour = json['favour'];
    opposition = json['opposition'];
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
    if (json['isInvolved'] != null) {
      isInvolved = MyReaction.fromJson(json['isInvolved']);
    }
    if (json['amIRequested'] != null) {
      amIRequested = MyReaction.fromJson(json['amIRequested']);
    }
    iV = json['__v'];
    if (json['gallery'] != null) {
      gallery = <Gallery>[];
      json['gallery'].forEach((v) {
        gallery!.add(Gallery.fromJson(v));
      });
    }
    if (json['leaders'] != null) {
      leaders = <Leaders>[];
      json['leaders'].forEach((v) {
        leaders!.add(Leaders.fromJson(v));
      });
    }
    leadersCount = json['leadersCount'];
    joinersCount = json['joinersCount'];
    inviteCount = json['inviteCount'];
    requestsCount = json['requestsCount'];
    afterMe =
        json['afterMe'] != null ? AfterMe.fromJson(json['afterMe']) : null;
    if (json['myReaction'] != null) {
      myReaction = <MyReaction>[];
      json['myReaction'].forEach((v) {
        myReaction!.add(MyReaction.fromJson(v));
      });
    }
    mySupport = json['mySupport'];
    amIfollowing = json['amIfollowing'] ?? 0;
    support = json['support'] ?? 0;
    totalVote = json['totalVote'] ?? 0;
    totalPost = json['totalPost'] ?? 0;
    totalFavourPost = json['totalFavourPost'] ?? 0;
    oppositionCount = json['oppositionCount'] ?? 0;
    favourCount = json['favourCount'] ?? 0;
    uniqueCity = json['uniqueCity'] ?? 0;
    uniqueState = json['uniqueState'] ?? 0;
    uniqueCountry = json['uniqueCountry'] ?? 0;
    amIjoined = json['amIjoined'] ?? 0;
    favourInvite = (json['favourInvite'] != null)
        ? LeadershipModelDataMuddaInviteData.fromJson(json['favourInvite'])
        : null;
    oppositionInvite = (json['oppositionInvite'] != null)
        ? LeadershipModelDataMuddaInviteData.fromJson(json['oppositionInvite'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    if (this.gallery != null) {
      data['gallery'] = this.gallery!.map((v) => v.toJson()).toList();
    }
    if (this.leaders != null) {
      data['leaders'] = this.leaders!.map((v) => v.toJson()).toList();
    }
    data['leadersCount'] = this.leadersCount;
    if (this.afterMe != null) {
      data['afterMe'] = this.afterMe!.toJson();
    }
    if (this.myReaction != null) {
      data['myReaction'] = this.myReaction!.map((v) => v.toJson()).toList();
    }
    data['mySupport'] = this.mySupport;
    data['amIfollowing'] = this.amIfollowing;
    data['support'] = this.support;
    data['opposition'] = this.opposition;
    data['favour'] = this.favour;
    data['totalVote'] = this.totalVote;
    data['totalPost'] = this.totalPost;
    data['totalFavourPost'] = this.totalFavourPost;
    data['id'] = this.id;
    if (favourInvite != null) {
      data['favourInvite'] = favourInvite!.toJson();
    }
    if (oppositionInvite != null) {
      data['oppositionInvite'] = oppositionInvite!.toJson();
    }
    return data;
  }
}

class MuddaRole {
/*
{
  "_id": "6361103f384dd7058d58d194",
  "muddaId": "63384519113fac9ad1b1e67a",
  "userId": "6315e547fa9cb80348b74a7c",
  "role": "member"
}
*/

  String? Id;
  String? muddaId;
  String? userId;
  String? role;

  MuddaRole({
    this.Id,
    this.muddaId,
    this.userId,
    this.role,
  });

  MuddaRole.fromJson(Map<String, dynamic> json) {
    Id = json['_id']?.toString();
    muddaId = json['muddaId']?.toString();
    userId = json['userId']?.toString();
    role = json['role']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = Id;
    data['muddaId'] = muddaId;
    data['userId'] = userId;
    data['role'] = role;
    return data;
  }
}

class Leaders {
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
  AcceptUserDetail? acceptUserDetail;
  MuddaRole? muddaRole;
  String? id;

  Leaders(
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
      this.acceptUserDetail,
      this.muddaRole,
      this.id});

  Leaders.fromJson(Map<String, dynamic> json) {
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
    acceptUserDetail = json['acceptUserDetail'] != null
        ? AcceptUserDetail.fromJson(json['acceptUserDetail'])
        : json['user'] != null
            ? AcceptUserDetail.fromJson(json['user'])
            : null;
    id = json['id'];
    muddaRole = (json['muddaRole'] != null)
        ? MuddaRole.fromJson(json['muddaRole'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['request_to_user_id'] = this.requestToUserId;
    data['joining_content_id'] = this.joiningContentId;
    data['accept_type'] = this.acceptType;
    data['joiner_type'] = this.joinerType;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.acceptUserDetail != null) {
      data['acceptUserDetail'] = this.acceptUserDetail!.toJson();
    }
    data['id'] = this.id;
    if (muddaRole != null) {
      data['muddaRole'] = muddaRole!.toJson();
    }
    return data;
  }
}

class AcceptUserDetail {
  String? sId;
  String? invitedId;
  String? supportId;
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
  int? isProfileVerified;
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
  int? followerIndex;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isBlocked;
  String? blockedTill;
  int? countFollowing;
  int? countFollowers;
  int? muddebaazCount;
  int? countNetwork;
  int? countRequests;
  String? chatId;
  List<MemberOfOrganization>? memberOfOrganization;
  int? memberOfOrganizationCount;
  List<MemberOfOrganization>? organizationMember;
  int? organizationMemberCount;
  int? amIFollowing;
  int? amIRequested;
  int? amIInvited;
  bool? isUserBlocked;
  AmIJoined? amIJoined;
  String? id;
  bool? invitedStatus;
  bool? supportStatus;

  AcceptUserDetail(
      {this.sId,
      this.fullname,
      this.username,
      this.invitedId,
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
      this.isProfileVerified,
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
      this.iV,
      this.isBlocked,
      this.isUserBlocked,
      this.blockedTill,
      this.followerIndex,
      this.countFollowing,
      this.countFollowers,
      this.countNetwork,
        this.muddebaazCount,
      this.countRequests,
      this.memberOfOrganization,
      this.memberOfOrganizationCount,
      this.organizationMember,
      this.organizationMemberCount,
      this.amIFollowing,
      this.amIRequested,
        this.amIInvited,
      this.amIJoined,
      this.chatId,
      this.invitedStatus,
      this.supportStatus,
      this.id});

  AcceptUserDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    followerIndex = json['followerIndex'] ?? 0;
    fullname = json['fullname'];
    invitedId = json['invitedId'];
    username = json['username'];
    userType = json['user_type'];
    chatId = json['chatId'];
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
    muddaCount = json['muddaCount'];
    isProfileVerified = json['isProfileVerified'];
    description = json['description'];
    category = json['category'] != null ? json['category'].cast<String>() : [];
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
    isBlocked = json['isBlocked'];
    isUserBlocked = json['isUserBlocked'] ?? false;
    blockedTill = json['blockedTill'];
    countFollowing = json['countFollowing'];
    muddebaazCount = json['muddebazzCount'];
    countFollowers = json['count_followers'];
    countNetwork = json['count_network'];
    countRequests = json['count_requests'];
    amIFollowing = json['amIFollowing'] ?? 0;
    amIRequested = json['amIRequested'] ?? 0;
    amIInvited = json['amIInvited'] ?? 0;
    invitedStatus = json['invitedStatus'] ?? false;
    supportStatus = json['supportStatus'] ?? false;
    amIJoined = json['amIJoined'] != null
        ? AmIJoined.fromJson(json['amIJoined'])
        : null;
    if (json['memberOfOrganization'] != null) {
      memberOfOrganization = <MemberOfOrganization>[];
      json['memberOfOrganization'].forEach((v) {
        memberOfOrganization!.add(MemberOfOrganization.fromJson(v));
      });
    }
    memberOfOrganizationCount = json['memberOfOrganizationCount'];
    if (json['organizationMember'] != null) {
      organizationMember = <MemberOfOrganization>[];
      json['organizationMember'].forEach((v) {
        organizationMember!.add(MemberOfOrganization.fromJson(v));
      });
    }
    organizationMemberCount = json['organizationMemberCount'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['followerIndex'] = this.followerIndex;
    data['fullname'] = this.fullname;
    data['invitedId'] = this.invitedId;
    data['username'] = this.username;
    data['chatId'] = this.chatId;
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
    data['muddaCount'] = this.muddaCount;
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
    data['isBlocked'] = this.isBlocked;
    data['isUserBlocked'] = this.isUserBlocked;
    data['blockedTill'] = this.blockedTill;
    data['countFollowing'] = this.countFollowing;
    data['count_followers'] = this.countFollowers;
    data['count_network'] = this.countNetwork;
    data['muddebazzCount'] = this.muddebaazCount;
    data['count_requests'] = this.countRequests;
    data['amIFollowing'] = this.amIFollowing;
    data['invitedStatus'] = this.invitedStatus;
    data['supportStatus'] = this.supportStatus;
    if (this.memberOfOrganization != null) {
      data['memberOfOrganization'] =
          this.memberOfOrganization!.map((v) => v.toJson()).toList();
    }
    data['memberOfOrganizationCount'] = this.memberOfOrganizationCount;
    // if (this.organizationMember != null) {
    //   data['organizationMember'] =
    //       this.organizationMember!.map((v) => v.toJson()).toList();
    // }
    data['organizationMemberCount'] = this.organizationMemberCount;
    data['id'] = this.id;
    return data;
  }
}

class AmIJoined {
  String? sId;
  String? userId;
  String? organizationId;
  String? organizationType;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;
  String? role;

  AmIJoined(
      {this.sId,
      this.userId,
      this.organizationId,
      this.organizationType,
      this.status,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.id,
      this.role});

  AmIJoined.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    organizationId = json['organization_id'];
    organizationType = json['organization_type'];
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
    role = json['role'];
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
    data['id'] = this.id;
    data['role'] = this.role;
    return data;
  }
}

class MemberOfOrganization {
  String? sId;
  String? userId;
  String? organizationId;
  String? organizationType;
  String? role;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  OrganizationDetail? organizationDetail;
  OrganizationDetail? userDetail;
  String? id;

  MemberOfOrganization(
      {this.sId,
      this.userId,
      this.organizationId,
      this.organizationType,
      this.role,
      this.status,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.organizationDetail,
      this.userDetail,
      this.id});

  MemberOfOrganization.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    organizationId = json['organization_id'];
    organizationType = json['organization_type'];
    role = json['role'];
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['organizationDetail'] != null) {
      organizationDetail =
          OrganizationDetail.fromJson(json['organizationDetail']);
    }
    if (json['userDetail'] != null) {
      userDetail = OrganizationDetail.fromJson(json['userDetail']);
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['organization_id'] = this.organizationId;
    data['organization_type'] = this.organizationType;
    data['role'] = this.role;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['organizationDetail'] = this.organizationDetail;
    data['id'] = this.id;
    return data;
  }
}

class OrganizationDetail {
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
  String? id;

  OrganizationDetail(
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
      this.iV,
      this.id});

  OrganizationDetail.fromJson(Map<String, dynamic> json) {
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
    muddaCount = json['muddaCount'];
    description = json['description'];
    category = json['category'] != null ? json['category'].cast<String>() : [];
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
    id = json['id'];
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
    data['muddaCount'] = this.muddaCount;
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
    data['id'] = this.id;
    return data;
  }
}

class AfterMe {
  String? sId;
  String? userId;
  String? joiningContentId;
  String? acceptType;
  String? actionType;
  int? totalSupport;
  int? totalUnsupport;
  int? totalPost;
  int? totalFavourPost;
  int? totalUnfavourPost;
  int? totalReaction;
  int? totalFavourReaction;
  int? totalUnfavourReaction;
  int? totalLeaderJoin;
  int? totalFavourLeaderJoin;
  int? totalUnfavourLeaderJoin;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  AfterMe(
      {this.sId,
      this.userId,
      this.joiningContentId,
      this.acceptType,
      this.actionType,
      this.totalSupport,
      this.totalUnsupport,
      this.totalPost,
      this.totalFavourPost,
      this.totalUnfavourPost,
      this.totalReaction,
      this.totalFavourReaction,
      this.totalUnfavourReaction,
      this.totalLeaderJoin,
      this.totalFavourLeaderJoin,
      this.totalUnfavourLeaderJoin,
      this.status,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.id});

  AfterMe.fromJson(Map<dynamic, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    joiningContentId = json['joining_content_id'];
    acceptType = json['accept_type'];
    actionType = json['action_type'];
    totalSupport = json['total_support'];
    totalUnsupport = json['total_unsupport'];
    totalPost = json['total_post'];
    totalFavourPost = json['total_favour_post'];
    totalUnfavourPost = json['total_unfavour_post'];
    totalReaction = json['total_reaction'];
    totalFavourReaction = json['total_favour_reaction'];
    totalUnfavourReaction = json['total_unfavour_reaction'];
    totalLeaderJoin = json['total_leader_join'];
    totalFavourLeaderJoin = json['total_favour_leader_join'];
    totalUnfavourLeaderJoin = json['total_unfavour_leader_join'];
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
    data['joining_content_id'] = this.joiningContentId;
    data['accept_type'] = this.acceptType;
    data['action_type'] = this.actionType;
    data['total_support'] = this.totalSupport;
    data['total_unsupport'] = this.totalUnsupport;
    data['total_post'] = this.totalPost;
    data['total_favour_post'] = this.totalFavourPost;
    data['total_unfavour_post'] = this.totalUnfavourPost;
    data['total_reaction'] = this.totalReaction;
    data['total_favour_reaction'] = this.totalFavourReaction;
    data['total_unfavour_reaction'] = this.totalUnfavourReaction;
    data['total_leader_join'] = this.totalLeaderJoin;
    data['total_favour_leader_join'] = this.totalFavourLeaderJoin;
    data['total_unfavour_leader_join'] = this.totalUnfavourLeaderJoin;
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}

class MyReaction {
  String? sId;
  String? userId;
  String? requestToUserId;
  String? joiningContentId;
  String? acceptType;
  String? joinerType;
  int? status;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  MyReaction(
      {this.sId,
      this.userId,
      this.requestToUserId,
      this.joiningContentId,
      this.acceptType,
      this.joinerType,
      this.status,
      this.deleted,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.id});

  MyReaction.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    requestToUserId = json['request_to_user_id'];
    joiningContentId = json['joining_content_id'];
    acceptType = json['accept_type'];
    joinerType = json['joiner_type'];
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
    data['status'] = this.status;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}
