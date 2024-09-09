/// success : true
/// data : {"delivery_person_privacy":"<p>Lorem Ipsum, sometimes referred to as 'lipsum', is the placeholder text used in design when creating content. It helps designers plan out where the content will sit, without needing to wait for the content to be written and approved. It originally comes from a Latin text, but to today's reader, it's seen as gibberish<br></p>","delivery_person_t_and_c":"<p>Lorem Ipsum, Sometimes Referred To As 'Lipsum', Is The Placeholder Text Used In Design When Creating Content. It Helps Designers Plan Out Where The Content Will Sit, Without Needing To Wait For The Content To Be Written And Approved. It Originally Comes From A Latin Text, But To Today's Reader, It's Seen As Gibberish<br></p>","auto_refresh":"30","delivery_person_about":"<p>Lorem Ipsum, Sometimes Referred To As 'Lipsum', Is The Placeholder Text Used In Design When Creating Content. It Helps Designers Plan Out Where The Content Will Sit, Without Needing To Wait For The Content To Be Written And Approved. It Originally Comes From A Latin Text, But To Today's Reader, It's Seen As Gibberish<br></p>","documents":"national id ,pan card,adhar card","cancel_reason":"[\"lorem ipsum\",\"lorem ipsum\",\"other reason\"]","driver_app_id":"a6155db8-3cc6-4796-98da-63a16c2e4080","driver_auth_key":"ODQ0OWU0NjMtOWEzZC00ZjZkLWEwNzYtY2FhNDVlODdiMWEx","api_key":"ZjMxY2VmOWQtMzlmMi00MDBlLTlhYjEtOWNlODAyZmI0MGEx"}

class SettingModel {
  SettingModel({
      bool? success, 
      Data? data,}){
    _success = success;
    _data = data;
}

  SettingModel.fromJson(dynamic json) {
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

/// delivery_person_privacy : "<p>Lorem Ipsum, sometimes referred to as 'lipsum', is the placeholder text used in design when creating content. It helps designers plan out where the content will sit, without needing to wait for the content to be written and approved. It originally comes from a Latin text, but to today's reader, it's seen as gibberish<br></p>"
/// delivery_person_t_and_c : "<p>Lorem Ipsum, Sometimes Referred To As 'Lipsum', Is The Placeholder Text Used In Design When Creating Content. It Helps Designers Plan Out Where The Content Will Sit, Without Needing To Wait For The Content To Be Written And Approved. It Originally Comes From A Latin Text, But To Today's Reader, It's Seen As Gibberish<br></p>"
/// auto_refresh : "30"
/// delivery_person_about : "<p>Lorem Ipsum, Sometimes Referred To As 'Lipsum', Is The Placeholder Text Used In Design When Creating Content. It Helps Designers Plan Out Where The Content Will Sit, Without Needing To Wait For The Content To Be Written And Approved. It Originally Comes From A Latin Text, But To Today's Reader, It's Seen As Gibberish<br></p>"
/// documents : "national id ,pan card,adhar card"
/// cancel_reason : "[\"lorem ipsum\",\"lorem ipsum\",\"other reason\"]"
/// driver_app_id : "a6155db8-3cc6-4796-98da-63a16c2e4080"
/// driver_auth_key : "ODQ0OWU0NjMtOWEzZC00ZjZkLWEwNzYtY2FhNDVlODdiMWEx"
/// api_key : "ZjMxY2VmOWQtMzlmMi00MDBlLTlhYjEtOWNlODAyZmI0MGEx"

class Data {
  Data({
      String? deliveryPersonPrivacy, 
      String? deliveryPersonTAndC, 
      String? autoRefresh, 
      String? deliveryPersonAbout, 
      String? documents, 
      String? cancelReason, 
      String? driverAppId, 
      String? driverAuthKey, 
      String? apiKey,}){
    _deliveryPersonPrivacy = deliveryPersonPrivacy;
    _deliveryPersonTAndC = deliveryPersonTAndC;
    _autoRefresh = autoRefresh;
    _deliveryPersonAbout = deliveryPersonAbout;
    _documents = documents;
    _cancelReason = cancelReason;
    _driverAppId = driverAppId;
    _driverAuthKey = driverAuthKey;
    _apiKey = apiKey;
}

  Data.fromJson(dynamic json) {
    _deliveryPersonPrivacy = json['delivery_person_privacy'];
    _deliveryPersonTAndC = json['delivery_person_t_and_c'];
    _autoRefresh = json['auto_refresh'];
    _deliveryPersonAbout = json['delivery_person_about'];
    _documents = json['documents'];
    _cancelReason = json['cancel_reason'];
    _driverAppId = json['driver_app_id'];
    _driverAuthKey = json['driver_auth_key'];
    _apiKey = json['api_key'];
  }
  String? _deliveryPersonPrivacy;
  String? _deliveryPersonTAndC;
  String? _autoRefresh;
  String? _deliveryPersonAbout;
  String? _documents;
  String? _cancelReason;
  String? _driverAppId;
  String? _driverAuthKey;
  String? _apiKey;

  String? get deliveryPersonPrivacy => _deliveryPersonPrivacy;
  String? get deliveryPersonTAndC => _deliveryPersonTAndC;
  String? get autoRefresh => _autoRefresh;
  String? get deliveryPersonAbout => _deliveryPersonAbout;
  String? get documents => _documents;
  String? get cancelReason => _cancelReason;
  String? get driverAppId => _driverAppId;
  String? get driverAuthKey => _driverAuthKey;
  String? get apiKey => _apiKey;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['delivery_person_privacy'] = _deliveryPersonPrivacy;
    map['delivery_person_t_and_c'] = _deliveryPersonTAndC;
    map['auto_refresh'] = _autoRefresh;
    map['delivery_person_about'] = _deliveryPersonAbout;
    map['documents'] = _documents;
    map['cancel_reason'] = _cancelReason;
    map['driver_app_id'] = _driverAppId;
    map['driver_auth_key'] = _driverAuthKey;
    map['api_key'] = _apiKey;
    return map;
  }

}