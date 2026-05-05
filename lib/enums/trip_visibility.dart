import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

enum TripVisibilityEnum {
  @JsonValue(0)
  public(0, Icons.public),
  @JsonValue(4)
  loggedInUser(4, Symbols.shield_person),
  @JsonValue(2)
  followerOnly(2, Icons.group),
  @JsonValue(1)
  notListed(1, Icons.link),
  @JsonValue(3)
  private(3, Icons.lock);

  final int value;
  final IconData icon;

  /// Also applicable for Mastodon
  const TripVisibilityEnum(this.value, this.icon);
  static TripVisibilityEnum fromValue(int val) {
    return TripVisibilityEnum.values.firstWhere((e) => e.value == val);
  }
}
