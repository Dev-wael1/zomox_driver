/// success : true
/// data : {"id":1,"image":"6149d1a39bf2a.png","owner_id":null,"device_token":"N/A","is_online":1,"is_verified":1,"otp":1234,"phone_code":"+91","phone":"9925088460","name":"Driver","delivery_zone_id":1,"email":"driver@gmail.com","password":"$2y$10$mKH7fozZi42sJhwrvFPRrupOekogyzeAScN7swNHgwuDNOnmUhNs2","driving_license":"6149a656d4c73.png","document_img":"6149a656d4dbb.png","document_type":"adhar card","lat":"22.2627738","lang":"70.7867009","status":1,"notification":1,"created_at":"2021-10-18T09:33:38.000000Z","updated_at":"2021-10-18T09:33:38.000000Z","fullImage":"https://zomox.saasmonks.in/public/images/upload/6149d1a39bf2a.png","license_img":"https://zomox.saasmonks.in/public/images/upload/6149a656d4c73.png","nation_id":"https://zomox.saasmonks.in/public/images/upload/6149a656d4dbb.png","deliveryzone":"Rajkot West Zone"}

class LoginDriverDetailModel {
  LoginDriverDetailModel({
      bool? success, 
      Data? data,}){
    _success = success;
    _data = data;
}

  LoginDriverDetailModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  Data? _data;

  bool? get success => _success;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// id : 1
/// image : "6149d1a39bf2a.png"
/// owner_id : null
/// device_token : "N/A"
/// is_online : 1
/// is_verified : 1
/// otp : 1234
/// phone_code : "+91"
/// phone : "9925088460"
/// name : "Driver"
/// delivery_zone_id : 1
/// email : "driver@gmail.com"
/// password : "$2y$10$mKH7fozZi42sJhwrvFPRrupOekogyzeAScN7swNHgwuDNOnmUhNs2"
/// driving_license : "6149a656d4c73.png"
/// document_img : "6149a656d4dbb.png"
/// document_type : "adhar card"
/// lat : "22.2627738"
/// lang : "70.7867009"
/// status : 1
/// notification : 1
/// created_at : "2021-10-18T09:33:38.000000Z"
/// updated_at : "2021-10-18T09:33:38.000000Z"
/// fullImage : "https://zomox.saasmonks.in/public/images/upload/6149d1a39bf2a.png"
/// license_img : "https://zomox.saasmonks.in/public/images/upload/6149a656d4c73.png"
/// nation_id : "https://zomox.saasmonks.in/public/images/upload/6149a656d4dbb.png"
/// deliveryzone : "Rajkot West Zone"

class Data {
  Data({
      int? id, 
      String? image, 
      dynamic ownerId, 
      String? deviceToken, 
      int? isOnline, 
      int? isVerified, 
      int? otp, 
      String? phoneCode, 
      String? phone, 
      String? name, 
      int? deliveryZoneId, 
      String? email, 
      String? password, 
      String? drivingLicense, 
      String? documentImg, 
      String? documentType, 
      String? lat, 
      String? lang, 
      int? status, 
      int? notification, 
      String? createdAt, 
      String? updatedAt, 
      String? fullImage, 
      String? licenseImg, 
      String? nationId, 
      String? deliveryzone,}){
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
    _notification = notification;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _fullImage = fullImage;
    _licenseImg = licenseImg;
    _nationId = nationId;
    _deliveryzone = deliveryzone;
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
    _notification = json['notification'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _fullImage = json['fullImage'];
    _licenseImg = json['license_img'];
    _nationId = json['nation_id'];
    _deliveryzone = json['deliveryzone'];
  }
  int? _id;
  String? _image;
  dynamic _ownerId;
  String? _deviceToken;
  int? _isOnline;
  int? _isVerified;
  int? _otp;
  String? _phoneCode;
  String? _phone;
  String? _name;
  int? _deliveryZoneId;
  String? _email;
  String? _password;
  String? _drivingLicense;
  String? _documentImg;
  String? _documentType;
  String? _lat;
  String? _lang;
  int? _status;
  int? _notification;
  String? _createdAt;
  String? _updatedAt;
  String? _fullImage;
  String? _licenseImg;
  String? _nationId;
  String? _deliveryzone;

  int? get id => _id;
  String? get image => _image;
  dynamic get ownerId => _ownerId;
  String? get deviceToken => _deviceToken;
  int? get isOnline => _isOnline;
  int? get isVerified => _isVerified;
  int? get otp => _otp;
  String? get phoneCode => _phoneCode;
  String? get phone => _phone;
  String? get name => _name;
  int? get deliveryZoneId => _deliveryZoneId;
  String? get email => _email;
  String? get password => _password;
  String? get drivingLicense => _drivingLicense;
  String? get documentImg => _documentImg;
  String? get documentType => _documentType;
  String? get lat => _lat;
  String? get lang => _lang;
  int? get status => _status;
  int? get notification => _notification;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get fullImage => _fullImage;
  String? get licenseImg => _licenseImg;
  String? get nationId => _nationId;
  String? get deliveryzone => _deliveryzone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
    map['notification'] = _notification;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['fullImage'] = _fullImage;
    map['license_img'] = _licenseImg;
    map['nation_id'] = _nationId;
    map['deliveryzone'] = _deliveryzone;
    return map;
  }

}