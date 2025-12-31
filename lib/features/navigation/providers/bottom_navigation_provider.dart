import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigationState {
  const BottomNavigationState({required this.index});

  final int index;

  BottomNavigationState copyWith({int? index}) {
    return BottomNavigationState(index: index ?? this.index);
  }
}

class BottomNavigationNotifier extends StateNotifier<BottomNavigationState> {
  BottomNavigationNotifier() : super(const BottomNavigationState(index: 0));

  void setIndex(int index) {
    if (index == state.index) return;
    state = state.copyWith(index: index);
  }
}

final bottomNavigationProvider =
    StateNotifierProvider<BottomNavigationNotifier, BottomNavigationState>(
  (ref) => BottomNavigationNotifier(),
);
