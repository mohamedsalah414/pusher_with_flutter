class ChatRoom {
  ChatRoom({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  ChatRoom.fromJson(Map<String, dynamic> json){
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
    required this.id,
    required this.name,
    required this.image,
    required this.lastMessage,
    required this.date,
    required this.time,
  });
  late final int id;
  late final String name;
  late final String image;
  late final String lastMessage;
  late final String date;
  late final String time;

  Response.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image']??'';
    lastMessage = json['lastMessage'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image'] = image;
    _data['lastMessage'] = lastMessage;
    _data['date'] = date;
    _data['time'] = time;
    return _data;
  }
}