class OrderedTime {
  List<Times>? times;
  String? date;

  OrderedTime({this.times, this.date});

  OrderedTime.fromJson(Map<String, dynamic> json) {
    if (json['times'] != null) {
      times = <Times>[];
      json['times'].forEach((v) {
        times!.add(new Times.fromJson(v));
      });
    }
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.times != null) {
      data['times'] = this.times!.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    return data;
  }
}

class Times {
  String? startTime;
  String? endTime;

  Times({this.startTime, this.endTime});

  Times.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}
