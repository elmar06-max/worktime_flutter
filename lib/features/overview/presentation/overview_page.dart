import 'package:flutter/material.dart';
 codex/plan-flutter-app-structure-and-state-management-cpcdu8
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/work_entry.dart';
import '../../entries/providers/work_entry_providers.dart';
import '../providers/selected_date_provider.dart';

class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final entriesAsync = ref.watch(workEntriesProvider);
    final localizations = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(selectedDate.year - 1, 1, 1),
                lastDate: DateTime(selectedDate.year + 1, 12, 31),
              );
              if (picked != null) {
                ref.read(selectedDateProvider.notifier).state = picked;
              }
            },
          ),
        ],
      ),
      body: entriesAsync.when(
        data: (entries) {
          final filtered = entries
              .where((entry) => WorkEntry.isSameDay(entry.date, selectedDate))
              .toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime));

          if (filtered.isEmpty) {
            return const Center(
              child: Text('No entries for this day'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final entry = filtered[index];
              final start = localizations.formatTimeOfDay(
                TimeOfDay.fromDateTime(entry.startTime),
                alwaysUse24HourFormat: true,
              );
              final end = localizations.formatTimeOfDay(
                TimeOfDay.fromDateTime(entry.endTime),
                alwaysUse24HourFormat: true,
              );
              final total = entry.workedDuration.inMinutes / 60;

              return ListTile(
                title: Text('$start - $end'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Break: ${entry.breakMinutes} min • Total: ${total.toStringAsFixed(2)} h',
                    ),
                    Text(
                      'Daytime: ${entry.daytimeHours.toStringAsFixed(2)} h • Overtime: ${entry.overtimeHours.toStringAsFixed(2)} h',
                    ),
                    if ((entry.note ?? '').isNotEmpty) Text(entry.note!),
                  ],
                ),
                trailing: const Icon(Icons.edit_note_outlined),
                onTap: () {
                  // Placeholder for WorkHourDialog integration (editing from Overview only).
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: filtered.length,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading entries: $error'),
        ),
      ),


class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Overview - Calendar and logs coming soon'),
      main
    );
  }
}
