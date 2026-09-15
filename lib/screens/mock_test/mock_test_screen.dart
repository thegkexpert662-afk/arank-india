import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../services/mock_question_service.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/mock_result_service.dart';
import 'result_screen.dart';



enum QuestionStatus {
  notVisited,
  notAnswered,
  answered,
  review,
  answeredReview,
}
class MockTestScreen extends StatefulWidget {
  final String mockTestId;
  final String language;

  const MockTestScreen({
    super.key,
    required this.mockTestId,
    required this.language,
  });

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();

        // Time Over
        submitTest(autoSubmit: true);
      }
    });
  }


  Timer? timer;

  int remainingSeconds = 60 * 60; // 60 Minutes

  int currentQuestion = 0;

  final MockQuestionService _service = MockQuestionService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final MockResultService _resultService = MockResultService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<QuestionStatus> questionStatus = [];
  List<QuestionModel> questions = [];
  List<int?> selectedAnswers = [];
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int skippedAnswers = 0;
  double finalScore = 0;


  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadQuestions();
  }


  int? selectedOption;

  bool isSubmitted = false;

  Future<void> submitTest({bool autoSubmit = false}) async {
    if (isSubmitted) return;

    isSubmitted = true;
    timer?.cancel();

    correctAnswers = 0;
    wrongAnswers = 0;
    skippedAnswers = 0;
    finalScore = 0;

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final selected = selectedAnswers[i];

      if (selected == null) {
        skippedAnswers++;
        continue;
      }

      String selectedAnswer = "";

      switch (selected) {
        case 0:
          selectedAnswer = "A";
          break;
        case 1:
          selectedAnswer = "B";
          break;
        case 2:
          selectedAnswer = "C";
          break;
        case 3:
          selectedAnswer = "D";
          break;
      }

      if (selectedAnswer == question.correctAnswer) {
        correctAnswers++;
        finalScore += question.marks;
      } else {
        wrongAnswers++;
        finalScore -= question.negativeMarks;
      }
    }
    final user = _auth.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    final studentName = userDoc.data()?["name"] ?? "Unknown";

    final questionsData = questions.map((q) => q.toMap()).toList();
    final questionModels = questions;
    final int totalQuestions = correctAnswers + wrongAnswers + skippedAnswers;

    final double percentage =
    totalQuestions == 0
        ? 0
        : (correctAnswers / totalQuestions) * 100;

    final int timeTaken = (60 * 60) - remainingSeconds;

    if (user != null) {
      await _resultService.saveResult(
        userId: user.uid,
        studentName: studentName,
        mockTestId: widget.mockTestId,
        language: widget.language,
        score: correctAnswers.toDouble(),
        correct: correctAnswers,
        wrong: wrongAnswers,
        skipped: skippedAnswers,
        selectedAnswers: selectedAnswers,
        questions: questionsData,
        mockTestName: widget.mockTestId,
        timeTaken: timeTaken,
        percentage: percentage,


      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            result: {
              "score": finalScore,
              "correct": correctAnswers,
              "wrong": wrongAnswers,
              "skipped": skippedAnswers,
              "totalQuestions":
              correctAnswers + wrongAnswers + skippedAnswers,

              "questions": questionsData,
              "questionModels": questionModels,
              "selectedAnswers": selectedAnswers,
            },
          ),
        ),
      );
    }
  }

  Future<void> loadQuestions() async {
    final user = _auth.currentUser;

    if (user != null) {
      final alreadyAttempted = await _resultService.isAlreadyAttempted(
        userId: user.uid,
        mockTestId: widget.mockTestId,
      );

      if (alreadyAttempted) {
        final result = await _resultService.getResult(
          userId: user.uid,
          mockTestId: widget.mockTestId,
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              result: result.data() ?? {},
            ),
          ),
        );

        return;
      }
    }

    final mockDoc = await _service.getMockTestDetails(widget.mockTestId);

    if (mockDoc.exists) {
      final data = mockDoc.data()!;
      remainingSeconds = (data["duration"] ?? 60) * 60;
    }

    questions = await _service.getMockTestQuestions(
      widget.mockTestId,
      widget.language,
    );

    selectedAnswers = List<int?>.filled(
      questions.length,
      null,
    );

    questionStatus = List.generate(
      questions.length,
          (_) => QuestionStatus.notVisited,
    );

    startTimer();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No Questions Found"),
        ),
      );
    }

    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mock Test"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                "${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:"
                    "${(remainingSeconds % 60).toString().padLeft(2, '0')}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Question ${currentQuestion + 1} / ${questions.length}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              question.question,
            ),

            SizedBox(
              height: 20,
            ),

            ...[
              question.optionA,
              question.optionB,
              question.optionC,
              question.optionD,
            ].asMap().entries.map(
                  (entry) {
                final i = entry.key;
                final option = entry.value;

                return RadioListTile<int>(
                  value: i,
                  groupValue: selectedAnswers[currentQuestion],
                  title: Text(option),
                    onChanged: isSubmitted
                        ? null
                        : (value) {
                     setState(() {
                      selectedAnswers[currentQuestion] = value;
                    });
                  },
                );
              },
            ),

            const Spacer(),


            Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                        setState(() {
                          currentQuestion--;
                      });
                    },
                    child: const Text("Previous"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentQuestion < questions.length - 1) {
                        setState(() {
                          currentQuestion++;

                          if (questionStatus[currentQuestion] ==
                              QuestionStatus.notVisited) {
                            questionStatus[currentQuestion] =
                                QuestionStatus.notAnswered;
                          }
                        });
                      }
                    },
                    child: const Text("Next"),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitted
                    ? null
                    : () async {
                  final submit = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Submit Test"),
                      content: const Text(
                        "Are you sure you want to submit the test?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("No"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );

                  if (submit == true) {
                    submitTest();
                  }
                },
                child: const Text("Submit Test"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}