import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/l10n/app_localizations.dart';

class TimeOverrideField extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime?) onDateChanged;
  final String watermark;

  const TimeOverrideField({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
    required this.watermark,
  });

  @override
  State<TimeOverrideField> createState() => _TimeOverrideFieldState();
}

class _TimeOverrideFieldState extends State<TimeOverrideField> {
  late final TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _selectedDate = widget.initialDate;
    if (_selectedDate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateTextField();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant TimeOverrideField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      setState(() {
        _selectedDate = widget.initialDate;
        if (_selectedDate == null) {
          _controller.text = "";
        } else {
          _updateTextField();
        }
      });
    }
  }

  void _updateTextField() {
    if (_selectedDate != null) {
      _controller.text = DateFormat.yMd(
        Localizations.localeOf(context).languageCode,
      ).add_Hm().format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return TextField(
      canRequestFocus: false,
      controller: _controller,
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          currentDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          firstDate: DateTime(1970),
        );
        if (date == null) {
          return;
        }
        if (!context.mounted) return;
        final time = await showTimePicker(
          context: context,
          initialTime: _selectedDate != null
              ? TimeOfDay.fromDateTime(_selectedDate!)
              : TimeOfDay.now(),
        );
        if (time != null) {
          final newDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          setState(() {
            _selectedDate = newDate;
            _updateTextField();
          });
          widget.onDateChanged(_selectedDate);
        }
      },
      decoration: InputDecoration(
        labelText: widget.watermark,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.schedule),
        suffixIcon: _selectedDate == null
            ? TextButton(
                onPressed: () {
                  final newDate = DateTime.now();
                  setState(() {
                    _selectedDate = newDate;
                    _updateTextField();
                  });
                  widget.onDateChanged(_selectedDate);
                },
                child: Text(localize.now),
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = null;
                    _controller.text = "";
                  });
                  widget.onDateChanged(null);
                },
                icon: const Icon(Icons.delete),
              ),
      ),
    );
  }
}
