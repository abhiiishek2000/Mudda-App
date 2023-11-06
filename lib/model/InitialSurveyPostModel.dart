class InitialSurveyPostModel {
  int? status;
  String? message;
  List<InitialSurvey>? data;

  InitialSurveyPostModel({this.status, this.message, this.data});

  InitialSurveyPostModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InitialSurvey>[];
      json['data'].forEach((v) {
        data!.add(InitialSurvey.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InitialSurvey {
  String? sId;
  String? userId;
  String? postAs;
  String? thumbnail;
  String? title;
  String? initialScope;
  String? description;
  List<String>? hashtags;
  String? area;
  String? landmark;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? latitude;
  String? longitude;
  int? isVerify;
  String? verifyBy;
  int? status;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<QuestionOption>? questionOption;
  String? id;

  InitialSurvey(
      {this.sId,
        this.userId,
        this.postAs,
        this.thumbnail,
        this.title,
        this.initialScope,
        this.description,
        this.hashtags,
        this.area,
        this.landmark,
        this.city,
        this.state,
        this.country,
        this.zipcode,
        this.latitude,
        this.longitude,
        this.isVerify,
        this.verifyBy,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.questionOption,
        this.id});

  InitialSurvey.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    postAs = json['post_as'];
    thumbnail = json['thumbnail'];
    title = json['title'];
    initialScope = json['initial_scope'];
    description = json['description'];
    hashtags = json['hashtags'].cast<String>();
    area = json['area'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isVerify = json['isVerify'];
    verifyBy = json['verify_by'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['questionOption'] != null) {
      questionOption = <QuestionOption>[];
      json['questionOption'].forEach((v) {
        questionOption!.add(new QuestionOption.fromJson(v));
      });
    }
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
    data['description'] = this.description;
    data['hashtags'] = this.hashtags;
    data['area'] = this.area;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zipcode'] = this.zipcode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isVerify'] = this.isVerify;
    data['verify_by'] = this.verifyBy;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.questionOption != null) {
      data['questionOption'] =
          this.questionOption!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class QuestionOption {
  String? sId;
  String? userId;
  String? postId;
  String? option;
  String? isRight;
  int? status;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? hitOption;
  String? id;

  QuestionOption(
      {this.sId,
        this.userId,
        this.postId,
        this.option,
        this.isRight,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.deleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.hitOption,
        this.id});

  QuestionOption.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    postId = json['post_id'];
    option = json['option'];
    isRight = json['isRight'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    hitOption = json['hitOption'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['option'] = this.option;
    data['isRight'] = this.isRight;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['hitOption'] = this.hitOption;
    data['id'] = this.id;
    return data;
  }
}
