import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../current_affairs_detail_screen.dart';

class CurrentAffairsCard extends StatelessWidget {
  const CurrentAffairsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.newspaper_rounded, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('Current Affairs', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('current_affairs')
                .where('isActive', isEqualTo: true)
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 110, child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return const Text('Current Affairs could not be loaded.');
              }

              final docs = [...(snapshot.data?.docs ?? [])];
              docs.sort((a, b) => _time(b).compareTo(_time(a)));

              if (docs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(16)),
                  child: const Text('No Current Affairs available right now.'),
                );
              }

              final doc = docs.first;
              final data = doc.data();
              final title = '${data['title'] ?? ''}';
              final summary = '${data['summary'] ?? ''}';
              final content = '${data['content'] ?? ''}';
              final dateText = '${data['dateText'] ?? ''}';

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🔥 $title', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(summary, style: const TextStyle(color: Colors.black87, height: 1.5)),
                        if (dateText.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Row(children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(dateText, style: const TextStyle(color: Colors.grey)),
                          ]),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CurrentAffairsDetailScreen(
                            title: title,
                            summary: summary,
                            content: content,
                            dateText: dateText,
                          ),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: const Text('Read More', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  DateTime _time(DocumentSnapshot<Map<String, dynamic>> doc) {
    final value = doc.data()?['createdAt'];
    return value is Timestamp ? value.toDate() : DateTime.fromMillisecondsSinceEpoch(0);
  }
}
