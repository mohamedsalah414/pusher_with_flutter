class Product {
  Product({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  Product.fromJson(Map<String, dynamic> json){
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
    required this.image,
    required this.price,
    required this.description,
    required this.beautyCenterId,
    required this.categoryId,
  });
  late final int id;
  late final String name;
  late final String image;
  late var price;
  late final String description;
  late final int beautyCenterId;
  late final int categoryId;

  Response.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    description = json['description'];
    beautyCenterId = json['beauty_center_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image'] = image;
    _data['price'] = price;
    _data['description'] = description;
    _data['beauty_center_id'] = beautyCenterId;
    _data['category_id'] = categoryId;
    return _data;
  }
}