import 'package:flutter/material.dart';
import 'package:traewelcross/components/ride_quick_view_wrapper.dart';

class OnTheMove extends StatelessWidget {
  const OnTheMove({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(controller: scrollController, slivers: [
      RideQuickViewWrapper(scrollController: scrollController, isOTM: true,)
    ],);
  }
}
