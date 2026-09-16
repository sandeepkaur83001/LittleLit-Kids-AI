import 'package:little_kids_ai/models/base_model.dart';

class MoodListResponseModel extends BaseModel {
  List<MoodModel>? data;

  MoodListResponseModel({
    super.success,
    super.status,
    super.message,
    this.data,
  });

  MoodListResponseModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      data = <MoodModel>[];
      json['data'].forEach((v) {
        data!.add(MoodModel.fromJson(v));
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

class MoodModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  String? icon;
  String? iconUrl;
  String? music;
  String? musicUrl;

  MoodModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.icon,
    this.iconUrl,
    this.music,
    this.musicUrl,
  });

  MoodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    icon = json['icon'];
    iconUrl = json['icon_url'];
    music = json['music'];
    musicUrl = json['music_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['icon'] = icon;
    data['icon_url'] = iconUrl;
    data['music'] = music;
    data['music_url'] = musicUrl;
    return data;
  }
}
