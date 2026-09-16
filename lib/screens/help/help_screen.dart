import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'faq_screen.dart';
import 'report_bug_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactStream = FirebaseFirestore.instance
        .collection('app_settings')
        .doc('contact')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: contactStream,
        builder: (context, snapshot) {
          final data = snapshot.data?.data() ?? {};
          final email = (data['email'] ?? 'contact@kopersay.in').toString();
          final mobile = (data['mobile'] ?? '+91 7319796868').toString();

          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text("FAQs"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FaqScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email Support"),
                subtitle: Text(email),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("Contact Us"),
                subtitle: Text(mobile),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.bug_report),
                title: const Text("Report a Bug"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReportBugScreen()),
                  );
                },
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
