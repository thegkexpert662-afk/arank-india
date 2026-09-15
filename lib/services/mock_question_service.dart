import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question_model.dart';

class MockQuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuestionModel>> getMockTestQuestions(
      String mockTestId,
      String language,
      ) async {
    final snapshot = await _firestore
        .collection('questions')
        .where('mockTestId', isEqualTo: mockTestId)
        .where('isActive', isEqualTo: true)
        .get();

    final questions = snapshot.docs.map((doc) {
      return QuestionModel.fromMap(
        doc.id,
        "",
        "",
        doc.data(),
      );
    }).toList();

    final maths = questions
        .where((q) => q.subject.trim().toUpperCase() == "MATHEMATICS")
        .toList();

    final reasoning = questions
        .where((q) => q.subject.trim().toUpperCase() == "REASONING")
        .toList();

    final gk = questions
        .where((q) => q.subject.trim().toUpperCase() == "GENERAL KNOWLEDGE")
        .toList();

    final lang = questions
        .where((q) =>
    q.subject.trim().toUpperCase() ==
        language.trim().toUpperCase())
        .toList();

    return [
      ...maths,
      ...reasoning,
      ...gk,
      ...lang,
    ];
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getMockTestDetails(
      String mockTestId,
      ) async {
    return await _firestore
        .collection('mock_tests')
        .doc(mockTestId)
        .get();
  }
}