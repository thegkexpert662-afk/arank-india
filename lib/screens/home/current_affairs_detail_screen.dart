import 'package:flutter/material.dart';

class CurrentAffairsDetailScreen extends StatelessWidget {
  final String title;
  final String summary;
  final String content;
  final String dateText;

  const CurrentAffairsDetailScreen({
    super.key,
    required this.title,
    required this.summary,
    required this.content,
    required this.dateText,
  });

  List<String> get paragraphs => content
      .split(RegExp(r'\n\s*\n|\n'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(title: const Text('Current Affairs')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
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
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              if (dateText.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(dateText, style: const TextStyle(color: Colors.grey)),
                ]),
              ],
              if (summary.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(summary, style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w600)),
              ],
              const SizedBox(height: 20),
              ...paragraphs.map((paragraph) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('👉', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(paragraph, style: const TextStyle(fontSize: 15, height: 1.65, color: Colors.black87))),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
