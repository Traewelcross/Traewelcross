import 'package:flutter/material.dart';

enum MastodonVisibility {
  public(0, Icons.public),
  followerOnly(2, Icons.group),
  notListed(1, Icons.link),
  private(3, Icons.lock);

  final int value;
  final IconData icon;

  /// Also applicable for Mastodon
  const MastodonVisibility(this.value, this.icon);
  static MastodonVisibility fromValue(int val) {
    return MastodonVisibility.values.firstWhere((e) => e.value == val);
  }
}
