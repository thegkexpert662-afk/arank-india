import 'package:flutter/material.dart';

class MockTestResultScreen extends StatelessWidget {
  const MockTestResultScreen({super.key});

  static const String testTitle = 'SSC GD Full Mock Test 01';
  static const int score = 82;
  static const int totalMarks = 100;
  static const int correct = 89;
  static const int incorrect = 11;
  static const String accuracy = '89%';
  static const String time = '52 min';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        title: const Text('Mock Test Result'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.emoji_events_rounded, size: 58, color: Colors.orange),
                  const SizedBox(height: 12),
                  const Text(testTitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Test Result', style: TextStyle(color: Colors.grey, fontSize: 15)),
                  const SizedBox(height: 24),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 10),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$score / $totalMarks', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Score', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(child: _stat('Accuracy', accuracy)),
                      const SizedBox(width: 12),
                      Expanded(child: _stat('Time', time)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Question Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _summary(Icons.check_circle_rounded, 'Correct', '$correct')),
                      Expanded(child: _summary(Icons.cancel_rounded, 'Incorrect', '$incorrect')),
                      Expanded(child: _summary(Icons.help_rounded, 'Skipped', '0')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Back to Home', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _stat(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(14)),
      child: Column(children: [Text(label, style: const TextStyle(color: Colors.grey)), const SizedBox(height: 5), Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
    );
  }

  static Widget _summary(IconData icon, String label, String value) {
    return Column(children: [Icon(icon, size: 28), const SizedBox(height: 6), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 3), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))]);
  }
}
