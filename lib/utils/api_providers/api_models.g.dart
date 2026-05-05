// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
  key: json['key'] as String?,
  value: json['value'] as String?,
  visibility: $enumDecodeNullable(
    _$TripVisibilityEnumEnumMap,
    json['visibility'],
  ),
);

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
  'key': instance.key,
  'value': instance.value,
  'visibility': _$TripVisibilityEnumEnumMap[instance.visibility],
};

const _$TripVisibilityEnumEnumMap = {
  TripVisibilityEnum.public: 0,
  TripVisibilityEnum.loggedInUser: 4,
  TripVisibilityEnum.followerOnly: 2,
  TripVisibilityEnum.notListed: 1,
  TripVisibilityEnum.private: 3,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String,
  displayName: json['displayName'] as String,
  username: json['username'] as String,
  profilePicture: json['profilePicture'] as String,
  totalDistance: (json['totalDistance'] as num).toInt(),
  totalDuration: (json['totalDuration'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  mastodonUrl: json['mastodonUrl'] as String?,
  privateProfile: json['privateProfile'] as bool,
  pointsEnabled: json['pointsEnabled'] as bool,
  userInvisibleToMe: json['userInvisibleToMe'] as bool,
  muted: json['muted'] as bool,
  blocked: json['blocked'] as bool,
  following: json['following'] as bool,
  followPending: json['followPending'] as bool,
  followedBy: json['followedBy'] as bool,
  preventIndex: json['preventIndex'] as bool,
  bio: json['bio'] as String,
  profileLinks: (json['profileLinks'] as List<dynamic>)
      .map((e) => ProfileLink.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'uuid': instance.uuid,
  'displayName': instance.displayName,
  'username': instance.username,
  'profilePicture': instance.profilePicture,
  'totalDistance': instance.totalDistance,
  'totalDuration': instance.totalDuration,
  'points': instance.points,
  'mastodonUrl': instance.mastodonUrl,
  'privateProfile': instance.privateProfile,
  'pointsEnabled': instance.pointsEnabled,
  'userInvisibleToMe': instance.userInvisibleToMe,
  'muted': instance.muted,
  'blocked': instance.blocked,
  'following': instance.following,
  'followPending': instance.followPending,
  'followedBy': instance.followedBy,
  'preventIndex': instance.preventIndex,
  'bio': instance.bio,
  'profileLinks': instance.profileLinks,
};

ProfileLink _$ProfileLinkFromJson(Map<String, dynamic> json) =>
    ProfileLink(name: json['name'] as String, url: json['url'] as String);

Map<String, dynamic> _$ProfileLinkToJson(ProfileLink instance) =>
    <String, dynamic>{'name': instance.name, 'url': instance.url};
