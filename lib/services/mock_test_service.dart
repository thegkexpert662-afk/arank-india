import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/question_model.dart';

class MockTestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuestionModel>> getMockTestQuestions(
      String mockTestId,
      ) async {
    final snapshot = await _firestore
        .collection('questions')
        .where('mockTestId', isEqualTo: mockTestId)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      return QuestionModel.fromMap(
        doc.id,
        doc['subjectId'] ?? '',
        doc['chapterId'] ?? '',
        doc.data(),
      );
    }).toList();
  }

  Future<List<QuestionModel>> getSubjectQuestions({
    required String subjectId,
    String? chapterId,
  }) async {
    Query query = _firestore
        .collection('questions')
        .where('subjectId', isEqualTo: subjectId)
        .where('isActive', isEqualTo: true);

    if (chapterId != null && chapterId.isNotEmpty) {
      query = query.where('chapterId', isEqualTo: chapterId);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      return QuestionModel.fromMap(
        doc.id,
        data['subjectId'] ?? '',
        data['chapterId'] ?? '',
        data,
      );
    }).toList();
  }
}