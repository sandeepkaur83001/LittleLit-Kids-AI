import 'package:little_kids_ai/models/base_model.dart';

class SkillListResponseModel extends BaseModel {
  List<SkillModel>? data;

  SkillListResponseModel({
    super.success,
    super.status,
    super.message,
    this.data,
  });

  SkillListResponseModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      data = <SkillModel>[];
      json['data'].forEach((v) {
        data!.add(SkillModel.fromJson(v));
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

class SkillModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  String? icon;
  String? iconUrl;
  int? level;
  int? minLevel;
  int? maxLevel;
  int? sortOrder;
  bool? isActive;

  SkillModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.icon,
    this.iconUrl,
    this.level,
    this.minLevel,
    this.maxLevel,
    this.sortOrder,
    this.isActive,
  });

  SkillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    name = json['name'] ?? json['title'];
    slug = json['slug'];
    description = json['description'];
    icon = json['icon'];
    iconUrl = json['icon_url'];
    level = json['level'] is int
        ? json['level']
        : int.tryParse(json['level']?.toString() ?? '1') ?? 1;
    minLevel = json['min_level'] is int
        ? json['min_level']
        : int.tryParse(json['min_level']?.toString() ?? '1') ?? 1;
    maxLevel = json['max_level'] is int
        ? json['max_level']
        : int.tryParse(json['max_level']?.toString() ?? '6') ?? 6;
    sortOrder = json['sort_order'] is int
        ? json['sort_order']
        : int.tryParse(json['sort_order']?.toString() ?? '');
    isActive = _parseBool(json['is_active']);
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
    data['icon'] = icon;
    data['icon_url'] = iconUrl;
    data['level'] = level;
    data['min_level'] = minLevel;
    data['max_level'] = maxLevel;
    data['sort_order'] = sortOrder;
    data['is_active'] = isActive;
    return data;
  }
}
