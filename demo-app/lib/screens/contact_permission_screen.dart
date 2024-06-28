import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPermissionScreen extends StatefulWidget {
  final String title;

  const ContactPermissionScreen({required this.title, super.key});

  @override
  State<ContactPermissionScreen> createState() =>
      _ContactPermissionScreenState();
}

class _ContactPermissionScreenState extends State<ContactPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: widget.title),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                PermissionStatus contactsStatus =
                    await Permission.contacts.status;
                if (contactsStatus == PermissionStatus.granted) {
                  await _launchContacts();
                } else if (contactsStatus == PermissionStatus.denied) {
                  if (await Permission.contacts.request().isGranted) {
                    // Open Contacts App
                    await _launchContacts();
                  }
                } else if (contactsStatus ==
                    PermissionStatus.permanentlyDenied) {
                  await openAppSettings();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                "Ask Contact Permission",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchContacts() async {
    const url = 'content://contacts/people/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
