class MessageData {
  MessageData({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  MessageData.fromJson(Map<String, dynamic> json){
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
  late final Response response;

  Data.fromJson(Map<String, dynamic> json){
    response = Response.fromJson(json['response']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['response'] = response.toJson();
    return _data;
  }
}

class Response {
  Response({
    required this.messages,
    required this.length,
  });
  late final List<Messages> messages;
  late final int length;

  Response.fromJson(Map<String, dynamic> json){
    messages = List.from(json['messages']).map((e)=>Messages.fromJson(e)).toList();
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['messages'] = messages.map((e)=>e.toJson()).toList();
    _data['length'] = length;
    return _data;
  }
}

class Messages {
  Messages({
    required this.content,
    required this.contentType,
    required this.senderType,
    required this.createdAt,
  });
  late final String content;
  late final String contentType;
  late final String senderType;
  late final String createdAt;

  Messages.fromJson(Map<String, dynamic> json){
    content = json['content'];
    contentType = json['content_type'];
    senderType = json['sender_type'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['content'] = content;
    _data['content_type'] = contentType;
    _data['sender_type'] = senderType;
    _data['created_at'] = createdAt;
    return _data;
  }
}