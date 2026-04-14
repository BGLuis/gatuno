import 'package:flutter/material.dart';
import 'package:gatuno/l10n/app_localizations.dart';
import '../components/templates/home_template.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return HomeTemplate(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: Center(child: Text(l10n.homeWelcome)),
    );
  }
}
