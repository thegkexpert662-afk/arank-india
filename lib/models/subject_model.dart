import 'package:flutter/material.dart';

class SubjectModel {
  final String id;
  final String title;
  final String category;

  final IconData icon;
  final Color color;

  final int order;
  final bool isActive;

  final int totalChapters;
  final int completedChapters;

  final int totalQuestions;
  final int solvedQuestions;

  final double progress;

  const SubjectModel({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.color,
    required this.order,
    required this.isActive,
    this.totalChapters = 0,
    this.completedChapters = 0,
    this.totalQuestions = 0,
    this.solvedQuestions = 0,
    this.progress = 0,
  });

  factory SubjectModel.fromFirestore(
      String id,
      Map<String, dynamic> data,
      ) {
    return SubjectModel(
      id: id,
      title: data["name"] ?? "",
      category: data["category"] ?? "",

      icon: _getIcon(data["icon"] ?? ""),
      color: _getColor(id),

      order: data["order"] ?? 0,
      isActive: data["isActive"] ?? true,

      totalChapters: data["totalChapters"] ?? 0,
      completedChapters: data["completedChapters"] ?? 0,
      totalQuestions: data["totalQuestions"] ?? 0,
      solvedQuestions: data["solvedQuestions"] ?? 0,
      progress: (data["progress"] ?? 0).toDouble(),
    );
  }

  static IconData _getIcon(String icon) {
    switch (icon) {
      case "calculate":
        return Icons.calculate;
      case "psychology":
        return Icons.psychology;
      case "public":
        return Icons.public;
      case "menu_book":
        return Icons.menu_book;
      default:
        return Icons.book;
    }
  }

  static Color _getColor(String id) {
    switch (id) {
      case "math":
        return Colors.blue;
      case "reasoning":
        return Colors.deepPurple;
      case "gk":
        return Colors.orange;
      case "english":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}