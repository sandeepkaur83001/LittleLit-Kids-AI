import 'package:little_kids_ai/models/base_model.dart';
import 'package:little_kids_ai/models/mood_model.dart';

class AuthResponseModel extends BaseModel {
  UserData? data;

  AuthResponseModel({
    super.success,
    super.status,
    super.message,
    this.data,
  });

  AuthResponseModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
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

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? childNickname;
  int? childAge;
  String? childGrade;
  bool? isNeurodivergent;
  bool? backgroundMusic;
  bool? music;
  int? moodId;
  MoodModel? mood;
  MoodModel? feeling;
  bool? termsAccepted;
  String? profilePicture;
  ChildModel? child;
  List<ChildModel>? children;
  String? accessToken;
  String? tokenType;
  String? createdAt;
  String? updatedAt;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.childNickname,
    this.childAge,
    this.childGrade,
    this.isNeurodivergent,
    this.backgroundMusic,
    this.music,
    this.moodId,
    this.mood,
    this.feeling,
    this.termsAccepted,
    this.profilePicture,
    this.child,
    this.children,
    this.accessToken,
    this.tokenType,
    this.createdAt,
    this.updatedAt,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'] ?? json['parent_email'];
    childNickname = json['child_nickname'] ?? json['nickname'];
    childAge = json['child_age'] is int
        ? json['child_age']
        : int.tryParse(json['child_age']?.toString() ?? (json['age']?.toString() ?? ''));
    childGrade = json['child_grade'] ?? json['grade'];
    isNeurodivergent = _parseBool(json['is_neurodivergent'] ?? json['neurodivergent']);
    backgroundMusic = _parseBool(json['background_music'] ?? json['music']);
    music = _parseBool(json['music']);
    moodId = json['mood_id'] is int
        ? json['mood_id']
        : int.tryParse(json['mood_id']?.toString() ?? (json['feeling_id']?.toString() ?? ''));
    mood = json['mood'] != null ? MoodModel.fromJson(json['mood']) : null;
    feeling = json['feeling'] != null ? MoodModel.fromJson(json['feeling']) : null;
    termsAccepted = _parseBool(json['terms_accepted'] ?? json['agree_to_terms']);
    profilePicture = json['profile_picture'];
    child = json['child'] != null ? ChildModel.fromJson(json['child']) : null;
    if (json['children'] != null) {
      children = <ChildModel>[];
      json['children'].forEach((v) {
        children!.add(ChildModel.fromJson(v));
      });
    }
    accessToken = json['access_token'] ?? json['token'];
    tokenType = json['token_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['child_nickname'] = childNickname;
    data['child_age'] = childAge;
    data['child_grade'] = childGrade;
    data['is_neurodivergent'] = isNeurodivergent;
    data['background_music'] = backgroundMusic;
    data['music'] = music;
    data['mood_id'] = moodId;
    if (mood != null) {
      data['mood'] = mood!.toJson();
    }
    if (feeling != null) {
      data['feeling'] = feeling!.toJson();
    }
    data['terms_accepted'] = termsAccepted;
    data['profile_picture'] = profilePicture;
    if (child != null) {
      data['child'] = child!.toJson();
    }
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ChildModel {
  int? id;
  String? nickname;
  int? age;
  String? grade;
  bool? isNeurodivergent;
  bool? backgroundMusic;
  bool? music;
  int? moodId;
  MoodModel? mood;
  MoodModel? feeling;

  ChildModel({
    this.id,
    this.nickname,
    this.age,
    this.grade,
    this.isNeurodivergent,
    this.backgroundMusic,
    this.music,
    this.moodId,
    this.mood,
    this.feeling,
  });

  ChildModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    nickname = json['nickname'] ?? json['child_nickname'];
    age = json['age'] is int
        ? json['age']
        : int.tryParse(json['age']?.toString() ?? (json['child_age']?.toString() ?? ''));
    grade = json['grade'] ?? json['child_grade'];
    isNeurodivergent = UserData._parseBool(json['is_neurodivergent'] ?? json['neurodivergent']);
    backgroundMusic = UserData._parseBool(json['background_music'] ?? json['music']);
    music = UserData._parseBool(json['music']);
    moodId = json['mood_id'] is int
        ? json['mood_id']
        : int.tryParse(json['mood_id']?.toString() ?? (json['feeling_id']?.toString() ?? ''));
    mood = json['mood'] != null ? MoodModel.fromJson(json['mood']) : null;
    feeling = json['feeling'] != null ? MoodModel.fromJson(json['feeling']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nickname'] = nickname;
    data['age'] = age;
    data['grade'] = grade;
    data['is_neurodivergent'] = isNeurodivergent;
    data['background_music'] = backgroundMusic;
    data['music'] = music;
    data['mood_id'] = moodId;
    if (mood != null) {
      data['mood'] = mood!.toJson();
    }
    if (feeling != null) {
      data['feeling'] = feeling!.toJson();
    }
    return data;
  }
}
