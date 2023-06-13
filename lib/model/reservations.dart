class Reservations {
  Reservations({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  Reservations.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.response,
  });
  late final List<Response> response;

  Data.fromJson(Map<String, dynamic> json){
    response = List.from(json['response']).map((e)=>Response.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['response'] = response.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Response {
  Response({
    required this.time,
    required this.skippedTime,
  });
  late final String time;
  late final int skippedTime;

  Response.fromJson(Map<String, dynamic> json){
    time = json['time'];
    skippedTime = json['skipped_time'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['skipped_time'] = skippedTime;
    return _data;
  }
}