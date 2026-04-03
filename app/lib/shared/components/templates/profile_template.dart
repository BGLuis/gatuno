import 'package:flutter/material.dart';
import 'package:gatuno/shared/components/atoms/app_loading_indicator.dart';

class ProfileTemplate extends StatelessWidget {
  final String title;
  final Widget header;
  final Widget settings;
  final bool isLoading;

  const ProfileTemplate({
    super.key,
    required this.title,
    required this.header,
    required this.settings,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: isLoading
          ? const Center(child: AppLoadingIndicator(size: 40))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  header,
                  const SizedBox(height: 32),
                  settings,
                ],
              ),
            ),
    );
  }
}
