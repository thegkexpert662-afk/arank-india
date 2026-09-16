import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  IconData _iconFromKey(String? key) {
    switch (key) {
      case 'emoji_events':
        return Icons.emoji_events;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'military_tech':
        return Icons.military_tech;
      case 'star':
        return Icons.star;
      case 'school':
        return Icons.school;
      case 'quiz':
        return Icons.quiz;
      case 'bolt':
        return Icons.bolt;
      case 'trending_up':
        return Icons.trending_up;
      default:
        return Icons.emoji_events;
    }
  }

  Color _colorFromValue(dynamic value) {
    if (value is int) return Color(value);
    return Colors.amber;
  }

  Future<bool> _isUnlocked(String achievementId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('achievements')
        .doc(achievementId)
        .get();

    return doc.exists && (doc.data()?['unlocked'] ?? true) == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('achievements')
            .where('isActive', isEqualTo: true)
            .orderBy('sortOrder')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load achievements.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final achievements = snapshot.data?.docs ?? [];

          if (achievements.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No achievements available right now.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: achievements.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final doc = achievements[index];
              final data = doc.data();
              final title = (data['title'] ?? '').toString();
              final description = (data['description'] ?? '').toString();
              final iconKey = data['icon']?.toString();
              final iconColor = _colorFromValue(data['iconColor']);

              return FutureBuilder<bool>(
                future: _isUnlocked(doc.id),
                builder: (context, unlockSnapshot) {
                  final unlocked = unlockSnapshot.data ?? false;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: iconColor.withValues(alpha: 0.12),
                      child: Icon(
                        _iconFromKey(iconKey),
                        color: unlocked ? iconColor : Colors.grey,
                      ),
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: unlocked ? null : Colors.grey.shade700,
                      ),
                    ),
                    subtitle: Text(description),
                    trailing: unlocked
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.lock_outline, color: Colors.grey),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
