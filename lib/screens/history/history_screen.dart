import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test History"),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.history),
            title: Text("SSC GD Mock Test 1"),
            subtitle: Text("Score: 82/100"),
            trailing: Text("Today"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Reasoning Practice"),
            subtitle: Text("Score: 45/50"),
            trailing: Text("Yesterday"),
          ),
        ],
      ),
    );
  }
}