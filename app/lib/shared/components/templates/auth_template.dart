import 'package:flutter/material.dart';

class AuthTemplate extends StatelessWidget {
  final Widget logo;
  final Widget title;
  final Widget form;
  final VoidCallback? onBack;

  const AuthTemplate({
    super.key,
    required this.logo,
    required this.title,
    required this.form,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: onBack != null
          ? AppBar(
              leading: BackButton(onPressed: onBack),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : null,
      extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  logo,
                  const SizedBox(height: 32),
                  title,
                  const SizedBox(height: 40),
                  form,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
