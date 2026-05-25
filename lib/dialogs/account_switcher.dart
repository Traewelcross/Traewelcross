import 'package:flutter/material.dart';

class AccountSwitcher extends StatelessWidget {
  const AccountSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(onClosing: () => "", builder:(context) {
      return ListView(
        children: [
          ListTile(title: Text("Nothing to see here (yet)"),)
        ],
      );
    },);
  }
}