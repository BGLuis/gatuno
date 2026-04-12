import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../view_models/me_view_model.dart';
import '../../../../shared/components/molecules/user_profile_header.dart';
import 'package:gatuno/features/settings/presentation/components/organisms/me_settings_list.dart';
import '../../../../shared/components/templates/profile_template.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<MeViewModel>();

    return ProfileTemplate(
      title: l10n.userMeTitle,
      isLoading: viewModel.isLoading,
      header: UserProfileHeader(
        displayName: viewModel.user?.displayName ?? '',
        email: viewModel.user?.email ?? '',
      ),
      settings: MeSettingsList(
        logoutButton: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              await viewModel.logout();
              if (!context.mounted) return;
              context.go('/settings');
            },
            icon: const Icon(Icons.logout),
            label: Text(l10n.commonLogout),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }
}
