class FilterBeautyCenter {
  FilterBeautyCenter({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  FilterBeautyCenter.fromJson(Map<String, dynamic> json){
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
    required this.phone,
    required this.email,
    required this.image,
    required this.timeTo,
    required this.timeFrom,
    required this.deviceToken,
    required this.offDay,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final String email;
  late final String image;
  late final String timeTo;
  late final String timeFrom;
  late final String deviceToken;
  late final String offDay;
  late final String createdAt;
  late final String updatedAt;

  Response.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name']??'';
    phone = json['phone'];
    email = json['email'];
    image = json['image']??'';
    timeTo = json['time_to']??'';
    timeFrom = json['time_from']??'';
    deviceToken = json['device_token'];
    offDay = json['off_day']??'';
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['image'] = image;
    _data['time_to'] = timeTo;
    _data['time_from'] = timeFrom;
    _data['device_token'] = deviceToken;
    _data['off_day'] = offDay;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}