import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

enum VolumeButtonType { up, down }

enum VolumeButtonAction { pressed, held }

enum VolumeButtonState { pressed, released }

class VolumeEvent {
  final VolumeButtonType button;
  final VolumeButtonAction action;
  VolumeEvent({required this.button, required this.action});

  @override
  String toString() {
    return "${button == VolumeButtonType.down ? "Down" : "Up"} is $action";
  }
}

class VolumeButtonService {
  static final VolumeButtonService _instance = VolumeButtonService._internal();
  factory VolumeButtonService() => _instance;
  VolumeButtonService._internal();

  static const int _holdDelayMs = 400;
  static const MethodChannel _channel = MethodChannel("volume");

  final StreamController<VolumeEvent> _controller =
      StreamController<VolumeEvent>.broadcast();
  Stream<VolumeEvent> get stream => _controller.stream;

  final StreamController<bool> _animateController =
      StreamController<bool>.broadcast();
  Stream<bool> get pressStartStream => _animateController.stream;

  Timer? _holdTimer;
  bool _hasTriggeredHold = false;
  VolumeButtonType? _currentPressedButton;

  void init() {
    _channel.setMethodCallHandler((call) async {
      final List<String> method = call.method.split("");
      final VolumeButtonType? button = switch (method.isNotEmpty
          ? method[0]
          : "") {
        "D" => VolumeButtonType.down,
        "U" => VolumeButtonType.up,
        _ => null,
      };
      final VolumeButtonState? state = switch (method.length > 1
          ? method[1]
          : "") {
        "P" => VolumeButtonState.pressed,
        "R" => VolumeButtonState.released,
        _ => null,
      };

      if (button == null || state == null) return;

      if (state == VolumeButtonState.pressed) {
        if (_currentPressedButton == button) return;
        _currentPressedButton = button;
        _hasTriggeredHold = false;

        _animateController.add(true);

        _holdTimer?.cancel();
        _holdTimer = Timer(const Duration(milliseconds: _holdDelayMs), () {
          if (_currentPressedButton == button) {
            _hasTriggeredHold = true;
            _controller.add(
              VolumeEvent(button: button, action: VolumeButtonAction.held),
            );
          }
        });
      } else {
        if (_currentPressedButton == button) {
          _holdTimer?.cancel();
          _holdTimer = null;

          _animateController.add(false);

          if (!_hasTriggeredHold) {
            _controller.add(
              VolumeEvent(button: button, action: VolumeButtonAction.pressed),
            );
          }

          _currentPressedButton = null;
          _hasTriggeredHold = false;
        }
      }
    });
  }

  Widget buildHoldProgressIndicator({double size = 32.0}) {
    return _VolumeHoldIndicatorWidget(service: this, size: size);
  }

  void dispose() {
    _holdTimer?.cancel();
    _controller.close();
    _animateController.close();
  }
}

class _VolumeHoldIndicatorWidget extends StatefulWidget {
  final VolumeButtonService service;
  final double size;

  const _VolumeHoldIndicatorWidget({required this.service, required this.size});

  @override
  State<_VolumeHoldIndicatorWidget> createState() =>
      _VolumeHoldIndicatorWidgetState();
}

class _VolumeHoldIndicatorWidgetState extends State<_VolumeHoldIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  StreamSubscription<bool>? _sub;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: VolumeButtonService._holdDelayMs),
    );

    _sub = widget.service.pressStartStream.listen((e) {
      if (e) {
        _animationController.forward(from: 0.0);
      } else {
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          if (_animationController.isDismissed) {
            return CircularProgressIndicator(value: 1.0, strokeWidth: 3.0);
          }
          return CircularProgressIndicator(
            value: 1.0 - _animationController.value,
            strokeWidth: 3.0,
          );
        },
      ),
    );
  }
}
