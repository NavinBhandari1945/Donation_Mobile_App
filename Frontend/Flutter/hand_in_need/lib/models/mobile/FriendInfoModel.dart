/// id : 5
/// username : "hari123"
/// firendUsername : "ram123"

class FriendInfoModel {
  FriendInfoModel({
      num? id, 
      String? username, 
      String? firendUsername,}){
    _id = id;
    _username = username;
    _firendUsername = firendUsername;
}

  FriendInfoModel.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _firendUsername = json['firendUsername'];
  }
  num? _id;
  String? _username;
  String? _firendUsername;
FriendInfoModel copyWith({  num? id,
  String? username,
  String? firendUsername,
}) => FriendInfoModel(  id: id ?? _id,
  username: username ?? _username,
  firendUsername: firendUsername ?? _firendUsername,
);
  num? get id => _id;
  String? get username => _username;
  String? get firendUsername => _firendUsername;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['firendUsername'] = _firendUsername;
    return map;
  }

}