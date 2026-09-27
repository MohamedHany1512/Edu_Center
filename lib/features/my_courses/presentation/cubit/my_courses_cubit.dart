 import 'package:edu_app/core/models/course_model.dart';
import 'package:edu_app/features/my_courses/data/repo/mycourses_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
part 'my_courses_state.dart';

class MyCoursesCubit extends Cubit<MyCoursesState> {
  final MyCoursesRepo myCoursesRepo;

  MyCoursesCubit({required this.myCoursesRepo}) : super(MyCoursesInitial());

Future<void> getMyCourses() async {
  emit(MyCoursesLoading());

  final result = await myCoursesRepo.getMyCourses();

  // فحص ما إذا كان الـ Cubit ما زال مفعلًا قبل إرسال الحالة الجديدة
  if (isClosed) return;

  result.fold(
    (failure) {
      if (!isClosed) emit(MyCoursesFailure(message: failure));
    },
    (courses) {
      if (!isClosed) emit(MyCoursesLoaded(myCourses: courses));
    },
  );
}
}
