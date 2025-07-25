import 'package:get/get.dart';

class ProductModel {
  ProductModel({bool? success, List<Products>? products}) {
    _success = success;
    _products = products;
  }

  ProductModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products?.add(Products.fromJson(v));
      });
    }
  }
  bool? _success;
  List<Products>? _products;
  ProductModel copyWith({bool? success, List<Products>? products}) =>
      ProductModel(
        success: success ?? _success,
        products: products ?? _products,
      );
  bool? get success => _success;
  List<Products>? get products => _products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_products != null) {
      map['products'] = _products?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Products {
  Products({
    int? id,
    RxInt? qty,
    String? sku,
    String? name,
    String? price,
    String? regularPrice,
    String? salePrice,
    String? stockStatus,
    String? image,
    List<String>? gallery,
    String? shortDescription,
    String? recipes,
    String? description,
    List<Variations>? variations,
  }) {
    _id = id;
    _sku = sku;
    _qty = qty;
    _name = name;
    _price = price;
    _regularPrice = regularPrice;
    _salePrice = salePrice;
    _stockStatus = stockStatus;
    _image = image;
    _gallery = gallery;
    _shortDescription = shortDescription;
    _recipes = recipes;
    _description = description;
    _variations = variations;
  }

  Products.fromJson(dynamic json) {
    _id = json['id'];
    _sku = json['sku'];
    _name = json['name'];
    _price = json['price'];
    _regularPrice = json['regular_price'];
    _salePrice = json['sale_price'];
    _stockStatus = json['stock_status'];
    _image = json['image'];
    _gallery = json['gallery'] != null ? json['gallery'].cast<String>() : [];
    _shortDescription = json['short_description'];
    _recipes = json['recipes'];
    _description = json['description'];
    if (json['variations'] != null) {
      _variations = [];
      json['variations'].forEach((v) {
        _variations?.add(Variations.fromJson(v));
      });
    }
  }
  int? _id;
  RxInt? _qty = 1.obs;
  String? _sku;
  String? _name;
  String? _price;
  String? _regularPrice;
  String? _salePrice;
  String? _stockStatus;
  String? _image;
  List<String>? _gallery;
  String? _recipes;
  String? _shortDescription;
  String? _description;
  List<Variations>? _variations;
  Products copyWith({
    int? id,
    String? sku,
    String? name,
    String? price,
    String? regularPrice,
    String? salePrice,
    String? stockStatus,
    String? image,
    List<String>? gallery,
    String? shortDescription,
    String? recipes,
    String? description,
    List<Variations>? variations,
  }) => Products(
    id: id ?? _id,
    sku: sku ?? _sku,
    name: name ?? _name,
    price: price ?? _price,
    regularPrice: regularPrice ?? _regularPrice,
    salePrice: salePrice ?? _salePrice,
    stockStatus: stockStatus ?? _stockStatus,
    image: image ?? _image,
    gallery: gallery ?? _gallery,
    shortDescription: shortDescription ?? _shortDescription,
    recipes: recipes ?? _recipes,
    description: description ?? _description,
    variations: variations ?? _variations,
  );
  int? get id => _id;
  String? get sku => _sku;
  RxInt? get qty => _qty;
  String? get name => _name;
  String? get price => _price;
  String? get regularPrice => _regularPrice;
  String? get salePrice => _salePrice;
  String? get stockStatus => _stockStatus;
  String? get image => _image;
  List<String>? get gallery => _gallery;
  String? get shortDescription => _shortDescription;
  String? get recipes => _recipes;
  String? get description => _description;
  List<Variations>? get variations => _variations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sku'] = _sku;
    map['name'] = _name;
    map['price'] = _price;
    map['regular_price'] = _regularPrice;
    map['sale_price'] = _salePrice;
    map['stock_status'] = _stockStatus;
    map['image'] = _image;
    map['gallery'] = _gallery;
    map['short_description'] = _shortDescription;
    map['recipes'] = _recipes;
    map['description'] = _description;
    if (_variations != null) {
      map['variations'] = _variations?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Variations {
  Variations({
    int? variationId,
    String? sku,
    String? price,
    String? regularPrice,
    String? salePrice,
    String? stockStatus,
    String? attributes,
    String? image,
  }) {
    _variationId = variationId;
    _sku = sku;
    _price = price;
    _regularPrice = regularPrice;
    _salePrice = salePrice;
    _stockStatus = stockStatus;
    _attributes = attributes;
    _image = image;
  }

  Variations.fromJson(dynamic json) {
    _variationId = json['variation_id'];
    _sku = json['sku'];
    _price = json['price'];
    _regularPrice = json['regular_price'];
    _salePrice = json['sale_price'];
    _stockStatus = json['stock_status'];
    _attributes = json['attributes'];
    _image = json['image'];
  }
  int? _variationId;
  String? _sku;
  String? _price;
  String? _regularPrice;
  String? _salePrice;
  String? _stockStatus;
  String? _attributes;
  String? _image;
  Variations copyWith({
    int? variationId,
    String? sku,
    String? price,
    String? regularPrice,
    String? salePrice,
    String? stockStatus,
    String? attributes,
    String? image,
  }) => Variations(
    variationId: variationId ?? _variationId,
    sku: sku ?? _sku,
    price: price ?? _price,
    regularPrice: regularPrice ?? _regularPrice,
    salePrice: salePrice ?? _salePrice,
    stockStatus: stockStatus ?? _stockStatus,
    attributes: attributes ?? _attributes,
    image: image ?? _image,
  );
  int? get variationId => _variationId;
  String? get sku => _sku;
  String? get price => _price;
  String? get regularPrice => _regularPrice;
  String? get salePrice => _salePrice;
  String? get stockStatus => _stockStatus;
  String? get attributes => _attributes;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['variation_id'] = _variationId;
    map['sku'] = _sku;
    map['price'] = _price;
    map['regular_price'] = _regularPrice;
    map['sale_price'] = _salePrice;
    map['stock_status'] = _stockStatus;
    map['attributes'] = _attributes;
    map['image'] = _image;
    return map;
  }
}
