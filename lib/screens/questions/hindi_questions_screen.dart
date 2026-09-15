import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';


class HindiQuestionsScreen extends StatefulWidget {
  const HindiQuestionsScreen({super.key});

  @override
  State<HindiQuestionsScreen> createState() =>
      _HindiQuestionsScreenState();
}

class _HindiQuestionsScreenState
    extends State<HindiQuestionsScreen> {

  final TextEditingController searchController =
  TextEditingController();

  List<Map<String, dynamic>> questions = [];
  List<Map<String, dynamic>> filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("hindi")
        .orderBy("questionNo", descending: false)
        .get();

    print("Documents = ${snapshot.docs.length}");

    questions = snapshot.docs.map((doc) {

      final Timestamp? createdAt = doc["createdAt"];

      final bool isNew = createdAt != null &&
          DateTime.now().difference(createdAt.toDate()).inHours < 24;

      return {
        "id": doc.id,
        "no": doc["questionNo"],
        "question": doc["question"],
        "answer": doc["answer"],
        "createdAt": createdAt,
        "isNew": isNew,
        "viewUpdated": false,
        "readUpdated": false,
        "reported": false,
        "liked": false,
      };
    }).toList();

    setState(() {
      filteredQuestions = List.from(questions);
    });
  }

  void searchQuestion(String value) {
    final search = value.trim().toLowerCase();

    setState(() {
      filteredQuestions = questions.where((q) {
        final question =
        q["question"].toString().toLowerCase();

        final number =
        q["no"].toString().toLowerCase();

        final isNew = q["isNew"] ?? false;

        return question.contains(search) ||
            number.contains(search) ||
            (search == "new" && isNew);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hindi"),
        centerTitle: true,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: searchQuestion,
              decoration: InputDecoration(
                hintText: "Search Question...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Total Questions : ${filteredQuestions.length}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredQuestions.length,
              itemBuilder: (context, index) {

                final q = filteredQuestions[index];
                if (q["viewUpdated"] == false) {
                  q["viewUpdated"] = true;

                  FirebaseFirestore.instance
                      .collection("hindi")
                      .doc(q["id"])
                      .update({
                    "views": FieldValue.increment(1),
                  });
                }
                final Timestamp? createdAt = q["createdAt"];

                final bool isNew = createdAt != null &&
                    DateTime.now().difference(createdAt.toDate()).inHours < 24;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Question No. ${q["no"]}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),

                                  if (isNew) ...[
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        "NEW",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.share,
                                size: 22,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection("hindi")
                                    .doc(q["id"])
                                    .update({
                                  "shares": FieldValue.increment(1),
                                });

                                Share.share(
                                  '''
                                    📚 ARANK INDIA
                                    
                                    🎯 SSC GD General Knowledge
                                    
                                    📝 Question No. ${q["no"]}
                                    
                                    ❓ ${q["question"]}
                                    
                                    ✅ Answer:
                                    ${q["answer"]}
                                    
                                    ━━━━━━━━━━━━━━━━━━━━━━
                                    
                                    📲 ARANK INDIA App
                                    SSC GD • Railway • Police • Defence • All Competitive Exams
                                    
                                    🚀 Download Coming Soon...
                                    ''',
                                );
                              },
                            ),

                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.flag_outlined,
                                size: 22,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                if (q["reported"] == true) return;

                                q["reported"] = true;

                                await FirebaseFirestore.instance
                                    .collection("hindi")
                                    .doc(q["id"])
                                    .update({
                                  "reportCount": FieldValue.increment(1),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Question Reported"),
                                  ),
                                );
                              },
                            ),

                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                q["liked"] == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                                size: 22,
                              ),
                              onPressed: () async {
                                if (q["liked"] == true) return;

                                q["liked"] = true;

                                await FirebaseFirestore.instance
                                    .collection("hindi")
                                    .doc(q["id"])
                                    .update({
                                  "likeCount": FieldValue.increment(1),
                                });

                                setState(() {});
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Question",
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          q["question"],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const Divider(height: 25),

                        const Text(
                          "Answer",
                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          q["answer"],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}