import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class WheelPickerScreen extends StatefulWidget {
  final String title;

  const WheelPickerScreen({required this.title, super.key});

  @override
  State<WheelPickerScreen> createState() => _WheelPickerScreenState();
}

class _WheelPickerScreenState extends State<WheelPickerScreen> {
  final List<String> _dropDownValues = ["red", "green", "blue"];
  final List _colors = [Colors.red, Colors.green, Colors.blue];
  int currentSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Column(
        children: [
          Container(
            height: 64,
            width: double.infinity,
            color: _colors[currentSelected],
            child: Center(
                child: Semantics(
              label: "current_color_text",
              explicitChildNodes: true,
              container: true,
              child: Text(
                "Current Color is ${_dropDownValues[currentSelected]}",
                style: const TextStyle(color: Colors.white),
              ),
            )),
          ),
          const Spacer(),
          Semantics(
            label: "dropdown_widget",
            explicitChildNodes: true,
            container: true,
            child: DropdownButton<String>(
              items: _dropDownValues.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: _dropDownValues[currentSelected],
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    currentSelected = _dropDownValues
                        .indexWhere((element) => element == value);
                  });
                }
              },
            ),
          ),
          const Spacer(),
          const Spacer(),
        ],
      ),
    );
  }
}
