import 'package:flutter/material.dart';

class JobDialog extends StatefulWidget {
  const JobDialog({super.key, this.initialName});

  final String? initialName;

  @override
  State<JobDialog> createState() => _JobDialogState();
}

class _JobDialogState extends State<JobDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? 'Add Job' : 'Edit Job'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Job name'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Name is required';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop<String?>(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(_controller.text.trim());
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
