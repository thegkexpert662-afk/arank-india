import 'package:cloud_firestore/cloud_firestore.dart';


class MockResultService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveResult({
    required String userId,
    required String studentName,
    required String mockTestId,
    required String language,
    required double score,
    required int correct,
    required int wrong,
    required int skipped,
    required List<int?> selectedAnswers,
    required List<Map<String, dynamic>> questions,
    required String mockTestName,
    required int timeTaken,
    required double percentage,


  }) async {
    await _firestore
        .collection("mock_results")
        .doc("${userId}_$mockTestId")
        .set({
      "userId": userId,
      "studentName": studentName,
      "mockTestId": mockTestId,
      "language": language,

      "score": score,
      "correct": correct,
      "wrong": wrong,
      "skipped": skipped,

      "totalQuestions": correct + wrong + skipped,

      "submittedAt": FieldValue.serverTimestamp(),

      "isSubmitted": true,
      "selectedAnswers": selectedAnswers,
      "questions": questions,
      "mockTestName": mockTestName,
      "timeTaken": timeTaken,
      "percentage": percentage,
      "leaderboardDate":
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",

      "rewardEligible": percentage >= 75,

      "rewardRank": 0,

      "rewardAmount": 0,

      "claimStatus": "not_claimed",

      "claimRequested": false,

      "claimApproved": false,

      "claimExpired": false,

    });

  }

  Future<bool> isAlreadyAttempted({
    required String userId,
    required String mockTestId,
  }) async {
    final doc = await _firestore
        .collection("mock_results")
        .doc("${userId}_$mockTestId")
        .get();

    return doc.exists;
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getResult({
    required String userId,
    required String mockTestId,
  }) async {
    return await _firestore
        .collection("mock_results")
        .doc("${userId}_$mockTestId")
        .get();
  }
}
