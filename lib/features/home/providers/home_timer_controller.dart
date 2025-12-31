import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/work_entry.dart';
import '../../entries/providers/work_entry_providers.dart';

class HomeTimerState {
  const HomeTimerState({
    required this.isRunning,
    required this.elapsed,
    this.startTime,
    this.lastEntry,
  });

  final bool isRunning;
  final Duration elapsed;
  final DateTime? startTime;
  final WorkEntry? lastEntry;

  HomeTimerState copyWith({
    bool? isRunning,
    Duration? elapsed,
    DateTime? startTime,
    WorkEntry? lastEntry,
  }) {
    return HomeTimerState(
      isRunning: isRunning ?? this.isRunning,
      elapsed: elapsed ?? this.elapsed,
      startTime: startTime ?? this.startTime,
      lastEntry: lastEntry ?? this.lastEntry,
    );
  }
}

class HomeTimerController extends StateNotifier<HomeTimerState> {
  HomeTimerController(this._read)
      : super(const HomeTimerState(isRunning: false, elapsed: Duration.zero));

  final Reader _read;
  Timer? _ticker;

  void start() {
    if (state.isRunning) return;
    final now = DateTime.now();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(now);
      state = state.copyWith(isRunning: true, elapsed: elapsed, startTime: now);
    });
    state = state.copyWith(isRunning: true, elapsed: Duration.zero, startTime: now);
  }

  Future<void> stop() async {
    if (!state.isRunning || state.startTime == null) return;
    _ticker?.cancel();
    final end = DateTime.now();
    final elapsed = end.difference(state.startTime!);
    final totalHours = elapsed.inMinutes / 60;

    final entry = await _read(workEntryRepositoryProvider).save(
      WorkEntry.newEntry(
        date: DateTime(
          state.startTime!.year,
          state.startTime!.month,
          state.startTime!.day,
        ),
        startTime: state.startTime!,
        endTime: end,
        breakMinutes: 0,
        daytimeHours: totalHours,
        overtimeHours: 0,
        note: null,
      ),
    );

    state = state.copyWith(
      isRunning: false,
      elapsed: Duration.zero,
      startTime: null,
      lastEntry: entry,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final homeTimerProvider =
    StateNotifierProvider<HomeTimerController, HomeTimerState>(
  (ref) => HomeTimerController(ref.read),
);
