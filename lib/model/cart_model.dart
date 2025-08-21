class CartModel {
  CartModel({
    bool? success,
    List<CartItems>? cartItems,
    dynamic cartCount,
    dynamic cartTotal,
    dynamic cartTotalFormatted,
    dynamic discountTotal,
    dynamic discountTotalFormatted,
    dynamic gstTotal,
    dynamic gstTotalFormatted,
    dynamic grandTotal,
    dynamic grandTotalFormatted,
    List<Coupons>? coupons,
  }) {
    _success = success;
    _cartItems = cartItems;
    _cartCount = cartCount;
    _cartTotal = cartTotal;
    _cartTotalFormatted = cartTotalFormatted;
    _discountTotal = discountTotal;
    _discountTotalFormatted = discountTotalFormatted;
    _gstTotal = gstTotal;
    _gstTotalFormatted = gstTotalFormatted;
    _grandTotal = grandTotal;
    _grandTotalFormatted = grandTotalFormatted;
    _coupons = coupons;
  }

  CartModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['cart_items'] != null) {
      _cartItems = [];
      json['cart_items'].forEach((v) {
        _cartItems?.add(CartItems.fromJson(v));
      });
    }
    _cartCount = json['cart_count'];
    _cartTotal = json['cart_total'];
    _cartTotalFormatted = json['cart_total_formatted'];
    _discountTotal = json['discount_total'];
    _discountTotalFormatted = json['discount_total_formatted'];
    _gstTotal = json['gst_total'];
    _gstTotalFormatted = json['gst_total_formatted'];
    _grandTotal = json['grand_total'];
    _grandTotalFormatted = json['grand_total_formatted'];
    if (json['coupons'] != null) {
      _coupons = [];
      json['coupons'].forEach((v) {
        _coupons?.add(Coupons.fromJson(v));
      });
    }
  }
  bool? _success;
  List<CartItems>? _cartItems;
  dynamic _cartCount;
  dynamic _cartTotal;
  dynamic _cartTotalFormatted;
  dynamic _discountTotal;
  dynamic _discountTotalFormatted;
  dynamic _gstTotal;
  dynamic _gstTotalFormatted;
  dynamic _grandTotal;
  dynamic _grandTotalFormatted;
  List<Coupons>? _coupons;
  CartModel copyWith({
    bool? success,
    List<CartItems>? cartItems,
    dynamic cartCount,
    dynamic cartTotal,
    dynamic cartTotalFormatted,
    dynamic discountTotal,
    dynamic discountTotalFormatted,
    dynamic gstTotal,
    dynamic gstTotalFormatted,
    dynamic grandTotal,
    dynamic grandTotalFormatted,
    List<Coupons>? coupons,
  }) => CartModel(
    success: success ?? _success,
    cartItems: cartItems ?? _cartItems,
    cartCount: cartCount ?? _cartCount,
    cartTotal: cartTotal ?? _cartTotal,
    cartTotalFormatted: cartTotalFormatted ?? _cartTotalFormatted,
    discountTotal: discountTotal ?? _discountTotal,
    discountTotalFormatted: discountTotalFormatted ?? _discountTotalFormatted,
    gstTotal: gstTotal ?? _gstTotal,
    gstTotalFormatted: gstTotalFormatted ?? _gstTotalFormatted,
    grandTotal: grandTotal ?? _grandTotal,
    grandTotalFormatted: grandTotalFormatted ?? _grandTotalFormatted,
    coupons: coupons ?? _coupons,
  );
  bool? get success => _success;
  List<CartItems>? get cartItems => _cartItems;
  dynamic get cartCount => _cartCount;
  dynamic get cartTotal => _cartTotal;
  dynamic get cartTotalFormatted => _cartTotalFormatted;
  dynamic get discountTotal => _discountTotal;
  dynamic get discountTotalFormatted => _discountTotalFormatted;
  dynamic get gstTotal => _gstTotal;
  dynamic get gstTotalFormatted => _gstTotalFormatted;
  dynamic get grandTotal => _grandTotal;
  dynamic get grandTotalFormatted => _grandTotalFormatted;
  List<Coupons>? get coupons => _coupons;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_cartItems != null) {
      map['cart_items'] = _cartItems?.map((v) => v.toJson()).toList();
    }
    map['cart_count'] = _cartCount;
    map['cart_total'] = _cartTotal;
    map['cart_total_formatted'] = _cartTotalFormatted;
    map['discount_total'] = _discountTotal;
    map['discount_total_formatted'] = _discountTotalFormatted;
    map['gst_total'] = _gstTotal;
    map['gst_total_formatted'] = _gstTotalFormatted;
    map['grand_total'] = _grandTotal;
    map['grand_total_formatted'] = _grandTotalFormatted;
    if (_coupons != null) {
      map['coupons'] = _coupons?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Coupons {
  Coupons({
    dynamic code,
    dynamic type,
    dynamic amount,
    dynamic calculatedDiscount,
  }) {
    _code = code;
    _type = type;
    _amount = amount;
    _calculatedDiscount = calculatedDiscount;
  }

  Coupons.fromJson(dynamic json) {
    _code = json['code'];
    _type = json['type'];
    _amount = json['amount'];
    _calculatedDiscount = json['calculated_discount'];
  }
  dynamic _code;
  dynamic _type;
  dynamic _amount;
  dynamic _calculatedDiscount;
  Coupons copyWith({
    dynamic code,
    dynamic type,
    dynamic amount,
    dynamic calculatedDiscount,
  }) => Coupons(
    code: code ?? _code,
    type: type ?? _type,
    amount: amount ?? _amount,
    calculatedDiscount: calculatedDiscount ?? _calculatedDiscount,
  );
  dynamic get code => _code;
  dynamic get type => _type;
  dynamic get amount => _amount;
  dynamic get calculatedDiscount => _calculatedDiscount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['type'] = _type;
    map['amount'] = _amount;
    map['calculated_discount'] = _calculatedDiscount;
    return map;
  }
}

