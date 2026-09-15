import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../mock_test/mock_test_list_screen.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('continue_learning')
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.docs.first.data();
        final title = _text(data['title']) ?? 'Continue Learning';
        final subtitle = _text(data['subtitle']) ?? '';
        final buttonText = _text(data['buttonText']) ?? 'Continue';
        final thumbnailUrl = _text(data['thumbnailUrl']);
        final targetType = _text(data['targetType']) ?? 'none';
        final progress = ((_number(data['progress'])).clamp(0.0, 1.0)).toDouble();
        final percent = (progress * 100).round();

        return _LearningCard(
          title: title,
          subtitle: subtitle,
          progress: progress,
          buttonText: buttonText,
          thumbnailUrl: thumbnailUrl,
          iconName: _text(data['icon']) ?? 'menu_book',
          scoreText: '$percent% Completed',
          onPressed: targetType == 'mockTest'
              ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MockTestListScreen()))
              : null,
        );
      },
    );
  }

  static double _number(dynamic value) => value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
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
  final String? thumbnailUrl;
  final String iconName;
  final VoidCallback? onPressed;

  const _LearningCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.buttonText,
    required this.thumbnailUrl,
    required this.iconName,
    this.scoreText,
    this.onPressed,
  });

  IconData _icon(String name) {
    const icons = {
      'menu_book': Icons.menu_book_rounded,
      'quiz': Icons.quiz_rounded,
      'play': Icons.play_circle_fill_rounded,
      'school': Icons.school_rounded,
      'math': Icons.calculate_rounded,
      'language': Icons.translate_rounded,
    };
    return icons[name] ?? Icons.menu_book_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.045), blurRadius: 14, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Continue Learning', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF687184))),
        const SizedBox(height: 14),
        Row(children: [
          Container(
            height: 46, width: 46,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: const Color(0xFFE7F3FF), borderRadius: BorderRadius.circular(13)),
            child: thumbnailUrl != null
                ? Image.network(thumbnailUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(_icon(iconName), color: const Color(0xFF2196F3), size: 25))
                : Icon(_icon(iconName), color: const Color(0xFF2196F3), size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF687184))),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ])),
        ]),
        const SizedBox(height: 14),
        ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: const Color(0xFFE4E9F8), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5064A0)))),
        const SizedBox(height: 6),
        Align(alignment: Alignment.centerRight, child: Text(scoreText ?? '$percent% Completed', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF687184)))),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, height: 42, child: ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D63E8), foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))), child: Text(buttonText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)))),
      ]),
    );
  }
}
