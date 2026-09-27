part of 'home_cubit.dart';

/// Home screen states.
///
/// `sealed` + `const` so consumers can `switch` exhaustively and identical
/// states are not re-allocated on every transition.
sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeSuccess extends HomeState {
  const HomeSuccess({
    required this.courses,
    required this.name,
    required this.allCourses,
    this.favoriteIds = const <String>{},
  });

  /// Courses after applying the active search filter.
  final List<CourseModel> courses;

  /// Unfiltered catalogue, kept so clearing the search restores the full list.
  final List<CourseModel> allCourses;

  final String name;

  /// Ids of the current user's favourite courses.
  final Set<String> favoriteIds;
}

final class HomeError extends HomeState {
  const HomeError({required this.message});

  final String message;
}