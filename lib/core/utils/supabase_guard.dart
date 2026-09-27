import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Runs a Supabase call and normalises any thrown exception into a
/// `Left(String)` failure.
///
/// Every repository method previously repeated the same 8-line
/// `try { ... } on AuthException { } on PostgrestException { } catch { }`
/// block, which was copied 15+ times across 6 repositories. Centralising it
/// guarantees a new exception type is handled consistently everywhere, and
/// makes adding a repository method a one-liner.
///
/// Failures are surfaced as user-facing strings, so the underlying exception is
/// logged for diagnostics while the message stays safe to display.
Future<Either<String, T>> guardSupabase<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on AuthException catch (error, stackTrace) {
    _log('auth', error, stackTrace);
    return Left(error.message);
  } on PostgrestException catch (error, stackTrace) {
    _log('postgrest', error, stackTrace);
    return Left(error.message);
  } catch (error, stackTrace) {
    _log('unexpected', error, stackTrace);
    return Left(error.toString());
  }
}

void _log(String source, Object error, StackTrace stackTrace) {
  // ignore: avoid_print
  print('[Supabase:$source] $error\n$stackTrace');
}