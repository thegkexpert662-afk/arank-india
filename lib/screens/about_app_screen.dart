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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Icon(
              Icons.school,
              size: 90,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Text(
              "ARank India",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "ARank India is an online learning and exam preparation platform designed to help students prepare for competitive examinations through mock tests, practice questions, leaderboards and performance analysis.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.flag),
              title: Text("Developed In"),
              subtitle: Text("India 🇮🇳"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.school),
              title: Text("Purpose"),
              subtitle: Text("Competitive Exam Preparation"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.quiz),
              title: Text("Features"),
              subtitle: Text(
                "Mock Tests, Practice Questions, Live Tests, Leaderboard & Performance Analysis",
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("Support"),
              subtitle: Text("supportallthinks@gmail.com"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.update),
              title: Text("Current Version"),
              subtitle: Text("1.0.0"),
            ),
            SizedBox(height: 30),
            Text(
              "Developed by KOPERSAY TECHNOLOGIES 🇮🇳",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 18),
            Text(
              "© 2026 ARank India\nAll Rights Reserved.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
