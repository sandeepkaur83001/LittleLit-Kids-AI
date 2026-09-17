import 'package:little_kids_ai/core/common_imports.dart';

class FriendsApiService {
  Future<FriendListResponseModel> getFriends({bool showLoading = false}) async {
    final response = await ApiService.get(
      ApiEndPointConstants.friends,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return FriendListResponseModel.fromJson(json);
    } catch (e) {
      return FriendListResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch friends: $e',
      );
    }
  }

  Future<FriendListResponseModel> getFriendRequests({bool showLoading = false}) async {
    final response = await ApiService.get(
      ApiEndPointConstants.friendRequests,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return FriendListResponseModel.fromJson(json);
    } catch (e) {
      return FriendListResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to fetch friend requests: $e',
      );
    }
  }

  Future<FriendActionResponseModel> sendFriendRequest(
    String secretKey, {
    bool showLoading = true,
  }) async {
    final Map<String, dynamic> body = {
      'secret_key': secretKey,
    };

    final response = await ApiService.formPost(
      ApiEndPointConstants.addFriend,
      body: body,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return FriendActionResponseModel.fromJson(json);
    } catch (e) {
      return FriendActionResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to send friend request: $e',
      );
    }
  }

  Future<FriendActionResponseModel> acceptFriendRequest(
    int userId, {
    bool showLoading = true,
  }) async {
    final Map<String, dynamic> body = {
      'user_id': userId.toString(),
    };

    final response = await ApiService.formPost(
      ApiEndPointConstants.acceptFriend,
      body: body,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return FriendActionResponseModel.fromJson(json);
    } catch (e) {
      return FriendActionResponseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to accept friend request: $e',
      );
    }
  }

  Future<BaseModel> rejectFriendRequest(
    int userId, {
    bool showLoading = true,
  }) async {
    final Map<String, dynamic> body = {
      'user_id': userId.toString(),
    };

    final response = await ApiService.formPost(
      ApiEndPointConstants.rejectFriend,
      body: body,
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return BaseModel.fromJson(json);
    } catch (e) {
      return BaseModel(
        success: false,
        status: response.statusCode,
        message: 'Failed to reject friend request: $e',
      );
    }
  }

  Future<BaseModel> removeFriend(
    int friendId, {
    bool showLoading = true,
  }) async {
    final response = await ApiService.delete(
      '${ApiEndPointConstants.friends}/$friendId',
      showLoading: showLoading,
    );

    try {
      final json = jsonDecode(response.body);
      return BaseModel.fromJson(json);
    } catch (e) {
      return BaseModel(
        success: response.statusCode == 200,
        status: response.statusCode,
        message: response.statusCode == 200 ? 'Friend removed successfully' : 'Failed to remove friend: $e',
      );
    }
  }
}
