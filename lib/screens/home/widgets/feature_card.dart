import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../mock_test/mock_test_list_screen.dart';
import '../../questions/ssc_gd_questions_screen.dart';
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
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      // Wide/short ratio matching the supplied reference.
      childAspectRatio: 1.62,
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('home_cards')
              .doc('practice_card')
              .snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data() as Map<String, dynamic>?;
            if (data != null && data['isActive'] == false) {
              return const SizedBox();
            }
            return FeatureItem(
              title: data?['title'] ?? 'Practice G.K.',
              subtitle: data?['subtitle'] ?? '10000+ Questions',
              icon: Icons.menu_book_rounded,
              color: const Color(0xFF2196F3),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SscGdQuestionsScreen()),
              ),
            );
          },
        ),
        FeatureItem(
          title: 'Hindi',
          subtitle: 'All Questions',
          icon: Icons.menu_book_rounded,
          color: const Color(0xFFFF4081),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HindiQuestionsScreen()),
          ),
        ),
        FeatureItem(
          title: 'Reasoning',
          subtitle: 'All Questions',
          icon: Icons.psychology_rounded,
          color: const Color(0xFFFFA000),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReasoningQuestionsScreen()),
          ),
        ),
        FeatureItem(
          title: 'Maths',
          subtitle: 'All Questions',
          icon: Icons.calculate_rounded,
          color: const Color(0xFF20B779),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MathsQuestionsScreen()),
          ),
        ),
        FeatureItem(
          title: 'Mock Test',
          subtitle: 'Full Length Tests',
          icon: Icons.assignment_rounded,
          color: const Color(0xFF7352F4),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MockTestListScreen()),
          ),
        ),
        FeatureItem(
          title: 'Leaderboard',
          subtitle: 'Top Performers',
          icon: Icons.emoji_events_rounded,
          color: const Color(0xFF2196F3),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
          ),
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
    final dark = Color.lerp(color, Colors.black, .12)!;
    final pale = Color.lerp(color, Colors.white, .94)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, pale],
            ),
            border: Border.all(color: color.withOpacity(.08)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(.10),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(.025),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Large, very light decorative graphic from the reference.
                Positioned(
                  right: -22,
                  top: -24,
                  child: Icon(
                    icon,
                    size: 122,
                    color: color.withOpacity(.055),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color, dark],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(.22),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: Colors.white, size: 32),
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF26344D),
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade500,
                                    height: 1.15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.withOpacity(.08),
                              border: Border.all(color: color.withOpacity(.10)),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: dark,
                              size: 22,
                            ),
                          ),
                        ],
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
