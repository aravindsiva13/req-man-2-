// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:req_mvvm/shared/error_page.dart';
import 'package:req_mvvm/shared/loading_page.dart';
import '../models/models.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../views/auth/login_screen.dart';
import '../views/admin/admin_dashboard.dart';
import '../views/user/user_dashboard.dart';


class AppRouter {
  static const String login = '/login';
  static const String adminDashboard = '/admin';
  static const String userDashboard = '/user';
  static const String requestDetails = '/request';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) =>  LoginScreen(),
          settings: settings,
        );
      
      case adminDashboard:
        return MaterialPageRoute(
          builder: (context) => AuthGuard(
            requiredRole: UserRole.admin,
            child: Consumer<AuthViewModel>(
              builder: (context, authViewModel, child) {
                if (authViewModel.currentUser == null) {
                  return const LoadingPage();
                }
                return AdminDashboard(currentUser: authViewModel.currentUser!);
              },
            ),
          ),
          settings: settings,
        );
      
      case userDashboard:
        return MaterialPageRoute(
          builder: (context) => AuthGuard(
            requiredRole: UserRole.user,
            allowAdmin: true, // Admins can access user dashboard
            child: Consumer<AuthViewModel>(
              builder: (context, authViewModel, child) {
                if (authViewModel.currentUser == null) {
                  return const LoadingPage();
                }
                return UserDashboard(currentUser: authViewModel.currentUser!);
              },
            ),
          ),
          settings: settings,
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorPage(
            title: 'Page Not Found',
            message: 'The requested page could not be found.',
          ),
        );
    }
  }
}

// Auth Guard Widget for Route Protection
class AuthGuard extends StatelessWidget {
  final Widget child;
  final UserRole? requiredRole;
  final bool allowAdmin;
  final String? redirectTo;

  const AuthGuard({
    Key? key,
    required this.child,
    this.requiredRole,
    this.allowAdmin = false,
    this.redirectTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        // Check authentication status
        if (!authViewModel.isLoggedIn || authViewModel.currentUser == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.login,
              (route) => false,
            );
          });
          return const LoadingPage(message: 'Checking authentication...');
        }

        // Check role permissions
        if (requiredRole != null) {
          final user = authViewModel.currentUser!;
          final hasRequiredRole = user.role == requiredRole;
          final isAdminWithAccess = allowAdmin && user.role == UserRole.admin;

          if (!hasRequiredRole && !isAdminWithAccess) {
            return const ErrorPage(
              title: 'Access Denied',
              message: 'You do not have permission to access this page.',
              showHomeButton: true,
            );
          }
        }

        return child;
      },
    );
  }
}
