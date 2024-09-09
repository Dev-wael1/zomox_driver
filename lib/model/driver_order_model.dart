/// success : true
/// data : [{"id":14,"location_id":17,"order_id":"#739945","user_id":30,"shop_id":1,"payment_status":"0","order_status":"Approve","amount":394,"payment_type":"COD","orderItems":[{"id":25,"order_id":14,"item":3,"price":322,"qty":2,"custimization":[{"main_menu":"cheese","data":{"name":"Mozzarella","price":"16"}},{"main_menu":"extra","data":{"name":"cheese","price":"20"}}],"itemName":"Burn Cheesy Pizza"}],"shop":{"id":1,"name":"Dakeshi's Restaurant","location":"Nana Mava Circle, Padmi Society, Mavdi, Rajkot, Gujarat","lat":"22.27589","lang":"70.77800","fullImage":"https://zomox.saasmonks.in/public/images/upload/","fullBannerImage":"https://zomox.saasmonks.in/public/images/upload/","rate":0},"user":{"id":30,"name":"user","phone":"1234567890","phone_code":"+91","fullImage":"https://zomox.saasmonks.in/public/images/upload/","logoImg":"https://zomox.saasmonks.in/public/images/upload/"},"address":{"id":17,"address":"Mavdi Main Road, Naval Nagar, Chandreshnagar, Rajkot, Gujarat, India","lat":"22.2326166","lang":"70.7647382"}}]
/// package_order : [{"id":7,"package_id":"#728521","user_id":30,"shop_id":7,"payment_status":"0","order_status":"Approve","category_id":27,"amount":200,"payment_type":"COD","pickup_location":"Mavdi Main Road, Naval Nagar, Chandreshnagar, Rajkot, Gujarat, India","dropup_location":"Jamnagar - Lalpur Road, Green City, Jamnagar, Gujarat, India","pick_lat":"22.3231127","pick_lang":"70.7785746","drop_lat":"22.2326166","drop_lang":"70.7647382","user":{"id":30,"phone":"1234567890","name":"user","phone_code":"+91","fullImage":"https://zomox.saasmonks.in/public/images/upload/","logoImg":"https://zomox.saasmonks.in/public/images/upload/"},"category":{"id":27,"name":"Foods & Flowers","fullImage":"https://zomox.saasmonks.in/public/images/upload/"}}]

class DriverOrderModel {
  DriverOrderModel({
      bool? success, 
      List<DriverOrder>? data,
      List<PackageOrder>? packageOrder,}){
    _success = success;
    _data = data;
    _packageOrder = packageOrder;
}

  DriverOrderModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DriverOrder.fromJson(v));
      });
    }
    if (json['package_order'] != null) {
      _packageOrder = [];
      json['package_order'].forEach((v) {
        _packageOrder?.add(PackageOrder.fromJson(v));
      });
    }
  }
  bool? _success;
  List<DriverOrder>? _data;
  List<PackageOrder>? _packageOrder;

  bool? get success => _success;
  List<DriverOrder>? get data => _data;
  List<PackageOrder>? get packageOrder => _packageOrder;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_packageOrder != null) {
      map['package_order'] = _packageOrder?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 7
/// package_id : "#728521"
/// user_id : 30
/// shop_id : 7
/// payment_status : "0"
/// order_status : "Approve"
/// category_id : 27
/// amount : 200
/// payment_type : "COD"
/// pickup_location : "Mavdi Main Road, Naval Nagar, Chandreshnagar, Rajkot, Gujarat, India"
/// dropup_location : "Jamnagar - Lalpur Road, Green City, Jamnagar, Gujarat, India"
/// pick_lat : "22.3231127"
/// pick_lang : "70.7785746"
/// drop_lat : "22.2326166"
/// drop_lang : "70.7647382"
/// user : {"id":30,"phone":"1234567890","name":"user","phone_code":"+91","fullImage":"https://zomox.saasmonks.in/public/images/upload/","logoImg":"https://zomox.saasmonks.in/public/images/upload/"}
/// category : {"id":27,"name":"Foods & Flowers","fullImage":"https://zomox.saasmonks.in/public/images/upload/"}

class PackageOrder {
  PackageOrder({
      int? id, 
      String? packageId, 
      int? userId, 
      int? shopId, 
      String? paymentStatus, 
      String? orderStatus, 
      int? categoryId, 
      int? amount, 
      String? paymentType, 
      String? pickupLocation, 
      String? dropupLocation, 
      String? pickLat, 
      String? pickLang, 
      String? dropLat, 
      String? dropLang, 
      User? user, 
      Category? category,}){
    _id = id;
    _packageId = packageId;
    _userId = userId;
    _shopId = shopId;
    _paymentStatus = paymentStatus;
    _orderStatus = orderStatus;
    _categoryId = categoryId;
    _amount = amount;
    _paymentType = paymentType;
    _pickupLocation = pickupLocation;
    _dropupLocation = dropupLocation;
    _pickLat = pickLat;
    _pickLang = pickLang;
    _dropLat = dropLat;
    _dropLang = dropLang;
    _user = user;
    _category = category;
}

  PackageOrder.fromJson(dynamic json) {
    _id = json['id'];
    _packageId = json['package_id'];
    _userId = json['user_id'];
    _shopId = json['shop_id'];
    _paymentStatus = json['payment_status'];
    _orderStatus = json['order_status'];
    _categoryId = json['category_id'];
    _amount = json['amount'];
    _paymentType = json['payment_type'];
    _pickupLocation = json['pickup_location'];
    _dropupLocation = json['dropup_location'];
    _pickLat = json['pick_lat'];
    _pickLang = json['pick_lang'];
    _dropLat = json['drop_lat'];
    _dropLang = json['drop_lang'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
  int? _id;
  String? _packageId;
  int? _userId;
  int? _shopId;
  String? _paymentStatus;
  String? _orderStatus;
  int? _categoryId;
  int? _amount;
  String? _paymentType;
  String? _pickupLocation;
  String? _dropupLocation;
  String? _pickLat;
  String? _pickLang;
  String? _dropLat;
  String? _dropLang;
  User? _user;
  Category? _category;

  int? get id => _id;
  String? get packageId => _packageId;
  int? get userId => _userId;
  int? get shopId => _shopId;
  String? get paymentStatus => _paymentStatus;
  String? get orderStatus => _orderStatus;
  int? get categoryId => _categoryId;
  int? get amount => _amount;
  String? get paymentType => _paymentType;
  String? get pickupLocation => _pickupLocation;
  String? get dropupLocation => _dropupLocation;
  String? get pickLat => _pickLat;
  String? get pickLang => _pickLang;
  String? get dropLat => _dropLat;
  String? get dropLang => _dropLang;
  User? get user => _user;
  Category? get category => _category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['package_id'] = _packageId;
    map['user_id'] = _userId;
    map['shop_id'] = _shopId;
    map['payment_status'] = _paymentStatus;
    map['order_status'] = _orderStatus;
    map['category_id'] = _categoryId;
    map['amount'] = _amount;
    map['payment_type'] = _paymentType;
    map['pickup_location'] = _pickupLocation;
    map['dropup_location'] = _dropupLocation;
    map['pick_lat'] = _pickLat;
    map['pick_lang'] = _pickLang;
    map['drop_lat'] = _dropLat;
    map['drop_lang'] = _dropLang;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_category != null) {
      map['category'] = _category?.toJson();
    }
    return map;
  }

}

/// id : 27
/// name : "Foods & Flowers"
/// fullImage : "https://zomox.saasmonks.in/public/images/upload/"

class Category {
  Category({
      int? id, 
      String? name, 
      String? fullImage,}){
    _id = id;
    _name = name;
    _fullImage = fullImage;
}

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _fullImage = json['fullImage'];
  }
  int? _id;
  String? _name;
  String? _fullImage;

  int? get id => _id;
  String? get name => _name;
  String? get fullImage => _fullImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['fullImage'] = _fullImage;
    return map;
  }

}

