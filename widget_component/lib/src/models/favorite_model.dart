class FavoriteModel {
  String? sId;
  String? name;
  String? avatar;
  int? followers;

  FavoriteModel({this.sId, this.name, this.avatar});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    avatar = json['avatar'];
    followers = json['followers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['avatar'] = avatar;
    data['followers'] = followers;
    return data;
  }
}
