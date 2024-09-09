/// success : true
/// data : {"id":3,"image":"defaultUser.png","owner_id":null,"device_token":null,"is_online":1,"is_verified":1,"otp":1234,"phone_code":"+91","phone":"9876543210","name":"Driver","delivery_zone_id":null,"email":"driver@gmail.com","password":"$2y$10$n1GibXzY9U2spuM/d2fcPe7HTUEVSGUYEmVG8p/LNmh5wGBKewG4O","driving_license":null,"document_img":null,"document_type":null,"lat":null,"lang":null,"status":1,"created_at":"2021-09-15T09:17:16.000000Z","updated_at":"2021-09-15T11:04:28.000000Z","token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMmU3NDlmYzcyNzBmMWRkNmJmZDNiYmFjZWI2NTNiZDVlYTJhNjM4MjU2NDY2Y2JhNjBhMTg5YjJiYzMyNjY2NzU0ODRlNTgyMzlkMTgyNzYiLCJpYXQiOjE2MzE3MDM4NjguNDM2NDgwOTk4OTkyOTE5OTIxODc1LCJuYmYiOjE2MzE3MDM4NjguNDM2NDg5MTA1MjI0NjA5Mzc1LCJleHAiOjE2NjMyMzk4NjguNDMwMzY4OTAwMjk5MDcyMjY1NjI1LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.dInY61fpqepFzYlpAewznuSPIkjm2FkRYTrHDgAnDkIb7cCeSUVpbRSfRRKQqLU_ex6T81Bgys39jw2a6DUlpUeSmUGCRpAKxOV10gsjLqQaLGcyI-1pr6HTgyv6EJWo9abrCpno19rw9AOAzDHwaJgDk_CIQnpkh8a2AlnZlU1oPpdqPxyy00PE8orb2fDGGhPzygf293utlkYYwTAhJnn20H7Fxd0K9FtBhf7MCIVjNKyTqgxG4QNmQSLeRQsNYKk8fomQn4WfJpOHF4fHZED3WkKojQjgVzI5PR0Kc_Bruaen-Fwxe4c8Tl-U2W91DcCFb7XZTYXNRMvfLghVrs_SHLci9mF7UaXvDq0RcF4Ps_kWLeCNCraDm_IU2qh9AgRfpZlF8OyJHwgwsmbzP7KbW1iVU2E7ABbjb4KPbpHwfiu_wh0kaWWAxUm3AddlvhPgPtTo8sQzVhOrBCiF25d7ebT2tpiI9Rw2Dhi4BqiVVUNw1xVV03rnpM2dw2el3w2DvOv6GRc0QD9Sc9pYl_EczvdtpVwZFCXrswRahASkOUgkY4bvRW5nirYYt8y2h3r6RY6wqaB40oD0O6OiqLkxLLqhc5Dj1MGBebERtRn32JwATzqNV_bOU5t2KXWm-CZ_oYz1QGr25c7nulUFhKYTys-JE5spLsVtbd2GBZ8","fullImage":"https://zomox.saasmonks.in/public/images/upload/defaultUser.png","license_img":"https://zomox.saasmonks.in/public/images/upload/","nation_id":"https://zomox.saasmonks.in/public/images/upload/"}
/// msg : "SuccessFully verify your account...!!"

class CheckOtpModel {
  bool? _success;
  Data? _data;
  String? _msg;

  bool? get success => _success;
  Data? get data => _data;
  String? get msg => _msg;

  CheckOtpModel({
      bool? success, 
      Data? data, 
      String? msg}){
    _success = success;
    _data = data;
    _msg = msg;
}

  CheckOtpModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['msg'] = _msg;
    return map;
  }

}

/// id : 3
/// image : "defaultUser.png"
/// owner_id : null
/// device_token : null
/// is_online : 1
/// is_verified : 1
/// otp : 1234
/// phone_code : "+91"
/// phone : "9876543210"
/// name : "Driver"
/// delivery_zone_id : null
/// email : "driver@gmail.com"
/// password : "$2y$10$n1GibXzY9U2spuM/d2fcPe7HTUEVSGUYEmVG8p/LNmh5wGBKewG4O"
/// driving_license : null
/// document_img : null
/// document_type : null
/// lat : null
/// lang : null
/// status : 1
/// created_at : "2021-09-15T09:17:16.000000Z"
/// updated_at : "2021-09-15T11:04:28.000000Z"
/// token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMmU3NDlmYzcyNzBmMWRkNmJmZDNiYmFjZWI2NTNiZDVlYTJhNjM4MjU2NDY2Y2JhNjBhMTg5YjJiYzMyNjY2NzU0ODRlNTgyMzlkMTgyNzYiLCJpYXQiOjE2MzE3MDM4NjguNDM2NDgwOTk4OTkyOTE5OTIxODc1LCJuYmYiOjE2MzE3MDM4NjguNDM2NDg5MTA1MjI0NjA5Mzc1LCJleHAiOjE2NjMyMzk4NjguNDMwMzY4OTAwMjk5MDcyMjY1NjI1LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.dInY61fpqepFzYlpAewznuSPIkjm2FkRYTrHDgAnDkIb7cCeSUVpbRSfRRKQqLU_ex6T81Bgys39jw2a6DUlpUeSmUGCRpAKxOV10gsjLqQaLGcyI-1pr6HTgyv6EJWo9abrCpno19rw9AOAzDHwaJgDk_CIQnpkh8a2AlnZlU1oPpdqPxyy00PE8orb2fDGGhPzygf293utlkYYwTAhJnn20H7Fxd0K9FtBhf7MCIVjNKyTqgxG4QNmQSLeRQsNYKk8fomQn4WfJpOHF4fHZED3WkKojQjgVzI5PR0Kc_Bruaen-Fwxe4c8Tl-U2W91DcCFb7XZTYXNRMvfLghVrs_SHLci9mF7UaXvDq0RcF4Ps_kWLeCNCraDm_IU2qh9AgRfpZlF8OyJHwgwsmbzP7KbW1iVU2E7ABbjb4KPbpHwfiu_wh0kaWWAxUm3AddlvhPgPtTo8sQzVhOrBCiF25d7ebT2tpiI9Rw2Dhi4BqiVVUNw1xVV03rnpM2dw2el3w2DvOv6GRc0QD9Sc9pYl_EczvdtpVwZFCXrswRahASkOUgkY4bvRW5nirYYt8y2h3r6RY6wqaB40oD0O6OiqLkxLLqhc5Dj1MGBebERtRn32JwATzqNV_bOU5t2KXWm-CZ_oYz1QGr25c7nulUFhKYTys-JE5spLsVtbd2GBZ8"
/// fullImage : "https://zomox.saasmonks.in/public/images/upload/defaultUser.png"
/// license_img : "https://zomox.saasmonks.in/public/images/upload/"
/// nation_id : "https://zomox.saasmonks.in/public/images/upload/"

