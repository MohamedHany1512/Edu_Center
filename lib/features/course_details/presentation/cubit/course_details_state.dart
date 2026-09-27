part of 'course_details_cubit.dart';

abstract class EnrollmentState {}

final class EnrollmentInitial extends EnrollmentState {}

final class EnrollmentLoading extends EnrollmentState {}

final class EnrollmentSuccess extends EnrollmentState {
  final bool isEnrolled;
  final bool isFavorite;
  EnrollmentSuccess({required this.isEnrolled, required this.isFavorite});
}

final class EnrollmentFailure extends EnrollmentState {
  final String errorMessage;

  EnrollmentFailure(this.errorMessage);
}
