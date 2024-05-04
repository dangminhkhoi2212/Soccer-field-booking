class StatisticFeedbackModel {
  int? oneStar;
  int? twoStar;
  int? threeStar;
  int? fourStar;
  int? fiveStar;
  int? totalFeedback;
  double? ratingStar;

  StatisticFeedbackModel(
      {this.oneStar,
      this.twoStar,
      this.threeStar,
      this.fourStar,
      this.fiveStar,
      this.totalFeedback,
      this.ratingStar});

  StatisticFeedbackModel.fromJson(Map<String, dynamic> json) {
    oneStar = json['oneStar'];
    twoStar = json['twoStar'];
    threeStar = json['threeStar'];
    fourStar = json['fourStar'];
    fiveStar = json['fiveStar'];
    totalFeedback = json['totalFeedback'];
    ratingStar = json['ratingStar'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oneStar'] = oneStar;
    data['twoStar'] = twoStar;
    data['threeStar'] = threeStar;
    data['fourStar'] = fourStar;
    data['fiveStar'] = fiveStar;
    data['totalFeedback'] = totalFeedback;
    data['ratingStar'] = ratingStar;
    return data;
  }
}
