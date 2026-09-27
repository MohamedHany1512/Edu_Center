 import 'package:edu_app/core/models/course_model.dart';
import 'package:edu_app/core/routing/app_navigation.dart';
 import 'package:edu_app/core/widgets/app_empty_view.dart';
import 'package:edu_app/core/widgets/app_error_view.dart';
import 'package:edu_app/core/widgets/app_loading_view.dart';
 import 'package:edu_app/features/home/data/repo/home_repo.dart';
import 'package:edu_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:edu_app/features/home/presentation/widgets/course_grid_card.dart';
import 'package:edu_app/features/home/presentation/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Course catalogue screen.
class HomePage extends StatelessWidget {
  const HomePage({super.key, this.refreshToken = 0});

 
  final int refreshToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(homeRepo: HomeRepo())..getHomeData(),
      child: _HomeView(refreshToken: refreshToken),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({required this.refreshToken});

  final int refreshToken;

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.refreshToken != oldWidget.refreshToken) {
      context.read<HomeCubit>().getHomeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeLoading() => const AppLoadingView(),
            HomeError(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<HomeCubit>().getHomeData(),
            ),
            HomeSuccess() => _HomeContent(
              state: state,
              searchController: _searchController,
            ),
            HomeInitial() => const AppLoadingView(),
          };
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state, required this.searchController});

  final HomeSuccess state;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    if (state.allCourses.isEmpty) {
      return const Scaffold(
        body: AppEmptyView(message: 'No courses available'),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          HomeHeader(
            name: state.name,
            searchController: searchController,
            onSearch: (query) =>
                context.read<HomeCubit>().searchCourses(query),
          ),
          Expanded(
            child: state.courses.isEmpty
                ? const AppEmptyView(
                    message: 'No courses found',
                    icon: Icons.search_off_rounded,
                  )
                : _CourseGrid(courses: state.courses, favorites: state.favoriteIds),
          ),
        ],
      ),
    );
  }
}

class _CourseGrid extends StatelessWidget {
  const _CourseGrid({required this.courses, required this.favorites});

  final List<CourseModel> courses;
  final Set<String> favorites;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: courses.length,
      // Built lazily so only visible cells are built.
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final course = courses[index];

        // A stable key lets Flutter reuse element state when the list is
        // reordered by a search instead of rebuilding every tile.
        return CourseGridCard(
          key: ValueKey(course.id),
          course: course,
          isFavorite: favorites.contains(course.id),
          onFavoriteTap: () =>
              context.read<HomeCubit>().toggleFavorite(course.id),
          onTap: () => context.pushCourseDetails(course),
        );
      },
    );
  }
}