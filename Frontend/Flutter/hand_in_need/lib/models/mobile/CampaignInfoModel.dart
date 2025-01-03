/// campaignId : 7
/// photo : "qqqq"
/// description : "eeee"
/// tittle : "eeee"
/// username : "eee"
/// campaignDate : "2024-02-12T00:00:00"
/// postId : 25
/// video : "eeee"
/// campaignFile : "eeeee"
/// fileExtension : "docx"

class CampaignInfoModel {
  CampaignInfoModel({
      num? campaignId, 
      String? photo, 
      String? description, 
      String? tittle, 
      String? username, 
      String? campaignDate, 
      num? postId, 
      String? video, 
      String? campaignFile, 
      String? fileExtension,}){
    _campaignId = campaignId;
    _photo = photo;
    _description = description;
    _tittle = tittle;
    _username = username;
    _campaignDate = campaignDate;
    _postId = postId;
    _video = video;
    _campaignFile = campaignFile;
    _fileExtension = fileExtension;
}

  CampaignInfoModel.fromJson(dynamic json) {
    _campaignId = json['campaignId'];
    _photo = json['photo'];
    _description = json['description'];
    _tittle = json['tittle'];
    _username = json['username'];
    _campaignDate = json['campaignDate'];
    _postId = json['postId'];
    _video = json['video'];
    _campaignFile = json['campaignFile'];
    _fileExtension = json['fileExtension'];
  }
  num? _campaignId;
  String? _photo;
  String? _description;
  String? _tittle;
  String? _username;
  String? _campaignDate;
  num? _postId;
  String? _video;
  String? _campaignFile;
  String? _fileExtension;
CampaignInfoModel copyWith({  num? campaignId,
  String? photo,
  String? description,
  String? tittle,
  String? username,
  String? campaignDate,
  num? postId,
  String? video,
  String? campaignFile,
  String? fileExtension,
}) => CampaignInfoModel(  campaignId: campaignId ?? _campaignId,
  photo: photo ?? _photo,
  description: description ?? _description,
  tittle: tittle ?? _tittle,
  username: username ?? _username,
  campaignDate: campaignDate ?? _campaignDate,
  postId: postId ?? _postId,
  video: video ?? _video,
  campaignFile: campaignFile ?? _campaignFile,
  fileExtension: fileExtension ?? _fileExtension,
);
  num? get campaignId => _campaignId;
  String? get photo => _photo;
  String? get description => _description;
  String? get tittle => _tittle;
  String? get username => _username;
  String? get campaignDate => _campaignDate;
  num? get postId => _postId;
  String? get video => _video;
  String? get campaignFile => _campaignFile;
  String? get fileExtension => _fileExtension;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['campaignId'] = _campaignId;
    map['photo'] = _photo;
    map['description'] = _description;
    map['tittle'] = _tittle;
    map['username'] = _username;
    map['campaignDate'] = _campaignDate;
    map['postId'] = _postId;
    map['video'] = _video;
    map['campaignFile'] = _campaignFile;
    map['fileExtension'] = _fileExtension;
    return map;
  }

}