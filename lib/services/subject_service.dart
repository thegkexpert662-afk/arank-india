import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject_model.dart';

class SubjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SubjectModel>> getSubjects() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .get();

    return snapshot.docs
        .map((doc) => SubjectModel.fromFirestore(doc.id, doc.data()))
        .toList();
  }
}