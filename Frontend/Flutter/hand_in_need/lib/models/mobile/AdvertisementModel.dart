class AdvertisementModel {
  AdvertisementModel({
    num? adId,
    String? adPhoto,
    String? adUrl,}){
    _adId = adId;
    _adPhoto = adPhoto;
    _adUrl = adUrl;
  }

  AdvertisementModel.fromJson(dynamic json) {
    _adId = json['adId'];
    _adPhoto = json['adPhoto'];
    _adUrl = json['adUrl'];
  }
  num? _adId;
  String? _adPhoto;
  String? _adUrl;
  AdvertisementModel copyWith({  num? adId,
    String? adPhoto,
    String? adUrl,
  }) => AdvertisementModel(  adId: adId ?? _adId,
    adPhoto: adPhoto ?? _adPhoto,
    adUrl: adUrl ?? _adUrl,
  );
  num? get adId => _adId;
  String? get adPhoto => _adPhoto;
  String? get adUrl => _adUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['adId'] = _adId;
    map['adPhoto'] = _adPhoto;
    map['adUrl'] = _adUrl;
    return map;
  }

}