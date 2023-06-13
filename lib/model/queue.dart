class Queue {
  Queue({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  Queue.fromJson(Map<String, dynamic> json){
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
  late final List<Responsee> response;

  Data.fromJson(Map<String, dynamic> json){
    response = List.from(json['response']).map((e)=>Responsee.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['response'] = response.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Responsee {
  Responsee({
    required this.id,
    required this.time,
    required this.waitingNumber,
    required this.active,
  });
  late final int id;
  late final String time;
  late final int waitingNumber;
  late final int active;

  Responsee.fromJson(Map<String, dynamic> json){
    id = json['id'];
    time = json['time'];
    waitingNumber = json['waiting_number'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['time'] = time;
    _data['waiting_number'] = waitingNumber;
    _data['active'] = active;
    return _data;
  }
}