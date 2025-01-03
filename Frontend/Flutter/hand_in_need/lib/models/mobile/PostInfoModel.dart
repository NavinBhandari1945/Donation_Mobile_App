/// postId : 25
/// username : "qqq"
/// dateCreated : "2022-02-03T00:00:00"
/// description : "qqqq"
/// photo : "qqq"
/// video : "qqqq"
/// postFile : "qqqq"
/// fileExtension : "docx"

class PostInfoModel {
  PostInfoModel({
      num? postId, 
      String? username, 
      String? dateCreated, 
      String? description, 
      String? photo, 
      String? video, 
      String? postFile, 
      String? fileExtension,}){
    _postId = postId;
    _username = username;
    _dateCreated = dateCreated;
    _description = description;
    _photo = photo;
    _video = video;
    _postFile = postFile;
    _fileExtension = fileExtension;
}

  PostInfoModel.fromJson(dynamic json) {
    _postId = json['postId'];
    _username = json['username'];
    _dateCreated = json['dateCreated'];
    _description = json['description'];
    _photo = json['photo'];
    _video = json['video'];
    _postFile = json['postFile'];
    _fileExtension = json['fileExtension'];
  }
  num? _postId;
  String? _username;
  String? _dateCreated;
  String? _description;
  String? _photo;
  String? _video;
  String? _postFile;
  String? _fileExtension;
PostInfoModel copyWith({  num? postId,
  String? username,
  String? dateCreated,
  String? description,
  String? photo,
  String? video,
  String? postFile,
  String? fileExtension,
}) => PostInfoModel(  postId: postId ?? _postId,
  username: username ?? _username,
  dateCreated: dateCreated ?? _dateCreated,
  description: description ?? _description,
  photo: photo ?? _photo,
  video: video ?? _video,
  postFile: postFile ?? _postFile,
  fileExtension: fileExtension ?? _fileExtension,
);
  num? get postId => _postId;
  String? get username => _username;
  String? get dateCreated => _dateCreated;
  String? get description => _description;
  String? get photo => _photo;
  String? get video => _video;
  String? get postFile => _postFile;
  String? get fileExtension => _fileExtension;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postId'] = _postId;
    map['username'] = _username;
    map['dateCreated'] = _dateCreated;
    map['description'] = _description;
    map['photo'] = _photo;
    map['video'] = _video;
    map['postFile'] = _postFile;
    map['fileExtension'] = _fileExtension;
    return map;
  }

}