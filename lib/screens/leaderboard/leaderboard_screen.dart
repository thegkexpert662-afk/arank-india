import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {


  Future<String> getClaimStatus(String userId, String mockTestId) async {
    final result = await FirebaseFirestore.instance
        .collection("reward_claims")
        .where("userId", isEqualTo: userId)
        .where("mockTestId", isEqualTo: mockTestId)
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      return "not_claimed";
    }

    return result.docs.first["claimStatus"] ?? "pending";
  }
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {
                    final today =
                  "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
              return Scaffold(
                  appBar: AppBar(
                    title: const Text("Leaderboard"),
              ),


      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("mock_results")
            .where("leaderboardDate", isEqualTo: today)
            .orderBy("score", descending: true)
            .orderBy("timeTaken")
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Leaderboard Data"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                  color: data["userId"] == currentUserId
                      ? Colors.blue.shade50
                      : null,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: index == 0
                          ? Colors.amber
                          : index == 1
                          ? Colors.grey
                          : index == 2
                          ? Colors.brown
                          : Colors.blue,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      data["studentName"] ?? "Unknown",
                      style: TextStyle(
                        fontWeight: data["userId"] == currentUserId
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,


                      children: [

                        if (data["claimStatus"] == "pending")
                          const Text(
                            "⏳ Status: Pending",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        if (data["claimStatus"] == "approved")
                          const Text(
                            "✅ Status: Approved",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        if (data["claimStatus"] == "rejected")
                          const Text(
                            "❌ Status: Rejected",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Text(
                          "Score: ${data["score"]} | ${data["language"]}",
                        ),
                        const SizedBox(height: 6),

                        if (index == 0 &&
                            data["userId"] == currentUserId &&
                            (data["percentage"] ?? 0) >= 75)


                          ElevatedButton(
                            onPressed: () async {

                              final existing = await FirebaseFirestore.instance
                                  .collection("reward_claims")
                                  .where("userId", isEqualTo: currentUserId)
                                  .where("mockTestId", isEqualTo: data["mockTestId"])
                                  .get();

                              if (existing.docs.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("You have already claimed this reward."),
                                  ),
                                );
                                return;
                              }
                              await FirebaseFirestore.instance
                                  .collection("reward_claims")
                                  .add({
                                "userId": currentUserId,
                                "studentName": data["studentName"],
                                "mockTestId": data["mockTestId"],
                                "rank": index + 1,
                                "rewardAmount": index == 0
                                    ? 101
                                    : index == 1
                                    ? 51
                                    : 21,
                                "percentage": data["percentage"],
                                "claimStatus": "pending",
                                "adminApproved": false,
                                "claimExpired": false,
                                "claimRequestedAt": FieldValue.serverTimestamp(),
                              });
                              await FirebaseFirestore.instance
                                  .collection("mock_results")
                                  .doc("${currentUserId}_${data["mockTestId"]}")
                                  .update({
                                "claimRequested": true,
                                "claimStatus": "pending",
                                "rewardRank": index + 1,
                                "rewardAmount": index == 0
                                    ? 101
                                    : index == 1
                                    ? 51
                                    : 21,
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Reward claim submitted successfully."),
                                ),
                              );
                            },
                            child: const Text("🥇 Claim ₹101"),
                          ),

                        if (index == 1 &&
                            data["userId"] == currentUserId &&
                            (data["percentage"] ?? 0) >= 75)
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("🥈 Claim ₹51"),
                          ),

                        if (index == 2 &&
                            data["userId"] == currentUserId &&
                            (data["percentage"] ?? 0) >= 75)
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("🥉 Claim ₹21"),
                          ),
                      ],
                    ),


                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                        "${data["score"]}/100",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${data["percentage"]?.toStringAsFixed(1) ?? 0}%",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),




               ),
              );
            },
          );
        },
      ),
    );
  }
}