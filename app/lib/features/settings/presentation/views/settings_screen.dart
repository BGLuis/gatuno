import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../view_models/settings_view_model.dart';
import '../../../../shared/components/atoms/app_switch.dart';
import '../../../../shared/components/molecules/settings_profile_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _urlController.text = context.read<SettingsViewModel>().apiUrl ?? '';
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsProfileCard(
            name: viewModel.isAuthenticated && viewModel.user != null
                ? viewModel.user!.displayName
                : l10n.commonGuest,
            email: viewModel.isAuthenticated && viewModel.user != null
                ? viewModel.user!.email
                : null,
            onTap: () {
              if (viewModel.isAuthenticated) {
                context.push('/settings/profile');
              } else {
                context.push('/auth/signin');
              }
            },
          ),
          const Divider(height: 32),
          Text(
            'General',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          AppSwitch(
            title: l10n.userMeSensitiveContent,
            subtitle: l10n.userMeSensitiveContentDesc,
            value: viewModel.sensitiveContentEnabled,
            onChanged: (value) => viewModel.setSensitiveContentEnabled(value),
          ),
          const Divider(height: 32),
          Text(
            'API Configuration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'API Base URL',
              border: OutlineInputBorder(),
              hintText: 'http://your-api.com/api',
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: viewModel.isLoading
                ? null
                : () async {
                    final success = await viewModel.updateApiUrl(
                      _urlController.text,
                    );
                    if (context.mounted) {
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('API URL updated successfully'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Error updating API URL: Could not connect or certificate invalid',
                            ),
                          ),
                        );
                      }
                    }
                  },
            child: viewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save API URL'),
          ),
        ],
      ),
    );
  }
}
