class ShippingMethodsModel {
  ShippingMethodsModel({
    bool? success,
    int? cartItemCount,
    List<ShippingMethods>? shippingMethods,
  }) {
    _success = success;
    _cartItemCount = cartItemCount;
    _shippingMethods = shippingMethods;
  }

  ShippingMethodsModel.fromJson(dynamic json) {
    _success = json['success'];
    _cartItemCount = json['cart_item_count'];
    if (json['shipping_methods'] != null) {
      _shippingMethods = [];
      json['shipping_methods'].forEach((v) {
        _shippingMethods?.add(ShippingMethods.fromJson(v));
      });
    }
  }
  bool? _success;
  int? _cartItemCount;
  List<ShippingMethods>? _shippingMethods;
  ShippingMethodsModel copyWith({
    bool? success,
    int? cartItemCount,
    List<ShippingMethods>? shippingMethods,
  }) => ShippingMethodsModel(
    success: success ?? _success,
    cartItemCount: cartItemCount ?? _cartItemCount,
    shippingMethods: shippingMethods ?? _shippingMethods,
  );
  bool? get success => _success;
  int? get cartItemCount => _cartItemCount;
  List<ShippingMethods>? get shippingMethods => _shippingMethods;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['cart_item_count'] = _cartItemCount;
    if (_shippingMethods != null) {
      map['shipping_methods'] =
          _shippingMethods?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ShippingMethods {
  ShippingMethods({
    dynamic id,
    dynamic label,
    dynamic costRaw,
    dynamic cost,
    int? package,
  }) {
    _id = id;
    _label = label;
    _costRaw = costRaw;
    _cost = cost;
    _package = package;
  }

  ShippingMethods.fromJson(dynamic json) {
    _id = json['id'];
    _label = json['label'];
    _costRaw = json['cost_raw'];
    _cost = json['cost'];
    _package = json['package'];
  }
  dynamic _id;
  dynamic _label;
  dynamic _costRaw;
  dynamic _cost;
  int? _package;
  ShippingMethods copyWith({
    dynamic id,
    dynamic label,
    dynamic costRaw,
    dynamic cost,
    int? package,
  }) => ShippingMethods(
    id: id ?? _id,
    label: label ?? _label,
    costRaw: costRaw ?? _costRaw,
    cost: cost ?? _cost,
    package: package ?? _package,
  );
  dynamic get id => _id;
  dynamic get label => _label;
  dynamic get costRaw => _costRaw;
  dynamic get cost => _cost;
  int? get package => _package;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['label'] = _label;
    map['cost_raw'] = _costRaw;
    map['cost'] = _cost;
    map['package'] = _package;
    return map;
  }
}
