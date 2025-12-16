import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traewelcross/config/appearance_config.dart';
import 'package:traewelcross/config/behavior_config.dart';
import 'package:traewelcross/config/misc_config.dart';
import 'package:traewelcross/config/notification_config.dart';
part 'config.g.dart';

@JsonSerializable()
class Config with ChangeNotifier {
  Config() {
    appearance.addListener(_onConfigChanged);
    behavior.addListener(_onConfigChanged);
    misc.addListener(_onConfigChanged);
    notification.addListener(_onConfigChanged);
  }
  @JsonKey(defaultValue: AppearanceConfig.new)
  AppearanceConfig appearance = AppearanceConfig();
  @JsonKey(defaultValue: BehaviorConfig.new)
  BehaviorConfig behavior = BehaviorConfig();
  @JsonKey(defaultValue: MiscConfig.new)
  MiscConfig misc = MiscConfig();
  @JsonKey(defaultValue: NotificationConfig.new)
  NotificationConfig notification = NotificationConfig();

  void _onConfigChanged() {
    saveCofig();
    notifyListeners();
  }

  Future<void> saveCofig() async {
    final jString = jsonEncode(this.toJson());
    SharedPreferencesAsync().setString("config", jString);
  }

  static Future<Config> getConfig() async {
    final jString = await SharedPreferencesAsync().getString("config");
    if (jString == null) {
      return Config();
    } else {
      return Config.fromJson(jsonDecode(jString));
    }
  }

  @override
  void dispose() {
    appearance.removeListener(_onConfigChanged);
    behavior.removeListener(_onConfigChanged);
    misc.removeListener(_onConfigChanged);
    notification.removeListener(_onConfigChanged);
    super.dispose();
  }

  factory Config.fromJson(Map<String, dynamic> json) {
    final config = _$ConfigFromJson(json);
    config.appearance.addListener(config._onConfigChanged);
    config.behavior.addListener(config._onConfigChanged);
    config.misc.addListener(config._onConfigChanged);
    config.notification.addListener(config._onConfigChanged);
    return config;
  }
  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
