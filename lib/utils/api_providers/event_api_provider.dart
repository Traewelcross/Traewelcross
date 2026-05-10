import 'dart:convert';

import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';

class EventApiProvider {
  final ApiService _api;
  const EventApiProvider(this._api);

  Future<List<Event>> getEvents({required String timestamp}) async{
      final response = await _api.request(
      "/events?timestamp=$timestamp",
      .GET,
    );
    if(response.statusCode == 200){
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<Event> events = jsonData.map((e) => Event.fromJson(e)).toList();
      return events;
    } else {
      return Future.error("${response.statusCode}\n${response.body}");
    }
  }
}