import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/shared.dart';

class MastodonApiProvider {
  MastodonApiProvider();
  final Map<String, Map<String, String>> _emojiCache = {};
  final Map<String, Future<List<MastoCustomEmoji>>> _inFlight = {};
  Future<String?> getEmoji(String? mastodonUrl, String shortcode) async {
    if (mastodonUrl == null || mastodonUrl.isEmpty) {
      return "";
    }
    final lookUpCode = shortcode.replaceAll(":", "");
    if(_emojiCache.containsKey(mastodonUrl)){
      return _emojiCache[mastodonUrl]?[lookUpCode];
    }
    if(!_inFlight.containsKey(mastodonUrl)){
      _inFlight[mastodonUrl] = _getEmojis(mastodonUrl);
    }
    List<MastoCustomEmoji>? emojis = await _inFlight[mastodonUrl];
    _emojiCache[mastodonUrl] = {};
    if(emojis != null){
      for (MastoCustomEmoji emoji in emojis){
        _emojiCache[mastodonUrl]![emoji.shortcode.replaceAll(":", "")] = emoji.staticUrl;
      }
    }
    _inFlight.remove(mastodonUrl);
    return _emojiCache[mastodonUrl]?[lookUpCode];
  }

  Future<List<MastoCustomEmoji>> _getEmojis(String mastodonUrl) async {
    final url = SharedFunctions.concatUri([
      mastodonUrl,
      "/api/v1/custom_emojis",
    ]);
    var file = await DefaultCacheManager().getSingleFile(url.toString());
    final emojisS = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(emojisS);
    final List<MastoCustomEmoji> emojis = jsonData
        .map((e) => MastoCustomEmoji.fromJson(e))
        .toList();
    return emojis;
  }
}
