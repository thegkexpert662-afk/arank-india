import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../continue_learning_screen.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('continue_learning').where('isActive', isEqualTo: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _box(const CircularProgressIndicator());
        if (snapshot.hasError) return _box(const Text('Continue Learning is temporarily unavailable.'));
        final docs = [...(snapshot.data?.docs ?? [])];
        docs.sort((a, b) => '${a.data()['subject'] ?? ''}'.compareTo('${b.data()['subject'] ?? ''}'));
        if (docs.isEmpty) return _box(const Text('New learning sets will appear here.'));

        final groups = <String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>{};
        for (final d in docs) {
          final subject = '${d.data()['subject'] ?? 'Other'}'.trim();
          groups.putIfAbsent(subject.isEmpty ? 'Other' : subject, () => []).add(d);
        }

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Continue Learning', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF687184))),
          const SizedBox(height: 12),
          ...groups.entries.map((entry) => _SubjectSection(subject: entry.key, sets: entry.value)),
        ]);
      },
    );
  }

  Widget _box(Widget child) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: child,
      );
}

class _SubjectSection extends StatelessWidget {
  final String subject;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> sets;
  const _SubjectSection({required this.subject, required this.sets});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(_icon(subject), size: 20, color: const Color(0xFF2D63E8)), const SizedBox(width: 7), Expanded(child: Text(subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF343B4A))))]),
          const SizedBox(height: 8),
          ...sets.map((doc) => _SetTile(doc: doc)),
        ]),
      );

  IconData _icon(String value) {
    final s = value.toLowerCase();
    if (s.contains('math')) return Icons.calculate_rounded;
    if (s.contains('reason')) return Icons.psychology_rounded;
    if (s.contains('hindi')) return Icons.translate_rounded;
    if (s.contains('current')) return Icons.newspaper_rounded;
    return Icons.menu_book_rounded;
  }
}

class _SetTile extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  const _SetTile({required this.doc});

  @override
  Widget build(BuildContext context) {
    final d = doc.data();
    final count = (d['questionCount'] as num?)?.toInt() ?? 0;
    final user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: user == null ? null : FirebaseFirestore.instance.collection('users').doc(user.uid).collection('continue_learning_progress').doc(doc.id).get(),
      builder: (context, snapshot) {
        final completed = (snapshot.data?.data()?['currentIndex'] as num?)?.toInt() ?? 0;
        final safeCompleted = completed.clamp(0, count);
        final percent = count == 0 ? 0.0 : safeCompleted / count;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(color: const Color(0xFFF7F9FF), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFE5EAF5))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text('${d['title'] ?? 'Learning Set'}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))), Text('$safeCompleted/$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF687184)))]),
            const SizedBox(height: 7),
            ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: percent, minHeight: 7, backgroundColor: const Color(0xFFE1E7F4))),
            const SizedBox(height: 9),
            Row(children: [
              Expanded(child: Text(count == 0 ? 'Questions will be added soon' : safeCompleted >= count ? 'Completed' : 'Question ${safeCompleted + 1} next', style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
              SizedBox(height: 36, child: ElevatedButton(
                onPressed: count == 0 ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContinueLearningScreen(setId: doc.id, title: '${d['title'] ?? 'Continue Learning'}'))),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D63E8), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
                child: Text(safeCompleted >= count && count > 0 ? 'Review' : 'Continue'),
              )),
            ]),
          ]),
        );
      },
    );
  }
}
