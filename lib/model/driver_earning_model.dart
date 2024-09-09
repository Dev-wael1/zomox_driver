/// success : true
/// data : {"current_month":100,"today_earning":0,"week_earning":100,"yearliy_earning":200,"total_amount":200,"graph":[{"month":"Sep","month_earning":0},{"month":"Aug","month_earning":600},{"month":"Jul","month_earning":400},{"month":"Jun","month_earning":0},{"month":"May","month_earning":0},{"month":"Apr","month_earning":0},{"month":"Mar","month_earning":0},{"month":"Feb","month_earning":0},{"month":"Jan","month_earning":0},{"month":"Dec","month_earning":0},{"month":"Nov","month_earning":0},{"month":"Oct","month_earning":0}]}

class DriverEarningModel {
  bool? _success;
  Data? _data;

  bool? get success => _success;
  Data? get data => _data;

  DriverEarningModel({
      bool? success, 
      Data? data}){
    _success = success;
    _data = data;
}

  DriverEarningModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// current_month : 100
/// today_earning : 0
/// week_earning : 100
/// yearliy_earning : 200
/// total_amount : 200
/// graph : [{"month":"Sep","month_earning":0},{"month":"Aug","month_earning":600},{"month":"Jul","month_earning":400},{"month":"Jun","month_earning":0},{"month":"May","month_earning":0},{"month":"Apr","month_earning":0},{"month":"Mar","month_earning":0},{"month":"Feb","month_earning":0},{"month":"Jan","month_earning":0},{"month":"Dec","month_earning":0},{"month":"Nov","month_earning":0},{"month":"Oct","month_earning":0}]

class Data {
  int? _currentMonth;
  int? _todayEarning;
  int? _weekEarning;
  int? _yearliyEarning;
  int? _totalAmount;
  List<Graph>? _graph;

  int? get currentMonth => _currentMonth;
  int? get todayEarning => _todayEarning;
  int? get weekEarning => _weekEarning;
  int? get yearliyEarning => _yearliyEarning;
  int? get totalAmount => _totalAmount;
  List<Graph>? get graph => _graph;

  Data({
      int? currentMonth, 
      int? todayEarning, 
      int? weekEarning, 
      int? yearliyEarning, 
      int? totalAmount, 
      List<Graph>? graph}){
    _currentMonth = currentMonth;
    _todayEarning = todayEarning;
    _weekEarning = weekEarning;
    _yearliyEarning = yearliyEarning;
    _totalAmount = totalAmount;
    _graph = graph;
}

  Data.fromJson(dynamic json) {
    _currentMonth = json['current_month'];
    _todayEarning = json['today_earning'];
    _weekEarning = json['week_earning'];
    _yearliyEarning = json['yearliy_earning'];
    _totalAmount = json['total_amount'];
    if (json['graph'] != null) {
      _graph = [];
      json['graph'].forEach((v) {
        _graph?.add(Graph.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['current_month'] = _currentMonth;
    map['today_earning'] = _todayEarning;
    map['week_earning'] = _weekEarning;
    map['yearliy_earning'] = _yearliyEarning;
    map['total_amount'] = _totalAmount;
    if (_graph != null) {
      map['graph'] = _graph?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// month : "Sep"
/// month_earning : 0

class Graph {
  String? _month;
  int? _monthEarning;

  String? get month => _month;
  int? get monthEarning => _monthEarning;

  Graph({
      String? month, 
      int? monthEarning}){
    _month = month;
    _monthEarning = monthEarning;
}

  Graph.fromJson(dynamic json) {
    _month = json['month'];
    _monthEarning = json['month_earning'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['month'] = _month;
    map['month_earning'] = _monthEarning;
    return map;
  }

}