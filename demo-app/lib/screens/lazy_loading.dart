import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class LazyLoadingScreen extends StatefulWidget {
  final String title;

  const LazyLoadingScreen({required this.title, super.key});

  @override
  State<LazyLoadingScreen> createState() => _LazyLoadingScreenState();
}

class _LazyLoadingScreenState extends State<LazyLoadingScreen> {
  bool showMessage = true;
  bool isLoading = false;

  void toggleMessage() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        isLoading = false;
        showMessage = !showMessage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            if (showMessage) ...[
              Semantics(
                label: "message_field",
                // textField: true,
                explicitChildNodes: true,
                container: true,
                child: const Text("Hello world"),
              )
            ],
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Semantics(
                label: "toggle_button",
                explicitChildNodes: true,
                container: true,
                child: InkWell(
                  onTap: !isLoading
                      ? () async {
                          toggleMessage();
                        }
                      : null,
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: const Center(
                        child: Text(
                      "Toggle message",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Semantics(
              label: "note_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: const Text(
                  "NOTE: The message will appear/disappear after 5 seconds after toggle button is clicked"),
            )
          ],
        ),
      ),
    );
  }
}
