// import 'package:flutter/material.dart';
// import '../models/models.dart';
// import '../services/mock_api_service.dart';

// class AuthViewModel extends ChangeNotifier {
//   final MockApiService _apiService = MockApiService();
  
//   User? _currentUser;
//   bool _isLoading = false;
//   String? _errorMessage;

//   // Getters
//   User? get currentUser => _currentUser;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   bool get isLoggedIn => _currentUser != null;
//   bool get isAdmin => _currentUser?.role == UserRole.admin;

//   // Login method
//   Future<bool> login(String email, String password) async {
//     _setLoading(true);
//     _setError(null);
    
//     try {
//       final user = await _apiService.validateLogin(email, password);
      
//       if (user != null) {
//         _currentUser = user;
//         notifyListeners();
//         return true;
//       } else {
//         _setError('Invalid email or password');
//         return false;
//       }
//     } catch (e) {
//       _setError('Login failed: ${e.toString()}');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Logout method
//   void logout() {
//     _currentUser = null;
//     _errorMessage = null;
//     notifyListeners();
//   }

//   // Check authentication status
//   bool isAuthenticated() {
//     return _currentUser != null;
//   }

//   // Update current user
//   void updateCurrentUser(User user) {
//     _currentUser = user;
//     notifyListeners();
//   }

//   // Private helper methods
//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String? error) {
//     _errorMessage = error;
//     notifyListeners();
//   }

//   // Clear error message
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
// }


//2

// lib/viewmodels/auth_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_api_service.dart';

class AuthViewModel extends ChangeNotifier {
  final MockApiService _apiService = MockApiService();
  
  // Authentication state
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  
  // Disposed flag to prevent operations after disposal
  bool _disposed = false;

  // Getters with null safety and disposal checks
  User? get currentUser => _disposed ? null : _currentUser;
  bool get isLoading => _disposed ? false : _isLoading;
  String? get errorMessage => _disposed ? null : _errorMessage;
  bool get isLoggedIn => _disposed ? false : _isLoggedIn;
  bool get isAdmin => _disposed ? false : (_currentUser?.role == UserRole.admin);

  // Secure login method with proper validation
  Future<bool> login(String email, String password) async {
    if (_disposed) return false;
    
    // Input validation and sanitization
    final sanitizedEmail = _sanitizeInput(email.trim().toLowerCase());
    final sanitizedPassword = _sanitizeInput(password.trim());
    
    if (!_isValidEmail(sanitizedEmail)) {
      _setError('Please enter a valid email address');
      return false;
    }
    
    if (sanitizedPassword.length < 6) {
      _setError('Password must be at least 6 characters');
      return false;
    }

    _safeSetState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _apiService.validateLogin(sanitizedEmail, sanitizedPassword);
      
      if (_disposed) return false; // Check disposal after async operation
      
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        _errorMessage = null;
        
        // Update last login time
        _currentUser = _currentUser!.copyWith(lastLoginAt: DateTime.now());
        
        debugPrint('Login successful for user: ${user.email}');
        _safeNotifyListeners();
        return true;
      } else {
        _setError('Invalid email or password. Please try again.');
        return false;
      }
    } catch (e) {
      if (!_disposed) {
        _setError('Login failed. Please check your connection and try again.');
        debugPrint('Login error: $e');
      }
      return false;
    } finally {
      if (!_disposed) {
        _isLoading = false;
        _safeNotifyListeners();
      }
    }
  }

  // Secure logout with cleanup
  Future<void> logout() async {
    if (_disposed) return;
    
    try {
      // Clear sensitive data
      _currentUser = null;
      _isLoggedIn = false;
      _errorMessage = null;
      
      // Additional cleanup for security
      await _clearSecureStorage();
      
      debugPrint('User logged out successfully');
    } catch (e) {
      debugPrint('Logout error: $e');
    }
    
    _safeNotifyListeners();
  }

  // Check authentication status
  Future<bool> checkAuthStatus() async {
    if (_disposed) return false;
    
    try {
      // In a real app, this would check stored JWT tokens
      // For now, we'll check if user session is valid
      if (_currentUser != null) {
        final isValid = await _validateUserSession(_currentUser!.id);
        if (!isValid && !_disposed) {
          await logout();
          return false;
        }
        return !_disposed && isValid;
      }
      return false;
    } catch (e) {
      debugPrint('Auth check error: $e');
      return false;
    }
  }

  // Check if authenticated (synchronous version)
  bool isAuthenticated() {
    return !_disposed && _currentUser != null && _isLoggedIn;
  }

  // Update current user
  void updateCurrentUser(User user) {
    if (_disposed) return;
    
    _currentUser = user;
    _safeNotifyListeners();
  }

  // Input sanitization to prevent XSS
  // Input sanitization to prevent XSS
String _sanitizeInput(String input) {
  return input
      .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
      .replaceAll(RegExp(r'''[<>"'&]'''), '') // Remove dangerous characters
      .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
      .replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '')
      .trim();
}
  // Email validation
  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate user session (mock implementation)
  Future<bool> _validateUserSession(String userId) async {
    if (_disposed) return false;
    
    try {
      // In real implementation, validate JWT token here
      await Future.delayed(const Duration(milliseconds: 100));
      return userId.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Clear secure storage (mock implementation)
  Future<void> _clearSecureStorage() async {
    if (_disposed) return;
    
    // In real implementation, clear JWT tokens, biometric data, etc.
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Safe state management methods
  void _safeSetState(VoidCallback fn) {
    if (!_disposed) {
      fn();
      notifyListeners();
    }
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void _setError(String? error) {
    if (!_disposed && _errorMessage != error) {
      _errorMessage = error;
      _safeNotifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    if (!_disposed) {
      _setError(null);
    }
  }

  // Comprehensive disposal to prevent memory leaks
  @override
  void dispose() {
    debugPrint('AuthViewModel disposing...');
    
    // Set disposed flag first
    _disposed = true;
    
    // Clear sensitive data
    _currentUser = null;
    _isLoading = false;
    _errorMessage = null;
    _isLoggedIn = false;
    
    // Call parent dispose
    super.dispose();
  }
}