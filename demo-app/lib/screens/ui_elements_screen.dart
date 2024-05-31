import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class UiElementsScreen extends StatefulWidget {
  final String title;

  const UiElementsScreen({required this.title, super.key});

  @override
  State<UiElementsScreen> createState() => _UiElementsScreenState();
}

class _UiElementsScreenState extends State<UiElementsScreen> {
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
            Semantics(
              label: "enabled_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Input",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "disabled_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: const TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: "Last Name",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "enabled_checkbox",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: const CheckboxListTile(
                title: Text(
                  'Remember Password',
                  style: TextStyle(color: Colors.grey),
                ),
                value: true,
                onChanged: null,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "disabled_checkbox",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: CheckboxListTile(
                title: const Text(
                  'Remember Password',
                  style: TextStyle(color: Colors.grey),
                ),
                value: true,
                onChanged: (bool? value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
