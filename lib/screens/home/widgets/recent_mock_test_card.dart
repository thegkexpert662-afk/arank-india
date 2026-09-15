import 'package:flutter/material.dart';
import '../mock_test_result_screen.dart';

class RecentMockTestCard extends StatelessWidget {
  const RecentMockTestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.assignment_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Recent Mock Test', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(18)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SSC GD Full Mock Test 01', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Score'), Text('82 / 100', style: TextStyle(fontWeight: FontWeight.bold))]),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Accuracy'), Text('89%', style: TextStyle(fontWeight: FontWeight.bold))]),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Time'), Text('52 min', style: TextStyle(fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MockTestResultScreen())),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: const Text('View Result', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
