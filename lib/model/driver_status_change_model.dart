/// success : true
/// data : 13
/// msg : "status changed"

class DriverStatusChangeModel {
  DriverStatusChangeModel({
      bool? success, 
      int? data, 
      String? msg,}){
    _success = success;
    _data = data;
    _msg = msg;
}

  DriverStatusChangeModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'];
    _msg = json['msg'];
  }
  bool? _success;
  int? _data;
  String? _msg;

  bool? get success => _success;
  int? get data => _data;
  String? get msg => _msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['data'] = _data;
    map['msg'] = _msg;
    return map;
  }

}