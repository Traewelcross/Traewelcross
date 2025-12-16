import 'package:flutter/material.dart';
import 'package:traewelcross/components/profile_picture.dart';
import 'package:traewelcross/utils/shared.dart';

class OwnProfilePicture extends StatelessWidget {
  const OwnProfilePicture({super.key, required this.maxWidth});

  final double maxWidth;
  Future<String> _getPfpURL() async {
    final userInfo = await SharedFunctions.getUserInfoFromCache();
    return userInfo["profilePicture"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getPfpURL(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return ProfilePicture(
            imageUrl: asyncSnapshot.data,
            maxWidth: maxWidth,
          );
        }
        return const Icon(Icons.account_circle);
      },
    );
  }
}
