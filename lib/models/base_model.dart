class BaseModel {
  bool? success;
  int? status;
  String? message;

  BaseModel({this.success, this.status, this.message});

  BaseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'] is int
        ? json['status']
        : int.tryParse(json['status']?.toString() ?? '');
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
