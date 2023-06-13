class GetBookingDetails {
  GetBookingDetails({
    required this.status,
    required this.msg,
    required this.data,
  });
  late final bool status;
  late final String msg;
  late final Data data;

  GetBookingDetails.fromJson(Map<String, dynamic> json){
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
    required this.bookId,
    required this.date,
    required this.time,
    required this.employeeName,
    required this.beautyCenterName,
    required this.address,
    required this.isReviewed,
    required this.review,
  });
  late  var bookId;
  late final String date;
  late final String time;
  late final String employeeName;
  late final String beautyCenterName;
  late final String address;
  late  var isReviewed;
  late final List<Review> review;

  Response.fromJson(Map<String, dynamic> json){
    bookId = json['book_id'];
    date = json['date'];
    time = json['time'];
    employeeName = json['employee_name'];
    beautyCenterName = json['beauty_center_name'];
    address = json['address'];
    isReviewed = json['isReviewed'];
    review = List.from(json['Review']).map((e)=>Review.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['book_id'] = bookId;
    _data['date'] = date;
    _data['time'] = time;
    _data['employee_name'] = employeeName;
    _data['beauty_center_name'] = beautyCenterName;
    _data['address'] = address;
    _data['isReviewed'] = isReviewed;
    _data['Review'] = review.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Review {
  Review({
    required this.id,
    required this.rate,
    required this.feedback,
    required this.customerId,
    required this.beautyCenterId,
    required this.createdAt,
    required this.updatedAt,
  });
  late var id;
  late var rate;
  late final String feedback;
  late var customerId;
  late var beautyCenterId;
  late final String createdAt;
  late final String updatedAt;

  Review.fromJson(Map<String, dynamic> json){
    id = json['id'];
    rate = json['rate']??0;
    feedback = json['feedback']??'';
    customerId = json['customer_id'];
    beautyCenterId = json['beauty_center_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['rate'] = rate;
    _data['feedback'] = feedback;
    _data['customer_id'] = customerId;
    _data['beauty_center_id'] = beautyCenterId;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}