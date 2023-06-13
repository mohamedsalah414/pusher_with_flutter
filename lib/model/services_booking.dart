class ResponseBookingService {
  ResponseBookingService({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
required this.serviceOrPackage,
  });
  late final int id;
  late final String name;
  late int price;
  late final String duration;
  late final String serviceOrPackage;


  ResponseBookingService.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    price = json['price'];
    duration = json['duration'];
    serviceOrPackage=json['serviceOrPackage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['price'] = price;
    _data['duration'] = duration;
    _data['serviceOrPackage'] = serviceOrPackage;
    return _data;
  }
}