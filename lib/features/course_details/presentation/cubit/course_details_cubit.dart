import 'package:edu_app/features/course_details/data/repo/course_details_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'course_details_state.dart';

class CourseDetailsCubit extends Cubit<EnrollmentState> {
  final CourseDetailsRepo courseDetailsRepo;
  CourseDetailsCubit({required this.courseDetailsRepo})
    : super(EnrollmentInitial());

  String get userId => Supabase.instance.client.auth.currentUser!.id;
  bool isEnrolled = false;

  bool isFavorite = false;
  bool isFavoriteLoading = false;

  bool isEnrollLoading = false;

  /// جلب حالة الاشتراك والمفضلة معاً عند فتح الصفحة
  Future<void> loadCourseState(String courseId) async {
    final enrollResult = await courseDetailsRepo.checkEnrollments(
      userId: userId,
      courseId: courseId,
    );

    if (isClosed) return;

    final favoriteResult = await courseDetailsRepo.checkFavorite(
      userId: userId,
      courseId: courseId,
    );

    if (isClosed) return;

    final String? error = enrollResult.fold((e) => e, (_) => null) ??
        favoriteResult.fold((e) => e, (_) => null);

    if (error != null) {
      emit(EnrollmentFailure(error));
      return;
    }

    isEnrolled = enrollResult.fold((_) => false, (value) => value);
    isFavorite = favoriteResult.fold((_) => false, (value) => value);

    emit(EnrollmentSuccess(isEnrolled: isEnrolled, isFavorite: isFavorite));
  }

  Future<void> enrollCourse(String courseId) async {
    if (isEnrollLoading) return;

    isEnrollLoading = true;
    emit(EnrollmentLoading());

    final result = await courseDetailsRepo.enrollCourse(userId, courseId);

    if (isClosed) return;

    isEnrollLoading = false;

    result.fold((error) => emit(EnrollmentFailure(error)), (_) {
      isEnrolled = true;
      emit(EnrollmentSuccess(isEnrolled: isEnrolled, isFavorite: isFavorite));
    });
  }

  Future<void> checkEnrollments({required String courseId}) async {
    final result = await courseDetailsRepo.checkEnrollments(
      userId: userId,
      courseId: courseId,
    );

    if (isClosed) return;

    result.fold((error) => emit(EnrollmentFailure(error)), (value) {
      isEnrolled = value;
      emit(EnrollmentSuccess(isEnrolled: isEnrolled, isFavorite: isFavorite));
    });
  }

  Future<void> checkFavorite({required String courseId}) async {
    final result = await courseDetailsRepo.checkFavorite(
      userId: userId,
      courseId: courseId,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(EnrollmentFailure(failure));
      },
      (value) {
        isFavorite = value;
        emit(EnrollmentSuccess(isEnrolled: isEnrolled, isFavorite: isFavorite));
      },
    );
  }

  Future<void> toggleFavorite({required String courseId}) async {
    if (isFavoriteLoading) return;

    isFavoriteLoading = true;
    final wasFavorite = isFavorite;

    // تحديث فوري للحالة قبل الاستجابة من السيرفر
    isFavorite = !wasFavorite;
    emit(EnrollmentSuccess(isEnrolled: isEnrolled, isFavorite: isFavorite));

    final result = wasFavorite
        ? await courseDetailsRepo.removeFavorite(
            userId: userId,
            courseId: courseId,
          )
        : await courseDetailsRepo.addFavorite(
            userId: userId,
            courseId: courseId,
          );

    if (isClosed) return;

    isFavoriteLoading = false;

    result.fold(
      (failure) {
        // فشل الحفظ: الرجوع للحالة السابقة
        isFavorite = wasFavorite;
        emit(EnrollmentSuccess(isEnrolled: isEnrolled, isFavorite: isFavorite));
        emit(EnrollmentFailure(failure));
      },
      (_) {
        emit(EnrollmentSuccess(isEnrolled: isEnrolled, isFavorite: isFavorite));
      },
    );
  }
}
