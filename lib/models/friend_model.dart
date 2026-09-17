import 'package:little_kids_ai/models/base_model.dart';

class FriendListResponseModel extends BaseModel {
  List<FriendModel>? data;

  FriendListResponseModel({
    super.success,
    super.status,
    super.message,
    this.data,
  });

  FriendListResponseModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null) {
      data = <FriendModel>[];
      json['data'].forEach((v) {
        data!.add(FriendModel.fromJson(v));
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

class FriendActionResponseModel extends BaseModel {
  FriendModel? data;

  FriendActionResponseModel({
    super.success,
    super.status,
    super.message,
    this.data,
  });

  FriendActionResponseModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['data'] != null ? FriendModel.fromJson(json['data']) : null;
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

class FriendModel {
  int? id;
  int? userId;
  int? requestId;
  String? firstName;
  String? lastName;
  String? childNickname;
  String? nickname;
  String? secretKey;
  String? profilePicture;
  String? status;
  String? addedAt;
  String? requestedAt;

  FriendModel({
    this.id,
    this.userId,
    this.requestId,
    this.firstName,
    this.lastName,
    this.childNickname,
    this.nickname,
    this.secretKey,
    this.profilePicture,
    this.status,
    this.addedAt,
    this.requestedAt,
  });

  String get displayName {
    if (childNickname != null && childNickname!.isNotEmpty) {
      return childNickname!;
    }
    if (nickname != null && nickname!.isNotEmpty) {
      return nickname!;
    }
    if (firstName != null && firstName!.isNotEmpty) {
      return lastName != null ? '$firstName $lastName' : firstName!;
    }
    return 'Friend';
  }

  FriendModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    userId = json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '');
    requestId = json['request_id'] is int ? json['request_id'] : int.tryParse(json['request_id']?.toString() ?? '');
    firstName = json['first_name'];
    lastName = json['last_name'];
    childNickname = json['child_nickname'] ?? json['nickname'];
    nickname = json['nickname'] ?? json['child_nickname'];
    secretKey = json['secret_key'] ?? json['key'];
    profilePicture = json['profile_picture'];
    status = json['status'];
    addedAt = json['added_at'];
    requestedAt = json['requested_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['request_id'] = requestId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['child_nickname'] = childNickname;
    data['nickname'] = nickname;
    data['secret_key'] = secretKey;
    data['profile_picture'] = profilePicture;
    data['status'] = status;
    data['added_at'] = addedAt;
    data['requested_at'] = requestedAt;
    return data;
  }
}