/// id : 30
/// phone : "1234567890"
/// name : "user"
/// phone_code : "+91"
/// fullImage : "https://zomox.saasmonks.in/public/images/upload/"
/// logoImg : "https://zomox.saasmonks.in/public/images/upload/"

class User {
  User({
      int? id, 
      String? phone, 
      String? name, 
      String? phoneCode, 
      String? fullImage, 
      String? logoImg,}){
    _id = id;
    _phone = phone;
    _name = name;
    _phoneCode = phoneCode;
    _fullImage = fullImage;
    _logoImg = logoImg;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _phone = json['phone'];
    _name = json['name'];
    _phoneCode = json['phone_code'];
    _fullImage = json['fullImage'];
    _logoImg = json['logoImg'];
  }
  int? _id;
  String? _phone;
  String? _name;
  String? _phoneCode;
  String? _fullImage;
  String? _logoImg;

  int? get id => _id;
  String? get phone => _phone;
  String? get name => _name;
  String? get phoneCode => _phoneCode;
  String? get fullImage => _fullImage;
  String? get logoImg => _logoImg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['phone'] = _phone;
    map['name'] = _name;
    map['phone_code'] = _phoneCode;
    map['fullImage'] = _fullImage;
    map['logoImg'] = _logoImg;
    return map;
  }

}

/// id : 14
/// location_id : 17
/// order_id : "#739945"
/// user_id : 30
/// shop_id : 1
/// payment_status : "0"
/// order_status : "Approve"
/// amount : 394
/// payment_type : "COD"
/// orderItems : [{"id":25,"order_id":14,"item":3,"price":322,"qty":2,"custimization":[{"main_menu":"cheese","data":{"name":"Mozzarella","price":"16"}},{"main_menu":"extra","data":{"name":"cheese","price":"20"}}],"itemName":"Burn Cheesy Pizza"}]
/// shop : {"id":1,"name":"Dakeshi's Restaurant","location":"Nana Mava Circle, Padmi Society, Mavdi, Rajkot, Gujarat","lat":"22.27589","lang":"70.77800","fullImage":"https://zomox.saasmonks.in/public/images/upload/","fullBannerImage":"https://zomox.saasmonks.in/public/images/upload/","rate":0}
/// user : {"id":30,"name":"user","phone":"1234567890","phone_code":"+91","fullImage":"https://zomox.saasmonks.in/public/images/upload/","logoImg":"https://zomox.saasmonks.in/public/images/upload/"}
/// address : {"id":17,"address":"Mavdi Main Road, Naval Nagar, Chandreshnagar, Rajkot, Gujarat, India","lat":"22.2326166","lang":"70.7647382"}

class DriverOrder {
  DriverOrder({
      int? id, 
      int? locationId, 
      String? orderId, 
      int? userId, 
      int? shopId, 
      String? paymentStatus, 
      String? orderStatus, 
      int? amount, 
      String? paymentType, 
      List<OrderItems>? orderItems, 
      Shop? shop, 
      User? user, 
      Address? address,}){
    _id = id;
    _locationId = locationId;
    _orderId = orderId;
    _userId = userId;
    _shopId = shopId;
    _paymentStatus = paymentStatus;
    _orderStatus = orderStatus;
    _amount = amount;
    _paymentType = paymentType;
    _orderItems = orderItems;
    _shop = shop;
    _user = user;
    _address = address;
}

  DriverOrder.fromJson(dynamic json) {
    _id = json['id'];
    _locationId = json['location_id'];
    _orderId = json['order_id'];
    _userId = json['user_id'];
    _shopId = json['shop_id'];
    _paymentStatus = json['payment_status'];
    _orderStatus = json['order_status'];
    _amount = json['amount'];
    _paymentType = json['payment_type'];
    if (json['orderItems'] != null) {
      _orderItems = [];
      json['orderItems'].forEach((v) {
        _orderItems?.add(OrderItems.fromJson(v));
      });
    }
    _shop = json['shop'] != null ? Shop.fromJson(json['shop']) : null;
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }
  int? _id;
  int? _locationId;
  String? _orderId;
  int? _userId;
  int? _shopId;
  String? _paymentStatus;
  String? _orderStatus;
  int? _amount;
  String? _paymentType;
  List<OrderItems>? _orderItems;
  Shop? _shop;
  User? _user;
  Address? _address;

