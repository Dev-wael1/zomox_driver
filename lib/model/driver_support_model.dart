/// success : true
/// data : [{"question":"lorem ipsum","answer":"Lorem Ipsum, Sometimes Referred To As 'Lipsum', Is The Placeholder Text Used In Design When Creating Content. It Helps Designers Plan Out Where The Content Will Sit, Without Needing To Wait For The Content To Be Written And Approved. It Originally Comes From A Latin Text, But To Today's Reader, It's Seen As Gibberish"},{"question":"lorem","answer":"Lorem Ipsum, Sometimes Referred To As 'Lipsum', Is The Placeholder Text Used In Design When Creating Content. It Helps Designers Plan Out Where The Content Will Sit, Without Needing To Wait For The Content To Be Written And Approved. It Originally Comes From A Latin Text, But To Today's Reader, It's Seen As Gibberish"}]

class DriverSupportModel {
  DriverSupportModel({
      bool? success, 
      List<Data>? data,}){
    _success = success;
    _data = data;
}

  DriverSupportModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _success;
  List<Data>? _data;

  bool? get success => _success;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// question : "lorem ipsum"
/// answer : "Lorem Ipsum, Sometimes Referred To As 'Lipsum', Is The Placeholder Text Used In Design When Creating Content. It Helps Designers Plan Out Where The Content Will Sit, Without Needing To Wait For The Content To Be Written And Approved. It Originally Comes From A Latin Text, But To Today's Reader, It's Seen As Gibberish"

class Data {
  Data({
      String? question, 
      String? answer,}){
    _question = question;
    _answer = answer;
}

  Data.fromJson(dynamic json) {
    _question = json['question'];
    _answer = json['answer'];
  }
  String? _question;
  String? _answer;

  String? get question => _question;
  String? get answer => _answer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question'] = _question;
    map['answer'] = _answer;
    return map;
  }

}