class Notifications {
  Notifications({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  Notifications.fromJson(Map<String, dynamic> json){
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
    required this.notification,
    required this.length,
  });
  late final List<Notification> notification;
  late final int length;

  Response.fromJson(Map<String, dynamic> json){
    notification = List.from(json['notification']).map((e)=>Notification.fromJson(e)).toList();
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['notification'] = notification.map((e)=>e.toJson()).toList();
    _data['length'] = length;
    return _data;
  }
}

class Notification {
  Notification({
    required this.contentType,
    required this.notification,
    required this.contentId,
    required this.seen,
    required this.createdAt,
  });
  late final String contentType;
  late final String notification;
  late final int contentId;
  late final int seen;
  late final String createdAt;

  Notification.fromJson(Map<String, dynamic> json){
    contentType = json['content_type'];
    notification = json['notification'];
    contentId = json['content_id'];
    seen = json['seen'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['content_type'] = contentType;
    _data['notification'] = notification;
    _data['content_id'] = contentId;
    _data['seen'] = seen;
    _data['created_at'] = createdAt;
    return _data;
  }
}