  int? get id => _id;
  int? get locationId => _locationId;
  String? get orderId => _orderId;
  int? get userId => _userId;
  int? get shopId => _shopId;
  String? get paymentStatus => _paymentStatus;
  String? get orderStatus => _orderStatus;
  int? get amount => _amount;
  String? get paymentType => _paymentType;
  List<OrderItems>? get orderItems => _orderItems;
  Shop? get shop => _shop;
  User? get user => _user;
  Address? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['location_id'] = _locationId;
    map['order_id'] = _orderId;
    map['user_id'] = _userId;
    map['shop_id'] = _shopId;
    map['payment_status'] = _paymentStatus;
    map['order_status'] = _orderStatus;
    map['amount'] = _amount;
    map['payment_type'] = _paymentType;
    if (_orderItems != null) {
      map['orderItems'] = _orderItems?.map((v) => v.toJson()).toList();
    }
    if (_shop != null) {
      map['shop'] = _shop?.toJson();
    }
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    return map;
  }

}

/// id : 17
/// address : "Mavdi Main Road, Naval Nagar, Chandreshnagar, Rajkot, Gujarat, India"
/// lat : "22.2326166"
/// lang : "70.7647382"

class Address {
  Address({
      int? id, 
      String? address, 
      String? lat, 
      String? lang,}){
    _id = id;
    _address = address;
    _lat = lat;
    _lang = lang;
}

  Address.fromJson(dynamic json) {
    _id = json['id'];
    _address = json['address'];
    _lat = json['lat'];
    _lang = json['lang'];
  }
  int? _id;
  String? _address;
  String? _lat;
  String? _lang;

  int? get id => _id;
  String? get address => _address;
  String? get lat => _lat;
  String? get lang => _lang;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['address'] = _address;
    map['lat'] = _lat;
    map['lang'] = _lang;
    return map;
  }

}

/// id : 30
/// name : "user"
/// phone : "1234567890"
/// phone_code : "+91"
/// fullImage : "https://zomox.saasmonks.in/public/images/upload/"
/// logoImg : "https://zomox.saasmonks.in/public/images/upload/"

// class User {
//   User({
//       int? id,
//       String? name,
//       String? phone,
//       String? phoneCode,
//       String? fullImage,
//       String? logoImg,}){
//     _id = id;
//     _name = name;
//     _phone = phone;
//     _phoneCode = phoneCode;
//     _fullImage = fullImage;
//     _logoImg = logoImg;
// }
//
//   User.fromJson(dynamic json) {
//     _id = json['id'];
//     _name = json['name'];
//     _phone = json['phone'];
//     _phoneCode = json['phone_code'];
//     _fullImage = json['fullImage'];
//     _logoImg = json['logoImg'];
//   }
//   int? _id;
//   String? _name;
//   String? _phone;
//   String? _phoneCode;
//   String? _fullImage;
//   String? _logoImg;
//
//   int? get id => _id;
//   String? get name => _name;
//   String? get phone => _phone;
//   String? get phoneCode => _phoneCode;
//   String? get fullImage => _fullImage;
//   String? get logoImg => _logoImg;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     map['phone'] = _phone;
//     map['phone_code'] = _phoneCode;
//     map['fullImage'] = _fullImage;
//     map['logoImg'] = _logoImg;
//     return map;
//   }
//
// }

