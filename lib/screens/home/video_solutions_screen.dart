import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoSolutionsScreen extends StatefulWidget {
  const VideoSolutionsScreen({super.key});
  @override State<VideoSolutionsScreen> createState() => _VideoSolutionsScreenState();
}

class _VideoSolutionsScreenState extends State<VideoSolutionsScreen> {
  final _db = FirebaseFirestore.instance;
  bool _loading = true;
  bool _allowed = false;
  String _message = 'Loading video solutions...';
  String _instituteId = '';

  @override
  void initState() { super.initState(); _checkAccess(); }

  Future<void> _checkAccess() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) { _message = 'Please login again.'; return; }
      final user = (await _db.collection('users').doc(uid).get()).data() ?? {};
      _instituteId = '${user['instituteId'] ?? user['tenantId'] ?? ''}';
      if (_instituteId.isEmpty) { _message = 'Institute is not connected.'; return; }
      final app = (await _db.collection('apps').doc(_instituteId).get()).data() ?? {};
      if (app['isActive'] == false) { _message = 'Your institute is currently inactive.'; return; }
      final global = (await _db.collection('service_controls').doc('global').get()).data() ?? {};
      if (global['videoSolutions'] == false) { _message = 'Video Solutions is currently unavailable.'; return; }
      final adminUid = '${app['ownerAdminUid'] ?? app['adminUid'] ?? ''}';
      if (adminUid.isEmpty) { _message = 'Video Solutions is not configured for this institute.'; return; }
      final admin = (await _db.collection('admin_service_controls').doc(adminUid).get()).data() ?? {};
      if (admin['videoSolutions'] != true) { _message = 'Video Solutions is not enabled for your institute.'; return; }
      _allowed = true;
    } catch (_) { _message = 'Unable to load Video Solutions.'; }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _open(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to open this video.')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Video Solutions')),
    body: _loading ? const Center(child: CircularProgressIndicator()) : !_allowed ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.lock_outline_rounded, size: 64, color: Colors.grey), const SizedBox(height: 14), Text(_message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700))])) : StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: _db.collection('video_solutions').where('instituteId', isEqualTo: _instituteId).where('isActive', isEqualTo: true).snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) return const Center(child: Text('No video solutions available yet.'));
        return ListView.separated(padding: const EdgeInsets.all(18), itemCount: docs.length, separatorBuilder: (_,__)=>const SizedBox(height:12), itemBuilder: (_,i){final d=docs[i].data(); return Card(child: InkWell(borderRadius: BorderRadius.circular(16), onTap: ()=>_open('${d['videoUrl']??''}'), child: Padding(padding:const EdgeInsets.all(16),child:Row(children:[Container(width:58,height:58,decoration:BoxDecoration(color:Colors.blue.shade50,borderRadius:BorderRadius.circular(16)),child:const Icon(Icons.play_circle_fill_rounded,color:Colors.blue,size:34)),const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('${d['title']??'Video Solution'}',style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800)),if('${d['subject']??''}'.isNotEmpty) Text('${d['subject']}',style:TextStyle(color:Colors.grey.shade600)),if('${d['description']??''}'.isNotEmpty) Text('${d['description']}',maxLines:2,overflow:TextOverflow.ellipsis,style:TextStyle(color:Colors.grey.shade600))])),const Icon(Icons.arrow_forward_ios_rounded,size:16)]))));});
      },
    ),
  );
}
