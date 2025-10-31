class PriceModel {
  PriceModel({
    bool? success,
    List<CartItems>? cartItems,
    dynamic cartCount,
    dynamic subtotal,
    String? subtotalFormatted,
    List<Fees>? fees,
    String? totalFeesFormatted,
    dynamic gstTotal,
    String? gstTotalFormatted,
    dynamic grandTotal,
    String? grandTotalFormatted,
    String? shippingMethodId,
    String? shippingMethodTitle,
    dynamic shippingTotal,
    String? shippingTotalFormatted,
  }) {
    _success = success;
    _cartItems = cartItems;
    _cartCount = cartCount;
    _subtotal = subtotal;
    _subtotalFormatted = subtotalFormatted;
    _fees = fees;
    _totalFeesFormatted = totalFeesFormatted;
    _gstTotal = gstTotal;
    _gstTotalFormatted = gstTotalFormatted;
    _grandTotal = grandTotal;
    _grandTotalFormatted = grandTotalFormatted;
    _shippingMethodId = shippingMethodId;
    _shippingMethodTitle = shippingMethodTitle;
    _shippingTotal = shippingTotal;
    _shippingTotalFormatted = shippingTotalFormatted;
  }

  PriceModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['cart_items'] != null) {
      _cartItems = [];
      json['cart_items'].forEach((v) {
        _cartItems?.add(CartItems.fromJson(v));
      });
    }
    _cartCount = json['cart_count'];
    _subtotal = json['subtotal'];
    _subtotalFormatted = json['subtotal_formatted'];
    if (json['fees'] != null) {
      _fees = [];
      json['fees'].forEach((v) {
        _fees?.add(Fees.fromJson(v));
      });
    }
    _totalFeesFormatted = json['total_fees_formatted'];
    _gstTotal = json['gst_total'];
    _gstTotalFormatted = json['gst_total_formatted'];
    _grandTotal = json['grand_total'];
    _grandTotalFormatted = json['grand_total_formatted'];
    _shippingMethodId = json['shipping_method_id'];
    _shippingMethodTitle = json['shipping_method_title'];
    _shippingTotal = json['shipping_total'];
    _shippingTotalFormatted = json['shipping_total_formatted'];
  }
  bool? _success;
  List<CartItems>? _cartItems;
  dynamic _cartCount;
  dynamic _subtotal;
  String? _subtotalFormatted;
  List<Fees>? _fees;
  String? _totalFeesFormatted;
  dynamic _gstTotal;
  String? _gstTotalFormatted;
  dynamic _grandTotal;
  String? _grandTotalFormatted;
  String? _shippingMethodId;
  String? _shippingMethodTitle;
  dynamic _shippingTotal;
  String? _shippingTotalFormatted;
  PriceModel copyWith({
    bool? success,
    List<CartItems>? cartItems,
    dynamic cartCount,
    dynamic subtotal,
    String? subtotalFormatted,
    List<Fees>? fees,
    String? totalFeesFormatted,
    dynamic gstTotal,
    String? gstTotalFormatted,
    dynamic grandTotal,
    String? grandTotalFormatted,
    String? shippingMethodId,
    String? shippingMethodTitle,
    dynamic shippingTotal,
    String? shippingTotalFormatted,
  }) => PriceModel(
    success: success ?? _success,
    cartItems: cartItems ?? _cartItems,
    cartCount: cartCount ?? _cartCount,
    subtotal: subtotal ?? _subtotal,
    subtotalFormatted: subtotalFormatted ?? _subtotalFormatted,
    fees: fees ?? _fees,
    totalFeesFormatted: totalFeesFormatted ?? _totalFeesFormatted,
    gstTotal: gstTotal ?? _gstTotal,
    gstTotalFormatted: gstTotalFormatted ?? _gstTotalFormatted,
    grandTotal: grandTotal ?? _grandTotal,
    grandTotalFormatted: grandTotalFormatted ?? _grandTotalFormatted,
    shippingMethodId: shippingMethodId ?? _shippingMethodId,
    shippingMethodTitle: shippingMethodTitle ?? _shippingMethodTitle,
    shippingTotal: shippingTotal ?? _shippingTotal,
    shippingTotalFormatted: shippingTotalFormatted ?? _shippingTotalFormatted,
  );
  bool? get success => _success;
  List<CartItems>? get cartItems => _cartItems;
  dynamic get cartCount => _cartCount;
  dynamic get subtotal => _subtotal;
  String? get subtotalFormatted => _subtotalFormatted;
  List<Fees>? get fees => _fees;
  String? get totalFeesFormatted => _totalFeesFormatted;
  dynamic get gstTotal => _gstTotal;
  String? get gstTotalFormatted => _gstTotalFormatted;
  dynamic get grandTotal => _grandTotal;
  String? get grandTotalFormatted => _grandTotalFormatted;
  String? get shippingMethodId => _shippingMethodId;
  String? get shippingMethodTitle => _shippingMethodTitle;
  dynamic get shippingTotal => _shippingTotal;
  String? get shippingTotalFormatted => _shippingTotalFormatted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_cartItems != null) {
      map['cart_items'] = _cartItems?.map((v) => v.toJson()).toList();
    }
    map['cart_count'] = _cartCount;
    map['subtotal'] = _subtotal;
    map['subtotal_formatted'] = _subtotalFormatted;
    if (_fees != null) {
      map['fees'] = _fees?.map((v) => v.toJson()).toList();
    }
    map['total_fees_formatted'] = _totalFeesFormatted;
    map['gst_total'] = _gstTotal;
    map['gst_total_formatted'] = _gstTotalFormatted;
    map['grand_total'] = _grandTotal;
    map['grand_total_formatted'] = _grandTotalFormatted;
    map['shipping_method_id'] = _shippingMethodId;
    map['shipping_method_title'] = _shippingMethodTitle;
    map['shipping_total'] = _shippingTotal;
    map['shipping_total_formatted'] = _shippingTotalFormatted;
    return map;
  }
}

