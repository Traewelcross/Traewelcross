import "package:flutter/material.dart";
import "package:traewelcross/components/app_bar_title.dart";
import "package:traewelcross/components/main_scaffold.dart";
import "package:traewelcross/components/profile_picture.dart";
import "package:traewelcross/pages/profile_view.dart";
import "package:traewelcross/utils/api_providers/api_models.dart";

class ProfileLink extends StatelessWidget {
  const ProfileLink({
    super.key,
    required this.user,
    this.enableNavigateToProfile,
    this.appendUsername,
    this.subTitle,
    this.action,
  });
  final User user;
  final bool? enableNavigateToProfile;
  final bool? appendUsername;
  final String? subTitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (enableNavigateToProfile ?? true)
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScaffold(
                    title: AppBarTitle(user.displayName),
                    body: ProfileView(
                      isOtherUser: true,
                      username: user.username,
                      userId: user.id,
                      scrollController: ScrollController(),
                      tempScrollController: true,
                    ),
                  ),
                ),
              );
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ProfilePicture(imageUrl: user.profilePicture, maxWidth: 64),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user.displayName}${(appendUsername ?? false) ? " (@${user.username})" : ""}",
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subTitle != null)
                          Text(
                            subTitle!,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(fontFamily: "SUSE"),
                          ),
                      ],
                    ),
                  ),
                  if ((user.userInvisibleToMe) &&
                      (user.privateProfile)) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.lock, size: 16),
                  ],
                ],
              ),
            ),
            action ?? const SizedBox(width: 0),
            if ((enableNavigateToProfile ?? true))
              const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
