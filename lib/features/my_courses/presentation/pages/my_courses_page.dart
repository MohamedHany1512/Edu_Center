import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/widgets/app_empty_view.dart';
import 'package:edu_app/core/widgets/app_error_view.dart';
import 'package:edu_app/core/widgets/app_loading_view.dart';
import 'package:edu_app/features/my_courses/data/repo/mycourses_repo.dart';
import 'package:edu_app/features/my_courses/presentation/cubit/my_courses_cubit.dart';
import 'package:edu_app/features/my_courses/presentation/widgets/my_courses_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCoursesPage extends StatelessWidget {
  /// يزداد مع كل عرض للصفحة ليتم إعادة جلب البيانات
  final int refreshToken;

  const MyCoursesPage({super.key, this.refreshToken = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MyCoursesCubit(myCoursesRepo: MyCoursesRepo())..getMyCourses(),
      child: _MyCoursesView(refreshToken: refreshToken),
    );
  }
}

class _MyCoursesView extends StatefulWidget {
  final int refreshToken;

  const _MyCoursesView({required this.refreshToken});

  @override
  State<_MyCoursesView> createState() => _MyCoursesViewState();
}

class _MyCoursesViewState extends State<_MyCoursesView> {
  @override
  void didUpdateWidget(covariant _MyCoursesView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.refreshToken != oldWidget.refreshToken) {
      context.read<MyCoursesCubit>().getMyCourses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "دوراتي",
          // size18PxBold -> titleLarge
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<MyCoursesCubit, MyCoursesState>(
        builder: (context, state) {
          if (state is MyCoursesLoading) {
            return const AppLoadingView();
          }

          if (state is MyCoursesFailure) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<MyCoursesCubit>().getMyCourses(),
            );
          }

          if (state is MyCoursesLoaded) {
            if (state.myCourses.isEmpty) {
              return const AppEmptyView(message: "لم تشترك في أي دورة بعد");
            }

            return RefreshIndicator(
              onRefresh: () => context.read<MyCoursesCubit>().getMyCourses(),
              child: MyCoursesListView(courses: state.myCourses),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
