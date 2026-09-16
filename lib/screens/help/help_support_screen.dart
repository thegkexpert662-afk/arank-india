import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        centerTitle: true,
      ),
      body: ListView(
        children: [

          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("FAQs"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Open FAQ Screen
            },
          ),
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text("Email Support"),
            subtitle: const Text("contact@kopersay.in"),
            onTap: () {
              // TODO: Open Email App
            },
          ),
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.call_outlined),
            title: const Text("Contact Us"),
            subtitle: const Text("+91 XXXXX XXXXX"),
            onTap: () {
              // TODO: Call Support
            },
          ),
          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text("Report a Bug"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Open Report Bug Screen
            },
          ),

        ],
      ),
    );
  }
}
