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
      childAspectRatio: 0.88,
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
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(.12),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}