class Fees {
  Fees({String? name, String? amount, String? shippingModel}) {
    _name = name;
    _amount = amount;
    _shippingModel = shippingModel;
  }

  Fees.fromJson(dynamic json) {
    _name = json['name'];
    _amount = json['amount'];
    _shippingModel = json['shipping_amount'];
  }
  String? _name;
  String? _amount;
  String? _shippingModel;

  Fees copyWith({String? name, String? amount, String? shippingModel}) => Fees(
    name: name ?? _name,
    amount: amount ?? _amount,
    shippingModel: shippingModel ?? _shippingModel,
  );
  String? get name => _name;
  String? get amount => _amount;
  String? get shippingModel => _shippingModel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['amount'] = _amount;
    map['shipping_amount'] = _shippingModel;
    return map;
  }
}

class CartItems {
  CartItems({
    dynamic productId,
    dynamic variationId,
    dynamic quantity,
    String? productName,
    String? currentPrice,
    dynamic lineSubtotal,
    String? productImage,
  }) {
    _productId = productId;
    _variationId = variationId;
    _quantity = quantity;
    _productName = productName;
    _currentPrice = currentPrice;
    _lineSubtotal = lineSubtotal;
    _productImage = productImage;
  }

  CartItems.fromJson(dynamic json) {
    _productId = json['product_id'];
    _variationId = json['variation_id'];
    _quantity = json['quantity'];
    _productName = json['product_name'];
    _currentPrice = json['current_price'];
    _lineSubtotal = json['line_subtotal'];
    _productImage = json['product_image'];
  }
  dynamic _productId;
  dynamic _variationId;
  dynamic _quantity;
  String? _productName;
  String? _currentPrice;
  dynamic _lineSubtotal;
  String? _productImage;
  CartItems copyWith({
    dynamic productId,
    dynamic variationId,
    dynamic quantity,
    String? productName,
    String? currentPrice,
    dynamic lineSubtotal,
    String? productImage,
  }) => CartItems(
    productId: productId ?? _productId,
    variationId: variationId ?? _variationId,
    quantity: quantity ?? _quantity,
    productName: productName ?? _productName,
    currentPrice: currentPrice ?? _currentPrice,
    lineSubtotal: lineSubtotal ?? _lineSubtotal,
    productImage: productImage ?? _productImage,
  );
  dynamic get productId => _productId;
  dynamic get variationId => _variationId;
  dynamic get quantity => _quantity;
  String? get productName => _productName;
  String? get currentPrice => _currentPrice;
  dynamic get lineSubtotal => _lineSubtotal;
  String? get productImage => _productImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = _productId;
    map['variation_id'] = _variationId;
    map['quantity'] = _quantity;
    map['product_name'] = _productName;
    map['current_price'] = _currentPrice;
    map['line_subtotal'] = _lineSubtotal;
    map['product_image'] = _productImage;
    return map;
  }
}
