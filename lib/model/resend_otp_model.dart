/// success : true
/// data : 4

class ResendOtpModel {
  ResendOtpModel({
      bool? success, 
      int? data,}){
    _success = success;
    _data = data;
}

  ResendOtpModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'];
  }
  bool? _success;
  int? _data;

  bool? get success => _success;
  int? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['data'] = _data;
    return map;
  }

}