/// id : 1
/// name : "Dakeshi's Restaurant"
/// location : "Nana Mava Circle, Padmi Society, Mavdi, Rajkot, Gujarat"
/// lat : "22.27589"
/// lang : "70.77800"
/// fullImage : "https://zomox.saasmonks.in/public/images/upload/"
/// fullBannerImage : "https://zomox.saasmonks.in/public/images/upload/"
/// rate : 0

class Shop {
  Shop({
      int? id, 
      String? name, 
      String? location, 
      String? lat, 
      String? lang, 
      String? fullImage, 
      String? fullBannerImage, 
      int? rate,}){
    _id = id;
    _name = name;
    _location = location;
    _lat = lat;
    _lang = lang;
    _fullImage = fullImage;
    _fullBannerImage = fullBannerImage;
    _rate = rate;
}

  Shop.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _location = json['location'];
    _lat = json['lat'];
    _lang = json['lang'];
    _fullImage = json['fullImage'];
    _fullBannerImage = json['fullBannerImage'];
    _rate = json['rate'];
  }
  int? _id;
  String? _name;
  String? _location;
  String? _lat;
  String? _lang;
  String? _fullImage;
  String? _fullBannerImage;
  int? _rate;

  int? get id => _id;
  String? get name => _name;
  String? get location => _location;
  String? get lat => _lat;
  String? get lang => _lang;
  String? get fullImage => _fullImage;
  String? get fullBannerImage => _fullBannerImage;
  int? get rate => _rate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['location'] = _location;
    map['lat'] = _lat;
    map['lang'] = _lang;
    map['fullImage'] = _fullImage;
    map['fullBannerImage'] = _fullBannerImage;
    map['rate'] = _rate;
    return map;
  }

}

/// id : 25
/// order_id : 14
/// item : 3
/// price : 322
/// qty : 2
/// custimization : [{"main_menu":"cheese","data":{"name":"Mozzarella","price":"16"}},{"main_menu":"extra","data":{"name":"cheese","price":"20"}}]
/// itemName : "Burn Cheesy Pizza"

class OrderItems {
  OrderItems({
      int? id, 
      int? orderId, 
      int? item, 
      int? price, 
      int? qty, 
      List<Custimization>? custimization,
      String? itemName,}){
    _id = id;
    _orderId = orderId;
    _item = item;
    _price = price;
    _qty = qty;
    _custimization = custimization;
    _itemName = itemName;
}

  OrderItems.fromJson(dynamic json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _item = json['item'];
    _price = json['price'];
    _qty = json['qty'];
    if (json['custimization'] != null) {
      _custimization = [];
      json['custimization'].forEach((v) {
        _custimization?.add(Custimization.fromJson(v));
      });
    }
    _itemName = json['itemName'];
  }
  int? _id;
  int? _orderId;
  int? _item;
  int? _price;
  int? _qty;
  List<Custimization>? _custimization;
  String? _itemName;

  int? get id => _id;
  int? get orderId => _orderId;
  int? get item => _item;
  int? get price => _price;
  int? get qty => _qty;
  List<Custimization>? get custimization => _custimization;
  String? get itemName => _itemName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_id'] = _orderId;
    map['item'] = _item;
    map['price'] = _price;
    map['qty'] = _qty;
    if (_custimization != null) {
      map['custimization'] = _custimization?.map((v) => v.toJson()).toList();
    }
    map['itemName'] = _itemName;
    return map;
  }

}

/// main_menu : "cheese"
/// data : {"name":"Mozzarella","price":"16"}

class Custimization {
  Custimization({
      String? mainMenu, 
      Data? data,}){
    _mainMenu = mainMenu;
    _data = data;
}

  Custimization.fromJson(dynamic json) {
    _mainMenu = json['main_menu'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _mainMenu;
  Data? _data;

  String? get mainMenu => _mainMenu;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['main_menu'] = _mainMenu;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// name : "Mozzarella"
/// price : "16"

class Data {
  Data({
      String? name, 
      String? price,}){
    _name = name;
    _price = price;
}

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _price = json['price'];
  }
  String? _name;
  String? _price;

  String? get name => _name;
  String? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['price'] = _price;
    return map;
  }

}