import 'package:edu_app/core/models/course_model.dart';
import 'package:edu_app/features/my_favorites/data/repo/my_favorites_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'my_favorites_state.dart';


 
 
class MyFavoritesCubit extends Cubit<MyFavoritesState> {
  final MyFavoritesRepo myfavoritesRepo;
  MyFavoritesCubit({required this.myfavoritesRepo})
    : super(MyFavoritesInitial());

  Future<void> getMyFavorites() async {
    emit(MyFavoritesStateLoading());

    final result = await myfavoritesRepo.getMyFavorites();

    if (isClosed) return;

    result.fold(
      (failure) => emit(MyFavoritesStateFailure(message: failure)),
      (myFavorites) => emit(MyFavoritesStateLoaded(myFavorites: myFavorites)),
    );
  }

  /// إزالة كورس من المفضلة مع تحديث الحالة محلياً
  Future<void> removeFromFavorites(String courseId) async {
    if (state is! MyFavoritesStateLoaded) return;

    final currentState = state as MyFavoritesStateLoaded;
    final optimisticList = currentState.myFavorites
        .where((course) => course.id != courseId)
        .toList();

    emit(MyFavoritesStateLoaded(myFavorites: optimisticList));

    final result = await myfavoritesRepo.removeFromFavorites(courseId);

    if (isClosed) return;

    result.fold(
      // فشل الحذف: الرجوع للقائمة السابقة
      (_) => emit(MyFavoritesStateLoaded(myFavorites: currentState.myFavorites)),
      (_) => getMyFavorites(),
    );
  }
}
