import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int correct;
  final int wrong;
  final int unattempted;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.correct,
    required this.wrong,
    required this.unattempted,
    required this.totalQuestions,
  });



  @override
  Widget build(BuildContext context) {
    final accuracy =
    ((correct / totalQuestions) * 100).toStringAsFixed(1);


    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Icon(
              Icons.emoji_events,
              color: Colors.orange,
              size: 90,
            ),

            const SizedBox(height: 20),

            Text(
              "$correct / $totalQuestions",
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                title: const Text("Correct"),
                trailing: Text(correct.toString()),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text("Wrong"),
                trailing: Text(wrong.toString()),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text("Unattempted"),
                trailing: Text(unattempted.toString()),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text("Accuracy"),
                trailing: Text("$accuracy%"),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Retry"),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}