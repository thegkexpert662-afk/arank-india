import 'package:flutter/material.dart';
import '../models/subject_model.dart';

class SubjectData {
  static const List<SubjectModel> subjects = [

    SubjectModel(
      id: "reasoning",
      title: "General Intelligence",
      category: "Reasoning",
      icon: Icons.psychology,
      color: Colors.deepPurple,
      totalChapters: 25,
      completedChapters: 12,
      totalQuestions: 1200,
      solvedQuestions: 580,
      progress: 0.48,
      order: 2,
      isActive: true,
    ),

    SubjectModel(
      id: "math",
      title: "Mathematics",
      category: "Math",
      icon: Icons.calculate,
      color: Colors.blue,
      totalChapters: 30,
      completedChapters: 8,
      totalQuestions: 1500,
      solvedQuestions: 420,
      progress: 0.28,
      order: 2,
      isActive: true,
    ),

    SubjectModel(
      id: "english",
      title: "English",
      category: "English",
      icon: Icons.menu_book,
      color: Colors.green,
      totalChapters: 20,
      completedChapters: 10,
      totalQuestions: 900,
      solvedQuestions: 460,
      progress: 0.50,
      order: 2,
      isActive: true,
    ),

    SubjectModel(
      id: "gk",
      title: "General Knowledge",
      category: "GK",
      icon: Icons.public,
      color: Colors.orange,
      totalChapters: 35,
      completedChapters: 15,
      totalQuestions: 2000,
      solvedQuestions: 900,
      progress: 0.45,
      order: 2,
      isActive: true,
    ),

    SubjectModel(
      id: "hindi",
      title: "Hindi",
      category: "Hindi",
      icon: Icons.text_fields,
      color: Colors.red,
      totalChapters: 22,
      completedChapters: 0,
      totalQuestions: 1000,
      solvedQuestions: 0,
      progress: 0.0,
      order: 2,
      isActive: true,
    ),
  ];
}