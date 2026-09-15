import 'package:flutter/material.dart';

class PracticeProvider extends ChangeNotifier {
  String _selectedCategory = "All";

  String get selectedCategory => _selectedCategory;

  final List<String> categories = [
    "All",
    "GK",
    "Reasoning",
    "Math",
    "English",
  ];

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  bool isSelected(String category) {
    return _selectedCategory == category;
  }
}