class UserModel {
  LockUser? lock;
  String? sId;
  String? name;
  String? email;
  String? avatar;
  bool? isPublic;
  String? phone;
  String? role;
  String? accessToken;
  String? refreshToken;
  int? fieldCount;

  UserModel(
      {this.lock,
      this.sId,
      this.name,
      this.email,
      this.avatar,
      this.isPublic,
      this.phone,
      this.role,
      this.fieldCount});

  UserModel.fromJson(Map<String, dynamic> json) {
    lock = json['lock'] != null ? LockUser.fromJson(json['lock']) : null;
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    isPublic = json['isPublic'];
    phone = json['phone'];
    role = json['role'];
    fieldCount = json['fieldCount'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
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
    data['fieldCount'] = fieldCount;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    return data;
  }
}

class LockUser {
  bool? status;
  String? content;

  LockUser({this.status, this.content});

  LockUser.fromJson(Map<String, dynamic> json) {
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
