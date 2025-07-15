class CartModel {
  CartModel({
    bool? success,
    List<CartItems>? cartItems,
    dynamic cartTotal,
    dynamic gstTotal,
    dynamic grantTotal,
    dynamic cartCount,
  }) {
    _success = success;
    _cartItems = cartItems;
    _cartTotal = cartTotal;
    _gstTotal = gstTotal;
    _grantTotal = grantTotal;
    _cartCount = cartCount;
  }

  CartModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['cart_items'] != null) {
      _cartItems = [];
      json['cart_items'].forEach((v) {
        _cartItems?.add(CartItems.fromJson(v));
      });
    }
    _cartTotal = json['cart_total'];
    _cartCount = json['cart_count'];
    _gstTotal = json['gst_total'];
    _grantTotal = json['grand_total'];
  }
  bool? _success;
  List<CartItems>? _cartItems;
  dynamic _cartTotal;
  dynamic _cartCount;
  dynamic _gstTotal;
  dynamic _grantTotal;
  CartModel copyWith({
    bool? success,
    List<CartItems>? cartItems,
    dynamic cartTotal,
    dynamic gstTotal,
    dynamic grantTotal,
    dynamic cartCount,
  }) => CartModel(
    success: success ?? _success,
    cartItems: cartItems ?? _cartItems,
    cartTotal: cartTotal ?? _cartTotal,
    gstTotal: gstTotal ?? _gstTotal,
    grantTotal: grantTotal ?? _grantTotal,
    cartCount: cartCount ?? _cartCount,
  );
  bool? get success => _success;
  List<CartItems>? get cartItems => _cartItems;
  dynamic get cartTotal => _cartTotal;
  dynamic get cartCount => _cartCount;
  dynamic get gstTotal => _gstTotal;
  dynamic get grantTotal => _grantTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_cartItems != null) {
      map['cart_items'] = _cartItems?.map((v) => v.toJson()).toList();
    }
    map['cart_total'] = _cartTotal;
    map['gst_total'] = _gstTotal;
    map['grand_total'] = _grantTotal;
    map['cart_count'] = _cartCount;
    return map;
  }
}

class CartItems {
  CartItems({
    dynamic productId,
    dynamic productName,
    dynamic quantity,
    dynamic price,
    dynamic subtotal,
    dynamic total,
    dynamic productImage,
    dynamic variationId,
  }) {
    _productId = productId;
    _productName = productName;
    _quantity = quantity;
    _price = price;
    _subtotal = subtotal;
    _total = total;
    _productImage = productImage;
    _variationId = variationId;
  }

  CartItems.fromJson(dynamic json) {
    _productId = json['product_id'];
    _productName = json['product_name'];
    _quantity = json['quantity'];
    _price = json['price'];
    _subtotal = json['subtotal'];
    _total = json['total'];
    _productImage = json['product_image'];
    _variationId = json['variation_id'];
  }
  dynamic _productId;
  dynamic _productName;
  dynamic _quantity;
  dynamic _price;
  dynamic _subtotal;
  dynamic _total;
  dynamic _productImage;
  dynamic _variationId;
  CartItems copyWith({
    dynamic productId,
    dynamic productName,
    dynamic quantity,
    dynamic price,
    dynamic subtotal,
    dynamic total,
    dynamic productImage,
    dynamic variationId,
  }) => CartItems(
    productId: productId ?? _productId,
    productName: productName ?? _productName,
    quantity: quantity ?? _quantity,
    price: price ?? _price,
    subtotal: subtotal ?? _subtotal,
    total: total ?? _total,
    productImage: productImage ?? _productImage,
    variationId: variationId ?? _variationId,
  );
  dynamic get productId => _productId;
  dynamic get productName => _productName;
  dynamic get quantity => _quantity;
  dynamic get price => _price;
  dynamic get subtotal => _subtotal;
  dynamic get total => _total;
  dynamic get productImage => _productImage;
  dynamic get variationId => _variationId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = _productId;
    map['product_name'] = _productName;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['subtotal'] = _subtotal;
    map['total'] = _total;
    map['product_image'] = _productImage;
    map['variation_id'] = _variationId;
    return map;
  }
}
