import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContinueLearningScreen extends StatefulWidget {
  final String setId;
  final String title;
  const ContinueLearningScreen({super.key, required this.setId, required this.title});

  @override
  State<ContinueLearningScreen> createState() => _ContinueLearningScreenState();
}

class _ContinueLearningScreenState extends State<ContinueLearningScreen> {
  final _db = FirebaseFirestore.instance;
  int _index = 0;
  bool _loading = true;
  bool _saving = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _questions = [];
  String? _selected;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final qs = await _db.collection('continue_learning').doc(widget.setId).collection('questions').orderBy('questionNo').get();
      final user = FirebaseAuth.instance.currentUser;
      int saved = 0;
      if (user != null) {
        final p = await _db.collection('users').doc(user.uid).collection('continue_learning_progress').doc(widget.setId).get();
        saved = (p.data()?['currentIndex'] as num?)?.toInt() ?? 0;
      }
      if (!mounted) return;
      setState(() {
        _questions = qs.docs;
        _index = saved.clamp(0, qs.docs.length);
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not load questions: $e')));
    }
  }

  Future<void> _saveProgress(int nextIndex) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _saving = true);
    await _db.collection('users').doc(user.uid).collection('continue_learning_progress').doc(widget.setId).set({
      'currentIndex': nextIndex,
      'totalQuestions': _questions.length,
      'completed': nextIndex >= _questions.length && _questions.isNotEmpty,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _next() async {
    if (_questions.isEmpty || _index >= _questions.length) return;
    final next = _index + 1;
    await _saveProgress(next);
    if (!mounted) return;
    setState(() {
      _index = next;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
              ? const Center(child: Text('No questions available in this set.'))
              : _index >= _questions.length
                  ? _completed()
                  : _questionView(_questions[_index].data()),
    );
  }

  Widget _completed() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.celebration_rounded, size: 70, color: Color(0xFF2D63E8)),
            const SizedBox(height: 15),
            const Text('Set Completed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${_questions.length}/${_questions.length} questions completed'),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => setState(() { _index = 0; _selected = null; }), child: const Text('Review from Start')),
          ]),
        ),
      );

  Widget _questionView(Map<String, dynamic> q) {
    final options = <String, String>{
      'A': '${q['optionA'] ?? ''}',
      'B': '${q['optionB'] ?? ''}',
      'C': '${q['optionC'] ?? ''}',
      'D': '${q['optionD'] ?? ''}',
    }..removeWhere((_, value) => value.trim().isEmpty);
    final hasOptions = options.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text('Question ${_index + 1} of ${_questions.length}', style: const TextStyle(fontWeight: FontWeight.w700))), Text('${((_index / _questions.length) * 100).round()}%')]),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: _index / _questions.length, minHeight: 7),
        const SizedBox(height: 24),
        Text('${q['question'] ?? ''}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 18),
        if (hasOptions) ...options.entries.map((entry) => _option(entry.key, entry.value, '${q['correctAnswer'] ?? ''}')),
        if (!hasOptions && '${q['answer'] ?? ''}'.trim().isNotEmpty) ...[
          const Text('Answer', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${q['answer']}'),
        ],
        const SizedBox(height: 25),
        if (_selected != null) ...[
          Text('Correct Answer: ${q['correctAnswer'] ?? q['answer'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w700)),
          if ('${q['explanation'] ?? ''}'.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('${q['explanation']}'),
          ],
          const SizedBox(height: 18),
        ],
        SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
          onPressed: _saving ? null : _next,
          child: Text(_index + 1 >= _questions.length ? 'Finish' : 'Next Question'),
        )),
      ]),
    );
  }

  Widget _option(String key, String value, String correct) {
    final selected = _selected == key;
    final isCorrect = key.toLowerCase() == correct.trim().toLowerCase() || value.trim().toLowerCase() == correct.trim().toLowerCase();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: _selected == null ? () => setState(() => _selected = key) : null,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), border: Border.all(color: selected ? (isCorrect ? Colors.green : Colors.red) : const Color(0xFFE1E6F0))),
          child: Row(children: [
            CircleAvatar(radius: 15, child: Text(key)),
            const SizedBox(width: 12),
            Expanded(child: Text(value)),
            if (selected) Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red),
          ]),
        ),
      ),
    );
  }
}
