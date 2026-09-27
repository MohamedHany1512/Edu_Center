part of 'layout_cubit.dart';

/// Bottom-navigation state.
///
/// The selected index is now part of the state rather than a mutable field on
/// the cubit. Previously the index lived outside the state, so `BlocBuilder`
/// could not react to it correctly and had to call `getCurrentIndex()` as a
/// side channel.
sealed class LayoutState {
  const LayoutState();
}

final class LayoutInitial extends LayoutState {
  const LayoutInitial();
}

final class LayoutTabSelected extends LayoutState {
  const LayoutTabSelected(this.index);

  final int index;
}