class Data {
  int? _id;
  String? _image;
  dynamic _ownerId;
  dynamic _deviceToken;
  int? _isOnline;
  int? _isVerified;
  int? _otp;
  String? _phoneCode;
  String? _phone;
  String? _name;
  dynamic _deliveryZoneId;
  String? _email;
  String? _password;
  dynamic _drivingLicense;
  dynamic _documentImg;
  dynamic _documentType;
  dynamic _lat;
  dynamic _lang;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _token;
  String? _fullImage;
  String? _licenseImg;
  String? _nationId;

  int? get id => _id;
  String? get image => _image;
  dynamic get ownerId => _ownerId;
  dynamic get deviceToken => _deviceToken;
  int? get isOnline => _isOnline;
  int? get isVerified => _isVerified;
  int? get otp => _otp;
  String? get phoneCode => _phoneCode;
  String? get phone => _phone;
  String? get name => _name;
  dynamic get deliveryZoneId => _deliveryZoneId;
  String? get email => _email;
  String? get password => _password;
  dynamic get drivingLicense => _drivingLicense;
  dynamic get documentImg => _documentImg;
  dynamic get documentType => _documentType;
  dynamic get lat => _lat;
  dynamic get lang => _lang;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get token => _token;
  String? get fullImage => _fullImage;
  String? get licenseImg => _licenseImg;
  String? get nationId => _nationId;

  Data({
      int? id, 
      String? image, 
      dynamic ownerId,
      dynamic deviceToken,
      int? isOnline, 
      int? isVerified, 
      int? otp, 
      String? phoneCode, 
      String? phone, 
      String? name, 
      dynamic deliveryZoneId,
      String? email, 
      String? password, 
      dynamic drivingLicense,
      dynamic documentImg,
      dynamic documentType,
      dynamic lat,
      dynamic lang,
      int? status, 
      String? createdAt, 
      String? updatedAt, 
      String? token, 
      String? fullImage, 
      String? licenseImg, 
      String? nationId}){
    _id = id;
    _image = image;
    _ownerId = ownerId;
    _deviceToken = deviceToken;
    _isOnline = isOnline;
    _isVerified = isVerified;
    _otp = otp;
    _phoneCode = phoneCode;
    _phone = phone;
    _name = name;
    _deliveryZoneId = deliveryZoneId;
    _email = email;
    _password = password;
    _drivingLicense = drivingLicense;
    _documentImg = documentImg;
    _documentType = documentType;
    _lat = lat;
    _lang = lang;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _token = token;
    _fullImage = fullImage;
    _licenseImg = licenseImg;
    _nationId = nationId;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _image = json['image'];
    _ownerId = json['owner_id'];
    _deviceToken = json['device_token'];
    _isOnline = json['is_online'];
    _isVerified = json['is_verified'];
    _otp = json['otp'];
    _phoneCode = json['phone_code'];
    _phone = json['phone'];
    _name = json['name'];
    _deliveryZoneId = json['delivery_zone_id'];
    _email = json['email'];
    _password = json['password'];
    _drivingLicense = json['driving_license'];
    _documentImg = json['document_img'];
    _documentType = json['document_type'];
    _lat = json['lat'];
    _lang = json['lang'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _token = json['token'];
    _fullImage = json['fullImage'];
    _licenseImg = json['license_img'];
    _nationId = json['nation_id'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['image'] = _image;
    map['owner_id'] = _ownerId;
    map['device_token'] = _deviceToken;
    map['is_online'] = _isOnline;
    map['is_verified'] = _isVerified;
    map['otp'] = _otp;
    map['phone_code'] = _phoneCode;
    map['phone'] = _phone;
    map['name'] = _name;
    map['delivery_zone_id'] = _deliveryZoneId;
    map['email'] = _email;
    map['password'] = _password;
    map['driving_license'] = _drivingLicense;
    map['document_img'] = _documentImg;
    map['document_type'] = _documentType;
    map['lat'] = _lat;
    map['lang'] = _lang;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['token'] = _token;
    map['fullImage'] = _fullImage;
    map['license_img'] = _licenseImg;
    map['nation_id'] = _nationId;
    return map;
  }

}