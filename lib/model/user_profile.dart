class UserProfile {
  UserProfile({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  UserProfile.fromJson(Map<String, dynamic> json){
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
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.deviceToken,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final String email;
  late final String address;
  late final String deviceToken;
  late final String image;
  late final String createdAt;
  late final String updatedAt;

  Response.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name']??'';
    phone = json['phone']??'';
    email = json['email'];
    address = json['address']??'';
    deviceToken = json['device_token'];
    image = json['image']??'';
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['address'] = address;
    _data['device_token'] = deviceToken;
    _data['image'] = image;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}