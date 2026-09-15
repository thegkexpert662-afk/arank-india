import 'package:flutter/material.dart';
import 'review_screen.dart';
import '../../services/pdf_service.dart';
import '../../models/question_model.dart';


class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double score = (widget.result["score"] ?? 0).toDouble();
    final int correct = widget.result["correct"] ?? 0;
    final int wrong = widget.result["wrong"] ?? 0;
    final int skipped = widget.result["skipped"] ?? 0;
    final int total = correct + wrong + skipped;

    final double percentage =
    total == 0 ? 0 : (score / total) * 100;

    final double accuracy =
    (correct + wrong) == 0
        ? 0
        : (correct / (correct + wrong)) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mock Test Result"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    size: 90,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),


            const SizedBox(height: 10),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text(
                      "Accuracy",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 05),
                    Text(
                      "${accuracy.toStringAsFixed(2)}%",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Correct",
                    correct.toString(),
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    "Wrong",
                    wrong.toString(),
                    Colors.red,
                    Icons.cancel,
                  ),
                ),
              ],
            ),


            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "Skipped",
                    skipped.toString(),
                    Colors.orange,
                    Icons.remove_circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    "Percentage",
                    "${percentage.toStringAsFixed(2)}%",
                    Colors.blue,
                    Icons.bar_chart,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 4,

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [

                    _tile(
                      "Correct",
                      correct.toString(),
                      Colors.green,
                    ),

                    _tile(
                      "Wrong",
                      wrong.toString(),
                      Colors.red,
                    ),

                    _tile(
                      "Skipped",
                      skipped.toString(),
                      Colors.orange,
                    ),

                    _tile(
                      "Accuracy",
                      "${accuracy.toStringAsFixed(2)} %",
                      Colors.blue,
                    ),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReviewScreen(
                        questions: List<Map<String, dynamic>>.from(
                          widget.result["questions"] ?? [],
                        ),
                        selectedAnswers: List<dynamic>.from(
                          widget.result["selectedAnswers"] ?? [],
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.menu_book),
                label: const Text("View Questions & Solutions"),
              )
            ),

            const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await PdfService.createResultPdf(
                          studentName: "Mohan Kumar",
                          userId: "ARK123456",
                          mockTestName: "SSC GD Mock Test 01",
                          score: widget.result["score"].toDouble(),
                          correct: widget.result["correct"],
                          wrong: widget.result["wrong"],
                          skipped: widget.result["skipped"],
                          questions: (widget.result["questions"] as List<dynamic>? ?? [])
                              .map(
                                (e) => QuestionModel.fromMap(
                              e["id"] ?? "",
                              e["subjectId"] ?? "",
                              e["chapterId"] ?? "",
                              Map<String, dynamic>.from(e),
                            ),
                          )
                              .toList(),

                          selectedAnswers: List<int?>.from(
                            widget.result["selectedAnswers"] ?? [],
                          ),
                        );

                        await PdfService.printPdf(
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text("Preview PDF"),
                    )
              ),


                const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,

              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                        (route) => route.isFirst,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text("Back to Home"),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      Color color,
      IconData icon,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 35,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _tile(
      String title,
      String value,
      Color color,
      ) {
    return ListTile(
      title: Text(title),
      trailing: Text(
        value,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}