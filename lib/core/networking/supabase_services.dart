import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class SupabaseServices {
   static const String projectUrl = String.fromEnvironment(
    'https://fijhxvufaekpcibmpxzd.supabase.co',
    defaultValue: 'https://fijhxvufaekpcibmpxzd.supabase.co',
  );

   static const String publishableKey = String.fromEnvironment(
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZpamh4dnVmYWVrcGNpYm1weHpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTAzNTMwNzMsImV4cCI6MjEwNTkyOTA3M30.w0zw7DV7xNzcBlP4P_4dDMgSxsn3eFMgjcGR5MVbPFU',
    defaultValue: 'sb_publishable_8NyrjQ4f9Zw_OHWKzsZREw__LtMKHcG',
  );

  static bool get isConfigured =>
      projectUrl.isNotEmpty && publishableKey.isNotEmpty;

  static Future<void> init() async {
    if (!isConfigured) {
      throw StateError(
        'Supabase is not configured. Pass SUPABASE_URL and SUPABASE_ANON_KEY '
        'via --dart-define.',
      );
    }

    await Supabase.initialize(url: projectUrl, anonKey: publishableKey);
  }
}
