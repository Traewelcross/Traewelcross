import 'dart:convert';

import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';

class OperatorApiProvider {
  final ApiService _api;
  OperatorApiProvider(this._api);

  Future<List<Operator>> autocompleteOperator(String query) async{
    final response = await _api.request("/operators?query=$query", .GET);
    if(response.statusCode == 200){
      final List<dynamic> jsonData = jsonDecode(response.body)["data"];
      final List<Operator> operators = jsonData.map((o) => Operator.fromJson(o as Map<String, dynamic>)).toList();
      return operators;
    }
    return [];
  }
}