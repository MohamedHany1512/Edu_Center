import 'package:edu_app/core/models/course_model.dart';
import 'package:edu_app/features/home/data/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

/// Business logic for the course catalogue: loading, searching and
/// optimistic favourite toggling.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required HomeRepo homeRepo})
    : _homeRepo = homeRepo,
      super(const HomeInitial());

  final HomeRepo _homeRepo;

  /// Loads courses, the user's display name and their favourite ids.
  Future<void> getHomeData() async {
    emit(const HomeLoading());

    // The three requests are independent, so they run concurrently instead of
    // the previous strictly sequential awaits.
    //
    // `Future.wait` is typed on a single element type, so the three differently
    // typed `Either`s are widened to `Object` and would lose their fold
    // signatures. Each future is therefore mapped to a record, which keeps
    // every result statically typed while still awaiting them together.
    final (coursesResult, nameResult, favoritesResult) = await (
      _homeRepo.getCourses(),
      _homeRepo.getUserName(),
      _homeRepo.getFavoriteCourseIds(),
    ).wait;

    // Protects against "emit after close" if the user left the screen while
    // the requests were in flight.
    if (isClosed) return;

    coursesResult.fold(
      (failure) => emit(HomeError(message: failure)),
      (courses) => emit(
        HomeSuccess(
          courses: courses,
          allCourses: courses,
          name: nameResult.fold((_) => '', (value) => value),
          favoriteIds: favoritesResult.fold(
            (_) => const <String>{},
            (ids) => ids.toSet(),
          ),
        ),
      ),
    );
  }

  /// Filters the catalogue by title, description or instructor.
  ///
  /// [query] is normalised once here rather than at each call site.
  void searchCourses(String query) {
    final currentState = state;
    if (currentState is! HomeSuccess) return;

    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      emit(
        HomeSuccess(
          courses: currentState.allCourses,
          allCourses: currentState.allCourses,
          name: currentState.name,
          favoriteIds: currentState.favoriteIds,
        ),
      );
      return;
    }

    final filtered = currentState.allCourses.where((course) {
      return course.title.toLowerCase().contains(searchQuery) ||
          course.desc.toLowerCase().contains(searchQuery) ||
          course.instructorName.toLowerCase().contains(searchQuery);
    }).toList();

    emit(
      HomeSuccess(
        courses: filtered,
        allCourses: currentState.allCourses,
        name: currentState.name,
        favoriteIds: currentState.favoriteIds,
      ),
    );
  }

  /// Adds or removes a favourite, updating the UI optimistically.
  ///
  /// Favourite writes now go through [HomeRepo] instead of reaching into
  /// `CourseDetailsRepo` and Supabase directly, which previously broke the
  /// layering of this cubit.
  Future<void> toggleFavorite(String courseId) async {
    final currentState = state;
    if (currentState is! HomeSuccess) return;

    final wasFavorite = currentState.favoriteIds.contains(courseId);

    final updatedIds = Set<String>.from(currentState.favoriteIds);
    wasFavorite ? updatedIds.remove(courseId) : updatedIds.add(courseId);

    // Optimistic update for instant feedback.
    emit(
      HomeSuccess(
        courses: currentState.courses,
        allCourses: currentState.allCourses,
        name: currentState.name,
        favoriteIds: updatedIds,
      ),
    );

    final result = wasFavorite
        ? await _homeRepo.removeFavorite(courseId)
        : await _homeRepo.addFavorite(courseId);

    if (isClosed) return;

    // Roll back to the previous state when persistence failed.
    if (result.isLeft()) {
      final reverted = Set<String>.from(updatedIds);
      wasFavorite ? reverted.add(courseId) : reverted.remove(courseId);

      emit(
        HomeSuccess(
          courses: currentState.courses,
          allCourses: currentState.allCourses,
          name: currentState.name,
          favoriteIds: reverted,
        ),
      );
    }
  }
}