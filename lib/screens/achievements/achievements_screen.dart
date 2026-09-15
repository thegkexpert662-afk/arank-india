import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements"),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.emoji_events, color: Colors.amber),
            title: Text("First Test Completed"),
            subtitle: Text("Complete your first mock test"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_fire_department, color: Colors.orange),
            title: Text("7 Days Streak"),
            subtitle: Text("Practice for 7 consecutive days"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.workspace_premium, color: Colors.blue),
            title: Text("100 Questions Solved"),
            subtitle: Text("Solve your first 100 questions"),
          ),
        ],
      ),
    );
  }
}