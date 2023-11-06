class PlaceModel {
  int? status;
  String? message;
  List<Place>? data;

  PlaceModel({this.status, this.message, this.data});

  PlaceModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Place>[];
      json['data'].forEach((v) {
        data!.add(new Place.fromJson(v));
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

class Place {
  int? status;
  String? createdBy;
  String? updatedBy;
  bool? deleted;
  String? sId;
  String? state;
  String? district;
  String? country;
  String? continent;

  Place(
      {this.status,
        this.createdBy,
        this.updatedBy,
        this.deleted,
        this.sId,
        this.state,
        this.district,
        this.country,
        this.continent});

  Place.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deleted = json['deleted'];
    sId = json['_id'];
    state = json['state'];
    district = json['district'];
    country = json['country'];
    continent = json['continent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted'] = this.deleted;
    data['_id'] = this.sId;
    data['state'] = this.state;
    data['district'] = this.district;
    data['country'] = this.country;
    data['continent'] = this.continent;
    return data;
  }
}
