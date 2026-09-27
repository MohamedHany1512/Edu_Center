import 'package:dartz/dartz.dart';
import 'package:edu_app/core/utils/supabase_guard.dart';
import 'package:edu_app/features/course_videos/data/models/video_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Data source for course lessons.
class CourseVideosRepo {
  CourseVideosRepo({SupabaseClient? supabaseClient})
    : _supabase = supabaseClient ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  /// Lessons for [courseId], ordered by their position in the course.
  Future<Either<String, List<VideoModel>>> getCourseVideos(
    String courseId,
  ) {
    return guardSupabase(() async {
      final response = await _supabase
          .from('course_videos')
          .select()
          .eq('course_id', courseId)
          .order('order_index', ascending: true);

      return response.map(VideoModel.fromJson).toList();
    });
  }
}