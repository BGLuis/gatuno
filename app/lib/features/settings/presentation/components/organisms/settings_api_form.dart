import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';

class SettingsApiForm extends StatefulWidget {
  final String initialUrl;
  final bool isLoading;
  final Future<void> Function(String) onSave;

  const SettingsApiForm({
    super.key,
    required this.initialUrl,
    required this.isLoading,
    required this.onSave,
  });

  @override
  State<SettingsApiForm> createState() => _SettingsApiFormState();
}

class _SettingsApiFormState extends State<SettingsApiForm> {
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _urlController,
          decoration: InputDecoration(
            labelText: l10n.settingsApiUrlLabel,
            border: const OutlineInputBorder(),
            hintText: l10n.settingsApiUrlHint,
          ),
          enabled: !widget.isLoading,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: widget.isLoading
              ? null
              : () => widget.onSave(_urlController.text),
          child: widget.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.welcomeConnect),
        ),
      ],
    );
  }
}
