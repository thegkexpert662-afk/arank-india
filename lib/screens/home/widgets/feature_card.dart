import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              assetPath: 'assets/images/home_cards/practice_gk.svg',
              color: const Color(0xFF2196F3),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SscGdQuestionsScreen())),
            );
          },
        ),
        FeatureItem(
          title: 'Hindi', subtitle: 'All Questions',
          assetPath: 'assets/images/home_cards/hindi.svg', color: const Color(0xFFFF4081),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HindiQuestionsScreen())),
        ),
        FeatureItem(
          title: 'Reasoning', subtitle: 'All Questions',
          assetPath: 'assets/images/home_cards/reasoning.svg', color: const Color(0xFFFFA000),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReasoningQuestionsScreen())),
        ),
        FeatureItem(
          title: 'Maths', subtitle: 'All Questions',
          assetPath: 'assets/images/home_cards/maths.svg', color: const Color(0xFF20B779),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MathsQuestionsScreen())),
        ),
        FeatureItem(
          title: 'Mock Test', subtitle: 'Full Length Tests',
          assetPath: 'assets/images/home_cards/mock_test.svg', color: const Color(0xFF7352F4),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MockTestListScreen())),
        ),
        FeatureItem(
          title: 'Leaderboard', subtitle: 'Top Performers',
          assetPath: 'assets/images/home_cards/leaderboard.svg', color: const Color(0xFF2196F3),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
        ),
      ],
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;
  final Color color;
  final VoidCallback onTap;

  const FeatureItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.assetPath,
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
              BoxShadow(color: color.withOpacity(.11), blurRadius: 18, offset: const Offset(0, 7)),
              BoxShadow(color: Colors.black.withOpacity(.025), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned(
                  right: -22,
                  top: -25,
                  child: Opacity(
                    opacity: .065,
                    child: SvgPicture.asset(assetPath, width: 125, height: 125),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(assetPath, width: 78, height: 78),
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
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1E2D47), height: 1.1),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500, height: 1.15),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.withOpacity(.09),
                              border: Border.all(color: color.withOpacity(.10)),
                            ),
                            child: Icon(Icons.arrow_forward_rounded, color: dark, size: 23),
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
