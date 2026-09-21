import 'package:little_kids_ai/models/base_model.dart';

class CategoryListResponseModel extends BaseModel {
  List<CategoryModel>? data;

  CategoryListResponseModel({
    super.success,
    super.status,
    super.message,
    this.data,
  });

  CategoryListResponseModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      data = <CategoryModel>[];
      json['data'].forEach((v) {
        data!.add(CategoryModel.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = super.toJson();
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SingleCategoryResponseModel extends BaseModel {
  CategoryModel? data;

  SingleCategoryResponseModel({
    super.success,
    super.status,
    super.message,
    this.data,
  });

  SingleCategoryResponseModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['data'] != null ? CategoryModel.fromJson(json['data']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = super.toJson();
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class CategoryModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  String? image;
  String? icon;
  String? iconUrl;
  int? parentId;
  int? sortOrder;
  bool? isActive;
  bool? isSelected;
  bool? isSpecial;
  List<CategoryModel>? children;

  CategoryModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.image,
    this.icon,
    this.iconUrl,
    this.parentId,
    this.sortOrder,
    this.isActive,
    this.isSelected = false,
    this.isSpecial = false,
    this.children,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    name = json['name'] ?? json['title'];
    slug = json['slug'];
    description = json['description'];
    image = json['image'] ?? json['icon_url'] ?? json['icon'] ?? json['image_url'];
    icon = json['icon'] ?? json['image'];
    iconUrl = json['icon_url'] ?? json['image_url'] ?? json['image'];
    parentId = json['parent_id'] is int
        ? json['parent_id']
        : int.tryParse(json['parent_id']?.toString() ?? '');
    sortOrder = json['sort_order'] is int
        ? json['sort_order']
        : int.tryParse(json['sort_order']?.toString() ?? '');
    isActive = _parseBool(json['is_active']);
    isSelected = _parseBool(json['is_selected'] ?? json['isSelected']) ?? false;
    isSpecial = _parseBool(json['is_special'] ?? json['isSpecial']) ?? false;

    if (json['children'] != null) {
      children = <CategoryModel>[];
      json['children'].forEach((v) {
        children!.add(CategoryModel.fromJson(v));
      });
    } else if (json['sub_categories'] != null) {
      children = <CategoryModel>[];
      json['sub_categories'].forEach((v) {
        children!.add(CategoryModel.fromJson(v));
      });
    }
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == '1' || lower == 'true' || lower == 'yes' || lower == 'on';
    }
    return false;
  }

  String get displayImage {
    if (image != null && image!.isNotEmpty) return image!;
    if (iconUrl != null && iconUrl!.isNotEmpty) return iconUrl!;
    if (icon != null && icon!.isNotEmpty) return icon!;
    return '';
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? description,
    String? image,
    String? icon,
    String? iconUrl,
    int? parentId,
    int? sortOrder,
    bool? isActive,
    bool? isSelected,
    bool? isSpecial,
    List<CategoryModel>? children,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      image: image ?? this.image,
      icon: icon ?? this.icon,
      iconUrl: iconUrl ?? this.iconUrl,
      parentId: parentId ?? this.parentId,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      isSelected: isSelected ?? this.isSelected,
      isSpecial: isSpecial ?? this.isSpecial,
      children: children ?? this.children,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['image'] = image;
    data['icon'] = icon;
    data['icon_url'] = iconUrl;
    data['parent_id'] = parentId;
    data['sort_order'] = sortOrder;
    data['is_active'] = isActive;
    data['is_selected'] = isSelected;
    data['is_special'] = isSpecial;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
