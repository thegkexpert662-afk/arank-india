import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 20, 14, 24),
        child: Column(
          children: [
            const Icon(
              Icons.school,
              size: 90,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              "ARank India",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              "ARank India is an online learning and exam preparation platform designed to help students prepare for competitive examinations through mock tests, practice questions, leaderboards and performance analysis.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 28),
            const ListTile(
              leading: Icon(Icons.flag),
              title: Text("Developed In"),
              subtitle: Text("India 🇮🇳"),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.school),
              title: Text("Purpose"),
              subtitle: Text("Competitive Exam Preparation"),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.quiz),
              title: Text("Features"),
              subtitle: Text(
                "Mock Tests, Practice Questions, Live Tests, Leaderboard & Performance Analysis",
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.email),
              title: Text("Support"),
              subtitle: Text("supportallthinks@gmail.com"),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.update),
              title: Text("Current Version"),
              subtitle: Text("1.0.0"),
            ),
            const SizedBox(height: 26),
            const Text(
              "Developed by",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              "KOPERSAY TECHNOLOGIES",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            const Text(
              "India 🇮🇳",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              "© 2026 ARank India\nAll Rights Reserved.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
