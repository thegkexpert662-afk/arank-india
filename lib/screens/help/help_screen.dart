import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/tenant_service.dart';
import 'faq_screen.dart';
import 'report_bug_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appId = TenantService.appId;
    final contactStream = appId == null || appId.isEmpty
        ? const Stream<DocumentSnapshot<Map<String, dynamic>>>.empty()
        : FirebaseFirestore.instance.collection('apps').doc(appId).snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support'), centerTitle: true),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: contactStream,
        builder: (context, snapshot) {
          final data = snapshot.data?.data() ?? {};
          final adminName = (data['adminName'] ?? 'Admin').toString();
          final displayedInstituteId = (data['appId'] ?? appId ?? 'Not configured').toString();
          final appName = (data['appName'] ?? 'ARank India').toString();
          final email = (data['supportEmail'] ?? 'contact@kopersay.in').toString();
          final mobile = (data['mobile'] ?? '+91 7319796868').toString();

          return ListView(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.indigo.withOpacity(0.08),
                  border: Border.all(color: Colors.indigo.withOpacity(0.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.account_balance_outlined),
                        SizedBox(width: 10),
                        Text('Your Institute / App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _InfoRow(label: 'Institute', value: adminName),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Institute ID', value: displayedInstituteId),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'App Name', value: appName),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('FAQs'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FaqScreen())),
              ),
              const Divider(),
              ListTile(leading: const Icon(Icons.email), title: const Text('Email Support'), subtitle: Text(email)),
              const Divider(),
              ListTile(leading: const Icon(Icons.phone), title: const Text('Contact Us'), subtitle: Text(mobile)),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.bug_report),
                title: const Text('Report a Bug'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportBugScreen())),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 105, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey))),
        Expanded(child: SelectableText(value, style: const TextStyle(fontWeight: FontWeight.w700))),
      ],
    );
  }
}
