import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import '../settings/settings_screen.dart';
import '../achievements/achievements_screen.dart';
import '../help/help_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arank_india/screens/leaderboard/leaderboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> _resultsStream(String uid) {
    return _firestore
        .collection('mock_results')
        .where('userId', isEqualTo: uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _todayResultsStream() {
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';
    return _firestore
        .collection('mock_results')
        .where('leaderboardDate', isEqualTo: today)
        .snapshots();
  }

  double _number(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login again')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _firestore.collection('users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('No Profile Found'));
                }

                final data = snapshot.data!.data() ?? {};
                final avatarEnabled = data['avatarEnabled'] == true;
                final avatar = data['avatar'] is int ? data['avatar'] as int : 1;
                final safeAvatar = avatar.clamp(1, 10);

                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade100,
                      backgroundImage: avatarEnabled
                          ? AssetImage('assets/avatars/avatar$safeAvatar.png')
                          : null,
                      child: avatarEnabled
                          ? null
                          : const Icon(
                              Icons.person_outline,
                              size: 48,
                              color: Colors.grey,
                            ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      (data['name'] ?? 'User').toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text((data['email'] ?? user.email ?? '').toString()),
                    const SizedBox(height: 20),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Mobile Number'),
                        subtitle: Text((data['phone'] ?? '').toString()),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text('State'),
                        subtitle: Text((data['state'] ?? '').toString()),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_city),
                        title: const Text('City'),
                        subtitle: Text(
                          (data['city'] ?? data['district'] ?? '').toString(),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.account_balance_wallet),
                        title: const Text('UPI ID'),
                        subtitle: Text(
                          (data['upiId'] ?? 'Not Added').toString(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _resultsStream(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const _StatsError();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snapshot.data?.docs ?? [];
                final attempted = docs.length;
                double totalPercentage = 0;
                for (final doc in docs) {
                  totalPercentage += _number(doc.data()['percentage']);
                }
                final accuracy = attempted == 0
                    ? 0.0
                    : (totalPercentage / attempted).clamp(0, 100);

                return Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.quiz),
                        title: const Text('Tests Attempted'),
                        trailing: Text('$attempted'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.check_circle),
                        title: const Text('Accuracy'),
                        trailing: Text('${accuracy.toStringAsFixed(1)}%'),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _todayResultsStream(),
                      builder: (context, rankSnapshot) {
                        String rankText = '—';
                        if (rankSnapshot.hasData) {
                          final results = [...rankSnapshot.data!.docs];
                          results.sort((a, b) {
                            final scoreCompare = _number(b.data()['score'])
                                .compareTo(_number(a.data()['score']));
                            if (scoreCompare != 0) return scoreCompare;
                            return _number(a.data()['timeTaken'])
                                .compareTo(_number(b.data()['timeTaken']));
                          });
                          final index = results.indexWhere(
                            (doc) => doc.data()['userId'] == user.uid,
                          );
                          if (index >= 0) rankText = '#${index + 1}';
                        }

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.star),
                            title: const Text('Rank'),
                            trailing: rankText == '—'
                                ? const Icon(Icons.arrow_forward_ios, size: 18)
                                : Text(
                                    rankText,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LeaderboardScreen(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.emoji_events),
                title: const Text('Achievements'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AchievementsScreen(),
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditProfileScreen(),
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.support_agent),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpScreen()),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () async {
                  final logout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Logout'),
                      content: const Text(
                        'Are you sure you want to logout?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                  if (logout == true) {
                    await _auth.signOut();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsError extends StatelessWidget {
  const _StatsError();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: Icon(Icons.info_outline),
        title: Text('Statistics unavailable'),
        subtitle: Text('Please try again later.'),
      ),
    );
  }
}
