import 'package:flutter/material.dart';
       codex/plan-flutter-app-structure-and-state-management-2hoku7
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/job.dart';
import '../../jobs/providers/job_providers.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: jobsAsync.when(
        data: (jobs) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return ListTile(
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
                    onPressed: () async =>
                        ref.read(jobRepositoryProvider).delete(job.id),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Failed to load jobs: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Job'),
        onPressed: () => _addJob(context, ref),
      ),


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings - Configure jobs and preferences'),
       main
    );
  }
}
