class UserJson {
  String? avatar;
  Lock? lock;
  String? sId;
  String? name;
  String? email;
  bool? isPublic;
  String? phone;
  String? refreshToken;
  String? createdAt;
  String? updatedAt;
  String? role;
  String? accessToken;

  UserJson(
      {this.avatar,
      this.lock,
      this.sId,
      this.name,
      this.email,
      this.isPublic,
      this.phone,
      this.refreshToken,
      this.createdAt,
      this.updatedAt,
      this.role,
      this.accessToken});

  UserJson.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    lock = json['lock'] != null ? Lock.fromJson(json['lock']) : null;
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    isPublic = json['isPublic'];
    phone = json['phone'];
    refreshToken = json['refreshToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (lock != null) {
      data['lock'] = lock!.toJson();
    }
    data['avatar'] = avatar;
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['isPublic'] = isPublic;
    data['phone'] = phone;
    data['refreshToken'] = refreshToken;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['role'] = role;
    data['accessToken'] = accessToken;
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
