part of 'my_courses_cubit.dart';

abstract class MyCoursesState {}

final class MyCoursesInitial extends MyCoursesState {}

final class MyCoursesLoading extends MyCoursesState {}

final class MyCoursesLoaded extends MyCoursesState {
  final List<CourseModel> myCourses;

  MyCoursesLoaded({required this.myCourses});
}

final class MyCoursesFailure extends MyCoursesState {
  final String message;

  MyCoursesFailure({required this.message});
}
