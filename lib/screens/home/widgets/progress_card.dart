import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const _ProgressView(
        questions: 0,
        accuracy: 0,
        mockTests: 0,
        streak: 0,
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('mock_results')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const _ProgressView(
            questions: 0,
            accuracy: 0,
            mockTests: 0,
            streak: 0,
          );
        }

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        int questions = 0;
        int correct = 0;
        int wrong = 0;
        int mockTests = 0;
        final activeDays = <DateTime>{};

        for (final doc in snapshot.data?.docs ?? []) {
          final data = doc.data();
          final submittedAt = _readDate(data['submittedAt']);
          if (submittedAt == null) continue;

          final date = DateTime(
            submittedAt.year,
            submittedAt.month,
            submittedAt.day,
          );
          activeDays.add(date);

          // Today's Progress must show only today's activity.
          if (date != today) continue;

          mockTests++;

          final resultCorrect = _readInt(data['correct']);
          final resultWrong = _readInt(data['wrong']);
          final resultSkipped = _readInt(data['skipped']);

          correct += resultCorrect;
          wrong += resultWrong;
          questions += resultCorrect + resultWrong + resultSkipped;
        }

        final attempted = correct + wrong;
        final accuracy = attempted == 0
            ? 0
            : ((correct / attempted) * 100).round();

        return _ProgressView(
          questions: questions,
          accuracy: accuracy,
          mockTests: mockTests,
          streak: _calculateStreak(activeDays, today),
        );
      },
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  static DateTime? _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  static int _calculateStreak(Set<DateTime> days, DateTime today) {
    if (!days.contains(today)) return 0;

    int streak = 0;
    DateTime current = today;

    while (days.contains(current)) {
      streak++;
      current = current.subtract(const Duration(days: 1));
    }

    return streak;
  }
}

class _ProgressView extends StatelessWidget {
  final int questions;
  final int accuracy;
  final int mockTests;
  final int streak;

  const _ProgressView({
    required this.questions,
    required this.accuracy,
    required this.mockTests,
    required this.streak,
  });

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
          const Text(
            "Today's Progress",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProgressItem(
                  icon: Icons.menu_book_rounded,
                  color: Colors.blue,
                  value: '$questions',
                  title: 'Questions',
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ProgressItem(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  value: '$accuracy%',
                  title: 'Accuracy',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ProgressItem(
                  icon: Icons.assignment,
                  color: Colors.orange,
                  value: '$mockTests',
                  title: 'Mock Tests',
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ProgressItem(
                  icon: Icons.local_fire_department,
                  color: Colors.red,
                  value: '$streak',
                  title: 'Day Streak',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String title;

  const ProgressItem({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
