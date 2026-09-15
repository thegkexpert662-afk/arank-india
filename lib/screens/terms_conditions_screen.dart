import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            Text(
              "Terms & Conditions",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Last Updated: July 2026",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 20),

            Text(
              "Welcome to ARank India. By using this application, you agree to the following Terms & Conditions.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "1. User Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "• Provide accurate information.\n"
                  "• Keep your account secure.\n"
                  "• Do not share your OTP with anyone.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "2. Acceptable Use",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Users must not:\n\n"
                  "• Cheat during exams.\n"
                  "• Create fake accounts.\n"
                  "• Upload harmful content.\n"
                  "• Misuse rewards or leaderboard.\n"
                  "• Attempt to hack or reverse engineer the application.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "3. Intellectual Property",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "All logos, designs, questions, study material and application content belong to ARank India unless otherwise stated.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "4. Rewards & Leaderboard",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Rewards and leaderboard positions are subject to verification. Any fraudulent activity may result in cancellation of rewards or account suspension.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "5. Account Suspension",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "We reserve the right to suspend or permanently terminate accounts involved in cheating, abuse, fraud or violation of these Terms.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "6. Limitation of Liability",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "ARank India is provided 'as available'. We are not responsible for losses caused by technical issues, downtime or network problems.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "7. Changes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "These Terms & Conditions may be updated at any time. Continued use of the application means you accept the latest version.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "8. Contact Us",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Email: supportallthinks@gmail.com",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}