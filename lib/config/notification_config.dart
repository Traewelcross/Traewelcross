import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'notification_config.g.dart';

@JsonSerializable()
class NotificationConfig with ChangeNotifier {
  NotificationConfig();
  factory NotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$NotificationConfigFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationConfigToJson(this);

  bool _notificationsEnabled = false;
  @JsonKey(defaultValue: false)
  bool get notificationsEnabled => _notificationsEnabled;
  set notificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  bool _notificationsAvailable = false;
  @JsonKey(defaultValue: false)
  bool get notificationsAvailable => _notificationsAvailable;
  set notificationsAvailable(bool value) {
    _notificationsAvailable = value;
    notifyListeners();
  }

  String _fcmToken = "";
  @JsonKey(defaultValue: "")
  String get fcmToken => _fcmToken;
  set fcmToken(String value) {
    _fcmToken = value;
    notifyListeners();
  }

  bool _hasBeenRegistered = false;
  @JsonKey(defaultValue: false)
  bool get hasBeenRegistered => _hasBeenRegistered;
  set hasBeenRegistered(bool value) {
    _hasBeenRegistered = value;
    notifyListeners();
  }
}
