class AddressModel {
  String? sId;
  UserID? userID;
  String? address;
  String? createdAt;
  String? district;
  double? latitude;
  double? longitude;
  String? province;
  String? sub;
  String? updatedAt;
  String? ward;

  AddressModel(
      {this.sId,
      this.userID,
      this.address,
      this.createdAt,
      this.district,
      this.latitude,
      this.longitude,
      this.province,
      this.sub,
      this.updatedAt,
      this.ward});

  AddressModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userID = json['userID'] != null ? UserID.fromJson(json['userID']) : null;
    address = json['address'];
    createdAt = json['createdAt'];
    district = json['district'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    province = json['province'];
    sub = json['sub'];
    updatedAt = json['updatedAt'];
    ward = json['ward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (userID != null) {
      data['userID'] = userID!.toJson();
    }
    data['address'] = address;
    data['createdAt'] = createdAt;
    data['district'] = district;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['province'] = province;
    data['sub'] = sub;
    data['updatedAt'] = updatedAt;
    data['ward'] = ward;
    return data;
  }
}

class UserID {
  String? sId;
  String? name;
  String? avatar;

  UserID({this.sId, this.name, this.avatar});

  UserID.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['avatar'] = avatar;
    return data;
  }
}
