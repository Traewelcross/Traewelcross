import 'package:material_ui/material_ui.dart';
import 'package:json_annotation/json_annotation.dart';

part "dialog_config.g.dart";

@JsonSerializable()
class DialogConfig with ChangeNotifier {
  DialogConfig();
  factory DialogConfig.fromJson(Map<String, dynamic> json) =>
      _$DialogConfigFromJson(json);
  Map<String, dynamic> toJson() => _$DialogConfigToJson(this);

  /// Show manual trip creation dialog
  bool _manaulTripInfo = true;
  @JsonKey(defaultValue: true)
  bool get manualTripInfo => _manaulTripInfo;
  set manualTripInfo(bool val){
    _manaulTripInfo = val;
    notifyListeners();
  }
  int _notifyFixInfoDisplayCount = 0;
  @JsonKey(defaultValue: 0)
  int get notifyFixInfoDisplayCount => _notifyFixInfoDisplayCount;
  set notifyFixInfoDisplayCount(int val){
    _notifyFixInfoDisplayCount = val;
    notifyListeners();
  }
}