/// success : true
/// data : "Password Update Successfully...!!"

class ChangePasswordModel {
  bool? _success;
  String? _data;

  bool? get success => _success;
  String? get data => _data;

  ChangePasswordModel({
      bool? success, 
      String? data}){
    _success = success;
    _data = data;
}

  ChangePasswordModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['success'] = _success;
    map['data'] = _data;
    return map;
  }

}