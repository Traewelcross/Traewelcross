import 'package:json_annotation/json_annotation.dart';

import 'package:traewelcross/enums/trip_type.dart';
import 'package:traewelcross/enums/trip_visibility.dart';

part "api_models.g.dart";

@JsonSerializable(fieldRename: .none)
class Tag {
  final String? key;
  final String? value;
  final TripVisibilityEnum? visibility;
  const Tag({required this.key, required this.value, required this.visibility});
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);
}

@JsonSerializable(fieldRename: .none)
class UserAuth extends User {
  @JsonKey(name: "likes_enabled")
  final bool? likesEnabled; // null for now, so when it get's renamed to likesEnabled, we don't throw an error because we can't find the field
  final String mapProvider;
  final Station? home;
  final String? language;
  final TripVisibilityEnum defaultStatusVisibility;
  final List<String>? roles;

  UserAuth({
    required super.id,
    required super.uuid,
    required super.displayName,
    required super.username,
    required super.profilePicture,
    required super.totalDistance,
    required super.totalDuration,
    required super.points,
    required super.privateProfile,
    required super.pointsEnabled,
    super.userInvisibleToMe = false,
    super.muted = false,
    super.blocked = false,
    super.following = false,
    super.followPending = false,
    super.followedBy = false,
    required super.preventIndex,
    super.bio,
    super.profileLinks,
    super.mastodonUrl,
    this.likesEnabled,
    required this.mapProvider,
    this.home,
    required this.defaultStatusVisibility,
    this.roles,
    this.language,
  }) : super();
  factory UserAuth.fromJson(Map<String, dynamic> json) =>
      _$UserAuthFromJson(json);
      @override
  Map<String, dynamic> toJson() => _$UserAuthToJson(this);
}

@JsonSerializable(fieldRename: .none)
class User {
  final int id;
  final String uuid;
  final String displayName;
  final String username;
  final String profilePicture;
  final int totalDistance;
  final int totalDuration;
  final int points;
  final String? mastodonUrl;
  final bool privateProfile;
  final bool pointsEnabled;
  final bool userInvisibleToMe;
  final bool muted;
  final bool blocked;
  final bool following;
  final bool followPending;
  final bool followedBy;
  final bool preventIndex;
  final String? bio;
  final List<ProfileLink>? profileLinks;
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

@JsonSerializable(fieldRename: .none)
class ProfileLink {
  final String name;
  final String url;
  const ProfileLink({required this.name, required this.url});
  factory ProfileLink.fromJson(Map<String, dynamic> json) =>
      _$ProfileLinkFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileLinkToJson(this);
}

@JsonSerializable(fieldRename: .none)
class Mention {
  final User user;
  final int position;
  final int length;
  const Mention({
    required this.user,
    required this.position,
    required this.length,
  });
  factory Mention.fromJson(Map<String, dynamic> json) =>
      _$MentionFromJson(json);
  Map<String, dynamic> toJson() => _$MentionToJson(this);
}

@JsonSerializable(fieldRename: .none)
class Client {
  final int id;
  final String name;
  final String? privacyPolicyUrl;
  const Client({
    required this.id,
    required this.name,
    required this.privacyPolicyUrl,
  });
  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
  Map<String, dynamic> toJson() => _$ClientToJson(this);
}

@JsonSerializable(fieldRename: .none)
class Stopover {
  final int id;
  final String name;
  final String? arrivalPlanned;
  final String? arrivalReal;
  final String? arrivalPlatformPlanned;
  final String? arrivalPlatformReal;
  final String? departurePlanned;
  final String? departureReal;
  final String? departurePlatformPlanned;
  final String? departurePlatformReal;
  final String? platform;
  final bool isArrivalDelayed;
  final bool isDepartureDelayed;
  final bool cancelled;
  const Stopover({
    required this.id,
    required this.name,
    this.arrivalPlanned,
    this.arrivalReal,
    this.arrivalPlatformPlanned,
    this.arrivalPlatformReal,
    this.departurePlanned,
    this.departureReal,
    this.departurePlatformPlanned,
    this.departurePlatformReal,
    this.platform,
    required this.isArrivalDelayed,
    required this.isDepartureDelayed,
    required this.cancelled,
  });
  factory Stopover.fromJson(Map<String, dynamic> json) =>
      _$StopoverFromJson(json);
  Map<String, dynamic> toJson() => _$StopoverToJson(this);
}

@JsonSerializable(fieldRename: .none)
class OperatorIdentifier {
  final String type;
  final String identifier;
  final String? name;
  const OperatorIdentifier({
    required this.type,
    required this.identifier,
    this.name,
  });
  factory OperatorIdentifier.fromJson(Map<String, dynamic> json) =>
      _$OperatorIdentifierFromJson(json);
  Map<String, dynamic> toJson() => _$OperatorIdentifierToJson(this);
}

@JsonSerializable(fieldRename: .none)
class Operator {
  final String type;
  final String uuid;
  final String name;
  final List<OperatorIdentifier> identifiers;
  const Operator({
    required this.type,
    required this.uuid,
    required this.name,
    required this.identifiers,
  });
  factory Operator.fromJson(Map<String, dynamic> json) =>
      _$OperatorFromJson(json);
  Map<String, dynamic> toJson() => _$OperatorToJson(this);
}

@JsonSerializable(fieldRename: .none)
class DataSource {
  final String id;
  final String attribution;
  const DataSource({required this.id, required this.attribution});
  factory DataSource.fromJson(Map<String, dynamic> json) =>
      _$DataSourceFromJson(json);
  Map<String, dynamic> toJson() => _$DataSourceToJson(this);
}

@JsonSerializable(fieldRename: .none)
class Transport {
  final int trip;
  final String hafasId;
  final String category;
  final String? mode;
  final String? number;
  final String lineName;
  final String? routeColor;
  final String? routeTextColor;
  final int? journeyNumber;
  final String? manualJourneyNumber;
  final int distance;
  final int points;
  final int duration;
  final String? manualDeparture;
  final String? manualArrival;
  final Stopover origin;
  final Stopover destination;
  final Operator? operator;
  final DataSource? dataSource;
  const Transport({
    required this.trip,
    required this.hafasId,
    required this.category,
    this.mode,
    this.number,
    required this.lineName,
    this.routeColor,
    this.routeTextColor,
    required this.journeyNumber,
    this.manualJourneyNumber,
    required this.distance,
    required this.points,
    required this.duration,
    this.manualDeparture,
    this.manualArrival,
    required this.origin,
    required this.destination,
    required this.operator,
    this.dataSource,
  });
  factory Transport.fromJson(Map<String, dynamic> json) =>
      _$TransportFromJson(json);
  Map<String, dynamic> toJson() => _$TransportToJson(this);
}

@JsonSerializable(fieldRename: .none)
class Area {
  final String name;
  @JsonKey(name: "default")
  final bool standard;
  final int adminLevel;
  const Area({
    required this.name,
    required this.standard,
    required this.adminLevel,
  });
  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);
  Map<String, dynamic> toJson() => _$AreaToJson(this);
}

