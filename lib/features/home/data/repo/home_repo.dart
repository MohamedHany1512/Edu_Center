import 'package:dartz/dartz.dart';
import 'package:edu_app/core/models/course_model.dart';
import 'package:edu_app/core/utils/supabase_guard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Data source for the course catalogue and the user's favourite ids.
class HomeRepo {
  HomeRepo({SupabaseClient? supabaseClient})
    : _supabase = supabaseClient ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  /// The current user id, or `null` when signed out.
  ///
  /// Returning `null` instead of using `currentUser!.id` removes a hard crash:
  /// the session can expire while the app is in the foreground.
  String? get _userId => _supabase.auth.currentUser?.id;

  Future<Either<String, List<CourseModel>>> getCourses() {
    return guardSupabase(() async {
      final response = await _supabase
          .from('courses')
          .select('*, course_videos(count)')
          .order('created_at', ascending: false);

      return response.map<CourseModel>(
        (row) => CourseModel.fromJson({
          ...row,
          'lessons_count': CourseModel.parseLessonsCount(
            row['course_videos'],
          ),
        }),
      ).toList();
    });
  }

  /// Thrown when the session is missing. [guardSupabase] converts it into a
  /// `Left`, so the caller only ever sees a failure, never an exception.
  ///
  /// This is the same convention [addFavorite] and [removeFavorite] use for a
  /// signed-out user.
  static const _notSignedIn = AuthException('User is not signed in.');

  /// Reads the display name from the `profiles` table.
  ///
  /// Falls back to the Supabase account metadata, then to the email local part,
  /// so the header never renders blank.
  Future<Either<String, String>> getUserName() {
    return guardSupabase(() async {
      final user = _supabase.auth.currentUser;
      if (user == null) throw _notSignedIn;

      final response = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .maybeSingle();

      final fromProfiles = response?['full_name']?.toString().trim() ?? '';
      if (fromProfiles.isNotEmpty) return fromProfiles;

      return _fallbackName(user);
    });
  }

  String _fallbackName(User user) {
    final metadata = user.userMetadata?['full_name']?.toString().trim() ?? '';
    if (metadata.isNotEmpty) return metadata;

    return user.email?.split('@').first ?? '';
  }

  /// Ids of the current user's favourite courses.
  Future<Either<String, List<String>>> getFavoriteCourseIds() {
    return guardSupabase(() async {
      final userId = _userId;
      if (userId == null) return const <String>[];

      final response = await _supabase
          .from('favorites')
          .select('course_id')
          .eq('user_id', userId);

      return response
          .map((row) => row['course_id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    });
  }

  /// Adds a course to the current user's favourites.
  Future<Either<String, void>> addFavorite(String courseId) {
    return guardSupabase(() async {
      final userId = _userId;
      if (userId == null) throw _notSignedIn;

      await _supabase.from('favorites').insert({
        'user_id': userId,
        'course_id': courseId,
      });
    });
  }

  /// Removes a course from the current user's favourites.
  Future<Either<String, void>> removeFavorite(String courseId) {
    return guardSupabase(() async {
      final userId = _userId;
      if (userId == null) throw _notSignedIn;

      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('course_id', courseId);
    });
  }
}