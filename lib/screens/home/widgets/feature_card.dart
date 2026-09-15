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
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.48,
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('home_cards')
              .doc('practice_card')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return FeatureItem(
                title: 'Practice G.K.',
                subtitle: '10000+ Questions',
                icon: Icons.menu_book_rounded,
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SscGdQuestionsScreen(),
                  ),
                ),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            if (data['isActive'] != true) return const SizedBox();

            return FeatureItem(
              title: data['title'] ?? 'Practice G.K.',
              subtitle: data['subtitle'] ?? '10000+ Questions',
              icon: Icons.menu_book_rounded,
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SscGdQuestionsScreen(),
                ),
              ),
            );
          },
        ),
        FeatureItem(
          title: 'Hindi',
          subtitle: 'All Questions',
          icon: Icons.menu_book_rounded,
          color: Colors.pinkAccent,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HindiQuestionsScreen()),
          ),
        ),
        FeatureItem(
          title: 'Reasoning',
          subtitle: 'All Questions',
          icon: Icons.psychology_rounded,
          color: Colors.orange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReasoningQuestionsScreen()),
          ),
        ),
        FeatureItem(
          title: 'Maths',
          subtitle: 'All Questions',
          icon: Icons.calculate_rounded,
          color: Colors.green,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MathsQuestionsScreen()),
          ),
        ),
        FeatureItem(
          title: 'Mock Test',
          subtitle: 'Full Length Tests',
          icon: Icons.assignment_rounded,
          color: Colors.deepPurple,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MockTestListScreen()),
          ),
        ),
        FeatureItem(
          title: 'Leaderboard',
          subtitle: 'Top Performers',
          icon: Icons.emoji_events_rounded,
          color: Colors.blue,
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
    final dark = Color.lerp(color, Colors.black, 0.18)!;
    final bg = Color.lerp(color, Colors.white, 0.93)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, bg],
            ),
            border: Border.all(color: color.withOpacity(0.10)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Positioned(
                  right: -12,
                  top: -18,
                  child: Icon(
                    icon,
                    size: 90,
                    color: color.withOpacity(0.055),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withOpacity(0.20),
                              color.withOpacity(0.08),
                            ],
                          ),
                        ),
                        child: Icon(icon, color: dark, size: 25),
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
                                    fontSize: 16,
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
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.82),
                              border: Border.all(
                                color: color.withOpacity(0.12),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: dark,
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
