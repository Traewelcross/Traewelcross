import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/shared.dart';

class MastodonApiProvider {
  const MastodonApiProvider();

  String getEmoji(String mastodonUrl, String shortcode){
    List<MastoCustomEmoji>? emojis;
    _getEmojis(mastodonUrl).then((x) => emojis = x);
    return emojis?.firstWhere((emoji) => emoji.shortcode == shortcode).staticUrl ?? "";
  }
  Future<List<MastoCustomEmoji>> _getEmojis(String mastodonUrl) async{
    final url = SharedFunctions.concatUri([mastodonUrl,"/api/v1/custom_emojis"]);
    var file = await DefaultCacheManager().getSingleFile(url.toString());
    final emojisS = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(emojisS);
      final List<MastoCustomEmoji> emojis = jsonData
          .map((e) => MastoCustomEmoji.fromJson(e))
          .toList();
      return emojis;
  }
}