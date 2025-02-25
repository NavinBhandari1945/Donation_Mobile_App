/// notId : 1
/// notType : "string"
/// notReceiverUsername : "string"
/// notMessage : "string"
/// notDate : "2025-02-25T13:06:25.687"

class NotificationsModel {
  NotificationsModel({
      num? notId, 
      String? notType, 
      String? notReceiverUsername, 
      String? notMessage, 
      String? notDate,}){
    _notId = notId;
    _notType = notType;
    _notReceiverUsername = notReceiverUsername;
    _notMessage = notMessage;
    _notDate = notDate;
}

  NotificationsModel.fromJson(dynamic json)
  {
    _notId = json['notId'];
    _notType = json['notType'];
    _notReceiverUsername = json['notReceiverUsername'];
    _notMessage = json['notMessage'];
    _notDate = json['notDate'];
  }
  num? _notId;
  String? _notType;
  String? _notReceiverUsername;
  String? _notMessage;
  String? _notDate;
NotificationsModel copyWith({  num? notId,
  String? notType,
  String? notReceiverUsername,
  String? notMessage,
  String? notDate,
}) => NotificationsModel(  notId: notId ?? _notId,
  notType: notType ?? _notType,
  notReceiverUsername: notReceiverUsername ?? _notReceiverUsername,
  notMessage: notMessage ?? _notMessage,
  notDate: notDate ?? _notDate,
);
  num? get notId => _notId;
  String? get notType => _notType;
  String? get notReceiverUsername => _notReceiverUsername;
  String? get notMessage => _notMessage;
  String? get notDate => _notDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notId'] = _notId;
    map['notType'] = _notType;
    map['notReceiverUsername'] = _notReceiverUsername;
    map['notMessage'] = _notMessage;
    map['notDate'] = _notDate;
    return map;
  }

}