import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../mock_test/mock_test_list_screen.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const _LearningCard(
        title: 'Start Learning',
        subtitle: 'Choose a subject to begin',
        progress: 0,
        buttonText: 'Start Learning',
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('mock_results')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const _LearningCard(
            title: 'Start Learning',
            subtitle: 'Choose a subject to begin',
            progress: 0,
            buttonText: 'Start Learning',
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const _LearningCard(
            title: 'Start Learning',
            subtitle: 'No learning activity yet',
            progress: 0,
            buttonText: 'Start Learning',
          );
        }

        docs.sort((a, b) {
          final aDate = _dateValue(a.data()['submittedAt']);
          final bDate = _dateValue(b.data()['submittedAt']);
          return bDate.compareTo(aDate);
        });

        final data = docs.first.data();
        final name = _text(data['mockTestName']) ??
            _text(data['mockTestId']) ??
            'Mock Test';
        final total = _number(data['totalQuestions']);
        final correct = _number(data['correct']);
        final wrong = _number(data['wrong']);
        final skipped = _number(data['skipped']);
        final attempted = correct + wrong;
        final progress = total > 0
            ? ((attempted / total).clamp(0.0, 1.0)).toDouble()
            : 0.0;

        final detail = total > 0
            ? '$attempted of $total questions attempted'
            : 'Latest learning activity';

        return _LearningCard(
          title: name,
          subtitle: detail,
          progress: progress,
          buttonText: 'Continue',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MockTestListScreen()),
            );
          },
          scoreText: total > 0
              ? '${(correct / total * 100).clamp(0, 100).toStringAsFixed(0)}% Completed'
              : null,
        );
      },
    );
  }

  static DateTime _dateValue(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  static double _number(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0;
  }

  static String? _text(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}

class _LearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final String buttonText;
  final String? scoreText;
  final VoidCallback? onPressed;

  const _LearningCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.buttonText,
    this.scoreText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Continue Learning',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF687184),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F3FF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF2196F3),
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF687184),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE4E9F8),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF5064A0),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              scoreText ?? (progress == 0 ? 'Not started' : '$percent% Completed'),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF687184),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D63E8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
