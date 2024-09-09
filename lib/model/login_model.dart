/// success : true
/// data : {"id":4,"image":"defaultUser.png","owner_id":0,"device_token":"a67c101a-5790-446e-8fe5-197edf310e1e","is_online":1,"is_verified":1,"otp":1234,"phone_code":"+91","phone":"9874563210","name":"Driver Abc","delivery_zone_id":1,"email":"driver2@gmail.com","password":"$2y$10$AvlK.cANmFK18TzCk7oKUuZLzyYwtcgsPrxf8HrnVTjuuIcSU.Jaa","driving_license":"616e4ae4f40c0.png","document_img":"616e4ae502f60.png","document_type":"adhar card","lat":"22.2627723","lang":"70.7867054","status":1,"notification":1,"created_at":"2021-10-22T07:00:12.000000Z","updated_at":"2021-10-22T07:00:12.000000Z","token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiY2RlNjVkOWRmMjhmMzFlMmNkY2RiMzEzNzNjOTY0NjU4MmI1MzE2YWM4MzU1Nzk0ODFlZDNlNzhiMGZhODYxYmU3ODNiOGYxMDY3Zjg0YzciLCJpYXQiOjE2MzQ4OTMzNTMuNDc5NTIzODk3MTcxMDIwNTA3ODEyNSwibmJmIjoxNjM0ODkzMzUzLjQ3OTUyNzk1MDI4Njg2NTIzNDM3NSwiZXhwIjoxNjY2NDI5MzUzLjQ3NTIxOTAxMTMwNjc2MjY5NTMxMjUsInN1YiI6IjQiLCJzY29wZXMiOltdfQ.noUcrSNte2pcKBfdLrE8fizR3I8Rf0nxpfk-9swXMKZ6El8LQhUlFU0xjquYLaTmZJPrFJYwni-TBinA2chu5YEcw-9ED8MPnwpLfTc8AZah9ZWUQ3VBFzRhBaaEwIhfMf07UyjhryhVRNhRF-5Gs7B_ufJrGOtJZkEVhh6K3Kn1lZhiyAqAoo70PPn4CFz_Y_r010xp5za7AHjIB2GyhtZgF5jeUKHWvD3HURh6Cy3fNZytblACQDuuXGaKQRFyisMvXwRsmCG8v9M-6h6f8P02_606WMfwR72bwQSReCITzY6wHY_v9gMNOx4xOfIajX5mKK6zpOAKsijZeAeccktFxRKXAjCE-WL2OHfTLRwoWU2O45yrAn2khXJ4iI5Zx_hrnISu40QoVRhR465vXVRRrEXRZrIwppvxnhBkASnaOMwH83m-O952NhQ1VyQz66sXEO5kusPDxbNGWcUUM7Mxc7PBQCiWMManvK7bArqFoVZPriQEEgqDDRlgXkTdxqAOVEvl5K3DSVaId5OOAukcQ6qRIdLCAvY7tuQk4FoFY2q7xxeeCyJ10WcCmo5tAkCLGa8Rw5CV85gKxc_8wwLqTJG3BlKWzcy_Dxlcv9Y0hvJfmp-Oj-8xXlzvB2tsIfe5AX-ev2Cbjd2UTJfmMYivXBEeeCxm9xu6xHEFwpA","fullImage":"https://zomox.saasmonks.in/public/images/upload/defaultUser.png","license_img":"https://zomox.saasmonks.in/public/images/upload/616e4ae4f40c0.png","nation_id":"https://zomox.saasmonks.in/public/images/upload/616e4ae502f60.png","deliveryzone":"Rajkot West Zone"}
/// msg : "Login Successfully."

class LoginModel {
  LoginModel({
      bool? success, 
      Data? data, 
      String? msg,}){
    _success = success;
    _data = data;
    _msg = msg;
}

  LoginModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _msg = json['msg'];
  }
  bool? _success;
  Data? _data;
  String? _msg;

  bool? get success => _success;
  Data? get data => _data;
  String? get msg => _msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['msg'] = _msg;
    return map;
  }

}

