import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../view_models/settings_view_model.dart';
import '../../../../shared/components/atoms/app_switch.dart';
import '../components/molecules/settings_profile_card.dart';
import '../components/molecules/settings_section_header.dart';
import '../components/organisms/settings_api_form.dart';
import '../components/templates/settings_template.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _handleApiSave(
    BuildContext context,
    SettingsViewModel viewModel,
    String url,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final success = await viewModel.updateApiUrl(url);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? l10n.settingsApiUrlSuccess : l10n.settingsApiUrlError,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<SettingsViewModel>();

    return SettingsTemplate(
      appBarTitle: Text(l10n.settingsTitle),
      profileCard: SettingsProfileCard(
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
      generalSectionHeader: SettingsSectionHeader(
        title: l10n.settingsGeneralSection,
      ),
      sensitiveContentToggle: AppSwitch(
        title: l10n.userMeSensitiveContent,
        subtitle: l10n.userMeSensitiveContentDesc,
        value: viewModel.sensitiveContentEnabled,
        onChanged: (value) => viewModel.setSensitiveContentEnabled(value),
      ),
      apiSectionHeader: SettingsSectionHeader(title: l10n.settingsApiSection),
      apiForm: SettingsApiForm(
        initialUrl: viewModel.apiUrl ?? '',
        isLoading: viewModel.isLoading,
        onSave: (url) => _handleApiSave(context, viewModel, url),
      ),
    );
  }
}
