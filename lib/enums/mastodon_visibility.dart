import 'package:material_ui/material_ui.dart';
import 'package:json_annotation/json_annotation.dart';


enum MastodonVisibility {
  @JsonValue(0)
  public(0, Icons.public),
  @JsonValue(2)
  followerOnly(2, Icons.group),
  @JsonValue(1)
  notListed(1, Icons.link),
  @JsonValue(3)
  private(3, Icons.lock);

  final int value;
  final IconData icon;

  /// Also applicable for Mastodon
  const MastodonVisibility(this.value, this.icon);
  static MastodonVisibility fromValue(int val) {
    return MastodonVisibility.values.firstWhere((e) => e.value == val);
  }
}
