import 'package:flutter/material.dart';
import '../../data/question_data.dart';
import '../../models/question_model.dart';
import 'result_screen.dart';
import 'dart:async';
import '../../models/question_status.dart';
import 'package:shared_preferences/shared_preferences.dart';



class QuestionScreen extends StatefulWidget {
  final String chapterId;
  final String chapterName;
  final String subject;

  const QuestionScreen({
    super.key,
    required this.chapterId,
    required this.chapterName,
    required this.subject,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}
late List<QuestionModel> questions;

class _QuestionScreenState extends State<QuestionScreen> {
  int? selectedAnswer;
  bool answerSubmitted = false;

  int currentQuestionIndex = 0;

  Timer? timer;
  int timeLeft = 20 * 60;

  Map<int, int> userAnswers = {};
  Map<int, QuestionStatus> questionStatus = {};

  int calculateScore() {
    int totalScore = 0;

    for (int i = 0; i < questions.length; i++) {
      if (!userAnswers.containsKey(i)) continue;

      if (userAnswers[i] == questions[i].correctAnswer) {
        totalScore++;
      }
    }

    return totalScore;
  }

  int calculateWrong() {
    int wrong = 0;

    for (int i = 0; i < questions.length; i++) {
      if (userAnswers.containsKey(i) &&
          userAnswers[i] != questions[i].correctAnswer) {
        wrong++;
      }
    }

    return wrong;
  }

  int calculateUnattempted() {
    return questions.length - userAnswers.length;
  }

  @override
  void initState() {
    super.initState();

    questions = QuestionData.questions
        .where((q) => q.subject == widget.subject)
        .toList();

    questionStatus.putIfAbsent(
      0,
          () => QuestionStatus.visited,
    );

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              correct: calculateScore(),
              wrong: calculateWrong(),
              unattempted: calculateUnattempted(),
              totalQuestions: questions.length,
            ),
          ),
        );
      }
    });
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'currentQuestion_${widget.chapterId}',
      currentQuestionIndex,
    );

    await prefs.setString(
      'userAnswers_${widget.chapterId}',
      userAnswers.toString(),
    );
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    currentQuestionIndex =
        prefs.getInt('currentQuestion_${widget.chapterId}') ?? 0;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QuestionModel question = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: Text(widget.chapterName),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question ${currentQuestionIndex + 1} / ${questions.length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "${(timeLeft ~/ 60).toString().padLeft(2, '0')}:${(timeLeft % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 12),

            const SizedBox(height: 16),

            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final answered = userAnswers.containsKey(index);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentQuestionIndex = index;

                        if (answered) {
                          selectedAnswer = userAnswers[index];
                          answerSubmitted = true;
                        } else {
                          selectedAnswer = null;
                          answerSubmitted = false;
                        }
                      });
                    },
                    child: Container(
                      width: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: currentQuestionIndex == index
                            ? Colors.orange
                            : questionStatus[index] == QuestionStatus.answered
                            ? Colors.green
                            : questionStatus[index] == QuestionStatus.answeredReview
                            ? Colors.deepPurple
                            : questionStatus[index] == QuestionStatus.review
                            ? Colors.purple
                            : questionStatus[index] == QuestionStatus.visited
                            ? Colors.yellow
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {

                  final options = [
                    question.optionA,
                    question.optionB,
                    question.optionC,
                    question.optionD,
                  ];

                  final correctIndex = ["A", "B", "C", "D"]
                      .indexOf(question.correctAnswer.toUpperCase());

                  return Card(
                    color: answerSubmitted
                        ? index == correctIndex
                        ? Colors.green.shade100
                        : index == selectedAnswer
                        ? Colors.red.shade100
                        : null
                        : null,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () {
                        if (answerSubmitted) return;

                        setState(() {
                          selectedAnswer = index;
                          answerSubmitted = true;

                          userAnswers[currentQuestionIndex] = index;

                          if (questionStatus[currentQuestionIndex] ==
                              QuestionStatus.review) {
                            questionStatus[currentQuestionIndex] =
                                QuestionStatus.answeredReview;
                          } else {
                            questionStatus[currentQuestionIndex] =
                                QuestionStatus.answered;
                          }
                        });
                      },
                      title: Text(options[index]),
                    ),
                  );
                },
              ),
            ),

            if (answerSubmitted)
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Explanation",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.explanation,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Question reported successfully."),
                    ),
                  );
                },
                icon: const Icon(Icons.flag),
                label: const Text("Report Question"),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    if (userAnswers.containsKey(currentQuestionIndex)) {
                      questionStatus[currentQuestionIndex] =
                          QuestionStatus.answeredReview;
                    } else {
                      questionStatus[currentQuestionIndex] =
                          QuestionStatus.review;
                    }
                  });
                },
                icon: const Icon(Icons.bookmark_border),
                label: const Text("Mark for Review"),
              ),
            ),

            const SizedBox(height: 10),

            const SizedBox(height: 12),



            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: currentQuestionIndex == 0
                        ? null
                        : () {
                      setState(() {
                        currentQuestionIndex--;

                        if (userAnswers.containsKey(currentQuestionIndex)) {
                          selectedAnswer = userAnswers[currentQuestionIndex];
                          answerSubmitted = true;
                        } else {
                          selectedAnswer = null;
                          answerSubmitted = false;
                        }
                      });
                    },
                    child: const Text("Previous"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {

                      if (currentQuestionIndex < questions.length - 1) {
                        setState(() {
                          currentQuestionIndex++;
                          saveProgress();

                          questionStatus.putIfAbsent(
                            currentQuestionIndex,
                                () => QuestionStatus.visited,
                          );

                          if (userAnswers.containsKey(currentQuestionIndex)) {
                            selectedAnswer = userAnswers[currentQuestionIndex];
                            answerSubmitted = true;
                          } else {
                            selectedAnswer = null;
                            answerSubmitted = false;
                          }
                        });
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultScreen(
                              correct: calculateScore(),
                              wrong: calculateWrong(),
                              unattempted: calculateUnattempted(),
                              totalQuestions: questions.length,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      currentQuestionIndex == questions.length - 1
                          ? "Finish"
                          : "Next",
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}