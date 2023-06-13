class BranchesModel {
  BranchesModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  BranchesModel.fromJson(Map<String, dynamic> json){
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
    required this.timeFrom,
    required this.timeTo,
    required this.schedulerDuration,
    required this.offDay,
    required this.branches,
  });
  late final String timeFrom;
  late final String timeTo;
  late final int schedulerDuration;
  late final String offDay;
  late final List<Branches> branches;

  Response.fromJson(Map<String, dynamic> json){
    timeFrom = json['time_from'];
    timeTo = json['time_to'];
    schedulerDuration = json['scheduler_duration'];
    offDay = json['off_day'];
    branches = List.from(json['branches']).map((e)=>Branches.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time_from'] = timeFrom;
    _data['time_to'] = timeTo;
    _data['scheduler_duration'] = schedulerDuration;
    _data['off_day'] = offDay;
    _data['branches'] = branches.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Branches {
  Branches({
    required this.id,
    required this.name,
    required this.beautyCenterId,
    required this.location,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final int beautyCenterId;
  late final String location;
  late final String address;
  late final String createdAt;
  late final String updatedAt;

  Branches.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    beautyCenterId = json['beauty_center_id'];
    location = json['location'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['beauty_center_id'] = beautyCenterId;
    _data['location'] = location;
    _data['address'] = address;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}