/// id : 4
/// image : "defaultUser.png"
/// owner_id : 0
/// device_token : "a67c101a-5790-446e-8fe5-197edf310e1e"
/// is_online : 1
/// is_verified : 1
/// otp : 1234
/// phone_code : "+91"
/// phone : "9874563210"
/// name : "Driver Abc"
/// delivery_zone_id : 1
/// email : "driver2@gmail.com"
/// password : "$2y$10$AvlK.cANmFK18TzCk7oKUuZLzyYwtcgsPrxf8HrnVTjuuIcSU.Jaa"
/// driving_license : "616e4ae4f40c0.png"
/// document_img : "616e4ae502f60.png"
/// document_type : "adhar card"
/// lat : "22.2627723"
/// lang : "70.7867054"
/// status : 1
/// notification : 1
/// created_at : "2021-10-22T07:00:12.000000Z"
/// updated_at : "2021-10-22T07:00:12.000000Z"
/// token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiY2RlNjVkOWRmMjhmMzFlMmNkY2RiMzEzNzNjOTY0NjU4MmI1MzE2YWM4MzU1Nzk0ODFlZDNlNzhiMGZhODYxYmU3ODNiOGYxMDY3Zjg0YzciLCJpYXQiOjE2MzQ4OTMzNTMuNDc5NTIzODk3MTcxMDIwNTA3ODEyNSwibmJmIjoxNjM0ODkzMzUzLjQ3OTUyNzk1MDI4Njg2NTIzNDM3NSwiZXhwIjoxNjY2NDI5MzUzLjQ3NTIxOTAxMTMwNjc2MjY5NTMxMjUsInN1YiI6IjQiLCJzY29wZXMiOltdfQ.noUcrSNte2pcKBfdLrE8fizR3I8Rf0nxpfk-9swXMKZ6El8LQhUlFU0xjquYLaTmZJPrFJYwni-TBinA2chu5YEcw-9ED8MPnwpLfTc8AZah9ZWUQ3VBFzRhBaaEwIhfMf07UyjhryhVRNhRF-5Gs7B_ufJrGOtJZkEVhh6K3Kn1lZhiyAqAoo70PPn4CFz_Y_r010xp5za7AHjIB2GyhtZgF5jeUKHWvD3HURh6Cy3fNZytblACQDuuXGaKQRFyisMvXwRsmCG8v9M-6h6f8P02_606WMfwR72bwQSReCITzY6wHY_v9gMNOx4xOfIajX5mKK6zpOAKsijZeAeccktFxRKXAjCE-WL2OHfTLRwoWU2O45yrAn2khXJ4iI5Zx_hrnISu40QoVRhR465vXVRRrEXRZrIwppvxnhBkASnaOMwH83m-O952NhQ1VyQz66sXEO5kusPDxbNGWcUUM7Mxc7PBQCiWMManvK7bArqFoVZPriQEEgqDDRlgXkTdxqAOVEvl5K3DSVaId5OOAukcQ6qRIdLCAvY7tuQk4FoFY2q7xxeeCyJ10WcCmo5tAkCLGa8Rw5CV85gKxc_8wwLqTJG3BlKWzcy_Dxlcv9Y0hvJfmp-Oj-8xXlzvB2tsIfe5AX-ev2Cbjd2UTJfmMYivXBEeeCxm9xu6xHEFwpA"
/// fullImage : "https://zomox.saasmonks.in/public/images/upload/defaultUser.png"
/// license_img : "https://zomox.saasmonks.in/public/images/upload/616e4ae4f40c0.png"
/// nation_id : "https://zomox.saasmonks.in/public/images/upload/616e4ae502f60.png"
/// deliveryzone : "Rajkot West Zone"

class Data {
  Data({
      int? id, 
      String? image, 
      int? ownerId, 
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
      String? token, 
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
    _token = token;
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
    _token = json['token'];
    _fullImage = json['fullImage'];
    _licenseImg = json['license_img'];
    _nationId = json['nation_id'];
    _deliveryzone = json['deliveryzone'];
  }
  int? _id;
  String? _image;
  int? _ownerId;
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
  String? _token;
  String? _fullImage;
  String? _licenseImg;
  String? _nationId;
  String? _deliveryzone;

  int? get id => _id;
  String? get image => _image;
  int? get ownerId => _ownerId;
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
  String? get token => _token;
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
    map['token'] = _token;
    map['fullImage'] = _fullImage;
    map['license_img'] = _licenseImg;
    map['nation_id'] = _nationId;
    map['deliveryzone'] = _deliveryzone;
    return map;
  }

}