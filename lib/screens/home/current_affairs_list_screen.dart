import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'current_affairs_detail_screen.dart';

class CurrentAffairsListScreen extends StatelessWidget {
  const CurrentAffairsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(title: const Text('Current Affairs')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('current_affairs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Current Affairs could not be loaded: ${snapshot.error}'));
          }

          final docs = [...(snapshot.data?.docs ?? [])]
            .where((doc) => doc.data()['isActive'] != false)
            .toList();
          docs.sort((a, b) {
            final av = a.data()['createdAt'];
            final bv = b.data()['createdAt'];
            final at = av is Timestamp ? av.toDate() : DateTime.fromMillisecondsSinceEpoch(0);
            final bt = bv is Timestamp ? bv.toDate() : DateTime.fromMillisecondsSinceEpoch(0);
            return bt.compareTo(at);
          });

          if (docs.isEmpty) {
            return const Center(child: Text('No Current Affairs available right now.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final title = '${data['title'] ?? ''}'.trim();
              final summary = '${data['summary'] ?? ''}'.trim();
              final content = '${data['content'] ?? ''}'.trim();
              final dateText = '${data['dateText'] ?? ''}'.trim();

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 12, offset: const Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🔥 $title', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    if (summary.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(summary, style: const TextStyle(height: 1.5)),
                    ],
                    if (dateText.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(children: [const Icon(Icons.calendar_today, size: 15, color: Colors.grey), const SizedBox(width: 6), Text(dateText, style: const TextStyle(color: Colors.grey))]),
                    ],
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CurrentAffairsDetailScreen(title: title, summary: summary, content: content, dateText: dateText))),
                        child: const Text('Read More'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
