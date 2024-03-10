class OrderModel {
  String? sId;
  OrderUserID? userID;
  OrderUserID? sellerID;
  FieldID? fieldID;
  num? total;
  bool? isPay;
  String? startTime;
  String? endTime;
  String? date;
  String? status;
  String? createdAt;
  String? updatedAt;

  OrderModel(
      {this.sId,
      this.userID,
      this.sellerID,
      this.fieldID,
      this.total,
      this.isPay,
      this.startTime,
      this.endTime,
      this.date,
      this.status,
      this.createdAt,
      this.updatedAt});

  OrderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userID = json['userID'] != null
        ? new OrderUserID.fromJson(json['userID'])
        : null;
    sellerID = json['sellerID'] != null
        ? new OrderUserID.fromJson(json['sellerID'])
        : null;
    fieldID =
        json['fieldID'] != null ? new FieldID.fromJson(json['fieldID']) : null;
    total = json['total'];
    isPay = json['isPay'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    date = json['date'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userID != null) {
      data['userID'] = this.userID!.toJson();
    }
    if (this.sellerID != null) {
      data['sellerID'] = this.sellerID!.toJson();
    }
    if (this.fieldID != null) {
      data['fieldID'] = this.fieldID!.toJson();
    }
    data['total'] = this.total;
    data['isPay'] = this.isPay;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['date'] = this.date;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class OrderUserID {
  String? sId;
  String? name;
  String? email;
  String? avatar;
  String? phone;

  OrderUserID({this.sId, this.name, this.email, this.avatar, this.phone});

  OrderUserID.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['phone'] = this.phone;
    return data;
  }
}

class FieldID {
  String? sId;
  String? name;
  String? coverImage;

  FieldID({this.sId, this.name, this.coverImage});

  FieldID.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    coverImage = json['coverImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['coverImage'] = this.coverImage;
    return data;
  }
}
