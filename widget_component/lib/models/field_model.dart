class FieldModel {
  Lock? lock;
  String? sId;
  String? userID;
  String? name;
  int? views;
  int? price;
  String? coverImage;
  int? type;
  bool? isPublic;
  bool? isLock;
  bool? isRepair;
  String? description;
  int? length;
  int? width;
  String? createdAt;
  String? updatedAt;

  FieldModel(
      {this.lock,
      this.sId,
      this.userID,
      this.name,
      this.views,
      this.price,
      this.coverImage,
      this.type,
      this.isPublic,
      this.isLock,
      this.isRepair,
      this.description,
      this.length,
      this.width,
      this.createdAt,
      this.updatedAt});

  FieldModel.fromJson(Map<String, dynamic> json) {
    lock = json['lock'] != null ? Lock.fromJson(json['lock']) : null;
    sId = json['_id'];
    userID = json['userID'];
    name = json['name'];
    views = json['views'];
    price = json['price'];
    coverImage = json['coverImage'];
    type = json['type'];
    isPublic = json['isPublic'];
    isLock = json['isLock'];
    isRepair = json['isRepair'];
    description = json['description'];
    length = json['length'];
    width = json['width'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lock != null) {
      data['lock'] = lock!.toJson();
    }
    data['_id'] = sId;
    data['userID'] = userID;
    data['name'] = name;
    data['views'] = views;
    data['price'] = price;
    data['coverImage'] = coverImage;
    data['type'] = type;
    data['isPublic'] = isPublic;
    data['isLock'] = isLock;
    data['isRepair'] = isRepair;
    data['description'] = description;
    data['length'] = length;
    data['width'] = width;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
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