class CartItems {
  CartItems({
    dynamic cartItemKey,
    dynamic productId,
    dynamic variationId,
    dynamic productName,
    dynamic quantity,
    dynamic regularPrice,
    dynamic salePrice,
    dynamic currentPrice,
    dynamic currentPriceFormatted,
    dynamic lineSubtotal,
    dynamic lineSubtotalFormatted,
    dynamic productImage,
  }) {
    _cartItemKey = cartItemKey;
    _productId = productId;
    _variationId = variationId;
    _productName = productName;
    _quantity = quantity;
    _regularPrice = regularPrice;
    _salePrice = salePrice;
    _currentPrice = currentPrice;
    _currentPriceFormatted = currentPriceFormatted;
    _lineSubtotal = lineSubtotal;
    _lineSubtotalFormatted = lineSubtotalFormatted;
    _productImage = productImage;
  }

  CartItems.fromJson(dynamic json) {
    _cartItemKey = json['cart_item_key'];
    _productId = json['product_id'];
    _variationId = json['variation_id'];
    _productName = json['product_name'];
    _quantity = json['quantity'];
    _regularPrice = json['regular_price'];
    _salePrice = json['sale_price'];
    _currentPrice = json['current_price'];
    _currentPriceFormatted = json['current_price_formatted'];
    _lineSubtotal = json['line_subtotal'];
    _lineSubtotalFormatted = json['line_subtotal_formatted'];
    _productImage = json['product_image'];
  }
  dynamic _cartItemKey;
  dynamic _productId;
  dynamic _variationId;
  dynamic _productName;
  dynamic _quantity;
  dynamic _regularPrice;
  dynamic _salePrice;
  dynamic _currentPrice;
  dynamic _currentPriceFormatted;
  dynamic _lineSubtotal;
  dynamic _lineSubtotalFormatted;
  dynamic _productImage;
  CartItems copyWith({
    dynamic cartItemKey,
    dynamic productId,
    dynamic variationId,
    dynamic productName,
    dynamic quantity,
    dynamic regularPrice,
    dynamic salePrice,
    dynamic currentPrice,
    dynamic currentPriceFormatted,
    dynamic lineSubtotal,
    dynamic lineSubtotalFormatted,
    dynamic productImage,
  }) => CartItems(
    cartItemKey: cartItemKey ?? _cartItemKey,
    productId: productId ?? _productId,
    variationId: variationId ?? _variationId,
    productName: productName ?? _productName,
    quantity: quantity ?? _quantity,
    regularPrice: regularPrice ?? _regularPrice,
    salePrice: salePrice ?? _salePrice,
    currentPrice: currentPrice ?? _currentPrice,
    currentPriceFormatted: currentPriceFormatted ?? _currentPriceFormatted,
    lineSubtotal: lineSubtotal ?? _lineSubtotal,
    lineSubtotalFormatted: lineSubtotalFormatted ?? _lineSubtotalFormatted,
    productImage: productImage ?? _productImage,
  );
  dynamic get cartItemKey => _cartItemKey;
  dynamic get productId => _productId;
  dynamic get variationId => _variationId;
  dynamic get productName => _productName;
  dynamic get quantity => _quantity;
  dynamic get regularPrice => _regularPrice;
  dynamic get salePrice => _salePrice;
  dynamic get currentPrice => _currentPrice;
  dynamic get currentPriceFormatted => _currentPriceFormatted;
  dynamic get lineSubtotal => _lineSubtotal;
  dynamic get lineSubtotalFormatted => _lineSubtotalFormatted;
  dynamic get productImage => _productImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cart_item_key'] = _cartItemKey;
    map['product_id'] = _productId;
    map['variation_id'] = _variationId;
    map['product_name'] = _productName;
    map['quantity'] = _quantity;
    map['regular_price'] = _regularPrice;
    map['sale_price'] = _salePrice;
    map['current_price'] = _currentPrice;
    map['current_price_formatted'] = _currentPriceFormatted;
    map['line_subtotal'] = _lineSubtotal;
    map['line_subtotal_formatted'] = _lineSubtotalFormatted;
    map['product_image'] = _productImage;
    return map;
  }
}
