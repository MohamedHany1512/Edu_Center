import 'package:dartz/dartz.dart';
import 'package:edu_app/core/models/course_model.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

class MyFavoritesRepo {
  final supabaseClient = Supabase.instance.client;

  String get userId => supabaseClient.auth.currentUser!.id;

  Future<Either<String, List<CourseModel>>> getMyFavorites() async {
    try {
      final response = await supabaseClient
          .from("favorites")
          .select("courses(*, course_videos(count))")
          .eq("user_id", userId);

      final myFavorites = response
          .map<CourseModel?>((row) {
            final course = row['courses'];
            if (course is! Map<String, dynamic>) {
              return null;
            }
            return CourseModel.fromJson({
              ...course,
              'lessons_count': CourseModel.parseLessonsCount(
                course['course_videos'],
              ),
            });
          })
          .whereType<CourseModel>()
          .toList();

      return Right(myFavorites);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// إزالة الكورس من المفضلة
  Future<Either<String, void>> removeFromFavorites(String courseId) async {
    try {
      await supabaseClient
          .from("favorites")
          .delete()
          .eq("user_id", userId)
          .eq("course_id", courseId);

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
