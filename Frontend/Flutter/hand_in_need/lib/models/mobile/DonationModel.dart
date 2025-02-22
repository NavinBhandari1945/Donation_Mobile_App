/// donateId : 5
/// donerUsername : "ram123"
/// receiverUsername : "ram123"
/// donateAmount : 200
/// donateDate : "2025-02-03T12:54:10.657"
/// postId : 33
/// paymentMethod : "Esewa"

class DonationModel {
  DonationModel({
      num? donateId, 
      String? donerUsername, 
      String? receiverUsername, 
      num? donateAmount, 
      String? donateDate, 
      num? postId, 
      String? paymentMethod,}){
    _donateId = donateId;
    _donerUsername = donerUsername;
    _receiverUsername = receiverUsername;
    _donateAmount = donateAmount;
    _donateDate = donateDate;
    _postId = postId;
    _paymentMethod = paymentMethod;
}

  DonationModel.fromJson(dynamic json) {
    _donateId = json['donateId'];
    _donerUsername = json['donerUsername'];
    _receiverUsername = json['receiverUsername'];
    _donateAmount = json['donateAmount'];
    _donateDate = json['donateDate'];
    _postId = json['postId'];
    _paymentMethod = json['paymentMethod'];
  }
  num? _donateId;
  String? _donerUsername;
  String? _receiverUsername;
  num? _donateAmount;
  String? _donateDate;
  num? _postId;
  String? _paymentMethod;
DonationModel copyWith({  num? donateId,
  String? donerUsername,
  String? receiverUsername,
  num? donateAmount,
  String? donateDate,
  num? postId,
  String? paymentMethod,
}) => DonationModel(  donateId: donateId ?? _donateId,
  donerUsername: donerUsername ?? _donerUsername,
  receiverUsername: receiverUsername ?? _receiverUsername,
  donateAmount: donateAmount ?? _donateAmount,
  donateDate: donateDate ?? _donateDate,
  postId: postId ?? _postId,
  paymentMethod: paymentMethod ?? _paymentMethod,
);
  num? get donateId => _donateId;
  String? get donerUsername => _donerUsername;
  String? get receiverUsername => _receiverUsername;
  num? get donateAmount => _donateAmount;
  String? get donateDate => _donateDate;
  num? get postId => _postId;
  String? get paymentMethod => _paymentMethod;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['donateId'] = _donateId;
    map['donerUsername'] = _donerUsername;
    map['receiverUsername'] = _receiverUsername;
    map['donateAmount'] = _donateAmount;
    map['donateDate'] = _donateDate;
    map['postId'] = _postId;
    map['paymentMethod'] = _paymentMethod;
    return map;
  }

}