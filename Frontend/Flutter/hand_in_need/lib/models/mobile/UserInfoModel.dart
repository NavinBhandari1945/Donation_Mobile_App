/// firstName : "John"
/// lastName : "Doe"
/// email : "john.doe@example.com"
/// phoneNumber : "1234567890"
/// address : "123 Main Street"
/// type : "user"
/// username : "john_doe"
/// password : ""
/// photo : ""

class UserInfoModel {
  UserInfoModel({
      String? firstName, 
      String? lastName, 
      String? email, 
      String? phoneNumber, 
      String? address, 
      String? type, 
      String? username, 
      String? password, 
      String? photo,}){
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phoneNumber = phoneNumber;
    _address = address;
    _type = type;
    _username = username;
    _password = password;
    _photo = photo;
}

  UserInfoModel.fromJson(dynamic json) {
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _phoneNumber = json['phoneNumber'];
    _address = json['address'];
    _type = json['type'];
    _username = json['username'];
    _password = json['password'];
    _photo = json['photo'];
  }
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNumber;
  String? _address;
  String? _type;
  String? _username;
  String? _password;
  String? _photo;
UserInfoModel copyWith({  String? firstName,
  String? lastName,
  String? email,
  String? phoneNumber,
  String? address,
  String? type,
  String? username,
  String? password,
  String? photo,
}) => UserInfoModel(  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  email: email ?? _email,
  phoneNumber: phoneNumber ?? _phoneNumber,
  address: address ?? _address,
  type: type ?? _type,
  username: username ?? _username,
  password: password ?? _password,
  photo: photo ?? _photo,
);
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get address => _address;
  String? get type => _type;
  String? get username => _username;
  String? get password => _password;
  String? get photo => _photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['email'] = _email;
    map['phoneNumber'] = _phoneNumber;
    map['address'] = _address;
    map['type'] = _type;
    map['username'] = _username;
    map['password'] = _password;
    map['photo'] = _photo;
    return map;
  }

}