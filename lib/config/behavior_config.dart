import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'behavior_config.g.dart';

@JsonSerializable()
class BehaviorConfig with ChangeNotifier {
  BehaviorConfig();
  factory BehaviorConfig.fromJson(Map<String, dynamic> json) =>
      _$BehaviorConfigFromJson(json);
  Map<String, dynamic> toJson() => _$BehaviorConfigToJson(this);

  /// If the timestamp in ride_view_quick.dart is pressed, should the time be overwritten or select_connection.dart for the appropriate timestamp and station?
  bool _overrideOnTimeTap = true;
  @JsonKey(defaultValue: true)
  bool get overrideOnTimeTap => _overrideOnTimeTap;
  set overrideOnTimeTap(bool value) {
    _overrideOnTimeTap = value;
    notifyListeners();
  }

  /// If overrideOnTimeTap is active, this is the delay needed to not display system time but planned time instead
  /// Example:
  /// Departure: 10:15; System time: 10:20; Delay: 15 min -> If Timestamp is tapped, system time will be prefilled
  /// If System time were 10:40 though, instead of system time, planned time is used instead
  /// Can be disabled by setting to a negative value
  /// disabled by default
  int _delaySystemTimeOverride = -1;
  @JsonKey(defaultValue: -1)
  int get delaySystemTimeOverride => _delaySystemTimeOverride;
  set delaySystemTimeOverride(int val) {
    _delaySystemTimeOverride = val;
    notifyListeners();
  }

  /// Confirm deletion?
  bool _confirmDelete = true;
  @JsonKey(defaultValue: true)
  bool get confirmDelete => _confirmDelete;
  set confirmDelete(bool value) {
    _confirmDelete = value;
    notifyListeners();
  }

  /// If the planned time differs from the actual time provided by the API BUT the override equals the planned time, the override shouldn't be displayed.
  /// This seems to be the behavior on the official traewelling.de site
  /// If active, override will be hidden if: manual = planned (api) ≠ real (api)
  bool _hideManualOnTimeOverride = true;
  @JsonKey(defaultValue: true)
  bool get hideManualOnTimeOverride => _hideManualOnTimeOverride;
  set hideManualOnTimeOverride(bool value) {
    _hideManualOnTimeOverride = value;
    notifyListeners();
  }

  String? _defaultStatusText;
  @JsonKey(defaultValue: null)
  String? get defaultStatusText => _defaultStatusText;
  set defaultStatusText(String? value) {
    _defaultStatusText = value;
    notifyListeners();
  }

  static const _volChan = MethodChannel("volume");

  /// Can the user control the App via the volume buttons
  /// Experimental!
  bool _volumeBtnCtrl = false;
  @JsonKey(defaultValue: false)
  bool get volumeBtnCtrl => _volumeBtnCtrl;
  set volumeBtnCtrl(bool val) {
    _volumeBtnCtrl = val;
    if (Platform.isAndroid)
      _volChan.invokeMethod("setOverrideStatus", {"val": val});
    notifyListeners();
  }
}
