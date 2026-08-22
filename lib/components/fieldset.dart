import 'package:material_ui/material_ui.dart';

class Fieldset extends StatelessWidget {
  const Fieldset({super.key, required this.child, required this.label});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      child: child,
    );
  }
}
