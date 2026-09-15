import 'package:flutter/material.dart';

import '../../data/chapter_data.dart';
import '../../models/chapter_model.dart';
import '../questions/question_screen.dart';

class ChapterScreen extends StatelessWidget {
  final String subjectId;
  final String subjectName;

  const ChapterScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    final List<ChapterModel> chapters = ChapterData.chapters
        .where((chapter) => chapter.subjectId == subjectId)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(subjectName),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  Row(
                    children: [

                      CircleAvatar(
                        backgroundColor:
                        Colors.blue.withOpacity(.12),
                        child: Icon(
                          chapter.icon,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              chapter.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "${chapter.totalQuestions} Questions",
                            ),

                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuestionScreen(
                                chapterId: chapter.id,
                                chapterName: chapter.title,
                                subject: subjectName,
                              ),
                            ),
                          );
                        },
                        child: const Text("Start"),
                      ),

                    ],
                  ),

                  const SizedBox(height: 15),

                  LinearProgressIndicator(
                    value: chapter.progress,
                    minHeight: 8,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "${chapter.solvedQuestions}/${chapter.totalQuestions} Solved",
                      ),

                      Text(
                        "${(chapter.progress * 100).toInt()}%",
                      ),

                    ],
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}