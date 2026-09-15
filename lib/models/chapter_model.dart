import 'package:flutter/material.dart';

class ChapterModel {
  final String id;
  final String subjectId;
  final String title;
  final IconData icon;

  final int totalQuestions;
  final int solvedQuestions;

  final bool isLocked;
  final double progress;

  const ChapterModel({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.icon,
    required this.totalQuestions,
    required this.solvedQuestions,
    required this.isLocked,
    required this.progress,
  });
}