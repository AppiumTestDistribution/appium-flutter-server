import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ClockScreen extends StatefulWidget {
  final String title;

  const ClockScreen({super.key, required this.title});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  TimeOfDay? _selectedTime;

  Future<void> _openTimePicker() async {
    final TimeOfDay initialTime = _selectedTime ?? TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: 'Select time',
      cancelText: 'Cancel',
      confirmText: 'OK',
      builder: (context, child) {
        // Force 12-hour format to show AM/PM like the screenshot
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String display =
        _selectedTime != null ? _selectedTime!.format(context) : 'No time selected';
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'open_time_picker_button',
                explicitChildNodes: true,
                container: true,
                child: ElevatedButton(
                  onPressed: _openTimePicker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text(
                    'Select time',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: 'selected_time_text',
                explicitChildNodes: true,
                container: true,
                child: Text(
                  display,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
