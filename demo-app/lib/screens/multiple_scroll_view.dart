import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class MultipleScrollViewScreen extends StatefulWidget {
  final String title;

  const MultipleScrollViewScreen({required this.title, super.key});

  @override
  State<MultipleScrollViewScreen> createState() =>
      _MultipleScrollViewScreenState();
}

class _MultipleScrollViewScreenState extends State<MultipleScrollViewScreen> {
  final List _colors = [
    Colors.amber,
    Colors.green,
    Colors.deepOrange,
    Colors.red
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Horizontal Scroll"),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(color: _colors[index]),
                      child: Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                              fontSize: 24.0, color: Colors.white),
                        ),
                      ));
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Vertical Scroll"),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(color: _colors[index]),
                      child: Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                              fontSize: 24.0, color: Colors.white),
                        ),
                      ));
                }),
          ),
        ],
      ),
    );
  }
}
