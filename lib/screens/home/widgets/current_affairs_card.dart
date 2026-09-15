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
              Text(
                'Current Affairs',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('current_affairs')
                .where('isActive', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 110,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Text(
                  'Current Affairs could not be loaded: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                );
              }

              final docs = [...(snapshot.data?.docs ?? [])];
              docs.sort((a, b) => _time(b).compareTo(_time(a)));

              if (docs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('No Current Affairs available right now.'),
                );
              }

              return Column(
                children: [
                  ...docs.map((doc) {
                    final data = doc.data();
                    final title = '${data['title'] ?? ''}'.trim();
                    final summary = '${data['summary'] ?? ''}'.trim();
                    final content = '${data['content'] ?? ''}'.trim();
                    final dateText = '${data['dateText'] ?? ''}'.trim();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🔥 $title',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (summary.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                summary,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ],
                            if (dateText.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    dateText,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
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
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('Read More'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
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
    return value is Timestamp
        ? value.toDate()
        : DateTime.fromMillisecondsSinceEpoch(0);
  }
}
