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
  TripVisibilityEnum.trusted: 5,
  TripVisibilityEnum.notListed: 1,
  TripVisibilityEnum.private: 3,
};

UserAuth _$UserAuthFromJson(Map<String, dynamic> json) => UserAuth(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String?,
  displayName: json['displayName'] as String,
  username: json['username'] as String,
  profilePicture: json['profilePicture'] as String,
  totalDistance: (json['totalDistance'] as num).toInt(),
  totalDuration: (json['totalDuration'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  privateProfile: json['privateProfile'] as bool,
  pointsEnabled: json['pointsEnabled'] as bool?,
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
  'likes_enabled': instance.likesEnabled,
  'userInvisibleToMe': instance.userInvisibleToMe,
  'muted': instance.muted,
  'blocked': instance.blocked,
  'following': instance.following,
  'followPending': instance.followPending,
  'followedBy': instance.followedBy,
  'preventIndex': instance.preventIndex,
  'bio': instance.bio,
  'profileLinks': instance.profileLinks,
  'mapProvider': instance.mapProvider,
  'home': instance.home,
  'language': instance.language,
  'defaultStatusVisibility':
      _$TripVisibilityEnumEnumMap[instance.defaultStatusVisibility]!,
  'roles': instance.roles,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String?,
  displayName: json['displayName'] as String,
  username: json['username'] as String,
  profilePicture: json['profilePicture'] as String,
  totalDistance: (json['totalDistance'] as num).toInt(),
  totalDuration: (json['totalDuration'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  mastodonUrl: json['mastodonUrl'] as String?,
  privateProfile: json['privateProfile'] as bool,
  pointsEnabled: json['pointsEnabled'] as bool?,
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
  likesEnabled: json['likes_enabled'] as bool?,
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
  'likes_enabled': instance.likesEnabled,
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
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
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
  station: Station.fromJson(json['station'] as Map<String, dynamic>),
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
  'station': instance.station,
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
  identifiers: (json['identifiers'] as List<dynamic>?)
      ?.map((e) => OperatorIdentifier.fromJson(e as Map<String, dynamic>))
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

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
  id: json['id'] as String,
  type: json['type'] as String,
  lead: json['lead'] as String,
  leadFormatted: json['leadFormatted'] as String?,
  noticeFormatted: json['noticeFormatted'] as String?,
  notice: json['notice'] as String?,
  link: json['link'] as String?,
  data: json['data'],
  readAt: json['readAt'] as String?,
  createdAt: json['createdAt'] as String,
  createdAtForHumans: json['createdAtForHumans'] as String,
);

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'lead': instance.lead,
      'leadFormatted': instance.leadFormatted,
      'noticeFormatted': instance.noticeFormatted,
      'notice': instance.notice,
      'link': instance.link,
      'data': instance.data,
      'readAt': instance.readAt,
      'createdAt': instance.createdAt,
      'createdAtForHumans': instance.createdAtForHumans,
    };

CheckInRequest _$CheckInRequestFromJson(Map<String, dynamic> json) =>
    CheckInRequest(
      json['body'] as String?,
      $enumDecodeNullable(_$TripTypeEnumMap, json['business']),
      $enumDecodeNullable(_$TripVisibilityEnumEnumMap, json['visibility']),
      (json['eventId'] as num?)?.toInt(),
      json['toot'] as bool?,
      json['chainPost'] as bool?,
      json['tripId'] as String?,
      json['lineName'] as String?,
      (json['start'] as num?)?.toInt(),
      (json['destination'] as num?)?.toInt(),
      json['departure'] as String?,
      json['arrival'] as String?,
      json['force'] as bool,
      (json['with'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
    );

Map<String, dynamic> _$CheckInRequestToJson(CheckInRequest instance) =>
    <String, dynamic>{
      'body': instance.body,
      'business': _$TripTypeEnumMap[instance.business],
      'visibility': _$TripVisibilityEnumEnumMap[instance.visibility],
      'eventId': instance.eventId,
      'toot': instance.toot,
      'chainPost': instance.chainPost,
      'tripId': instance.tripId,
      'lineName': instance.lineName,
      'start': instance.start,
      'destination': instance.destination,
      'departure': instance.departure,
      'arrival': instance.arrival,
      'force': instance.force,
      'with': instance.alsoCheckIn,
    };

PointsCalculation _$PointsCalculationFromJson(Map<String, dynamic> json) =>
    PointsCalculation(
      base: (json['base'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      factor: (json['factor'] as num).toDouble(),
      reason: (json['reason'] as num).toInt(),
    );

Map<String, dynamic> _$PointsCalculationToJson(PointsCalculation instance) =>
    <String, dynamic>{
      'base': instance.base,
      'distance': instance.distance,
      'factor': instance.factor,
      'reason': instance.reason,
    };

Points _$PointsFromJson(Map<String, dynamic> json) => Points(
  points: (json['points'] as num).toInt(),
  calculation: PointsCalculation.fromJson(
    json['calculation'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PointsToJson(Points instance) => <String, dynamic>{
  'points': instance.points,
  'calculation': instance.calculation,
};

CheckinResponse _$CheckinResponseFromJson(Map<String, dynamic> json) =>
    CheckinResponse(
      points: Points.fromJson(json['points'] as Map<String, dynamic>),
      alsoOnThisConnection: (json['alsoOnThisConnection'] as List<dynamic>?)
          ?.map((e) => Status.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: Status.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckinResponseToJson(CheckinResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'alsoOnThisConnection': instance.alsoOnThisConnection,
      'points': instance.points,
    };

Alert _$AlertFromJson(Map<String, dynamic> json) => Alert(
  id: json['id'] as String,
  type: $enumDecode(_$AlertTypesEnumMap, json['type']),
  activeUntil: json['active_until'] as String?,
  activeFrom: json['active_from'] as String,
  url: json['url'] as String?,
  translations: (json['translations'] as List<dynamic>)
      .map((e) => AlertTranslation.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AlertToJson(Alert instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$AlertTypesEnumMap[instance.type]!,
  'active_from': instance.activeFrom,
  'active_until': instance.activeUntil,
  'url': instance.url,
  'translations': instance.translations,
};

const _$AlertTypesEnumMap = {
  AlertTypes.info: 'info',
  AlertTypes.warning: 'warning',
  AlertTypes.danger: 'danger',
  AlertTypes.success: 'success',
};

AlertTranslation _$AlertTranslationFromJson(Map<String, dynamic> json) =>
    AlertTranslation(
      title: json['title'] as String,
      content: json['content'] as String,
      url: json['url'] as String?,
      locale: json['locale'] as String,
    );

Map<String, dynamic> _$AlertTranslationToJson(AlertTranslation instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'url': instance.url,
      'locale': instance.locale,
    };

TrustedUser _$TrustedUserFromJson(Map<String, dynamic> json) => TrustedUser(
  user: LightUser.fromJson(json['user'] as Map<String, dynamic>),
  expiresAt: json['expiresAt'] as String?,
);

Map<String, dynamic> _$TrustedUserToJson(TrustedUser instance) =>
    <String, dynamic>{'user': instance.user, 'expiresAt': instance.expiresAt};

Departure _$DepartureFromJson(Map<String, dynamic> json) => Departure(
  tripId: json['tripId'] as String,
  when: json['when'] as String?,
  plannedWhen: json['plannedWhen'] as String,
  platform: json['platform'] as String?,
  plannedPlatform: json['plannedPlatform'] as String?,
  direction: json['direction'] as String,
  line: json['line'] == null
      ? null
      : LineResource.fromJson(json['line'] as Map<String, dynamic>),
  cancelled: json['cancelled'] as bool,
  station: Station.fromJson(json['station'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DepartureToJson(Departure instance) => <String, dynamic>{
  'tripId': instance.tripId,
  'when': instance.when,
  'plannedWhen': instance.plannedWhen,
  'platform': instance.platform,
  'plannedPlatform': instance.plannedPlatform,
  'direction': instance.direction,
  'line': instance.line,
  'cancelled': instance.cancelled,
  'station': instance.station,
};

LineResource _$LineResourceFromJson(Map<String, dynamic> json) => LineResource(
  type: json['type'] as String?,
  id: json['id'] as String?,
  fahrtNr: json['fahrtNr'] as String?,
  name: json['name'] as String?,
  color: json['color'] as String?,
  textColor: json['textColor'] as String?,
  mode: json['mode'] as String?,
  product: json['product'] as String?,
);

Map<String, dynamic> _$LineResourceToJson(LineResource instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'fahrtNr': instance.fahrtNr,
      'name': instance.name,
      'color': instance.color,
      'textColor': instance.textColor,
      'mode': instance.mode,
      'product': instance.product,
    };

TripResource _$TripResourceFromJson(Map<String, dynamic> json) => TripResource(
  id: (json['id'] as num).toInt(),
  tripId: json['tripId'] as String,
  category: json['category'] as String,
  mode: json['mode'] as String?,
  routeColor: json['routeColor'] as String?,
  routeTextColor: json['routeTextColor'] as String?,
  operator: json['operator'] == null
      ? null
      : Operator.fromJson(json['operator'] as Map<String, dynamic>),
  number: json['number'] as String,
  lineName: json['lineName'] as String,
  journeyNumber: (json['journeyNumber'] as num?)?.toInt(),
  origin: Station.fromJson(json['origin'] as Map<String, dynamic>),
  destination: Station.fromJson(json['destination'] as Map<String, dynamic>),
  stopovers: (json['stopovers'] as List<dynamic>)
      .map((e) => Stopover.fromJson(e as Map<String, dynamic>))
      .toList(),
  dataSource: json['dataSource'] == null
      ? null
      : DataSource.fromJson(json['dataSource'] as Map<String, dynamic>),
  continuationTrip: json['continuationTrip'] == null
      ? null
      : TripResource.fromJson(json['continuationTrip'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TripResourceToJson(TripResource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tripId': instance.tripId,
      'category': instance.category,
      'mode': instance.mode,
      'routeColor': instance.routeColor,
      'routeTextColor': instance.routeTextColor,
      'number': instance.number,
      'lineName': instance.lineName,
      'journeyNumber': instance.journeyNumber,
      'origin': instance.origin,
      'operator': instance.operator,
      'destination': instance.destination,
      'stopovers': instance.stopovers,
      'dataSource': instance.dataSource,
      'continuationTrip': instance.continuationTrip,
    };

TripDraft _$TripDraftFromJson(Map<String, dynamic> json) => TripDraft(
  category: $enumDecodeNullable(_$DepartTypesEnumMap, json['category']),
  lineName: json['lineName'] as String?,
  journeyNumber: (json['journeyNumber'] as num?)?.toInt(),
  operatorId: json['operatorId'] as String?,
  originId: (json['originId'] as num?)?.toInt(),
  originDeparturePlanned: json['originDeparturePlanned'] as String?,
  destinationId: (json['destinationId'] as num?)?.toInt(),
  destinationArrivalPlanned: json['destinationArrivalPlanned'] as String?,
  stopovers: (json['stopovers'] as List<dynamic>?)
      ?.map((e) => StopoverDraft.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TripDraftToJson(TripDraft instance) => <String, dynamic>{
  'category': _$DepartTypesEnumMap[instance.category],
  'lineName': instance.lineName,
  'journeyNumber': instance.journeyNumber,
  'operatorId': instance.operatorId,
  'originId': instance.originId,
  'originDeparturePlanned': instance.originDeparturePlanned,
  'destinationId': instance.destinationId,
  'destinationArrivalPlanned': instance.destinationArrivalPlanned,
  'stopovers': instance.stopovers,
};

const _$DepartTypesEnumMap = {
  DepartTypes.express: 'express',
  DepartTypes.nationalExpress: 'nationalExpress',
  DepartTypes.national: 'national',
  DepartTypes.regionalExp: 'regionalExp',
  DepartTypes.regional: 'regional',
  DepartTypes.subUrban: 'suburban',
  DepartTypes.subway: 'subway',
  DepartTypes.tram: 'tram',
  DepartTypes.bus: 'bus',
  DepartTypes.ferry: 'ferry',
  DepartTypes.taxi: 'taxi',
  DepartTypes.plane: 'plane',
  DepartTypes.freightTrain: 'freightTrain',
  DepartTypes.all: 'all',
};

StopoverDraft _$StopoverDraftFromJson(Map<String, dynamic> json) =>
    StopoverDraft(
      stationId: (json['stationId'] as num).toInt(),
      arrival: json['arrival'] as String?,
      name: json['name'] as String,
      departure: json['departure'] as String,
    );

Map<String, dynamic> _$StopoverDraftToJson(StopoverDraft instance) =>
    <String, dynamic>{
      'stationId': instance.stationId,
      'arrival': instance.arrival,
      'departure': instance.departure,
    };

MastoCustomEmoji _$MastoCustomEmojiFromJson(Map<String, dynamic> json) =>
    MastoCustomEmoji(
      shortcode: json['shortcode'] as String,
      url: json['url'] as String,
      staticUrl: json['static_url'] as String,
    );

Map<String, dynamic> _$MastoCustomEmojiToJson(MastoCustomEmoji instance) =>
    <String, dynamic>{
      'shortcode': instance.shortcode,
      'url': instance.url,
      'static_url': instance.staticUrl,
    };

UserProfileSettings _$UserProfileSettingsFromJson(Map<String, dynamic> json) =>
    UserProfileSettings(
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      profilePicture: json['profilePicture'] as String,
      privateProfile: json['privateProfile'] as bool,
      preventIndex: json['preventIndex'] as bool,
      defaultStatusVisibility: $enumDecode(
        _$TripVisibilityEnumEnumMap,
        json['defaultStatusVisibility'],
      ),
      privacyHideDays: (json['privacyHideDays'] as num?)?.toInt(),
      password: json['password'] as bool,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool,
      profilePictureSet: json['profilePictureSet'] as bool,
      mastodon: json['mastodon'] as String?,
      mastodonVisibility: $enumDecode(
        _$MastodonVisibilityEnumMap,
        json['mastodonVisibility'],
      ),
      friendCheckin: json['friendCheckin'] as String,
      likesEnabled: json['likesEnabled'] as bool,
      pointsEnabled: json['pointsEnabled'] as bool,
      timezone: json['timezone'] as String,
      bio: json['bio'] as String?,
      profileLinks: (json['profileLinks'] as List<dynamic>?)
          ?.map((e) => ProfileLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      experimental: json['experimental'] as bool,
    );

Map<String, dynamic> _$UserProfileSettingsToJson(
  UserProfileSettings instance,
) => <String, dynamic>{
  'username': instance.username,
  'displayName': instance.displayName,
  'profilePicture': instance.profilePicture,
  'privateProfile': instance.privateProfile,
  'preventIndex': instance.preventIndex,
  'defaultStatusVisibility':
      _$TripVisibilityEnumEnumMap[instance.defaultStatusVisibility]!,
  'privacyHideDays': instance.privacyHideDays,
  'password': instance.password,
  'email': instance.email,
  'emailVerified': instance.emailVerified,
  'profilePictureSet': instance.profilePictureSet,
  'mastodon': instance.mastodon,
  'mastodonVisibility':
      _$MastodonVisibilityEnumMap[instance.mastodonVisibility]!,
  'friendCheckin': instance.friendCheckin,
  'likesEnabled': instance.likesEnabled,
  'pointsEnabled': instance.pointsEnabled,
  'timezone': instance.timezone,
  'bio': instance.bio,
  'profileLinks': instance.profileLinks,
  'experimental': instance.experimental,
};

const _$MastodonVisibilityEnumMap = {
  MastodonVisibility.public: 0,
  MastodonVisibility.followerOnly: 2,
  MastodonVisibility.notListed: 1,
  MastodonVisibility.private: 3,
};

RouteMapEntry _$RouteMapEntryFromJson(Map<String, dynamic> json) =>
    RouteMapEntry(
      routeSegmentId: json['routeSegmentId'] as String?,
      polyline: json['polyline'] as String,
      polylinePrecision: (json['polylinePrecision'] as num).toInt(),
      distance: (json['distance'] as num?)?.toInt(),
      pathType: json['pathType'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      approximated: json['approximated'] as bool?,
    );

Map<String, dynamic> _$RouteMapEntryToJson(RouteMapEntry instance) =>
    <String, dynamic>{
      'routeSegmentId': instance.routeSegmentId,
      'polyline': instance.polyline,
      'polylinePrecision': instance.polylinePrecision,
      'distance': instance.distance,
      'pathType': instance.pathType,
      'categories': instance.categories,
      'approximated': instance.approximated,
    };

StatisticsOverview _$StatisticsOverviewFromJson(Map<String, dynamic> json) =>
    StatisticsOverview(
      totalCheckins: (json['total_checkins'] as num).toInt(),
      activeDays: (json['active_days'] as num).toInt(),
      totalDistanceKm: (json['total_distance_km'] as num).toDouble(),
      meanDistanceKm: (json['mean_distance_km'] as num).toDouble(),
      longestCheckinByDistance: json['longest_checkin_by_distance'] == null
          ? null
          : Status.fromJson(
              json['longest_checkin_by_distance'] as Map<String, dynamic>,
            ),
      shortestCheckinByDistance: json['shortest_checkin_by_distance'] == null
          ? null
          : Status.fromJson(
              json['shortest_checkin_by_distance'] as Map<String, dynamic>,
            ),
      longestCheckinByDuration: json['longest_checkin_by_duration'] == null
          ? null
          : Status.fromJson(
              json['longest_checkin_by_duration'] as Map<String, dynamic>,
            ),
      shortestCheckinByDuration: json['shortest_checkin_by_duration'] == null
          ? null
          : Status.fromJson(
              json['shortest_checkin_by_duration'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$StatisticsOverviewToJson(StatisticsOverview instance) =>
    <String, dynamic>{
      'total_checkins': instance.totalCheckins,
      'active_days': instance.activeDays,
      'total_distance_km': instance.totalDistanceKm,
      'mean_distance_km': instance.meanDistanceKm,
      'longest_checkin_by_distance': instance.longestCheckinByDistance,
      'shortest_checkin_by_distance': instance.shortestCheckinByDistance,
      'longest_checkin_by_duration': instance.longestCheckinByDuration,
      'shortest_checkin_by_duration': instance.shortestCheckinByDuration,
    };

StatisticsHistory _$StatisticsHistoryFromJson(Map<String, dynamic> json) =>
    StatisticsHistory(
      yearly: (json['yearly'] as List<dynamic>?)
          ?.map(
            (e) =>
                StatisticsHistoryListEntry.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      monthly: (json['monthly'] as List<dynamic>?)
          ?.map(
            (e) =>
                StatisticsHistoryListEntry.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      weekly: (json['weekly'] as List<dynamic>?)
          ?.map(
            (e) =>
                StatisticsHistoryListEntry.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$StatisticsHistoryToJson(StatisticsHistory instance) =>
    <String, dynamic>{
      'yearly': instance.yearly,
      'monthly': instance.monthly,
      'weekly': instance.weekly,
    };

StatisticsHistoryListEntry _$StatisticsHistoryListEntryFromJson(
  Map<String, dynamic> json,
) => StatisticsHistoryListEntry(
  period: json['period'] as String,
  periodType: json['period_type'] as String,
  checkinCount: (json['checkin_count'] as num).toInt(),
  distanceKm: (json['distance_km'] as num).toDouble(),
);

Map<String, dynamic> _$StatisticsHistoryListEntryToJson(
  StatisticsHistoryListEntry instance,
) => <String, dynamic>{
  'period': instance.period,
  'period_type': instance.periodType,
  'checkin_count': instance.checkinCount,
  'distance_km': instance.distanceKm,
};

StatisticsFavorites _$StatisticsFavoritesFromJson(
  Map<String, dynamic> json,
) => StatisticsFavorites(
  stations: (json['stations'] as List<dynamic>?)
      ?.map(
        (e) => StatisticsFavoritesStation.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  lines: (json['lines'] as List<dynamic>?)
      ?.map((e) => StatisticsFavoritesLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  routes: (json['routes'] as List<dynamic>?)
      ?.map((e) => StatisticsFavoritesRoute.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StatisticsFavoritesToJson(
  StatisticsFavorites instance,
) => <String, dynamic>{
  'stations': instance.stations,
  'lines': instance.lines,
  'routes': instance.routes,
};

StatisticsFavoritesStation _$StatisticsFavoritesStationFromJson(
  Map<String, dynamic> json,
) => StatisticsFavoritesStation(
  stationId: (json['station_id'] as num).toInt(),
  name: json['name'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$StatisticsFavoritesStationToJson(
  StatisticsFavoritesStation instance,
) => <String, dynamic>{
  'station_id': instance.stationId,
  'name': instance.name,
  'count': instance.count,
};

StatisticsFavoritesLine _$StatisticsFavoritesLineFromJson(
  Map<String, dynamic> json,
) => StatisticsFavoritesLine(
  linename: json['linename'] as String,
  number: json['number'] as String,
  count: (json['count'] as num).toInt(),
  distanceKm: (json['distance_km'] as num).toDouble(),
);

Map<String, dynamic> _$StatisticsFavoritesLineToJson(
  StatisticsFavoritesLine instance,
) => <String, dynamic>{
  'linename': instance.linename,
  'number': instance.number,
  'count': instance.count,
  'distance_km': instance.distanceKm,
};

StatisticsFavoritesRoute _$StatisticsFavoritesRouteFromJson(
  Map<String, dynamic> json,
) => StatisticsFavoritesRoute(
  originId: (json['origin_id'] as num).toInt(),
  origin: json['origin'] as String,
  destinationId: (json['destination_id'] as num).toInt(),
  destination: json['destination'] as String,
  count: (json['count'] as num).toInt(),
  distanceKm: (json['distance_km'] as num).toDouble(),
);

Map<String, dynamic> _$StatisticsFavoritesRouteToJson(
  StatisticsFavoritesRoute instance,
) => <String, dynamic>{
  'origin_id': instance.originId,
  'origin': instance.origin,
  'destination_id': instance.destinationId,
  'destination': instance.destination,
  'count': instance.count,
  'distance_km': instance.distanceKm,
};

StatisticsPersonal _$StatisticsPersonalFromJson(Map<String, dynamic> json) =>
    StatisticsPersonal(
      purpose: (json['purpose'] as List<dynamic>?)
          ?.map(
            (e) =>
                StatisticsPersonalPurpose.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map(
            (e) =>
                StatisticsPersonalCategory.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      operators: (json['operators'] as List<dynamic>?)
          ?.map(
            (e) =>
                StatisticsPersonalOperator.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      time: (json['time'] as List<dynamic>?)
          ?.map(
            (e) => StatisticsPersonalTime.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$StatisticsPersonalToJson(StatisticsPersonal instance) =>
    <String, dynamic>{
      'purpose': instance.purpose,
      'categories': instance.categories,
      'operators': instance.operators,
      'time': instance.time,
    };

StatisticsPersonalPurpose _$StatisticsPersonalPurposeFromJson(
  Map<String, dynamic> json,
) => StatisticsPersonalPurpose(
  name: (json['name'] as num).toInt(),
  count: (json['count'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
);

Map<String, dynamic> _$StatisticsPersonalPurposeToJson(
  StatisticsPersonalPurpose instance,
) => <String, dynamic>{
  'name': instance.name,
  'count': instance.count,
  'duration': instance.duration,
};

StatisticsPersonalCategory _$StatisticsPersonalCategoryFromJson(
  Map<String, dynamic> json,
) => StatisticsPersonalCategory(
  name: $enumDecode(_$DepartTypesEnumMap, json['name']),
  count: (json['count'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
);

Map<String, dynamic> _$StatisticsPersonalCategoryToJson(
  StatisticsPersonalCategory instance,
) => <String, dynamic>{
  'name': _$DepartTypesEnumMap[instance.name]!,
  'count': instance.count,
  'duration': instance.duration,
};

StatisticsPersonalOperator _$StatisticsPersonalOperatorFromJson(
  Map<String, dynamic> json,
) => StatisticsPersonalOperator(
  name: json['name'] as String?,
  count: (json['count'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
);

Map<String, dynamic> _$StatisticsPersonalOperatorToJson(
  StatisticsPersonalOperator instance,
) => <String, dynamic>{
  'name': instance.name,
  'count': instance.count,
  'duration': instance.duration,
};

StatisticsPersonalTime _$StatisticsPersonalTimeFromJson(
  Map<String, dynamic> json,
) => StatisticsPersonalTime(
  date: DateTime.parse(json['date'] as String),
  count: (json['count'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
);

Map<String, dynamic> _$StatisticsPersonalTimeToJson(
  StatisticsPersonalTime instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'count': instance.count,
  'duration': instance.duration,
};
