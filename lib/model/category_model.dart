class CategoryModel {
  CategoryModel({bool? success, List<Categories>? categories}) {
    _success = success;
    _categories = categories;
  }

  CategoryModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['categories'] != null) {
      _categories = [];
      json['categories'].forEach((v) {
        _categories?.add(Categories.fromJson(v));
      });
    }
  }
  bool? _success;
  List<Categories>? _categories;
  CategoryModel copyWith({bool? success, List<Categories>? categories}) =>
      CategoryModel(
        success: success ?? _success,
        categories: categories ?? _categories,
      );
  bool? get success => _success;
  List<Categories>? get categories => _categories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_categories != null) {
      map['categories'] = _categories?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Categories {
  Categories({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? image,
  }) {
    _id = id;
    _name = name;
    _slug = slug;
    _description = description;
    _image = image;
  }

  Categories.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _description = json['description'];
    _image = json['image'];
  }
  int? _id;
  String? _name;
  String? _slug;
  String? _description;
  String? _image;
  Categories copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? image,
  }) => Categories(
    id: id ?? _id,
    name: name ?? _name,
    slug: slug ?? _slug,
    description: description ?? _description,
    image: image ?? _image,
  );
  int? get id => _id;
  String? get name => _name;
  String? get slug => _slug;
  String? get description => _description;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['slug'] = _slug;
    map['description'] = _description;
    map['image'] = _image;
    return map;
  }
}
