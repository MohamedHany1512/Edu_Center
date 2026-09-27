import 'package:dartz/dartz.dart';
import 'package:edu_app/core/models/course_model.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

class MyCoursesRepo {
  final supabaseClient = Supabase.instance.client;

  String get userId => supabaseClient.auth.currentUser!.id;

  Future<Either<String, List<CourseModel>>> getMyCourses() async {
    try {
      final response = await supabaseClient
          .from("user_courses")
          .select("courses(*, course_videos(count))")
          .eq("user_id", userId);

      final myCourses = response
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

      return Right(myCourses);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
