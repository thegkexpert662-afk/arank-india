import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../notifications/notification_screen.dart';
import '../../profile/profile_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return _buildHeader(context, 'Student', null, 1);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? <String, dynamic>{};
        final name = (data['name'] ?? 'Student').toString().trim();
        final userId = (data['userId'] ?? '').toString().trim();
        final avatar = int.tryParse('${data['avatar'] ?? 1}') ?? 1;
        return _buildHeader(context, name.isEmpty ? 'Student' : name, userId.isEmpty ? null : userId, avatar);
      },
    );
  }

  Widget _buildHeader(BuildContext context, String name, String? userId, int avatar) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome 👋', style: TextStyle(fontSize: 15, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              if (userId != null) ...[
                const SizedBox(height: 2),
                Text(userId, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
          child: const Icon(Icons.notifications_none, size: 28),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xff2962FF),
            child: ClipOval(
              child: Image.asset(
                'assets/avatars/avatar$avatar.png',
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
