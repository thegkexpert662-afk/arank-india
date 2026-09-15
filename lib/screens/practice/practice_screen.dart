import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/practice_provider.dart';
import '../../providers/subject_provider.dart';

import 'widgets/filter_section.dart';
import 'widgets/practice_header.dart';
import 'widgets/progress_banner.dart';
import 'widgets/subject_card.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final practiceProvider = context.watch<PracticeProvider>();
    final subjectProvider = context.watch<SubjectProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (subjectProvider.subjects.isEmpty &&
          !subjectProvider.isLoading) {
        subjectProvider.loadSubjects();
      }
    });

    final subjects = subjectProvider.subjects.where((subject) {
      if (practiceProvider.selectedCategory == "All") {
        return true;
      }
      return subject.category == practiceProvider.selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Practice"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const PracticeHeader(),
          const SizedBox(height: 20),

          const ProgressBanner(),
          const SizedBox(height: 20),

          const FilterSection(),
          const SizedBox(height: 20),

          if (subjectProvider.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(),
              ),
            )
          else if (subjects.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  "No Subjects Found",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            ...subjects.map(
                  (subject) => SubjectCard(
                subject: subject,
              ),
            ),
        ],
      ),
    );
  }
}