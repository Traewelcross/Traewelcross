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

UserAuth _$UserAuthFromJson(Map<String, dynamic> json) => UserAuth(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String,
  displayName: json['displayName'] as String,
  username: json['username'] as String,
  profilePicture: json['profilePicture'] as String,
  totalDistance: (json['totalDistance'] as num).toInt(),
  totalDuration: (json['totalDuration'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  privateProfile: json['privateProfile'] as bool,
  pointsEnabled: json['pointsEnabled'] as bool,
  userInvisibleToMe: json['userInvisibleToMe'] as bool? ?? false,
  muted: json['muted'] as bool? ?? false,
  blocked: json['blocked'] as bool? ?? false,
  following: json['following'] as bool? ?? false,
  followPending: json['followPending'] as bool? ?? false,
  followedBy: json['followedBy'] as bool? ?? false,
  preventIndex: json['preventIndex'] as bool,
  bio: json['bio'] as String?,
  profileLinks: (json['profileLinks'] as List<dynamic>?)
      ?.map((e) => ProfileLink.fromJson(e as Map<String, dynamic>))
      .toList(),
  mastodonUrl: json['mastodonUrl'] as String?,
  likesEnabled: json['likes_enabled'] as bool?,
  mapProvider: json['mapProvider'] as String,
  home: json['home'] == null
      ? null
      : Station.fromJson(json['home'] as Map<String, dynamic>),
  defaultStatusVisibility: $enumDecode(
    _$TripVisibilityEnumEnumMap,
    json['defaultStatusVisibility'],
  ),
  roles: (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
  language: json['language'] as String?,
);

Map<String, dynamic> _$UserAuthToJson(UserAuth instance) => <String, dynamic>{
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
  'likes_enabled': instance.likesEnabled,
  'mapProvider': instance.mapProvider,
  'home': instance.home,
  'language': instance.language,
  'defaultStatusVisibility':
      _$TripVisibilityEnumEnumMap[instance.defaultStatusVisibility]!,
  'roles': instance.roles,
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
  bio: json['bio'] as String?,
  profileLinks: (json['profileLinks'] as List<dynamic>?)
      ?.map((e) => ProfileLink.fromJson(e as Map<String, dynamic>))
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

Mention _$MentionFromJson(Map<String, dynamic> json) => Mention(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  position: (json['position'] as num).toInt(),
  length: (json['length'] as num).toInt(),
);

Map<String, dynamic> _$MentionToJson(Mention instance) => <String, dynamic>{
  'user': instance.user,
  'position': instance.position,
  'length': instance.length,
};

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  privacyPolicyUrl: json['privacyPolicyUrl'] as String?,
);

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'privacyPolicyUrl': instance.privacyPolicyUrl,
};

Stopover _$StopoverFromJson(Map<String, dynamic> json) => Stopover(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  arrivalPlanned: json['arrivalPlanned'] as String?,
  arrivalReal: json['arrivalReal'] as String?,
  arrivalPlatformPlanned: json['arrivalPlatformPlanned'] as String?,
  arrivalPlatformReal: json['arrivalPlatformReal'] as String?,
  departurePlanned: json['departurePlanned'] as String?,
  departureReal: json['departureReal'] as String?,
  departurePlatformPlanned: json['departurePlatformPlanned'] as String?,
  departurePlatformReal: json['departurePlatformReal'] as String?,
  platform: json['platform'] as String?,
  isArrivalDelayed: json['isArrivalDelayed'] as bool,
  isDepartureDelayed: json['isDepartureDelayed'] as bool,
  cancelled: json['cancelled'] as bool,
);

Map<String, dynamic> _$StopoverToJson(Stopover instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'arrivalPlanned': instance.arrivalPlanned,
  'arrivalReal': instance.arrivalReal,
  'arrivalPlatformPlanned': instance.arrivalPlatformPlanned,
  'arrivalPlatformReal': instance.arrivalPlatformReal,
  'departurePlanned': instance.departurePlanned,
  'departureReal': instance.departureReal,
  'departurePlatformPlanned': instance.departurePlatformPlanned,
  'departurePlatformReal': instance.departurePlatformReal,
  'platform': instance.platform,
  'isArrivalDelayed': instance.isArrivalDelayed,
  'isDepartureDelayed': instance.isDepartureDelayed,
  'cancelled': instance.cancelled,
};

OperatorIdentifier _$OperatorIdentifierFromJson(Map<String, dynamic> json) =>
    OperatorIdentifier(
      type: json['type'] as String,
      identifier: json['identifier'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$OperatorIdentifierToJson(OperatorIdentifier instance) =>
    <String, dynamic>{
      'type': instance.type,
      'identifier': instance.identifier,
      'name': instance.name,
    };

Operator _$OperatorFromJson(Map<String, dynamic> json) => Operator(
  type: json['type'] as String,
  uuid: json['uuid'] as String,
  name: json['name'] as String,
  identifiers: (json['identifiers'] as List<dynamic>)
      .map((e) => OperatorIdentifier.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OperatorToJson(Operator instance) => <String, dynamic>{
  'type': instance.type,
  'uuid': instance.uuid,
  'name': instance.name,
  'identifiers': instance.identifiers,
};

DataSource _$DataSourceFromJson(Map<String, dynamic> json) => DataSource(
  id: json['id'] as String,
  attribution: json['attribution'] as String,
);

Map<String, dynamic> _$DataSourceToJson(DataSource instance) =>
    <String, dynamic>{'id': instance.id, 'attribution': instance.attribution};

Transport _$TransportFromJson(Map<String, dynamic> json) => Transport(
  trip: (json['trip'] as num).toInt(),
  hafasId: json['hafasId'] as String,
  category: json['category'] as String,
  mode: json['mode'] as String?,
  number: json['number'] as String?,
  lineName: json['lineName'] as String,
  routeColor: json['routeColor'] as String?,
  routeTextColor: json['routeTextColor'] as String?,
  journeyNumber: (json['journeyNumber'] as num?)?.toInt(),
  manualJourneyNumber: json['manualJourneyNumber'] as String?,
  distance: (json['distance'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
  manualDeparture: json['manualDeparture'] as String?,
  manualArrival: json['manualArrival'] as String?,
  origin: Stopover.fromJson(json['origin'] as Map<String, dynamic>),
  destination: Stopover.fromJson(json['destination'] as Map<String, dynamic>),
  operator: json['operator'] == null
      ? null
      : Operator.fromJson(json['operator'] as Map<String, dynamic>),
  dataSource: json['dataSource'] == null
      ? null
      : DataSource.fromJson(json['dataSource'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TransportToJson(Transport instance) => <String, dynamic>{
  'trip': instance.trip,
  'hafasId': instance.hafasId,
  'category': instance.category,
  'mode': instance.mode,
  'number': instance.number,
  'lineName': instance.lineName,
  'routeColor': instance.routeColor,
  'routeTextColor': instance.routeTextColor,
  'journeyNumber': instance.journeyNumber,
  'manualJourneyNumber': instance.manualJourneyNumber,
  'distance': instance.distance,
  'points': instance.points,
  'duration': instance.duration,
  'manualDeparture': instance.manualDeparture,
  'manualArrival': instance.manualArrival,
  'origin': instance.origin,
  'destination': instance.destination,
  'operator': instance.operator,
  'dataSource': instance.dataSource,
};

Area _$AreaFromJson(Map<String, dynamic> json) => Area(
  name: json['name'] as String,
  standard: json['default'] as bool,
  adminLevel: (json['adminLevel'] as num).toInt(),
);

Map<String, dynamic> _$AreaToJson(Area instance) => <String, dynamic>{
  'name': instance.name,
  'default': instance.standard,
  'adminLevel': instance.adminLevel,
};

StationIdentifier _$StationIdentifierFromJson(Map<String, dynamic> json) =>
    StationIdentifier(
      type: json['type'] as String,
      identifier: json['identifier'] as String,
      name: json['name'] as String?,
      origin: json['origin'] as String?,
    );

Map<String, dynamic> _$StationIdentifierToJson(StationIdentifier instance) =>
    <String, dynamic>{
      'type': instance.type,
      'identifier': instance.identifier,
      'name': instance.name,
      'origin': instance.origin,
    };

Station _$StationFromJson(Map<String, dynamic> json) => Station(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  latitude: json['latitude'] as num,
  longitude: json['longitude'] as num,
  areas: (json['areas'] as List<dynamic>?)
      ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
      .toList(),
  identifiers: (json['identifiers'] as List<dynamic>?)
      ?.map((e) => StationIdentifier.fromJson(e as Map<String, dynamic>))
      .toList(),
  timeOffset: (json['time_offset'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  history: json['history'] as bool?,
  home: json['home'] as bool?,
);

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'areas': instance.areas,
  'identifiers': instance.identifiers,
  'time_offset': instance.timeOffset,
  'created_at': instance.createdAt,
  'history': instance.history,
  'home': instance.home,
};

Event _$EventFromJson(Map<String, dynamic> json) => Event(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  slug: json['slug'] as String,
  hashtag: json['hashtag'] as String?,
  host: json['host'] as String?,
  url: json['url'] as String?,
  begin: json['begin'] as String,
  end: json['end'] as String,
  isPride: json['isPride'] as bool,
  station: json['station'] == null
      ? null
      : Station.fromJson(json['station'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'hashtag': instance.hashtag,
  'host': instance.host,
  'url': instance.url,
  'begin': instance.begin,
  'end': instance.end,
  'isPride': instance.isPride,
  'station': instance.station,
};

LightUserMastodon _$LightUserMastodonFromJson(Map<String, dynamic> json) =>
    LightUserMastodon(
      server: json['server'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LightUserMastodonToJson(LightUserMastodon instance) =>
    <String, dynamic>{'server': instance.server, 'user_id': instance.userId};

LightUser _$LightUserFromJson(Map<String, dynamic> json) => LightUser(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String,
  displayName: json['displayName'] as String,
  username: json['username'] as String,
  profilePicture: json['profilePicture'] as String,
  mastodon: json['mastodon'] == null
      ? null
      : LightUserMastodon.fromJson(json['mastodon'] as Map<String, dynamic>),
  preventIndex: json['preventIndex'] as bool,
);

Map<String, dynamic> _$LightUserToJson(LightUser instance) => <String, dynamic>{
  'id': instance.id,
  'uuid': instance.uuid,
  'displayName': instance.displayName,
  'username': instance.username,
  'profilePicture': instance.profilePicture,
  'mastodon': instance.mastodon,
  'preventIndex': instance.preventIndex,
};

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
  id: (json['id'] as num).toInt(),
  body: json['body'] as String,
  bodyMentions: (json['bodyMentions'] as List<dynamic>)
      .map((e) => Mention.fromJson(e as Map<String, dynamic>))
      .toList(),
  business: $enumDecode(_$TripTypeEnumMap, json['business']),
  visibility: $enumDecode(_$TripVisibilityEnumEnumMap, json['visibility']),
  likes: (json['likes'] as num).toInt(),
  liked: json['liked'] as bool,
  isLikable: json['isLikable'] as bool,
  client: json['client'] == null
      ? null
      : Client.fromJson(json['client'] as Map<String, dynamic>),
  checkin: Transport.fromJson(json['checkin'] as Map<String, dynamic>),
  event: json['event'] == null
      ? null
      : Event.fromJson(json['event'] as Map<String, dynamic>),
  user: LightUser.fromJson(json['user'] as Map<String, dynamic>),
  createdBy: json['createdBy'] == null
      ? null
      : LightUser.fromJson(json['createdBy'] as Map<String, dynamic>),
  tags: (json['tags'] as List<dynamic>)
      .map((e) => Tag.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
  'id': instance.id,
  'body': instance.body,
  'bodyMentions': instance.bodyMentions,
  'business': _$TripTypeEnumMap[instance.business]!,
  'visibility': _$TripVisibilityEnumEnumMap[instance.visibility]!,
  'likes': instance.likes,
  'liked': instance.liked,
  'isLikable': instance.isLikable,
  'client': instance.client,
  'checkin': instance.checkin,
  'event': instance.event,
  'user': instance.user,
  'createdBy': instance.createdBy,
  'tags': instance.tags,
  'createdAt': instance.createdAt,
};

const _$TripTypeEnumMap = {
  TripType.private: 0,
  TripType.commute: 2,
  TripType.business: 1,
};
