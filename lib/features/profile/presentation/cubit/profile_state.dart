part of 'profile_cubit.dart';

abstract class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileUpdating extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final ProfileModel profileModel;
  final int count;
  final int favoritesCount;

  ProfileLoaded({
    required this.profileModel,
    required this.count,
    this.favoritesCount = 0,
  });
}

final class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure({required this.message});
}

final class LoggedOut extends ProfileState {}

final class AuthFailure extends ProfileState {
  final String message;

  AuthFailure({required this.message});
}
