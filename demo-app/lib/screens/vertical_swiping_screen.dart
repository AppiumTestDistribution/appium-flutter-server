import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class VerticalSwipingScreen extends StatelessWidget {
  final String title;

  VerticalSwipingScreen({required this.title, super.key});

  final List<String> _languages = [
    "C",
    "C++",
    "Java",
    "Python",
    "JavaScript",
    "Ruby",
    "C#",
    ".net",
    "MySql",
    "Appium",
    "Jasmine"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: title),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Semantics(
          label: "vertical_swiping_list_view",
          child: ListView(
              children: List.generate(
                  _languages.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: Container(
                          height: 80,
                          decoration: BoxDecoration(color: Colors.blue.shade800),
                          child: Center(
                            child: Text(
                              _languages[index],
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                  ))),
        ),
      ),
    );
  }
}
