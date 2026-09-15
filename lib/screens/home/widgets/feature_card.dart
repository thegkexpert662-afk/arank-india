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
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.22,
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('home_cards')
              .doc('practice_card')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            if (data['isActive'] != true) {
              return const SizedBox();
            }

            return FeatureItem(
              title: data['title'] ?? 'Practice General Knowledge',
              subtitle: data['subtitle'] ?? '1000+ Questions',
              icon: Icons.menu_book_rounded,
              color: Colors.blue,
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
          title: "Hindi",
          subtitle: "ALl Questions",
          icon: Icons.book,
          color: Colors.pinkAccent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HindiQuestionsScreen(),
              ),
            );
          },
        ),

        FeatureItem(
          title: "Reasoning",
          subtitle: "ALl Questions",
          icon: Icons.menu_book,
          color: Colors.pink,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ReasoningQuestionsScreen(),
              ),
            );
          },
        ),

        FeatureItem(
          title: "Maths",
          subtitle: "ALl Questions",
          icon: Icons.align_vertical_bottom_rounded,
          color: Colors.lightBlueAccent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MathsQuestionsScreen(),
              ),
            );
          },
        ),

        FeatureItem(
          title: "Mock Test",
          subtitle: "Latest Tests \n Win 100rs",
          icon: Icons.assignment_rounded,
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MockTestListScreen(),
              ),
            );
          },
        ),

        FeatureItem(
          title: "Leaderboard",
          subtitle: "Go Top Rankers",
          icon: Icons.assignment_rounded,
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LeaderboardScreen(),
              ),
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
    final darkColor = Color.lerp(color, Colors.black, 0.18)!;
    final lightColor = Color.lerp(color, Colors.white, 0.90)!;

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
              colors: [
                Colors.white,
                lightColor,
              ],
            ),
            border: Border.all(
              color: color.withOpacity(0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned(
                  right: -18,
                  top: -22,
                  child: Icon(
                    icon,
                    size: 112,
                    color: color.withOpacity(0.055),
                  ),
                ),
                Positioned(
                  right: 14,
                  bottom: 14,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.72),
                      border: Border.all(
                        color: color.withOpacity(0.10),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: darkColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withOpacity(0.18),
                              color.withOpacity(0.08),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.10),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: darkColor,
                          size: 26,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 48),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF687184),
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(right: 42),
                        child: Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                            height: 1.2,
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