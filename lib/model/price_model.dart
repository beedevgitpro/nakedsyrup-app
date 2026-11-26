class PriceModel {
  PriceModel({
    dynamic success,
    List<CartItems>? cartItems,
    dynamic cartCount,
    dynamic subtotal,
    dynamic discountTotal,
    dynamic subtotalFormatted,
    List<Fees>? fees,
    dynamic totalFeesFormatted,
    dynamic gstTotal,
    dynamic gstTotalFormatted,
    dynamic grandTotal,
    dynamic grandTotalFormatted,
    dynamic shippingMethodId,
    dynamic hasTaxableProducts,
    dynamic taxStatus,
    dynamic showGst,
    dynamic shippingMethodTitle,
    dynamic shippingTotal,
    dynamic shippingTotalFormatted,
  }) {
    _success = success;
    _cartItems = cartItems;
    _cartCount = cartCount;
    _subtotal = subtotal;
    _discountTotal = discountTotal;
    _subtotalFormatted = subtotalFormatted;
    _fees = fees;
    _hasTaxableProducts = hasTaxableProducts;
    _taxStatus = taxStatus;
    _showGst = showGst;
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
    _discountTotal = json['discount_total'];
    _subtotal = json['subtotal'];
    _hasTaxableProducts = json['has_taxable_products'];
    _taxStatus = json['tax_status'];
    _showGst = json['show_gst'];
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
  dynamic _success;
  List<CartItems>? _cartItems;
  dynamic _cartCount;
  dynamic _discountTotal;
  dynamic _subtotal;
  dynamic _subtotalFormatted;
  List<Fees>? _fees;
  dynamic _totalFeesFormatted;
  dynamic _hasTaxableProducts;
      dynamic _taxStatus;
  dynamic _showGst;
  dynamic _gstTotal;
  dynamic _gstTotalFormatted;
  dynamic _grandTotal;
  dynamic _grandTotalFormatted;
  dynamic _shippingMethodId;
  dynamic _shippingMethodTitle;
  dynamic _shippingTotal;
  dynamic _shippingTotalFormatted;
  PriceModel copyWith({
    dynamic success,
    List<CartItems>? cartItems,
    dynamic cartCount,
    dynamic subtotal,
    dynamic discountTotal,
    dynamic subtotalFormatted,
    List<Fees>? fees,
    dynamic totalFeesFormatted,
    dynamic hasTaxableProducts,
    dynamic taxStatus,
    dynamic showGst,
    dynamic gstTotal,
    dynamic gstTotalFormatted,
    dynamic grandTotal,
    dynamic grandTotalFormatted,
    dynamic shippingMethodId,
    dynamic shippingMethodTitle,
    dynamic shippingTotal,
    dynamic shippingTotalFormatted,
  }) => PriceModel(
    success: success ?? _success,
    cartItems: cartItems ?? _cartItems,
    cartCount: cartCount ?? _cartCount,
    subtotal: subtotal ?? _subtotal,
    discountTotal: discountTotal ?? _discountTotal,
    subtotalFormatted: subtotalFormatted ?? _subtotalFormatted,
    fees: fees ?? _fees,
    totalFeesFormatted: totalFeesFormatted ?? _totalFeesFormatted,
    gstTotal: gstTotal ?? _gstTotal,
    hasTaxableProducts: hasTaxableProducts ?? _hasTaxableProducts,
    taxStatus: taxStatus ?? _taxStatus,
    showGst: showGst ?? _showGst,
    gstTotalFormatted: gstTotalFormatted ?? _gstTotalFormatted,
    grandTotal: grandTotal ?? _grandTotal,
    grandTotalFormatted: grandTotalFormatted ?? _grandTotalFormatted,
    shippingMethodId: shippingMethodId ?? _shippingMethodId,
    shippingMethodTitle: shippingMethodTitle ?? _shippingMethodTitle,
    shippingTotal: shippingTotal ?? _shippingTotal,
    shippingTotalFormatted: shippingTotalFormatted ?? _shippingTotalFormatted,
  );
  dynamic get success => _success;
  List<CartItems>? get cartItems => _cartItems;
  dynamic get cartCount => _cartCount;
  dynamic get discountTotal => _discountTotal;
  dynamic get subtotal => _subtotal;
  dynamic get subtotalFormatted => _subtotalFormatted;
  List<Fees>? get fees => _fees;
  dynamic get totalFeesFormatted => _totalFeesFormatted;
  dynamic get gstTotal => _gstTotal;
  dynamic get gstTotalFormatted => _gstTotalFormatted;
  dynamic get grandTotal => _grandTotal;
  dynamic get hasTaxableProducts => _hasTaxableProducts;
  dynamic get taxStatus => _taxStatus;
  dynamic get showGst => _showGst;
  dynamic get grandTotalFormatted => _grandTotalFormatted;
  dynamic get shippingMethodId => _shippingMethodId;
  dynamic get shippingMethodTitle => _shippingMethodTitle;
  dynamic get shippingTotal => _shippingTotal;
  dynamic get shippingTotalFormatted => _shippingTotalFormatted;

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
    map['has_taxable_products'] = _hasTaxableProducts;
    map['tax_status'] = _taxStatus;
    map['show_gst'] = _showGst;
    map['discount_total'] = _discountTotal;
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
  Fees({dynamic name, dynamic amount, dynamic shippingModel}) {
    _name = name;
    _amount = amount;
    _shippingModel = shippingModel;
  }

  Fees.fromJson(dynamic json) {
    _name = json['name'];
    _amount = json['amount'];
    _shippingModel = json['shipping_amount'];
  }
  dynamic _name;
  dynamic _amount;
  dynamic _shippingModel;

  Fees copyWith({dynamic name, dynamic amount, dynamic shippingModel}) => Fees(
    name: name ?? _name,
    amount: amount ?? _amount,
    shippingModel: shippingModel ?? _shippingModel,
  );
  dynamic get name => _name;
  dynamic get amount => _amount;
  dynamic get shippingModel => _shippingModel;

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
    dynamic productName,
    dynamic currentPrice,
    dynamic lineSubtotal,
    dynamic productImage,
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
  dynamic _productName;
  dynamic _currentPrice;
  dynamic _lineSubtotal;
  dynamic _productImage;
  CartItems copyWith({
    dynamic productId,
    dynamic variationId,
    dynamic quantity,
    dynamic productName,
    dynamic currentPrice,
    dynamic lineSubtotal,
    dynamic productImage,
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
  dynamic get productName => _productName;
  dynamic get currentPrice => _currentPrice;
  dynamic get lineSubtotal => _lineSubtotal;
  dynamic get productImage => _productImage;

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
