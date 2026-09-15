import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../services/subject_service.dart';

class SubjectProvider extends ChangeNotifier {
  final SubjectService _service = SubjectService();

  List<SubjectModel> _subjects = [];
  bool _isLoading = false;

  List<SubjectModel> get subjects => _subjects;
  bool get isLoading => _isLoading;

  Future<void> loadSubjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      _subjects = await _service.getSubjects();
    } catch (e) {
      debugPrint("Subject Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}