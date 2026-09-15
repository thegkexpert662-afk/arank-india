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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection("users").doc(_auth.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text("No Profile Found"));
              }
              final data = snapshot.data!.data() as Map<String, dynamic>;
              final avatarEnabled = data["avatarEnabled"] == true;
              final avatar = data["avatar"] is int ? data["avatar"] as int : 1;

              return Column(children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: avatarEnabled
                      ? AssetImage("assets/avatars/avatar$avatar.png")
                      : null,
                  child: avatarEnabled
                      ? null
                      : const Icon(Icons.person_outline, size: 48, color: Colors.grey),
                ),
                const SizedBox(height: 15),
                Text(data["name"] ?? "User", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(data["email"] ?? ""),
                const SizedBox(height: 20),
                Card(child: ListTile(leading: const Icon(Icons.phone), title: const Text("Mobile Number"), subtitle: Text(data["phone"] ?? ""))),
                Card(child: ListTile(leading: const Icon(Icons.location_on), title: const Text("State"), subtitle: Text(data["state"] ?? ""))),
                Card(child: ListTile(leading: const Icon(Icons.location_city), title: const Text("City"), subtitle: Text(data["city"] ?? ""))),
                Card(child: ListTile(leading: const Icon(Icons.account_balance_wallet), title: const Text("UPI ID"), subtitle: Text(data["upiId"] ?? "Not Added"))),
              ]);
            },
          ),
          const SizedBox(height: 20),
          const Text("Statistics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Card(child: ListTile(leading: const Icon(Icons.quiz), title: const Text("Tests Attempted"), trailing: const Text("0"))),
          Card(child: ListTile(leading: const Icon(Icons.check_circle), title: const Text("Accuracy"), trailing: const Text("0%"))),
          Card(child: ListTile(leading: const Icon(Icons.star), title: const Text("Rank"), trailing: const Icon(Icons.arrow_forward_ios, size: 18), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())))),
          Card(child: ListTile(leading: const Icon(Icons.emoji_events), title: const Text("Achievements"), trailing: const Icon(Icons.arrow_forward_ios), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen())))),
          Card(child: ListTile(leading: const Icon(Icons.edit), title: const Text("Edit Profile"), trailing: const Icon(Icons.arrow_forward_ios), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())))),
          Card(child: ListTile(leading: const Icon(Icons.settings), title: const Text("Settings"), trailing: const Icon(Icons.arrow_forward_ios), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())))),
          Card(child: ListTile(leading: const Icon(Icons.support_agent), title: const Text("Help & Support"), trailing: const Icon(Icons.arrow_forward_ios), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen())))),
          Card(child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () async {
              final logout = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Text("Logout"),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(context, true), child: const Text("Logout")),
                ],
              ));
              if (logout == true) {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
              }
            },
          )),
        ]),
      ),
    );
  }
}
