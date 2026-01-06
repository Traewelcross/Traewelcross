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
  set showStats(bool val){
    _showStats = val;
    notifyListeners();
  }
}
