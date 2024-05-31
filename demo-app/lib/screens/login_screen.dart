import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:appium_testing_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userNameController.text = "admin";
    passwordController.text = "1234";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: "Login",
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: "please_login_text",
              explicitChildNodes: true,
              container: true,
              child: const Text(
                "Please Login",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Semantics(
              label: "username_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: TextField(
                decoration:
                    const InputDecoration.collapsed(hintText: "Username"),
                controller: userNameController,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Semantics(
              label: "password_text_field",
              // textField: true,
              explicitChildNodes: true,
              container: true,
              child: TextField(
                key: const Key("password"),
                decoration:
                    const InputDecoration.collapsed(hintText: "Password"),
                obscureText: true,
                controller: passwordController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Semantics(
                label: "login_button",
                explicitChildNodes: true,
                container: true,
                child: ElevatedButton(
                  onPressed: () {
                    _validateCredentials();
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateCredentials() {
    if (userNameController.text == "admin" &&
        passwordController.text == "1234") {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
      return;
    }
    _showInvalidCredsPopup();
  }

  Future _showInvalidCredsPopup() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Oops"),
          content: const Text("Invalid Credentials"),
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
}
