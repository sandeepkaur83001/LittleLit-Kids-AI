import 'package:little_kids_ai/models/base_model.dart';

class InterestListResponseModel extends BaseModel {
  List<InterestModel>? data;

  InterestListResponseModel({
    super.success,
    super.status,
    super.message,
    this.data,
  });

  InterestListResponseModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      data = <InterestModel>[];
      json['data'].forEach((v) {
        data!.add(InterestModel.fromJson(v));
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

class SingleInterestResponseModel extends BaseModel {
  InterestModel? data;

  SingleInterestResponseModel({
    super.success,
    super.status,
    super.message,
    this.data,
  });

  SingleInterestResponseModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['data'] != null ? InterestModel.fromJson(json['data']) : null;
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

class InterestModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  int? sortOrder;
  bool? isActive;
  bool? isSelected;

  InterestModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.sortOrder,
    this.isActive,
    this.isSelected,
  });

  InterestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    sortOrder = json['sort_order'] is int
        ? json['sort_order']
        : int.tryParse(json['sort_order']?.toString() ?? '');
    isActive = _parseBool(json['is_active']);
    isSelected = _parseBool(json['is_selected']);
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['sort_order'] = sortOrder;
    data['is_active'] = isActive;
    data['is_selected'] = isSelected;
    return data;
  }
}
