class StatisticRevenueModel {
  String? typeID;
  List<Values>? values;

  StatisticRevenueModel({this.typeID, this.values});

  StatisticRevenueModel.fromJson(Map<String, dynamic> json) {
    typeID = json['typeID'];
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['typeID'] = typeID;
    if (values != null && values!.isNotEmpty) {
      data['values'] = values!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  num? revenue;
  int? id;

  Values({this.revenue, this.id});

  Values.fromJson(Map<String, dynamic> json) {
    revenue = json['revenue'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['revenue'] = revenue;
    data['id'] = id;
    return data;
  }
}
