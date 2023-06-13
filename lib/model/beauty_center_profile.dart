class BeautyCenterProfile {
  BeautyCenterProfile({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  BeautyCenterProfile.fromJson(Map<String, dynamic> json){
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
    required this.image,
    required this.timeTo,
    required this.timeFrom,
    required this.deviceToken,
    required this.offDay,
    required this.createdAt,
    required this.updatedAt,
    required this.schedulerDuration,
    required this.offDates,
    required this.verificationCode,
    required this.isBlocked,
    required this.banTimes,
    required this.beautyCenterMedia,
    required this.products,
    required this.address,
    required this.lat,
    required this.long,
    required this.isFavorite,
    required this.branchesName,
    required this.average,
  });
  late final int id;
  late final String name;
  late final String phone;
  late final String email;
  late final String image;
  late final String timeTo;
  late final String timeFrom;
  late final String deviceToken;
  late final List<String> offDay;
  late final String createdAt;
  late final String updatedAt;
  late final int schedulerDuration;
  late final List<String> offDates;
  late final int verificationCode;
  late final int isBlocked;
  late final int banTimes;
  late final List<BeautyCenterMedia> beautyCenterMedia;
  late final List<Products> products;
  late final String address;
  late final String lat;
  late final String long;
  late final bool isFavorite;
  late final List<BranchesName> branchesName;
  late final String average;

  Response.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    timeTo = json['time_to'];
    timeFrom = json['time_from'];
    deviceToken = json['device_token'];
    offDay = List.castFrom<dynamic, String>(json['off_day']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    schedulerDuration = json['scheduler_duration'];
    offDates = List.castFrom<dynamic, String>(json['offDates']);
    verificationCode = json['verification_code'];
    isBlocked = json['isBlocked'];
    banTimes = json['ban_times'];
    beautyCenterMedia = List.from(json['beautyCenterMedia']).map((e)=>BeautyCenterMedia.fromJson(e)).toList();
    products = List.from(json['products']).map((e)=>Products.fromJson(e)).toList();
    address = json['address'];
    lat = json['lat'];
    long = json['long'];
    isFavorite = json['isFavorite'];
    branchesName = List.from(json['branchesName']).map((e)=>BranchesName.fromJson(e)).toList();
    average = json['average'];
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
    _data['scheduler_duration'] = schedulerDuration;
    _data['offDates'] = offDates;
    _data['verification_code'] = verificationCode;
    _data['isBlocked'] = isBlocked;
    _data['ban_times'] = banTimes;
    _data['beautyCenterMedia'] = beautyCenterMedia.map((e)=>e.toJson()).toList();
    _data['products'] = products.map((e)=>e.toJson()).toList();
    _data['address'] = address;
    _data['lat'] = lat;
    _data['long'] = long;
    _data['isFavorite'] = isFavorite;
    _data['branchesName'] = branchesName.map((e)=>e.toJson()).toList();
    _data['average'] = average;
    return _data;
  }
}

class BeautyCenterMedia {
  BeautyCenterMedia({
    required this.id,
    required this.image,
  });
  late final int id;
  late final String image;

  BeautyCenterMedia.fromJson(Map<String, dynamic> json){
    id = json['id'];
    image = json['image']??'';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['image'] = image;
    return _data;
  }
}

class Products {
  Products({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });
  late final int id;
  late final String name;
  late final String image;
  late final int price;

  Products.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image'] = image;
    _data['price'] = price;
    return _data;
  }
}

class BranchesName {
  BranchesName({
    required this.id,
    required this.name,
    required this.address,
  });
  late final int id;
  late final String name;
  late final String address;

  BranchesName.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['address'] = address;
    return _data;
  }
}