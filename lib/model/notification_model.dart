class NotificationModel {
  NotificationModel({
    bool? success,
    bool? active,
    String? text,
    String? image,
    String? startDate,
    String? endDate,
  }) {
    _success = success;
    _active = active;
    _text = text;
    _image = image;
    _startDate = startDate;
    _endDate = endDate;
  }

  NotificationModel.fromJson(dynamic json) {
    _success = json['success'];
    _active = json['active'];
    _text = json['text'];
    _image = json['image'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
  }
  bool? _success;
  bool? _active;
  String? _text;
  String? _image;
  String? _startDate;
  String? _endDate;
  NotificationModel copyWith({
    bool? success,
    bool? active,
    String? text,
    String? image,
    String? startDate,
    String? endDate,
  }) => NotificationModel(
    success: success ?? _success,
    active: active ?? _active,
    text: text ?? _text,
    image: image ?? _image,
    startDate: startDate ?? _startDate,
    endDate: endDate ?? _endDate,
  );
  bool? get success => _success;
  bool? get active => _active;
  String? get text => _text;
  String? get image => _image;
  String? get startDate => _startDate;
  String? get endDate => _endDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['active'] = _active;
    map['text'] = _text;
    map['image'] = _image;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    return map;
  }
}
