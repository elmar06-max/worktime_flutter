       codex/plan-flutter-app-structure-and-state-management-2hoku7

       codex/plan-flutter-app-structure-and-state-management-zey9lz
        main
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

       codex/plan-flutter-app-structure-and-state-management-2hoku7
import '../../../domain/models/work_entry.dart';
import '../../entries/providers/work_entry_providers.dart';
import '../providers/selected_date_provider.dart';
import 'work_hour_dialog.dart';


import 'package:flutter/material.dart';
        codex/plan-flutter-app-structure-and-state-management-u9eotl

 codex/plan-flutter-app-structure-and-state-management-orinbg

 codex/plan-flutter-app-structure-and-state-management-cpcdu8
       main
        main
import 'package:flutter_riverpod/flutter_riverpod.dart';
        main

import '../../../domain/models/work_entry.dart';
import '../../entries/providers/work_entry_providers.dart';
import '../providers/selected_date_provider.dart';
        codex/plan-flutter-app-structure-and-state-management-zey9lz
import 'work_hour_dialog.dart';

 
       codex/plan-flutter-app-structure-and-state-management-u9eotl
import 'work_hour_dialog.dart';

 
       codex/plan-flutter-app-structure-and-state-management-orinbg
import 'work_hour_dialog.dart';

        main

        main
        main
        main
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
        codex/plan-flutter-app-structure-and-state-management-2hoku7
          
        codex/plan-flutter-app-structure-and-state-management-zey9lz
        main
          final monthEntries = entries
              .where(
                (entry) =>
                    entry.date.year == selectedDate.year &&
                    entry.date.month == selectedDate.month,
              )
              .toList();
          final monthTotalHours = monthEntries.fold<double>(
            0,
            (sum, entry) => sum + entry.workedDuration.inMinutes / 60,
          );
          final monthDaytime = monthEntries.fold<double>(
            0,
            (sum, entry) => sum + entry.daytimeHours,
          );
          final monthOvertime = monthEntries.fold<double>(
            0,
            (sum, entry) => sum + entry.overtimeHours,
          );

         codex/plan-flutter-app-structure-and-state-management-2hoku7

 
          main
        main
          final filtered = entries
              .where((entry) => WorkEntry.isSameDay(entry.date, selectedDate))
              .toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime));

        codex/plan-flutter-app-structure-and-state-management-2hoku7

       codex/plan-flutter-app-structure-and-state-management-zey9lz
          main
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TableCalendar<WorkEntry>(
                  firstDay: DateTime.utc(selectedDate.year - 1, 1, 1),
                  lastDay: DateTime.utc(selectedDate.year + 1, 12, 31),
                  focusedDay: selectedDate,
                  selectedDayPredicate: (day) => WorkEntry.isSameDay(day, selectedDate),
                  onDaySelected: (selected, focused) {
                    ref.read(selectedDateProvider.notifier).state =
                        DateTime(selected.year, selected.month, selected.day);
                  },
                  onPageChanged: (focusedDay) {
                    final daysInMonth = DateUtils.getDaysInMonth(
                      focusedDay.year,
                      focusedDay.month,
                    );
                    final clampedDay = min(selectedDate.day, daysInMonth);
                    ref.read(selectedDateProvider.notifier).state =
                        DateTime(focusedDay.year, focusedDay.month, clampedDay);
                  },
                  eventLoader: (day) => entries
                      .where((entry) => WorkEntry.isSameDay(entry.date, day))
                      .toList(),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Month totals',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text('Total: ${monthTotalHours.toStringAsFixed(2)} h'),
                        Text('Daytime: ${monthDaytime.toStringAsFixed(2)} h'),
                        Text('Overtime: ${monthOvertime.toStringAsFixed(2)} h'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('No entries for this day'),
                      )
                    : ListView.separated(
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
                            onTap: () => showDialog<bool>(
                              context: context,
                              builder: (_) => WorkHourDialog(
                                initialDate: selectedDate,
                                entry: entry,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemCount: filtered.length,
                      ),
              ),
            ],
        codex/plan-flutter-app-structure-and-state-management-2hoku7


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
        codex/plan-flutter-app-structure-and-state-management-u9eotl

    codex/plan-flutter-app-structure-and-state-management-orinbg
        main
                onTap: () => showDialog<bool>(
                  context: context,
                  builder: (_) => WorkHourDialog(
                    initialDate: selectedDate,
                    entry: entry,
                  ),
                ),
        codex/plan-flutter-app-structure-and-state-management-u9eotl


                onTap: () {
                  // Placeholder for WorkHourDialog integration (editing from Overview only).
                },
         main
        main
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: filtered.length,
        main
        main
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading entries: $error'),
        ),
      ),
        codex/plan-flutter-app-structure-and-state-management-2hoku7

        codex/plan-flutter-app-structure-and-state-management-zey9lz

        codex/plan-flutter-app-structure-and-state-management-u9eotl

       codex/plan-flutter-app-structure-and-state-management-orinbg
        main
        main
        main
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add entry'),
        onPressed: () => showDialog<bool>(
          context: context,
          builder: (_) => WorkHourDialog(
            initialDate: selectedDate,
          ),
        ),
      ),
        codex/plan-flutter-app-structure-and-state-management-2hoku7

        codex/plan-flutter-app-structure-and-state-management-zey9lz

        codex/plan-flutter-app-structure-and-state-management-u9eotl




class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Overview - Calendar and logs coming soon'),
      main
       main
        main
        main
        main
    );
  }
}
