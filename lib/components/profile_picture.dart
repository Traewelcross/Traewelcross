import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.imageUrl,
    required this.maxWidth,
  });

  final dynamic imageUrl;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(99999),
          child: CachedNetworkImage(
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            imageUrl: imageUrl ?? "",
            errorWidget: (context, url, error) => const Icon(Icons.error),
            placeholder: (context, url) => const Icon(Icons.account_circle),
          ),
        ),
      ),
    );
  }
}
