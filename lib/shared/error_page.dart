
// lib/views/shared/error_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:req_mvvm/views/auth/login_screen.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../models/models.dart';


class ErrorPage extends StatelessWidget {
  final String title;
  final String message;
  final bool showHomeButton;
  final VoidCallback? onRetry;

  const ErrorPage({
    Key? key,
    required this.title,
    required this.message,
    this.showHomeButton = false,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(32),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    children: [
                      if (onRetry != null)
                        ElevatedButton.icon(
                          onPressed: onRetry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      if (showHomeButton)
                        ElevatedButton.icon(
                          onPressed: () => _navigateHome(context),
                          icon: const Icon(Icons.home),
                          label: const Text('Go Home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateHome(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    
    if (!authViewModel.isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
      return;
    }

    final user = authViewModel.currentUser;
    if (user?.role == UserRole.admin) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/admin',
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/user',
        (route) => false,
      );
    }
  }
}
