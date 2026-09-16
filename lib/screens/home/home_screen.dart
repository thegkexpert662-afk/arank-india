import 'package:flutter/material.dart';

import 'widgets/banner_card.dart';
import 'widgets/bottom_navbar.dart';
import 'widgets/feature_card.dart';
import 'widgets/home_header.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/progress_card.dart';
import 'widgets/continue_learning_card.dart';
import 'widgets/current_affairs_card.dart';
import 'widgets/recent_mock_test_card.dart';
import 'video_solutions_screen.dart';
import '../practice/practice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            HomeHeader(),
            SizedBox(height: 25),
            SearchBarWidget(),
            SizedBox(height: 25),
            BannerCard(),
            SizedBox(height: 25),
            FeatureCard(),
            const SizedBox(height: 20),
            _VideoSolutionsCard(),
            const SizedBox(height: 20),
            ProgressCard(),
            const SizedBox(height: 20),
            ContinueLearningCard(),
            const SizedBox(height: 20),
            CurrentAffairsCard(),
            const SizedBox(height: 20),
            RecentMockTestCard(),
            const SizedBox(height: 20),
          ]),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}

class _VideoSolutionsCard extends StatelessWidget {
  const _VideoSolutionsCard();
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoSolutionsScreen())),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 15, offset: const Offset(0, 8))]),
        child: const Row(children: [
          CircleAvatar(radius: 29, backgroundColor: Color(0xFFE8F7FF), child: Icon(Icons.play_circle_fill_rounded, color: Color(0xFF0891B2), size: 34)),
          SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Video Solutions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1E2D47))),
            SizedBox(height: 4),
            Text('Learn with topic-wise video explanations', style: TextStyle(color: Colors.grey)),
          ])),
          Icon(Icons.arrow_forward_rounded, color: Color(0xFF0891B2)),
        ]),
      ),
    ),
  );
}
