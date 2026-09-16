import '../services/tenant_service.dart';

/// Backward-compatible runtime tenant accessor.
/// Tenant identity is now stored in SharedPreferences and resolved from the
/// Student App configuration instead of being hard-coded per build.
String? get kAdminTenantId => TenantService.appId;
