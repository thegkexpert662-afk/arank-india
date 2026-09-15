import 'package:flutter/material.dart';
import '../models/chapter_model.dart';

class ChapterData {
  static const List<ChapterModel> chapters = [

    // ================= Reasoning =================

    ChapterModel(
      id: "r1",
      subjectId: "reasoning",
      title: "Analogy",
      icon: Icons.psychology,
      totalQuestions: 120,
      solvedQuestions: 0,
      isLocked: false,
      progress: 0,
    ),

    ChapterModel(
      id: "r2",
      subjectId: "reasoning",
      title: "Classification",
      icon: Icons.psychology,
      totalQuestions: 100,
      solvedQuestions: 0,
      isLocked: false,
      progress: 0,
    ),

    // ================= Mathematics =================

    ChapterModel(
      id: "m1",
      subjectId: "math",
      title: "Number System",
      icon: Icons.calculate,
      totalQuestions: 150,
      solvedQuestions: 0,
      isLocked: false,
      progress: 0,
    ),

    ChapterModel(
      id: "m2",
      subjectId: "math",
      title: "Percentage",
      icon: Icons.calculate,
      totalQuestions: 130,
      solvedQuestions: 0,
      isLocked: false,
      progress: 0,
    ),

    // ================= English =================

    ChapterModel(
      id: "e1",
      subjectId: "english",
      title: "Grammar",
      icon: Icons.menu_book,
      totalQuestions: 180,
      solvedQuestions: 0,
      isLocked: false,
      progress: 0,
    ),

    // ================= Hindi =================

    ChapterModel(
      id: "h1",
      subjectId: "hindi",
      title: "संज्ञा",
      icon: Icons.text_fields,
      totalQuestions: 150,
      solvedQuestions: 0,
      isLocked: false,
      progress: 0,
    ),

    // ================= GK =================

    ChapterModel(
      id: "g1",
      subjectId: "gk",
      title: "History",
      icon: Icons.public,
      totalQuestions: 220,
      solvedQuestions: 0,
      isLocked: false,
      progress: 0,
    ),
  ];
}