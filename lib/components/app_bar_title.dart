import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) {
    return (Text(title, overflow: TextOverflow.ellipsis));
  }
}
