import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.notifications),
            ),
            title: Text("Welcome to ARank India"),
            subtitle: Text("Start your SSC GD 2026 preparation today."),
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.quiz),
            ),
            title: Text("New Mock Test Available"),
            subtitle: Text("SSC GD Mock Test 01 has been added."),
          ),
        ],
      ),
    );
  }
}