import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class FormsScreen extends StatefulWidget {
  final String title;

  const FormsScreen({required this.title, super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

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
              label: "firstname_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "First Name",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                controller: firstNameController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "lastname_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Last Name",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                controller: lastNameController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "email_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Email",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                controller: emailController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "phone_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Phone",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                controller: phoneController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "street_address_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Street Address",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                controller: streetAddressController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "postal_code_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Postal Code",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                controller: postalCodeController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "country_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Country",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                controller: countryController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "country_code_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Country Code",
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                ),
                controller: countryCodeController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      _showSuccessPopUp();
                    },
                    child: const Text("Submit", style: TextStyle(color: Colors.white),)))
          ],
        ),
      ),
    );
  }

  Future _showSuccessPopUp() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submission Successful"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              titleAndValue(
                  "First Name: ", firstNameController.text, "first_name"),
              titleAndValue(
                  "Last Name: ", lastNameController.text, "last_name"),
              titleAndValue("Email: ", emailController.text, "email"),
              titleAndValue("Phone: ", phoneController.text, "phone"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            )
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  Widget titleAndValue(String title, String value, String labelPrefix) {
    return Row(
      children: [
        Semantics(
          label: "${labelPrefix}_title",
          explicitChildNodes: true,
          container: true,
          child: Text(title),
        ),
        const SizedBox(
          width: 5,
        ),
        Semantics(
          label: "${labelPrefix}_value",
          explicitChildNodes: true,
          container: true,
          child: Text(value),
        ),
      ],
    );
  }
}
