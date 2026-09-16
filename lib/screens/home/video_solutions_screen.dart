import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoSolutionsScreen extends StatefulWidget {
  const VideoSolutionsScreen({super.key});

  @override
  State<VideoSolutionsScreen> createState() => _VideoSolutionsScreenState();
}

class _VideoSolutionsScreenState extends State<VideoSolutionsScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _loading = true;
  bool _allowed = false;
  String _message = 'Loading video solutions...';
  String _instituteId = '';

  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        _message = 'Please login again.';
        return;
      }

      final userSnapshot = await _db.collection('users').doc(uid).get();
      final user = userSnapshot.data() ?? <String, dynamic>{};
      _instituteId = '${user['instituteId'] ?? user['tenantId'] ?? ''}';

      if (_instituteId.isEmpty) {
        _message = 'Institute is not connected.';
        return;
      }

      final appSnapshot = await _db.collection('apps').doc(_instituteId).get();
      final app = appSnapshot.data() ?? <String, dynamic>{};

      if (app['isActive'] == false) {
        _message = 'Your institute is currently inactive.';
        return;
      }

      final globalSnapshot = await _db.collection('service_controls').doc('global').get();
      final global = globalSnapshot.data() ?? <String, dynamic>{};

      if (global['videoSolutions'] == false) {
        _message = 'Video Solutions is currently unavailable.';
        return;
      }

      final adminUid = '${app['ownerAdminUid'] ?? app['adminUid'] ?? ''}';
      if (adminUid.isEmpty) {
        _message = 'Video Solutions is not configured for this institute.';
        return;
      }

      final adminControlSnapshot = await _db.collection('admin_service_controls').doc(adminUid).get();
      final adminControls = adminControlSnapshot.data() ?? <String, dynamic>{};

      if (adminControls['videoSolutions'] != true) {
        _message = 'Video Solutions is not enabled for your institute.';
        return;
      }

      _allowed = true;
    } catch (_) {
      _message = 'Unable to load Video Solutions.';
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _openVideo(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open this video.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_allowed) {
      return Scaffold(
        appBar: AppBar(title: const Text('Video Solutions')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline_rounded, size: 64, color: Colors.grey),
                const SizedBox(height: 14),
                Text(
                  _message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Video Solutions')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _db
            .collection('video_solutions')
            .where('instituteId', isEqualTo: _instituteId)
            .where('isActive', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Unable to load video solutions.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? <QueryDocumentSnapshot<Map<String, dynamic>>>[];
          if (docs.isEmpty) {
            return const Center(child: Text('No video solutions available yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(18),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final title = '${data['title'] ?? 'Video Solution'}';
              final subject = '${data['subject'] ?? ''}';
              final description = '${data['description'] ?? ''}';
              final videoUrl = '${data['videoUrl'] ?? ''}';

              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: videoUrl.trim().isEmpty ? null : () => _openVideo(videoUrl),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.blue,
                            size: 34,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                              ),
                              if (subject.isNotEmpty)
                                Text(subject, style: TextStyle(color: Colors.grey.shade600)),
                              if (description.isNotEmpty)
                                Text(
                                  description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      ],
                    ),
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
