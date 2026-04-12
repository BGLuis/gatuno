import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../view_models/welcome_view_model.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _urlController = TextEditingController(
    text: 'http://localhost:3000/api',
  );

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WelcomeViewModel>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              Text(
                'Welcome to Gatuno',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please enter your server API URL to continue.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'API Base URL',
                  border: const OutlineInputBorder(),
                  errorText: viewModel.error,
                  hintText: 'http://your-server:3000/api',
                ),
                keyboardType: TextInputType.url,
                enabled: !viewModel.isLoading,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          final success = await viewModel.validateAndSaveUrl(
                            _urlController.text,
                          );
                          if (success && context.mounted) {
                            context.go('/home');
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Connect'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
