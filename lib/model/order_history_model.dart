class OrderHistoryModel {
  OrderHistoryModel({bool? success, List<Orders>? orders}) {
    _success = success;
    _orders = orders;
  }

  OrderHistoryModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['orders'] != null) {
      _orders = [];
      json['orders'].forEach((v) {
        _orders?.add(Orders.fromJson(v));
      });
    }
  }
  bool? _success;
  List<Orders>? _orders;
  OrderHistoryModel copyWith({bool? success, List<Orders>? orders}) =>
      OrderHistoryModel(
        success: success ?? _success,
        orders: orders ?? _orders,
      );
  bool? get success => _success;
  List<Orders>? get orders => _orders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_orders != null) {
      map['orders'] = _orders?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Orders {
  Orders({
    dynamic orderId,
    dynamic orderNumber,
    Billing? billing,
    Shipping? shipping,
    String? orderDate,
    String? status,
    dynamic total,
    dynamic subTotal,
    dynamic discount,
    dynamic gst,
    List<Items>? items,
  }) {
    _orderId = orderId;
    _orderNumber = orderNumber;
    _billing = billing;
    _shipping = shipping;
    _orderDate = orderDate;
    _status = status;
    _total = total;
    _subTotal = subTotal;
    _discount = discount;
    _gst = gst;
    _items = items;
  }

  Orders.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _orderNumber = json['order_number'];
    _billing =
        json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    _shipping =
        json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    _orderDate = json['order_date'];
    _status = json['status'];
    _total = json['total'];
    _subTotal = json['subTotal'];
    _discount = json['discount'];
    _gst = json['gst'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
  }
  dynamic _orderId;
  dynamic _orderNumber;
  Billing? _billing;
  Shipping? _shipping;
  String? _orderDate;
  String? _status;
  dynamic _total;
  dynamic _subTotal;
  dynamic _discount;
  dynamic _gst;
  List<Items>? _items;
  Orders copyWith({
    dynamic orderId,
    dynamic orderNumber,
    Billing? billing,
    Shipping? shipping,
    String? orderDate,
    String? status,
    dynamic total,
    dynamic gst,
    dynamic discount,
    dynamic subTotal,
    List<Items>? items,
  }) => Orders(
    orderId: orderId ?? _orderId,
    orderNumber: orderNumber ?? _orderNumber,
    billing: billing ?? _billing,
    shipping: shipping ?? _shipping,
    orderDate: orderDate ?? _orderDate,
    status: status ?? _status,
    total: total ?? _total,
    gst: gst ?? _gst,
    discount: discount ?? _discount,
    subTotal: subTotal ?? _subTotal,
    items: items ?? _items,
  );
  dynamic get orderId => _orderId;
  dynamic get orderNumber => _orderNumber;
  Billing? get billing => _billing;
  Shipping? get shipping => _shipping;
  String? get orderDate => _orderDate;
  String? get status => _status;
  dynamic get total => _total;
  dynamic get gst => _gst;
  dynamic get discount => _discount;
  dynamic get subTotal => _subTotal;
  List<Items>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['order_number'] = _orderNumber;
    if (_billing != null) {
      map['billing'] = _billing?.toJson();
    }
    if (_shipping != null) {
      map['shipping'] = _shipping?.toJson();
    }
    map['order_date'] = _orderDate;
    map['status'] = _status;
    map['total'] = _total;
    map['gst'] = _gst;
    map['discount'] = _discount;
    map['subTotal'] = _subTotal;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Items {
  Items({
    dynamic productId,
    String? productName,
    dynamic quantity,
    dynamic price,
    String? image,
  }) {
    _productId = productId;
    _productName = productName;
    _quantity = quantity;
    _price = price;
    _image = image;
  }

  Items.fromJson(dynamic json) {
    _productId = json['product_id'];
    _productName = json['product_name'];
    _quantity = json['quantity'];
    _price = json['price'];
    _image = json['image'];
  }
  dynamic _productId;
  String? _productName;
  dynamic _quantity;
  dynamic _price;
  String? _image;
  Items copyWith({
    dynamic productId,
    String? productName,
    dynamic quantity,
    dynamic price,
    String? image,
  }) => Items(
    productId: productId ?? _productId,
    productName: productName ?? _productName,
    quantity: quantity ?? _quantity,
    price: price ?? _price,
    image: image ?? _image,
  );
  dynamic get productId => _productId;
  String? get productName => _productName;
  dynamic get quantity => _quantity;
  dynamic get price => _price;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = _productId;
    map['product_name'] = _productName;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['image'] = _image;
    return map;
  }
}

class Shipping {
  Shipping({
    String? firstName,
    String? lastName,
    String? company,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? postcode,
    String? country,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _company = company;
    _address1 = address1;
    _address2 = address2;
    _city = city;
    _state = state;
    _postcode = postcode;
    _country = country;
  }

  Shipping.fromJson(dynamic json) {
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _company = json['company'];
    _address1 = json['address_1'];
    _address2 = json['address_2'];
    _city = json['city'];
    _state = json['state'];
    _postcode = json['postcode'];
    _country = json['country'];
  }
  String? _firstName;
  String? _lastName;
  String? _company;
  String? _address1;
  String? _address2;
  String? _city;
  String? _state;
  String? _postcode;
  String? _country;
  Shipping copyWith({
    String? firstName,
    String? lastName,
    String? company,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? postcode,
    String? country,
  }) => Shipping(
    firstName: firstName ?? _firstName,
    lastName: lastName ?? _lastName,
    company: company ?? _company,
    address1: address1 ?? _address1,
    address2: address2 ?? _address2,
    city: city ?? _city,
    state: state ?? _state,
    postcode: postcode ?? _postcode,
    country: country ?? _country,
  );
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get company => _company;
  String? get address1 => _address1;
  String? get address2 => _address2;
  String? get city => _city;
  String? get state => _state;
  String? get postcode => _postcode;
  String? get country => _country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['company'] = _company;
    map['address_1'] = _address1;
    map['address_2'] = _address2;
    map['city'] = _city;
    map['state'] = _state;
    map['postcode'] = _postcode;
    map['country'] = _country;
    return map;
  }
}

class Billing {
  Billing({
    String? firstName,
    String? lastName,
    String? company,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? postcode,
    String? country,
    String? email,
    String? phone,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _company = company;
    _address1 = address1;
    _address2 = address2;
    _city = city;
    _state = state;
    _postcode = postcode;
    _country = country;
    _email = email;
    _phone = phone;
  }

  Billing.fromJson(dynamic json) {
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _company = json['company'];
    _address1 = json['address_1'];
    _address2 = json['address_2'];
    _city = json['city'];
    _state = json['state'];
    _postcode = json['postcode'];
    _country = json['country'];
    _email = json['email'];
    _phone = json['phone'];
  }
  String? _firstName;
  String? _lastName;
  String? _company;
  String? _address1;
  String? _address2;
  String? _city;
  String? _state;
  String? _postcode;
  String? _country;
  String? _email;
  String? _phone;
  Billing copyWith({
    String? firstName,
    String? lastName,
    String? company,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? postcode,
    String? country,
    String? email,
    String? phone,
  }) => Billing(
    firstName: firstName ?? _firstName,
    lastName: lastName ?? _lastName,
    company: company ?? _company,
    address1: address1 ?? _address1,
    address2: address2 ?? _address2,
    city: city ?? _city,
    state: state ?? _state,
    postcode: postcode ?? _postcode,
    country: country ?? _country,
    email: email ?? _email,
    phone: phone ?? _phone,
  );
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get company => _company;
  String? get address1 => _address1;
  String? get address2 => _address2;
  String? get city => _city;
  String? get state => _state;
  String? get postcode => _postcode;
  String? get country => _country;
  String? get email => _email;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['company'] = _company;
    map['address_1'] = _address1;
    map['address_2'] = _address2;
    map['city'] = _city;
    map['state'] = _state;
    map['postcode'] = _postcode;
    map['country'] = _country;
    map['email'] = _email;
    map['phone'] = _phone;
    return map;
  }
}
