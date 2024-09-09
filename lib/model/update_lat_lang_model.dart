/// success : true
/// data : "update successfully..!"

class UpdateLatLangModel {
  UpdateLatLangModel({
      bool? success, 
      String? data,}){
    _success = success;
    _data = data;
}

  UpdateLatLangModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'];
  }
  bool? _success;
  String? _data;

  bool? get success => _success;
  String? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['data'] = _data;
    return map;
  }

}