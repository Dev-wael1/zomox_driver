/// success : true
/// data : [{"id":1,"name":"rajkot"},{"id":2,"name":"gondal"},{"id":3,"name":"mavdi rajkot"},{"id":4,"name":"hospital chowk"},{"id":5,"name":"Rajkot Zone"}]

class DeliveryZoneModel {
  bool? _success;
  List<DeliveryZone>? _data;

  bool? get success => _success;
  List<DeliveryZone>? get data => _data;

  DeliveryZoneModel({
      bool? success, 
      List<DeliveryZone>? data}){
    _success = success;
    _data = data;
}

  DeliveryZoneModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(DeliveryZone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "rajkot"

class DeliveryZone {
  int? _id;
  String? _name;

  int? get id => _id;
  String? get name => _name;

  DeliveryZone({
      int? id, 
      String? name}){
    _id = id;
    _name = name;
}

  DeliveryZone.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}