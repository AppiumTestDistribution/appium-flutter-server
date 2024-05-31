import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class SliderScreen extends StatefulWidget {
  final String title;

  const SliderScreen({required this.title, super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Semantics(
            label: "slider_widget",
            child: Slider(
              value: _currentSliderValue,
              max: 100,
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Semantics(
              label: "slider_value_text",
              explicitChildNodes: true,
              container: true,
              child: Text(_currentSliderValue.toStringAsFixed(2).toString())),
        ],
      ),
    );
  }
}
