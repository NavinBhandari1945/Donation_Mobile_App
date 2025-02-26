/// feedId : 1
/// fdUsername : "string"
/// fdDescription : "string"
/// fdDate : "2025-02-26T09:20:03.017"
/// fdImage : "string"

class FeedbackModel {
  FeedbackModel({
      num? feedId, 
      String? fdUsername, 
      String? fdDescription, 
      String? fdDate, 
      String? fdImage,}){
    _feedId = feedId;
    _fdUsername = fdUsername;
    _fdDescription = fdDescription;
    _fdDate = fdDate;
    _fdImage = fdImage;
}

  FeedbackModel.fromJson(dynamic json) {
    _feedId = json['feedId'];
    _fdUsername = json['fdUsername'];
    _fdDescription = json['fdDescription'];
    _fdDate = json['fdDate'];
    _fdImage = json['fdImage'];
  }
  num? _feedId;
  String? _fdUsername;
  String? _fdDescription;
  String? _fdDate;
  String? _fdImage;
FeedbackModel copyWith({  num? feedId,
  String? fdUsername,
  String? fdDescription,
  String? fdDate,
  String? fdImage,
}) => FeedbackModel(  feedId: feedId ?? _feedId,
  fdUsername: fdUsername ?? _fdUsername,
  fdDescription: fdDescription ?? _fdDescription,
  fdDate: fdDate ?? _fdDate,
  fdImage: fdImage ?? _fdImage,
);
  num? get feedId => _feedId;
  String? get fdUsername => _fdUsername;
  String? get fdDescription => _fdDescription;
  String? get fdDate => _fdDate;
  String? get fdImage => _fdImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['feedId'] = _feedId;
    map['fdUsername'] = _fdUsername;
    map['fdDescription'] = _fdDescription;
    map['fdDate'] = _fdDate;
    map['fdImage'] = _fdImage;
    return map;
  }

}