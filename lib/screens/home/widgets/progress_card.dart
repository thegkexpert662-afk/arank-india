import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Progress",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: const [
              Expanded(
                child: ProgressItem(
                  icon: Icons.menu_book_rounded,
                  color: Colors.blue,
                  value: "125",
                  title: "Questions",
                ),
              ),

              SizedBox(width: 15),

              Expanded(
                child: ProgressItem(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  value: "92%",
                  title: "Accuracy",
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: const [
              Expanded(
                child: ProgressItem(
                  icon: Icons.assignment,
                  color: Colors.orange,
                  value: "08",
                  title: "Mock Tests",
                ),
              ),

              SizedBox(width: 15),

              Expanded(
                child: ProgressItem(
                  icon: Icons.local_fire_department,
                  color: Colors.red,
                  value: "15",
                  title: "Day Streak",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String title;

  const ProgressItem({
    super.key,
    required this.icon,
    required this.color,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}