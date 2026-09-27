import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseDetailsRepo {
  final supabaseClient = Supabase.instance.client;

  Future<Either<String, void>> enrollCourse(
    String userId,
    String courseId,
  ) async {
    try {
      await supabaseClient.from("user_courses").insert({
        "user_id": userId,
        "course_id": courseId,
      });
      return Right(null);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> checkEnrollments({
    required String userId,
    required String courseId,
  }) async {
    try {
      final response = await supabaseClient
          .from("user_courses")
          .select()
          .eq("user_id", userId)
          .eq("course_id", courseId)
          .maybeSingle(); //if the user is already enrolled in the course, return unique row, else return null
      return Right(response != null);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> checkFavorite({
    required String userId,
    required String courseId,
  }) async {
    try {
      final response = await supabaseClient
          .from("favorites")
          .select()
          .eq("user_id", userId)
          .eq("course_id", courseId)
          .maybeSingle();

      return Right(response != null);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> addFavorite({
    required String userId,
    required String courseId,
  }) async {
    try {
      await supabaseClient.from("favorites").insert({
        "user_id": userId,
        "course_id": courseId,
      });

      return Right(null);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> removeFavorite({
    required String userId,
    required String courseId,
  }) async {
    try {
      await supabaseClient
          .from("favorites")
          .delete()
          .eq("user_id", userId)
          .eq("course_id", courseId);

      return Right(null);
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
