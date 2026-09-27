import 'package:flutter_bloc/flutter_bloc.dart';

part 'layout_state.dart';

/// Owns which bottom-navigation tab is selected.
///
/// Pages are built by the widget layer; the cubit only tracks the index and
/// the per-tab refresh counters.
class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutInitial());

  /// Number of bottom-navigation destinations.
  static const int tabCount = 4;

  /// Bumped whenever a tab is reselected, so the visible page refetches and
  /// reflects changes made on other screens.
  final List<int> _refreshTokens = List<int>.filled(tabCount, 0);

  int get currentIndex =>
      state is LayoutTabSelected ? (state as LayoutTabSelected).index : 0;

  int refreshTokenFor(int index) =>
      (index >= 0 && index < tabCount) ? _refreshTokens[index] : 0;

  void changeIndex(int index) {
    if (index < 0 || index >= tabCount) return;
    if (index == currentIndex) return;

    _refreshTokens[index]++;

    // Only the newly selected tab refetches; the others keep their state.
    emit(LayoutTabSelected(index));
  }
}