@JsonSerializable(fieldRename: .none)
class StationIdentifier {
  final String type;
  final String identifier;
  final String? name;
  final String? origin;
  const StationIdentifier({
    required this.type,
    required this.identifier,
    this.name,
    this.origin,
  });
  factory StationIdentifier.fromJson(Map<String, dynamic> json) =>
      _$StationIdentifierFromJson(json);
  Map<String, dynamic> toJson() => _$StationIdentifierToJson(this);
}

@JsonSerializable(fieldRename: .none)
class Station {
  final int id;
  final String name;
  final num latitude;
  final num longitude;
  final List<Area>? areas;
  final List<StationIdentifier>? identifiers;
  @JsonKey(name: "time_offset")
  final int? timeOffset;
  @JsonKey(name: "created_at")
  final String? createdAt;
  const Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.areas,
    required this.identifiers,
    this.timeOffset,
    this.createdAt,
  });
  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);
  Map<String, dynamic> toJson() => _$StationToJson(this);
}

@JsonSerializable(fieldRename: .none)
class Event {
  final int id;
  final String name;
  final String slug;
  final String? hashtag;
  final String? host;
  final String? url;
  final String begin;
  final String end;
  final bool isPride;
  final Station? station;
  const Event({
    required this.id,
    required this.name,
    required this.slug,
    this.hashtag,
    this.host,
    this.url,
    required this.begin,
    required this.end,
    required this.isPride,
    this.station,
  });
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}

@JsonSerializable(fieldRename: .none)
class LightUserMastodon {
  final String? server;
  @JsonKey(name: "user_id")
  final int? userId;
  const LightUserMastodon({required this.server, required this.userId});
  factory LightUserMastodon.fromJson(Map<String, dynamic> json) =>
      _$LightUserMastodonFromJson(json);
  Map<String, dynamic> toJson() => _$LightUserMastodonToJson(this);
}

@JsonSerializable(fieldRename: .none)
class LightUser {
  final int id;
  final String uuid;
  final String displayName;
  final String username;
  final String profilePicture;
  final LightUserMastodon? mastodon;
  final bool preventIndex;
  const LightUser({
    required this.id,
    required this.uuid,
    required this.displayName,
    required this.username,
    required this.profilePicture,
    this.mastodon,
    required this.preventIndex,
  });
  factory LightUser.fromJson(Map<String, dynamic> json) =>
      _$LightUserFromJson(json);
  Map<String, dynamic> toJson() => _$LightUserToJson(this);

  /// Return LightUser info in a User format, wonky but good enough (hopefully)
  User promoteToUser() {
    return User(
      id: id,
      uuid: uuid,
      displayName: displayName,
      username: username,
      profilePicture: profilePicture,
      totalDistance: 0,
      totalDuration: 0,
      points: 0,
      privateProfile: false,
      pointsEnabled: true,
      userInvisibleToMe: false,
      muted: false,
      blocked: false,
      following: false,
      followPending: false,
      followedBy: false,
      preventIndex: preventIndex,
      bio: "",
      profileLinks: [],
    );
  }
}

@JsonSerializable(fieldRename: .none)
class Status {
  final int id;
  final String body;
  final List<Mention> bodyMentions;
  final TripType business;
  final TripVisibilityEnum visibility;
  int likes;
  bool liked;
  final bool isLikable;
  final Client? client;
  final Transport checkin;
  final Event? event;
  final LightUser user;
  final LightUser? createdBy;
  final List<Tag> tags;
  final String createdAt;
  Status({
    required this.id,
    required this.body,
    required this.bodyMentions,
    required this.business,
    required this.visibility,
    required this.likes,
    required this.liked,
    required this.isLikable,
    required this.client,
    required this.checkin,
    this.event,
    required this.user,
    this.createdBy,
    required this.tags,
    required this.createdAt,
  });
  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);
  Map<String, dynamic> toJson() => _$StatusToJson(this);
}

class GenericStatusResponse {
  final bool wasSuccess;
  final String? body;
  const GenericStatusResponse({required this.wasSuccess, this.body});
}

class GenericStatusResponseWithObject extends GenericStatusResponse {
  final dynamic object;

  GenericStatusResponseWithObject({required super.wasSuccess, required this.object});
}