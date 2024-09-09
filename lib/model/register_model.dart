/// success : true
/// data : {"name":"Driver","email":"driver@gmail.com","image":"defaultUser.png","phone":"9876543210","phone_code":"+91","status":1,"is_online":1,"is_verified":0,"password":"$2y$10$n1GibXzY9U2spuM/d2fcPe7HTUEVSGUYEmVG8p/LNmh5wGBKewG4O","updated_at":"2021-09-15T09:17:16.000000Z","created_at":"2021-09-15T09:17:16.000000Z","id":3,"otp":1234,"fullImage":"https://zomox.saasmonks.in/public/images/upload/defaultUser.png","license_img":"https://zomox.saasmonks.in/public/images/upload/","nation_id":"https://zomox.saasmonks.in/public/images/upload/"}
/// msg : "your account created successfully please verify your account"

class RegisterModel {
  bool? _success;
  Data? _data;
  String? _msg;

  bool? get success => _success;
  Data? get data => _data;
  String? get msg => _msg;

  RegisterModel({
      bool? success, 
      Data? data, 
      String? msg}){
    _success = success;
    _data = data;
    _msg = msg;
}

  RegisterModel.fromJson(dynamic json) {
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

/// name : "Driver"
/// email : "driver@gmail.com"
/// image : "defaultUser.png"
/// phone : "9876543210"
/// phone_code : "+91"
/// status : 1
/// is_online : 1
/// is_verified : 0
/// password : "$2y$10$n1GibXzY9U2spuM/d2fcPe7HTUEVSGUYEmVG8p/LNmh5wGBKewG4O"
/// updated_at : "2021-09-15T09:17:16.000000Z"
/// created_at : "2021-09-15T09:17:16.000000Z"
/// id : 3
/// otp : 1234
/// fullImage : "https://zomox.saasmonks.in/public/images/upload/defaultUser.png"
/// license_img : "https://zomox.saasmonks.in/public/images/upload/"
/// nation_id : "https://zomox.saasmonks.in/public/images/upload/"

class Data {
  String? _name;
  String? _email;
  String? _image;
  String? _phone;
  String? _phoneCode;
  int? _status;
  int? _isOnline;
  int? _isVerified;
  String? _password;
  String? _updatedAt;
  String? _createdAt;
  int? _id;
  int? _otp;
  String? _fullImage;
  String? _licenseImg;
  String? _nationId;

  String? get name => _name;
  String? get email => _email;
  String? get image => _image;
  String? get phone => _phone;
  String? get phoneCode => _phoneCode;
  int? get status => _status;
  int? get isOnline => _isOnline;
  int? get isVerified => _isVerified;
  String? get password => _password;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  int? get id => _id;
  int? get otp => _otp;
  String? get fullImage => _fullImage;
  String? get licenseImg => _licenseImg;
  String? get nationId => _nationId;

  Data({
      String? name, 
      String? email, 
      String? image, 
      String? phone, 
      String? phoneCode, 
      int? status, 
      int? isOnline, 
      int? isVerified, 
      String? password, 
      String? updatedAt, 
      String? createdAt, 
      int? id, 
      int? otp, 
      String? fullImage, 
      String? licenseImg, 
      String? nationId}){
    _name = name;
    _email = email;
    _image = image;
    _phone = phone;
    _phoneCode = phoneCode;
    _status = status;
    _isOnline = isOnline;
    _isVerified = isVerified;
    _password = password;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
    _otp = otp;
    _fullImage = fullImage;
    _licenseImg = licenseImg;
    _nationId = nationId;
}

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
    _image = json['image'];
    _phone = json['phone'];
    _phoneCode = json['phone_code'];
    _status = json['status'];
    _isOnline = json['is_online'];
    _isVerified = json['is_verified'];
    _password = json['password'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
    _otp = json['otp'];
    _fullImage = json['fullImage'];
    _licenseImg = json['license_img'];
    _nationId = json['nation_id'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['image'] = _image;
    map['phone'] = _phone;
    map['phone_code'] = _phoneCode;
    map['status'] = _status;
    map['is_online'] = _isOnline;
    map['is_verified'] = _isVerified;
    map['password'] = _password;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    map['otp'] = _otp;
    map['fullImage'] = _fullImage;
    map['license_img'] = _licenseImg;
    map['nation_id'] = _nationId;
    return map;
  }

}