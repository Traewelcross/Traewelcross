import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

enum TripVisibilityEnum {
  public(0, Icons.public),
  loggedInUser(4, Symbols.shield_person),
  followerOnly(2, Icons.group),
  notListed(1, Icons.link),
  private(3, Icons.lock);

  final int value;
  final IconData icon;

  /// Also applicable for Mastodon
  const TripVisibilityEnum(this.value, this.icon);
  static TripVisibilityEnum fromValue(int val) {
    return TripVisibilityEnum.values.firstWhere((e) => e.value == val);
  }
}
