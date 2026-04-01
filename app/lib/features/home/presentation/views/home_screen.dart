import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../../../authentication/domain/use_cases/auth_service.dart';
import '../../../../core/di/injection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final status = await sl<AuthService>().isAuthenticated();
    if (mounted) {
      setState(() {
        _isAuthenticated = status;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          if (!_isLoading)
            _isAuthenticated
                ? IconButton(
                    icon: const Icon(Icons.account_circle_outlined),
                    tooltip: l10n.homeProfile,
                    onPressed: () {
                      // Profile placeholder action
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.login),
                    tooltip: l10n.authSignInButton,
                    onPressed: () => context.go('/auth/signin'),
                  ),
        ],
      ),
      body: Center(child: Text(l10n.homeWelcome)),
    );
  }
}
