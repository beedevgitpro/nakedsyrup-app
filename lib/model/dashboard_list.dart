class DashboardList {
  DashboardList({
    bool? success,
    List<Products>? products,
    int? total,
    int? totalPages,
    int? currentPage,
    int? perPage,
  }) {
    _success = success;
    _products = products;
    _total = total;
    _totalPages = totalPages;
    _currentPage = currentPage;
    _perPage = perPage;
  }

  DashboardList.fromJson(dynamic json) {
    _success = json['success'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products?.add(Products.fromJson(v));
      });
    }
    _total = json['total'];
    _totalPages = json['total_pages'];
    _currentPage = json['current_page'];
    _perPage = json['per_page'];
  }
  bool? _success;
  List<Products>? _products;
  int? _total;
  int? _totalPages;
  int? _currentPage;
  int? _perPage;
  DashboardList copyWith({
    bool? success,
    List<Products>? products,
    int? total,
    int? totalPages,
    int? currentPage,
    int? perPage,
  }) => DashboardList(
    success: success ?? _success,
    products: products ?? _products,
    total: total ?? _total,
    totalPages: totalPages ?? _totalPages,
    currentPage: currentPage ?? _currentPage,
    perPage: perPage ?? _perPage,
  );
  bool? get success => _success;
  List<Products>? get products => _products;
  int? get total => _total;
  int? get totalPages => _totalPages;
  int? get currentPage => _currentPage;
  int? get perPage => _perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_products != null) {
      map['products'] = _products?.map((v) => v.toJson()).toList();
    }
    map['total'] = _total;
    map['total_pages'] = _totalPages;
    map['current_page'] = _currentPage;
    map['per_page'] = _perPage;
    return map;
  }
}

class Products {
  Products({
    int? id,
    String? name,
    String? price,
    String? image,
    int? views,
    String? link,
  }) {
    _id = id;
    _name = name;
    _price = price;
    _image = image;
    _views = views;
    _link = link;
  }

  Products.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'];
    _image = json['image'];
    _views = json['views'];
    _link = json['link'];
  }
  int? _id;
  String? _name;
  String? _price;
  String? _image;
  int? _views;
  String? _link;
  Products copyWith({
    int? id,
    String? name,
    String? price,
    String? image,
    int? views,
    String? link,
  }) => Products(
    id: id ?? _id,
    name: name ?? _name,
    price: price ?? _price,
    image: image ?? _image,
    views: views ?? _views,
    link: link ?? _link,
  );
  int? get id => _id;
  String? get name => _name;
  String? get price => _price;
  String? get image => _image;
  int? get views => _views;
  String? get link => _link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['price'] = _price;
    map['image'] = _image;
    map['views'] = _views;
    map['link'] = _link;
    return map;
  }
}
