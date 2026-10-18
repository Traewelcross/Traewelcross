import 'dart:convert';

import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';

class MiscApiProvider {
  final ApiService _api;
  MiscApiProvider(this._api);

  Future<ProviderConfigInfo> getConfiguration() async {
    final response = await _api.request("/app/configuration", .GET);
    if (response.statusCode == 200) {
      return ProviderConfigInfo.fromJson(jsonDecode(response.body));
    }
    return ProviderConfigInfo(appName: "", appUrl: "", version: "");
  }
}
