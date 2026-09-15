import 'package:flutter/material.dart';
import '../../../models/subject_model.dart';
import '../../chapters/chapter_screen.dart';

class SubjectCard extends StatelessWidget {
  final SubjectModel subject;

  const SubjectCard({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: subject.color.withOpacity(0.15),
                  child: Icon(
                    subject.icon,
                    color: subject.color,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("${subject.totalChapters} Chapters"),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChapterScreen(
                          subjectId: subject.id,
                          subjectName: subject.title,
                        ),
                      ),
                    );
                  },
                  child: const Text("Start"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Progress",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: subject.progress,
                minHeight: 8,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Completed: ${subject.completedChapters}/${subject.totalChapters}",
                ),
                Text(
                  "${(subject.progress * 100).toInt()}%",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(
                  icon: Icons.quiz,
                  title: "${subject.totalQuestions}",
                  subtitle: "Questions",
                ),
                _InfoItem(
                  icon: Icons.check_circle,
                  title: "${subject.solvedQuestions}",
                  subtitle: "Solved",
                ),
                const _InfoItem(
                  icon: Icons.timer,
                  title: "35h",
                  subtitle: "Study",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 22,
          color: Colors.blue,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}