class OfferModel {
  OfferModel({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  OfferModel.fromJson(Map<String, dynamic> json){
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
    required this.offers,
    required this.length,
  });
  late final List<Offers> offers;
  late final int length;

  Response.fromJson(Map<String, dynamic> json){
    offers = List.from(json['offers']).map((e)=>Offers.fromJson(e)).toList();
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['offers'] = offers.map((e)=>e.toJson()).toList();
    _data['length'] = length;
    return _data;
  }
}

class Offers {
  Offers({
    required this.id,
    required this.image,
    required this.price,
    required this.newPrice,
    required this.durationOffer,
    required this.name,
    required this.percent,
  });
  late final int id;
  late final String image;
  late final int price;
  late final String newPrice;
  late final String durationOffer;
  late final String name;
  late var percent;

  Offers.fromJson(Map<String, dynamic> json){
    id = json['id'];
    image = json['image'];
    price = json['price'];
    newPrice = json['new_price'];
    durationOffer = json['durationOffer'];
    name = json['name'];
    percent = json['percent'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['image'] = image;
    _data['price'] = price;
    _data['new_price'] = newPrice;
    _data['durationOffer'] = durationOffer;
    _data['name'] = name;
    _data['percent'] = percent;
    return _data;
  }
}