import 'package:flutter/material.dart';
import '../../core/animations/app_animations.dart';

class ReviewScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final List<dynamic> selectedAnswers;

  const ReviewScreen({
    super.key,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  void _showQuestionPalette() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 450,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.questions.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              Color buttonColor = Colors.grey;

              final selected = widget.selectedAnswers[index];

              if (selected == null) {
                buttonColor = Colors.orange;
              } else {
                final correctAnswer =
                widget.questions[index]["correctAnswer"];

                final selectedLetter =
                _selectedLetter(selected);

                if (selectedLetter == correctAnswer) {
                  buttonColor = Colors.green;
                } else {
                  buttonColor = Colors.red;
                }
              }

              if (currentIndex == index) {
                buttonColor = Colors.blue;
              }

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);

                  setState(() {
                    currentIndex = index;
                  });
                },
                child: Text("${index + 1}"),
              );
            },
          ),
        );
      },
    );
  }
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];
    final selected = widget.selectedAnswers[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Question ${currentIndex + 1}/${widget.questions.length}",
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: _showQuestionPalette,
          ),
        ],
      ),
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            // Left Swipe → Next Question
            if (details.primaryVelocity! < 0) {
              if (currentIndex < widget.questions.length - 1) {
                setState(() {
                  currentIndex++;
                });
              }
            }

            // Right Swipe → Previous Question
            if (details.primaryVelocity! > 0) {
              if (currentIndex > 0) {
                setState(() {
                  currentIndex--;
                });
              }
            }
          },

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

            LinearProgressIndicator(
              value: (currentIndex + 1) / widget.questions.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),



            const SizedBox(height: 12),


            Text(
              "Question ${currentIndex + 1} / ${widget.questions.length}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: selected == null
                    ? Colors.yellow
                    : (_selectedLetter(selected) ==
                    question["correctAnswer"]
                    ? Colors.green
                    : Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected == null
                        ? Icons.remove_circle
                        : (_selectedLetter(selected) ==
                        question["correctAnswer"]
                        ? Icons.check_circle
                        : Icons.cancel),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    selected == null
                        ? "Skipped"
                        : (_selectedLetter(selected) ==
                        question["correctAnswer"]
                        ? "Correct"
                        : "Wrong"),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            AnimatedSwitcher(
              duration: AppAnimations.normal,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return AppAnimations.scale(child, animation);
              },
              child: Column(
                key: ValueKey(currentIndex),
                children: [

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      question["question"] ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _optionTile(
                    "A",
                    question["optionA"] ?? "",
                    selected == 0,
                    question["correctAnswer"] == "A",
                  ),

                  _optionTile(
                    "B",
                    question["optionB"] ?? "",
                    selected == 1,
                    question["correctAnswer"] == "B",
                  ),

                  _optionTile(
                    "C",
                    question["optionC"] ?? "",
                    selected == 2,
                    question["correctAnswer"] == "C",
                  ),

                  _optionTile(
                    "D",
                    question["optionD"] ?? "",
                    selected == 3,
                    question["correctAnswer"] == "D",
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Your Answer : ${_selectedLetter(selected)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Correct Answer : ${question["correctAnswer"]}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        question["explanation"] ??
                            "Explanation not available.",
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),

      ),
     ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: currentIndex == 0
                      ? null
                      : () {
                    setState(() {
                      currentIndex--;
                    });
                  },
                  label: const Text("Previous"),
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: currentIndex == widget.questions.length - 1
                      ? null
                      : () {
                    setState(() {
                      currentIndex++;
                    });
                  },

                  label: const Text("Next"),
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionTile(
      String letter,
      String option,
      bool selected,
      bool correct,
      ) {
    Color color = Colors.white;

    if (correct) {
      color = Colors.green.shade100;
    } else if (selected) {
      color = Colors.red.shade100;
    }

    return Card(
      color: color,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(letter),
        ),
        title: Text(option),
      ),
    );
  }

  String _selectedLetter(dynamic index) {
    switch (index) {
      case 0:
        return "A";
      case 1:
        return "B";
      case 2:
        return "C";
      case 3:
        return "D";
      default:
        return "Not Answered";
    }
  }
}