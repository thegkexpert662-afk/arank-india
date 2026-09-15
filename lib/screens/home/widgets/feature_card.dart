import 'package:flutter/material.dart';
import '../../mock_test/mock_test_list_screen.dart';
import '../../questions/ssc_gd_questions_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../questions/hindi_questions_screen.dart';
import '../../questions/maths_questions_screen.dart';
import '../../questions/reasoning_screen.dart';
import '../../leaderboard/leaderboard_screen.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.38,
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('home_cards')
              .doc('practice_card')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();

            final data = snapshot.data!.data() as Map<String, dynamic>;
            if (data['isActive'] != true) return const SizedBox();

            return FeatureItem(
              title: data['title'] ?? 'Practice G.K.',
              subtitle: data['subtitle'] ?? '10000+ Questions',
              icon: Icons.menu_book_rounded,
              color: const Color(0xFF2196F3),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SscGdQuestionsScreen(),
                  ),
                );
              },
            );
          },
        ),
        FeatureItem(
          title: 'Hindi',
          subtitle: 'All Questions',
          icon: Icons.menu_book_rounded,
          color: const Color(0xFFFF4081),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HindiQuestionsScreen()),
            );
          },
        ),
        FeatureItem(
          title: 'Reasoning',
          subtitle: 'All Questions',
          icon: Icons.psychology_rounded,
          color: const Color(0xFFFFA000),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReasoningQuestionsScreen()),
            );
          },
        ),
        FeatureItem(
          title: 'Maths',
          subtitle: 'All Questions',
          icon: Icons.calculate_rounded,
          color: const Color(0xFF26B67A),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MathsQuestionsScreen()),
            );
          },
        ),
        FeatureItem(
          title: 'Mock Test',
          subtitle: 'Full Length Tests',
          icon: Icons.assignment_rounded,
          color: const Color(0xFF7C4DFF),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MockTestListScreen()),
            );
          },
        ),
        FeatureItem(
          title: 'Leaderboard',
          subtitle: 'Top Performers',
          icon: Icons.emoji_events_rounded,
          color: const Color(0xFF2196F3),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
            );
          },
        ),
      ],
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const FeatureItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final darkColor = Color.lerp(color, Colors.black, 0.22)!;
    final backgroundColor = Color.lerp(color, Colors.white, 0.93)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, backgroundColor],
            ),
            border: Border.all(color: color.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.055),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                // Large soft background graphic, like the reference design.
                Positioned(
                  right: -22,
                  top: -20,
                  child: Icon(
                    icon,
                    size: 118,
                    color: color.withOpacity(0.055),
                  ),
                ),
                // Circular action button.
                Positioned(
                  right: 14,
                  bottom: 14,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.08),
                      border: Border.all(color: color.withOpacity(0.06)),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 21,
                      color: darkColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HD-style icon tile.
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withOpacity(0.98),
                              Color.lerp(color, Colors.black, 0.10)!,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.20),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 29,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 52),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF24324B),
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(right: 48),
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
