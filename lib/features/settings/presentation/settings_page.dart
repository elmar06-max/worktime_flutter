import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/job.dart';
import '../../../domain/models/pay_settings.dart';
import '../../jobs/providers/job_providers.dart';
import '../providers/settings_providers.dart';
import 'job_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<void> _addJob(BuildContext context, WidgetRef ref) async {
    final name = await showDialog<String?>(
      context: context,
      builder: (_) => const JobDialog(),
    );
    if (name == null) return;
    await ref.read(jobRepositoryProvider).save(Job.create(name));
  }

  Future<void> _editJob(
    BuildContext context,
    WidgetRef ref,
    Job job,
  ) async {
    final name = await showDialog<String?>(
      context: context,
      builder: (_) => JobDialog(initialName: job.name),
    );
    if (name == null) return;
    await ref.read(jobRepositoryProvider).update(job.copyWith(name: name));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(jobsProvider);
    final paySettingsAsync = ref.watch(paySettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          paySettingsAsync.when(
            data: (settings) => _PaySettingsCard(
              initialSettings: settings ??
                  const PaySettings(hourlyRate: 0, overtimeMultiplier: 1.5),
            ),
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(),
              ),
            ),
            error: (error, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Failed to load pay settings: $error'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          jobsAsync.when(
            data: (jobs) => Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Jobs'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _addJob(context, ref),
                    ),
                  ),
                  const Divider(height: 1),
                  ...jobs.map(
                    (job) => Column(
                      children: [
                        ListTile(
                          title: Text(job.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _editJob(context, ref, job),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () async => ref
                                    .read(jobRepositoryProvider)
                                    .delete(job.id),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                  if (jobs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No jobs yet. Add your first job.'),
                    ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Failed to load jobs: $error'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Job'),
        onPressed: () => _addJob(context, ref),
      ),
    );
  }
}

class _PaySettingsCard extends ConsumerStatefulWidget {
  const _PaySettingsCard({required this.initialSettings});

  final PaySettings initialSettings;

  @override
  ConsumerState<_PaySettingsCard> createState() => _PaySettingsCardState();
}

class _PaySettingsCardState extends ConsumerState<_PaySettingsCard> {
  late final TextEditingController _hourlyRateController;
  late final TextEditingController _overtimeMultiplierController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hourlyRateController = TextEditingController(
      text: widget.initialSettings.hourlyRate.toString(),
    );
    _overtimeMultiplierController = TextEditingController(
      text: widget.initialSettings.overtimeMultiplier.toString(),
    );
  }

  @override
  void dispose() {
    _hourlyRateController.dispose();
    _overtimeMultiplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pay settings (ISK)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hourlyRateController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Hourly rate'),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed < 0) {
                    return 'Enter a non-negative number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _overtimeMultiplierController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Overtime multiplier'),
                validator: (value) {
                  final parsed = double.tryParse(value ?? '');
                  if (parsed == null || parsed < 0) {
                    return 'Enter a non-negative number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    final settings = PaySettings(
                      hourlyRate: double.parse(_hourlyRateController.text),
                      overtimeMultiplier:
                          double.parse(_overtimeMultiplierController.text),
                    );
                    await ref.read(settingsRepositoryProvider).savePaySettings(settings);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pay settings saved')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
