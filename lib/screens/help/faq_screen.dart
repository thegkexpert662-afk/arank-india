import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQs"),
        centerTitle: true,
      ),
      body: ListView(
        children: const [

          ExpansionTile(
            title: Text("How do I start a Mock Test?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Go to Mock Test, choose your exam and start the test.",
                ),
              ),
            ],
          ),

          Divider(height: 1),

          ExpansionTile(
            title: Text("How is my score calculated?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Your score is calculated based on correct answers, negative marking (if applicable), and total marks.",
                ),
              ),
            ],
          ),

          Divider(height: 1),

          ExpansionTile(
            title: Text("How does the leaderboard work?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Leaderboard rankings are based on your test performance and scores.",
                ),
              ),
            ],
          ),

          Divider(height: 1),

          ExpansionTile(
            title: Text("How can I report a problem?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Open Help & Support and tap Report a Bug.",
                ),
              ),
            ],
          ),

          Divider(height: 1),

          ExpansionTile(
            title: Text("How can I contact support?"),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "You can contact us through Email Support or Contact Us in the Help & Support section.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}