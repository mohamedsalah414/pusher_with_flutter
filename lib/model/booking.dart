class GetBookings {
  GetBookings({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  GetBookings.fromJson(Map<String, dynamic> json){
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
    required this.beautyCenterName,
    required this.address,
    required this.date,
    required this.time,
    required this.employeeName,
    required this.servicesName,
    required this.price,
    required this.beautyCenterImage,
    required this.attendanceStatus,

  });
  late final int id;
  late final String beautyCenterName;
  late final String address;
  late final String date;
  late final String time;
  late final String employeeName;
  late final List<String> servicesName;
  late final int price;
  late final String beautyCenterImage;
  late final String attendanceStatus;


  Response.fromJson(Map<String, dynamic> json){
    id = json['id'];
    beautyCenterName = json['beauty_center_name'];
    address = json['address'];
    date = json['date'];
    time = json['time'];
    employeeName = json['employee_name'];
    servicesName = List.castFrom<dynamic, String>(json['services_name']);
    price = json['price'];
    beautyCenterImage = json['beauty_center_image']??'';
    attendanceStatus = json['attendance_status'];

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['beauty_center_name'] = beautyCenterName;
    _data['address'] = address;
    _data['date'] = date;
    _data['time'] = time;
    _data['employee_name'] = employeeName;
    _data['services_name'] = servicesName;
    _data['price'] = price;
    _data['beauty_center_image'] = beautyCenterImage;
    _data['attendance_status'] = attendanceStatus;

    return _data;
  }
}