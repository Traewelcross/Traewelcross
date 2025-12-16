import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.title,
    this.actions,
    this.bottomNavigationBar,
    required this.body,
    this.backButton,
    this.floatingActionButton,
  });
  final Widget title;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Widget body;
  final bool? backButton;
  final Widget? floatingActionButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: actions,
        centerTitle: true,
        animateColor: true,
        automaticallyImplyLeading: backButton ?? true,
        backgroundColor: Color.alphaBlend(
          Theme.of(context).colorScheme.primary.withValues(alpha: .02),
          Theme.of(context).colorScheme.surface,
        ),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: "SUSE",
        ),
      ),
      backgroundColor: Color.alphaBlend(
        Theme.of(context).colorScheme.primary.withValues(alpha: .02),
        Theme.of(context).colorScheme.surface,
      ),
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
