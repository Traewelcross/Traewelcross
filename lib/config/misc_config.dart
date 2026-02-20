import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:traewelcross/config/enums/account_type_enum.dart';
part 'misc_config.g.dart';

@JsonSerializable()
class MiscConfig with ChangeNotifier {
  MiscConfig();
  factory MiscConfig.fromJson(Map<String, dynamic> json) =>
      _$MiscConfigFromJson(json);
  Map<String, dynamic> toJson() => _$MiscConfigToJson(this);

  /// Träwelling or travelynx account? (Currently only Träwelling is supported)
  AccountTypeEnum _accountType = AccountTypeEnum.traewelling;
  @JsonKey(defaultValue: AccountTypeEnum.traewelling)
  AccountTypeEnum get accountType => _accountType;
  set accountType(AccountTypeEnum value) {
    _accountType = value;
    notifyListeners();
  }

  /// Is the statistics tab enabled?
  /// TODO: remove once feature complete
  bool _showStats = false;
  @JsonKey(defaultValue: false)
  bool get showStats => _showStats;
  set showStats(bool val) {
    _showStats = val;
    notifyListeners();
  }

  /// This option is (obivously) not exposed to the user, but used internally
  /// Putting this is the Config is maybe not quite right, but since we have something to persist data,
  /// might as well use it, eh?
  /// This option is used for prompting the user to login in again, if needed
  DateTime? _lastBoot;
  @JsonKey(defaultValue: null)
  DateTime? get lastBoot => _lastBoot;
  set lastBoot(DateTime? dt) {
    _lastBoot = dt;
    notifyListeners();
  }

  /// "Notifier" for option above
  bool _needsRelogin = false;
  @JsonKey(defaultValue: false)
  bool get needsRelogin => _needsRelogin;
  set needsRelogin(bool val) {
    _needsRelogin = val;
    notifyListeners();
  }
}
