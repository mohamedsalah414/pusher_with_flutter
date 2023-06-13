class HomePageModel {
  HomePageModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  HomePageModel.fromJson(Map<String, dynamic> json){
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
    required this.topRated,
    required this.bestOffers,
  });
  late final List<TopRated> topRated;
  late final List<BestOffers> bestOffers;

  Response.fromJson(Map<String, dynamic> json){
    topRated = List.from(json['topRated']).map((e)=>TopRated.fromJson(e)).toList();
    bestOffers = List.from(json['bestOffers']).map((e)=>BestOffers.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['topRated'] = topRated.map((e)=>e.toJson()).toList();
    _data['bestOffers'] = bestOffers.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class TopRated {
  TopRated({
    required this.id,
    required this.name,
    required this.image,
    required this.rate,
    required this.address,
  });
  late final int id;
  late final String name;
  late final String image;
  late final String rate;
  late final String address;

  TopRated.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image']??'';
    rate = json['rate'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image'] = image;
    _data['rate'] = rate;
    _data['address'] = address;
    return _data;
  }
}

class BestOffers {
  BestOffers({
    required this.id,
    required this.name,
    required this.image,
    required this.percent,
  });
  late final int id;
  late final String name;
  late final String image;
  late final double percent;

  BestOffers.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
    percent = json['percent'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image'] = image;
    _data['percent'] = percent;
    return _data;
  }
}