import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AchievementProgress {
  final double value;
  final double target;
  final bool unlocked;

  const AchievementProgress({
    required this.value,
    required this.target,
    required this.unlocked,
  });
}

class AchievementService {
  AchievementService._();
  static final AchievementService instance = AchievementService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AchievementProgress> evaluate(Map<String, dynamic> data) async {
    final user = FirebaseAuth.instance.currentUser;
    final target = _number(data['target'], fallback: 1).clamp(1, 1000000).toDouble();
    final taskType = (data['taskType'] ?? '').toString();

    if (user == null || taskType.isEmpty) {
      return AchievementProgress(value: 0, target: target, unlocked: false);
    }

    double value = 0;

    switch (taskType) {
      case 'mock_tests_completed':
        final snap = await _firestore
            .collection('mock_results')
            .where('userId', isEqualTo: user.uid)
            .get();
        value = snap.docs.length.toDouble();
        break;

      case 'questions_completed':
        final snap = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('continue_learning_progress')
            .get();
        for (final doc in snap.docs) {
          final data = doc.data();
          final currentIndex = _number(data['currentIndex']);
          final total = _number(data['totalQuestions']);
          value += (currentIndex > total ? total : currentIndex);
          if (data['completed'] == true && total > currentIndex) {
            value += total - currentIndex;
          }
        }
        break;

      case 'continue_learning_sets_completed':
        final snap = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('continue_learning_progress')
            .get();
        value = snap.docs.where((doc) => doc.data()['completed'] == true).length.toDouble();
        break;

      case 'perfect_score':
        final snap = await _firestore
            .collection('mock_results')
            .where('userId', isEqualTo: user.uid)
            .get();
        for (final doc in snap.docs) {
          final percentage = _number(doc.data()['percentage']);
          if (percentage > value) value = percentage;
        }
        break;

      default:
        value = 0;
    }

    final unlocked = value >= target;

    if (unlocked) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('achievements')
          .doc((data['id'] ?? '').toString())
          .set({
        'unlocked': true,
        'unlockedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return AchievementProgress(value: value, target: target, unlocked: unlocked);
  }

  double _number(dynamic value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
