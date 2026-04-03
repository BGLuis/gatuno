import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../view_models/home_view_model.dart';
import '../../../../shared/components/organisms/home_app_bar.dart';
import '../../../../shared/components/templates/home_template.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewModel = context.watch<HomeViewModel>();

    return HomeTemplate(
      appBar: HomeAppBar(
        title: l10n.homeTitle,
        isAuthenticated: viewModel.isAuthenticated,
        isLoading: !viewModel.isInitialized,
        displayName: viewModel.displayName,
        onProfilePressed: () => context.push('/users/me'),
        onSignInPressed: () => context.push('/auth/signin'),
        profileTooltip: l10n.homeProfile,
        signInTooltip: l10n.authSignInButton,
      ),
      body: Center(child: Text(l10n.homeWelcome)),
    );
  }
}
