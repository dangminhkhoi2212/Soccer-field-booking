class OrderModel {
  String? sId;
  double? total;
  bool? isPay;
  String? startTime;
  String? endTime;
  String? date;
  String? status;
  String? createdAt;
  String? updatedAt;
  Field? field;
  UserOrder? user;
  UserOrder? seller;
  bool? isFeedback;

  OrderModel(
      {this.sId,
      this.total,
      this.isPay,
      this.startTime,
      this.endTime,
      this.date,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.field,
      this.user,
      this.seller,
      this.isFeedback});

  OrderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    total = json['total'] != null ? json['total'] + 0.0 : 0.0;
    isPay = json['isPay'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    date = json['date'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    field = json['field'] != null ? Field.fromJson(json['field']) : null;
    user = json['user'] != null ? UserOrder.fromJson(json['user']) : null;
    seller = json['seller'] != null ? UserOrder.fromJson(json['seller']) : null;
    isFeedback = json['isFeedback'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['total'] = total;
    data['isPay'] = isPay;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['date'] = date;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['isFeedback'] = isFeedback;
    if (field != null) {
      data['field'] = field!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (seller != null) {
      data['seller'] = seller!.toJson();
    }
    return data;
  }
}

class Field {
  String? sId;
  String? userID;
  String? name;
  String? coverImage;

  Field({this.sId, this.userID, this.name, this.coverImage});

  Field.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userID = json['userID'];
    name = json['name'];
    coverImage = json['coverImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userID'] = userID;
    data['name'] = name;
    data['coverImage'] = coverImage;
    return data;
  }
}

class UserOrder {
  String? sId;
  String? name;
  String? email;
  String? avatar;
  String? phone;

  UserOrder({this.sId, this.name, this.email, this.avatar, this.phone});

  UserOrder.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    data['phone'] = phone;
    return data;
  }
}
