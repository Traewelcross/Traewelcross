import 'package:material_ui/material_ui.dart';
import 'package:json_annotation/json_annotation.dart';
part 'language_config.g.dart';

@JsonSerializable()
class LanguageConfig with ChangeNotifier {
  LanguageConfig();
  factory LanguageConfig.fromJson(Map<String, dynamic> json) =>
      _$LanguageConfigFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageConfigToJson(this);

  String? _langCode;
  @JsonKey(defaultValue: null)
  String? get langCode => _langCode;
  set langCode(String? val){
    _langCode = val;
    notifyListeners();
  }
}
