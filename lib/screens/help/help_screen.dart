import 'package:flutter/material.dart';
import 'faq_screen.dart';
import 'report_bug_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
            leading: const Icon(Icons.help),
            title: const Text("FAQs"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FaqScreen(),
                ),
              );
            },
          ),
          const Divider(),

          ListTile(
            leading: Icon(Icons.email),
            title: Text("Email Support"),
            subtitle: Text("supportallthinks@gmail.com"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text("Contact Us"),
            subtitle: Text("+91 7319796868"),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text("Report a Bug"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportBugScreen(),
                ),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}