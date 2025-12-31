import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/work_entry.dart';
import '../../entries/providers/work_entry_providers.dart';
       codex/plan-flutter-app-structure-and-state-management-hl9uva
import '../../jobs/providers/job_providers.dart';


       codex/plan-flutter-app-structure-and-state-management-2hoku7
import '../../jobs/providers/job_providers.dart';

        main

        main
class WorkHourDialog extends ConsumerStatefulWidget {
  const WorkHourDialog({
    super.key,
    required this.initialDate,
    this.entry,
  });

  final DateTime initialDate;
  final WorkEntry? entry;

  @override
  ConsumerState<WorkHourDialog> createState() => _WorkHourDialogState();
}

class _WorkHourDialogState extends ConsumerState<WorkHourDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
       codex/plan-flutter-app-structure-and-state-management-hl9uva
  String? _selectedJobId;

       codex/plan-flutter-app-structure-and-state-management-2hoku7
  String? _selectedJobId;

         main
        main
  late final TextEditingController _breakController;
  late final TextEditingController _daytimeController;
  late final TextEditingController _overtimeController;
  late final TextEditingController _noteController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _selectedDate = entry?.date ?? widget.initialDate;
    _startTime =
        entry != null ? TimeOfDay.fromDateTime(entry.startTime) : const TimeOfDay(hour: 9, minute: 0);
    _endTime =
        entry != null ? TimeOfDay.fromDateTime(entry.endTime) : const TimeOfDay(hour: 17, minute: 0);
       codex/plan-flutter-app-structure-and-state-management-hl9uva
    _selectedJobId = entry?.jobId;

        codex/plan-flutter-app-structure-and-state-management-2hoku7
    _selectedJobId = entry?.jobId;

       main
        main
    _breakController = TextEditingController(
      text: (entry?.breakMinutes ?? 0).toString(),
    );
    _daytimeController = TextEditingController(
      text: (entry?.daytimeHours ?? 0).toString(),
    );
    _overtimeController = TextEditingController(
      text: (entry?.overtimeHours ?? 0).toString(),
    );
    _noteController = TextEditingController(text: entry?.note ?? '');
  }

  @override
  void dispose() {
    _breakController.dispose();
    _daytimeController.dispose();
    _overtimeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  DateTime _combine(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(_selectedDate.year - 1, 1, 1),
      lastDate: DateTime(_selectedDate.year + 1, 12, 31),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  String? _validateNumber(String? value, {bool allowDouble = false}) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    if (allowDouble) {
      final parsed = double.tryParse(value);
      if (parsed == null || parsed < 0) return 'Must be a non-negative number';
    } else {
      final parsed = int.tryParse(value);
      if (parsed == null || parsed < 0) return 'Must be a non-negative number';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final start = _combine(_selectedDate, _startTime);
    final end = _combine(_selectedDate, _endTime);

    if (!end.isAfter(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    final breakMinutes = int.parse(_breakController.text);
    final daytimeHours = double.parse(_daytimeController.text);
    final overtimeHours = double.parse(_overtimeController.text);
    final note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();

    final repository = ref.read(workEntryRepositoryProvider);
    if (widget.entry == null) {
      await repository.save(
        WorkEntry.newEntry(
          date: _selectedDate,
       codex/plan-flutter-app-structure-and-state-management-hl9uva
          jobId: _selectedJobId,

        codex/plan-flutter-app-structure-and-state-management-2hoku7
          jobId: _selectedJobId,

        main
        main
          startTime: start,
          endTime: end,
          breakMinutes: breakMinutes,
          daytimeHours: daytimeHours,
          overtimeHours: overtimeHours,
          note: note,
        ),
      );
    } else {
      await repository.update(
        widget.entry!.copyWith(
          date: _selectedDate,
     codex/plan-flutter-app-structure-and-state-management-hl9uva
          jobId: _selectedJobId,
 
     codex/plan-flutter-app-structure-and-state-management-2hoku7
          jobId: _selectedJobId,

        main
        main
          startTime: start,
          endTime: end,
          breakMinutes: breakMinutes,
          daytimeHours: daytimeHours,
          overtimeHours: overtimeHours,
          note: note,
        ),
      );
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    codex/plan-flutter-app-structure-and-state-management-hl9uva
    final jobsAsync = ref.watch(jobsProvider);


      codex/plan-flutter-app-structure-and-state-management-2hoku7
    final jobsAsync = ref.watch(jobsProvider);


      main
       main
    return AlertDialog(
      title: Text(widget.entry == null ? 'Add entry' : 'Edit entry'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
       codex/plan-flutter-app-structure-and-state-management-hl9uva

       codex/plan-flutter-app-structure-and-state-management-2hoku7
       main
              jobsAsync.when(
                data: (jobs) {
                  return DropdownButtonFormField<String?>(
                    value: _selectedJobId,
                    decoration: const InputDecoration(labelText: 'Job'),
                    hint: const Text('Select job'),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('No job'),
                      ),
                      ...jobs.map(
                        (job) => DropdownMenuItem<String?>(
                          value: job.id,
                          child: Text(job.name),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _selectedJobId = value),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text('Failed to load jobs: $error'),
              ),
       codex/plan-flutter-app-structure-and-state-management-hl9uva


        main
        main
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${MaterialLocalizations.of(context).formatShortDate(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Change'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Start: ${_startTime.format(context)}')),
                  TextButton(
                    onPressed: _pickStartTime,
                    child: const Text('Change'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('End: ${_endTime.format(context)}')),
                  TextButton(
                    onPressed: _pickEndTime,
                    child: const Text('Change'),
                  ),
                ],
              ),
              TextFormField(
                controller: _breakController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Break (minutes)'),
                validator: (value) => _validateNumber(value, allowDouble: false),
              ),
              TextFormField(
                controller: _daytimeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Daytime hours'),
                validator: (value) => _validateNumber(value, allowDouble: true),
              ),
              TextFormField(
                controller: _overtimeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Overtime hours'),
                validator: (value) => _validateNumber(value, allowDouble: true),
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
