class OwnerModel {
  User? user;
  Seller? seller;
  Address? address;

  OwnerModel({this.user, this.seller, this.address});

  OwnerModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (seller != null) {
      data['seller'] = seller!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class User {
  Lock? lock;
  String? sId;
  String? name;
  String? email;
  String? avatar;
  bool? isPublic;
  String? phone;
  String? role;

  User(
      {this.lock,
      this.sId,
      this.name,
      this.email,
      this.avatar,
      this.isPublic,
      this.phone,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    lock = json['lock'] != null ? Lock.fromJson(json['lock']) : null;
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    isPublic = json['isPublic'];
    phone = json['phone'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lock != null) {
      data['lock'] = lock!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    data['isPublic'] = isPublic;
    data['phone'] = phone;
    data['role'] = role;
    return data;
  }
}

class Lock {
  bool? status;
  String? content;

  Lock({this.status, this.content});

  Lock.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['content'] = content;
    return data;
  }
}

class Seller {
  bool? isHalfHour;
  String? sId;
  String? userID;
  int? iV;
  String? endTime;
  int? revenue;
  String? startTime;

  Seller(
      {this.isHalfHour,
      this.sId,
      this.userID,
      this.iV,
      this.endTime,
      this.revenue,
      this.startTime});

  Seller.fromJson(Map<String, dynamic> json) {
    isHalfHour = json['isHalfHour'];
    sId = json['_id'];
    userID = json['userID'];
    iV = json['__v'];
    endTime = json['endTime'];
    revenue = json['revenue'];
    startTime = json['startTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isHalfHour'] = isHalfHour;
    data['_id'] = sId;
    data['userID'] = userID;
    data['__v'] = iV;
    data['endTime'] = endTime;
    data['revenue'] = revenue;
    data['startTime'] = startTime;
    return data;
  }
}

class Address {
  String? sId;
  String? userID;
  String? address;
  String? district;
  double? latitude;
  double? longitude;
  String? province;
  String? sub;
  String? ward;

  Address(
      {this.sId,
      this.userID,
      this.address,
      this.district,
      this.latitude,
      this.longitude,
      this.province,
      this.sub,
      this.ward});

  Address.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userID = json['userID'];
    address = json['address'];
    district = json['district'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    province = json['province'];
    sub = json['sub'];
    ward = json['ward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userID'] = userID;
    data['address'] = address;
    data['district'] = district;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['province'] = province;
    data['sub'] = sub;
    data['ward'] = ward;
    return data;
  }
}
