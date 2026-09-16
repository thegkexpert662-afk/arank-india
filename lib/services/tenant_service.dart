import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TenantService {
  static const _appIdKey = 'arank_app_id';
  static final _db = FirebaseFirestore.instance;

  static String? _appId;

  static String? get appId => _appId;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _appId = prefs.getString(_appIdKey);

    // Web deployments can receive the app ID once through a launch URL.
    final uri = Uri.base;
    final urlAppId = uri.queryParameters['appId']?.trim();
    if (urlAppId != null && urlAppId.isNotEmpty && urlAppId != _appId) {
      await setAppId(urlAppId);
    }
  }

  static Future<void> setAppId(String value) async {
    final normalized = value.trim().toUpperCase();
    if (normalized.isEmpty) throw ArgumentError('App ID cannot be empty');

    final snap = await _db.collection('apps').doc(normalized).get();
    final data = snap.data();
    if (!snap.exists || data == null || data['isActive'] != true) {
      throw StateError('Invalid or inactive App ID');
    }

    _appId = normalized;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appIdKey, normalized);
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getConfig() async {
    final id = _appId;
    if (id == null || id.isEmpty) throw StateError('Student App is not configured');
    return _db.collection('apps').doc(id).get();
  }

  static Future<void> attachStudentToTenant(String uid) async {
    final id = _appId;
    if (id == null || id.isEmpty || uid.isEmpty) return;
    await _db.collection('users').doc(uid).set({
      'tenantId': id,
      'appId': id,
      'tenantAssignedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
