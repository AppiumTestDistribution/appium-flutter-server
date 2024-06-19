import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class UiElementsScreen extends StatefulWidget {
  final String title;

  const UiElementsScreen({required this.title, super.key});

  @override
  State<UiElementsScreen> createState() => _UiElementsScreenState();
}

class _UiElementsScreenState extends State<UiElementsScreen> {
  int? _currentSelectedRadioButton;
  bool _switchButton = false;
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 30,
            ),
            TextField(
                key: ValueKey("enabled_text_field"),
                enabled: true,
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Input",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
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
          const CheckboxListTile(
                key: ValueKey("enabled_checkbox"),
                title: Text(
                  'Remember Password',
                  style: TextStyle(color: Colors.grey),
                ),
                value: true,
                enabled: true,
                onChanged: null,

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
            const Text(
              "Radio Buttons",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text("Yes"),
                  leading: Radio(
                         key: const ValueKey("radio_button_yes_radio"),
                        value: 1,
                        groupValue: _currentSelectedRadioButton,
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              _currentSelectedRadioButton = value;
                            });
                          }
                        }),
                ),
                ListTile(
                  title: const Text("No"),
                  leading: Semantics(
                    explicitChildNodes: true,
                    container: true,
                    label: "radio_button_no_radio",
                    child: Radio(
                        value: 0,
                        groupValue: _currentSelectedRadioButton,
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() {
                              _currentSelectedRadioButton = value;
                            });
                          }
                        }),
                  ),
                ),
              ],
            ),
            const Text(
              "Switch Button",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Semantics(
                  container: true,
                  explicitChildNodes: true,
                  label: "switch_button",
                  child: Switch(value: _switchButton, onChanged: (bool value){
                    setState(() {
                      _switchButton = value;
                    });
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
