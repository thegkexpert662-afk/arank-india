import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Last Updated: July 2026",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Welcome to ARank India. Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "1. Information We Collect",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "• Full Name\n"
                  "• Mobile Number\n"
                  "• Email Address (if provided)\n"
                  "• Profile Photo (optional)\n"
                  "• State & District\n"
                  "• Device Information\n"
                  "• App Usage Data\n"
                  "• Test Results & Progress",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "2. How We Use Your Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Your information is used to:\n\n"
                  "• Create your account\n"
                  "• Save your progress\n"
                  "• Show rankings and leaderboard\n"
                  "• Improve app performance\n"
                  "• Send important notifications\n"
                  "• Prevent fraud and misuse",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "3. Data Security",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Your data is stored securely using Firebase services. We take reasonable security measures to protect your information.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "4. Third-Party Services",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "ARank India may use:\n\n"
                  "• Firebase Authentication\n"
                  "• Firebase Firestore\n"
                  "• Firebase Storage\n"
                  "• Firebase Cloud Messaging\n"
                  "• Google Play Services",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "5. Children's Privacy",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "This application is intended for students aged 13 years and above.",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "6. Your Rights",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "You can:\n\n"
                  "• Update your profile\n"
                  "• Request account deletion\n"
                  "• Contact us regarding your data",
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            Text(
              "7. Changes to this Policy",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "We may update this Privacy Policy from time to time. Continued use of the app means you accept the updated policy.",
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