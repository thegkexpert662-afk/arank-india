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
          child: Column(
            children: [

              HomeHeader(),

              SizedBox(height: 25),

              SearchBarWidget(),

              SizedBox(height: 25),

              BannerCard(),

              SizedBox(height: 25),

              FeatureCard(),


              const SizedBox(height: 20),

              ProgressCard(),

              const SizedBox(height: 20),

              ContinueLearningCard(),

              const SizedBox(height: 20),

              CurrentAffairsCard(),

              const SizedBox(height: 20),

              RecentMockTestCard(),

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),

      bottomNavigationBar: const BottomNavbar(),
    );
  }
}