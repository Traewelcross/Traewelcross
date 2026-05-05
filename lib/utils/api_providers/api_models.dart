import 'package:json_annotation/json_annotation.dart';
import 'package:traewelcross/enums/trip_visibility.dart';

part "api_models.g.dart";
@JsonSerializable()
class Tag {
  @JsonKey(name: "key")
  final String? key;

  @JsonKey(name: "value")
  final String? value;

  @JsonKey(name: "visibility")
  final TripVisibilityEnum? visibility;
  const Tag({required this.key, required this.value, required this.visibility});
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "uuid")
  final String uuid;
  @JsonKey(name: "displayName")
  final String displayName;
  @JsonKey(name: "username")
  final String username;
  @JsonKey(name: "profilePicture")
  final String profilePicture;
  @JsonKey(name: "totalDistance")
  final int totalDistance;
  @JsonKey(name: "totalDuration")
  final int totalDuration;
  @JsonKey(name: "points")
  final int points;
  @JsonKey(name: "mastodonUrl")
  final String? mastodonUrl;
  @JsonKey(name: "privateProfile")
  final bool privateProfile;
  @JsonKey(name: "pointsEnabled")
  final bool pointsEnabled;
  @JsonKey(name: "userInvisibleToMe")
  final bool userInvisibleToMe;
  @JsonKey(name: "muted")
  final bool muted;
  @JsonKey(name: "blocked")
  final bool blocked;
  @JsonKey(name: "following")
  final bool following;
  @JsonKey(name: "followPending")
  final bool followPending;
  @JsonKey(name: "followedBy")
  final bool followedBy;
  @JsonKey(name: "preventIndex")
  final bool preventIndex;
  @JsonKey(name: "bio")
  final String bio;
  @JsonKey(name: "profileLinks")
  final List<ProfileLink> profileLinks;
  User({
    required this.id,
    required this.uuid,
    required this.displayName,
    required this.username,
    required this.profilePicture,
    required this.totalDistance,
    required this.totalDuration,
    required this.points,
    this.mastodonUrl,
    required this.privateProfile,
    required this.pointsEnabled,
    required this.userInvisibleToMe,
    required this.muted,
    required this.blocked,
    required this.following,
    required this.followPending,
    required this.followedBy,
    required this.preventIndex,
    required this.bio,
    required this.profileLinks,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class ProfileLink {
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "url")
  final String url;
  ProfileLink({
    required this.name,
    required this.url,
  });
  factory ProfileLink.fromJson(Map<String, dynamic> json) => _$ProfileLinkFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileLinkToJson(this);
}

class GenericStatusResponse {
  final bool wasSuccess;
  final String? body;
  const GenericStatusResponse({required this.wasSuccess, this.body});
}