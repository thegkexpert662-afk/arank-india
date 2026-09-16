import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/achievement_service.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  IconData _iconFromKey(String? key) {
    switch (key) {
      case 'emoji_events': return Icons.emoji_events;
      case 'local_fire_department': return Icons.local_fire_department;
      case 'workspace_premium': return Icons.workspace_premium;
      case 'military_tech': return Icons.military_tech;
      case 'star': return Icons.star;
      case 'school': return Icons.school;
      case 'quiz': return Icons.quiz;
      case 'bolt': return Icons.bolt;
      case 'trending_up': return Icons.trending_up;
      default: return Icons.emoji_events;
    }
  }

  Color _colorFromValue(dynamic value) => value is int ? Color(value) : Colors.amber;

  String _taskLabel(String taskType) {
    switch (taskType) {
      case 'mock_tests_completed': return 'Complete mock tests';
      case 'questions_completed': return 'Complete Continue Learning questions';
      case 'continue_learning_sets_completed': return 'Complete learning sets';
      case 'perfect_score': return 'Reach a score of';
      default: return 'Task not configured';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('achievements').where('isActive', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Unable to load achievements.\n${snapshot.error}', textAlign: TextAlign.center)));

          final achievements = [...(snapshot.data?.docs ?? [])];
          achievements.sort((a, b) => _sortOrder(a.data()).compareTo(_sortOrder(b.data())));
          if (achievements.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No achievements available right now.', textAlign: TextAlign.center)));

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: achievements.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final doc = achievements[index];
              final data = {...doc.data(), 'id': doc.id};
              final title = (data['title'] ?? '').toString();
              final description = (data['description'] ?? '').toString();
              final iconColor = _colorFromValue(data['iconColor']);
              final taskType = (data['taskType'] ?? '').toString();
              final target = (data['target'] ?? 1).toString();

              return FutureBuilder<AchievementProgress>(
                future: AchievementService.instance.evaluate(data),
                builder: (context, progressSnapshot) {
                  final progress = progressSnapshot.data;
                  final unlocked = progress?.unlocked ?? false;
                  final value = progress?.value ?? 0;
                  final progressTarget = progress?.target ?? double.tryParse(target) ?? 1;
                  final fraction = progressTarget <= 0 ? 0.0 : (value / progressTarget).clamp(0.0, 1.0);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: iconColor.withValues(alpha: 0.12),
                              child: Icon(_iconFromKey(data['icon']?.toString()), color: unlocked ? iconColor : Colors.grey, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: unlocked ? null : Colors.grey.shade800)),
                                  const SizedBox(height: 4),
                                  Text(description),
                                  const SizedBox(height: 8),
                                  if (taskType.isNotEmpty) ...[
                                    Text('${_taskLabel(taskType)} ${taskType == 'perfect_score' ? '$target%' : target}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 5),
                                    LinearProgressIndicator(value: fraction, minHeight: 6),
                                    const SizedBox(height: 4),
                                    Text(taskType == 'perfect_score' ? 'Best: ${value.toStringAsFixed(0)}%' : '${value.toStringAsFixed(0)} / ${progressTarget.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            unlocked ? const Icon(Icons.check_circle, color: Colors.green, size: 28) : const Icon(Icons.lock_outline, color: Colors.grey, size: 26),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  int _sortOrder(Map<String, dynamic> data) => int.tryParse('${data['sortOrder'] ?? 0}') ?? 0;
}
