import 'package:edu_app/features/profile/data/models/profile_model.dart';
import 'package:edu_app/features/profile/data/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  Future<void> getProfileData() async {
    emit(ProfileLoading());

    final userResult = await profileRepo.getProfileData();

    if (isClosed) return; // حماية بعد الانتظار الأول

    ProfileModel? userProfile;

    userResult.fold(
      (failure) {
        emit(ProfileFailure(message: failure));
      },
      (profile) {
        userProfile = profile;
      },
    );

    if (userProfile == null || isClosed) return;

    final coursesResult = await profileRepo.getCoursesCount();
    final favoritesResult = await profileRepo.getFavoritesCount();

    if (isClosed) return; // حماية بعد الانتظار الثاني

    coursesResult.fold(
      (failure) {
        emit(ProfileFailure(message: failure));
      },
      (count) {
        if (isClosed) return;
        emit(
          ProfileLoaded(
            profileModel: userProfile!,
            count: count,
            favoritesCount: favoritesResult.fold((_) => 0, (value) => value),
          ),
        );
      },
    );
  }

  Future<void> updateProfile({
    required String fullName,
    String? avatarUrl,
  }) async {
    emit(ProfileUpdating());

    final result = await profileRepo.updateProfile(
      fullName: fullName,
      avatarUrl: avatarUrl,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(ProfileFailure(message: failure)),
      (_) => getProfileData(),
    );
  }

  Future<void> logout() async {
    emit(ProfileLoading());

    final result = await profileRepo.logout();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(AuthFailure(message: failure));
      },
      (_) {
        emit(LoggedOut());
      },
    );
  }
}
