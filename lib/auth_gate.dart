// auth_gate.dart is now superseded by the GoRouter redirect guard in app_router.dart.
// Kept as a no-op stub to avoid breaking any remaining imports.
import 'package:flutter/material.dart';

/// Deprecated: routing is now handled by [AppRouter] in core/router/app_router.dart.
/// This widget is retained only to avoid removing the import in files that may
/// still reference it; it should be cleaned up in a future refactor.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
