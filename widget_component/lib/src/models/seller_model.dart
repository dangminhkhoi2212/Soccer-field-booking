/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var mySellerModelNode = SellerModel.fromJson(map);
*/
class SellerModel {
  String? id;
  String? userID;
  int? v;
  String? endTime;
  int? revenue;
  String? startTime;
  bool? isHalfHour;

  SellerModel(
      {this.id,
      this.userID,
      this.v,
      this.endTime,
      this.revenue,
      this.startTime,
      this.isHalfHour});

  SellerModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userID = json['userID'];
    v = json['__v'];
    endTime = json['endTime'];
    revenue = json['revenue'];
    startTime = json['startTime'];
    isHalfHour = json['isHalfHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['userID'] = userID;
    data['__v'] = v;
    data['endTime'] = endTime;
    data['revenue'] = revenue;
    data['startTime'] = startTime;
    data['isHalfHour'] = isHalfHour;
    return data;
  }
}
