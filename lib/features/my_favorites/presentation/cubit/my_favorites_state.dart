part of 'my_favorites_cubit.dart';

abstract class MyFavoritesState {}

final class MyFavoritesInitial extends MyFavoritesState {}

final class MyFavoritesStateLoading extends MyFavoritesState {}

final class MyFavoritesStateLoaded extends MyFavoritesState {
  final List<CourseModel> myFavorites;

  MyFavoritesStateLoaded({required this.myFavorites});
}

final class MyFavoritesStateFailure extends MyFavoritesState {
  final String message;

  MyFavoritesStateFailure({required this.message});
}
