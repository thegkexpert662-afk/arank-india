import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question_model.dart';

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuestionModel>> getQuestionsBySubject(
      String subject,
      ) async {
    final snapshot = await _firestore
        .collection('questions')
        .where('subject', isEqualTo: subject)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => QuestionModel.fromMap(
      doc.id,
      "",
      "",
      doc.data(),
    ))
        .toList();
  }
}