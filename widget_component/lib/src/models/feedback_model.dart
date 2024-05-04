class FeedbackModel {
  int? pageCount;
  List<FeedbackItemModel>? feedbacks;

  FeedbackModel({this.pageCount, this.feedbacks});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    pageCount = json['pageCount'];
    if (json['feedbacks'] != null) {
      feedbacks = <FeedbackItemModel>[];
      json['feedbacks'].forEach((v) {
        feedbacks!.add(FeedbackItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageCount'] = pageCount;
    if (feedbacks != null) {
      data['feedbacks'] = feedbacks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedbackItemModel {
  String? sId;
  UserIDFeedback? user;
  String? fieldID;
  int? star;
  String? content;
  List<String>? images;
  String? createdAt;
  String? updatedAt;

  FeedbackItemModel(
      {this.sId,
      this.user,
      this.fieldID,
      this.star,
      this.content,
      this.images,
      this.createdAt,
      this.updatedAt});

  FeedbackItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? UserIDFeedback.fromJson(json['user']) : null;
    fieldID = json['fieldID'];
    star = json['star'];
    content = json['content'];
    images = json['images'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['fieldID'] = fieldID;
    data['star'] = star;
    data['content'] = content;
    data['images'] = images;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class UserIDFeedback {
  String? sId;
  String? name;
  String? avatar;

  UserIDFeedback({this.sId, this.name, this.avatar});

  UserIDFeedback.fromJson(Map<String, dynamic> json) {
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
