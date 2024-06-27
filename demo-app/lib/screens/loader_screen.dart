import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class LoaderScreen extends StatefulWidget {
  final String title;
  const LoaderScreen({required this.title, super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {

  bool _showText = false;
  bool _showLoader = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _showLoader = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30,),
            _showLoader ? const CircularProgressIndicator() : const SizedBox(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showText = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30,),
            _showText ? Text("Button pressed"): const SizedBox(),
          ],
        ),
      ),
    );
  }
}
