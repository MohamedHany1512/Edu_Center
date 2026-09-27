import 'package:edu_app/features/home/presentation/pages/home_page.dart';
import 'package:edu_app/features/home/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:edu_app/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:edu_app/features/my_courses/presentation/pages/my_courses_page.dart';
import 'package:edu_app/features/my_favorites/presentation/pages/my_favorites_page.dart';
 import 'package:edu_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shell that hosts the four main tabs behind a floating bottom nav bar.
class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LayoutCubit>(
      create: (_) => LayoutCubit(),
      child: const _LayoutView(),
    );
  }
}

class _LayoutView extends StatelessWidget {
  const _LayoutView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        final cubit = context.read<LayoutCubit>();
        final currentIndex = cubit.currentIndex;

        return Scaffold(
        
          extendBody: true,
    
          body: _TabHost(currentIndex: currentIndex),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            onTap: cubit.changeIndex,
          ),
        );
      },
    );
  }
}

 
class _TabHost extends StatelessWidget {
  const _TabHost({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: [
        const _RefreshableTab(index: 0, builder: _homeTab),
        const _RefreshableTab(index: 1, builder: _myCoursesTab),
        const _RefreshableTab(index: 2, builder: _myFavoritesTab),
        const _RefreshableTab(index: 3, builder: _profileTab),
      ],
    );
  }

  static Widget _homeTab(int token) => HomePage(refreshToken: token);
  static Widget _myCoursesTab(int token) => MyCoursesPage(refreshToken: token);
  static Widget _myFavoritesTab(int token) =>
      MyFavoritesPage(refreshToken: token);
  static Widget _profileTab(int token) => ProfilePage(refreshToken: token);
}

/// Rebuilds its child only when the refresh token for [index] changes.
class _RefreshableTab extends StatelessWidget {
  const _RefreshableTab({required this.index, required this.builder});

  final int index;
  final Widget Function(int refreshToken) builder;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LayoutCubit, LayoutState, int>(
      selector: (state) => context.read<LayoutCubit>().refreshTokenFor(index),
      builder: (context, refreshToken) => builder(refreshToken),
    );
  }
}