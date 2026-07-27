import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class MastoEmoji extends StatelessWidget {
  final String? mastodonUrl;
  final String shortCode;
  final double width;
  const MastoEmoji({
    required this.mastodonUrl,
    required this.shortCode,
    required this.width,
    super.key
  });
  @override
  Widget build(BuildContext context) {
   return FutureBuilder(future: getIt<ApiService>().mastodon.getEmoji(mastodonUrl, shortCode), builder: (ctx, snp){
    if(snp.connectionState != .done || !snp.hasData){
      return Text(shortCode);
    }
    String imageUrl = snp.data!;
    return CachedNetworkImage(imageUrl: imageUrl, width: width,);
   });
  }
}