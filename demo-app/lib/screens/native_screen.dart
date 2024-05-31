import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class NativeScreen extends StatelessWidget {
  final String title;
  const NativeScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: title),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Container(
            height: 60,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 1), bottom: BorderSide(width: 1))
            ),
            child: const Center(child: Text("Hello World, I'm View one"),),
          ),
          const SizedBox(height: 40,),
          Container(
            height: 60,
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 1), bottom: BorderSide(width: 1))
            ),
            child: const Center(child: Text("Hello World, I'm View two"),),
          ),
          const SizedBox(height: 40,),
          Container(
            height: 60,
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 1), bottom: BorderSide(width: 1))
            ),
            child: const Center(child: Text("Hello World, I'm View three"),),
          ),
        ],
      ),
    );
  }
}
