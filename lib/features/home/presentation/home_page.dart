import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/home_timer_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.remainder(100).toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeTimerProvider);
    final controller = ref.read(homeTimerProvider.notifier);
    final isRunning = state.isRunning;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Work timer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              _formatDuration(state.elapsed),
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
              label: Text(isRunning ? 'Stop' : 'Start'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: isRunning ? controller.stop : controller.start,
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Last session',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            if (state.lastEntry == null)
              const Text('No session recorded yet.')
            else
              _LastSessionSummary(entry: state.lastEntry!),
            const SizedBox(height: 16),
            const Text(
              'Editing is only available from the Overview screen.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LastSessionSummary extends StatelessWidget {
  const _LastSessionSummary({required this.entry});

  final dynamic entry;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final start = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(entry.startTime),
      alwaysUse24HourFormat: true,
    );
    final end = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(entry.endTime),
      alwaysUse24HourFormat: true,
    );
    final total = entry.workedDuration.inMinutes / 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${localizations.formatShortDate(entry.date)} • $start - $end'),
        Text(
          'Break: ${entry.breakMinutes} min • Total: ${total.toStringAsFixed(2)} h',
        ),
        Text(
          'Daytime: ${entry.daytimeHours.toStringAsFixed(2)} h • Overtime: ${entry.overtimeHours.toStringAsFixed(2)} h',
        ),
        if ((entry.note ?? '').isNotEmpty) Text(entry.note!),
      ],
    );
  }
}
