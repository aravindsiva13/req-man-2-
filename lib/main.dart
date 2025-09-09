// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:req_mvvm/viewmodels/template_viewmodel.dart';
// import 'viewmodels/auth_viewmodel.dart';
// import 'viewmodels/admin_viewmodel.dart';
// import 'viewmodels/user_viewmodel.dart';
// import 'views/auth/login_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthViewModel()),
//         ChangeNotifierProvider(create: (_) => AdminViewModel()),
//         ChangeNotifierProvider(create: (_) => UserViewModel()),
//         ChangeNotifierProvider(create: (_) => TemplateViewModel()),
//       ],
//       child: MaterialApp(
//         title: 'Request Management System',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           useMaterial3: true,
//           appBarTheme: AppBarTheme(
//             backgroundColor: Colors.blue,
//             foregroundColor: Colors.white,
//             elevation: 2,
//           ),
//           cardTheme: CardThemeData(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ),
//         home: LoginScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }


//2




// lib/main.dart - Updated with router
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:req_mvvm/models/models.dart';
import 'package:req_mvvm/shared/loading_page.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/admin_viewmodel.dart';
import 'viewmodels/user_viewmodel.dart';
import 'viewmodels/template_viewmodel.dart';
import 'routes/app_router.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => TemplateViewModel()),
      ],
      child: MaterialApp(
        title: 'Request Management System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        home: const AuthenticationWrapper(),
        onGenerateRoute: AppRouter.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Authentication Wrapper to handle initial app state
class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialAuthState();
    });
  }

  Future<void> _checkInitialAuthState() async {
    final authViewModel = context.read<AuthViewModel>();
    
    try {
      final isAuthenticated = await authViewModel.checkAuthStatus();
      
      if (mounted) {
        if (isAuthenticated && authViewModel.currentUser != null) {
          final user = authViewModel.currentUser!;
          if (user.role == UserRole.admin) {
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
            Navigator.pushReplacementNamed(context, '/user');
          }
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingPage(message: 'Initializing application...');
  }
}