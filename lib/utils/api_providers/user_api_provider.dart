import 'dart:convert';

import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';

class UserApiProvider {
  final ApiService _api;
  const UserApiProvider(this._api);
  Future<List<User>> searchUser(String query) async {
    final response = await _api.request(
      "/user/search/${Uri.encodeComponent(query)}",
      .GET,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<User> users = jsonData
          .map((u) => User.fromJson(u as Map<String, dynamic>))
          .toList();
      return users;
    }
    return Future.error("${response.statusCode} / ${response.body}");
  }
}
