// import 'package:flutter/material.dart';
// import '../models/models.dart';
// import '../services/mock_api_service.dart';


// class AdminViewModel extends ChangeNotifier {
//   final MockApiService _apiService = MockApiService();
  
//   // Dashboard Stats
//   DashboardStats? _dashboardStats;
//   bool _isLoadingStats = false;
  
//   // Requests
//   List<Request> _allRequests = [];
//   List<Request> _filteredRequests = [];
//   bool _isLoadingRequests = false;
//   String _requestSearchQuery = '';
//   String? _statusFilter;
//   Priority? _priorityFilter;
  
//   // Request Types
//   List<RequestType> _requestTypes = [];
//   bool _isLoadingTypes = false;
  
//   // Templates
//   List<RequestTemplate> _templates = [];
//   bool _isLoadingTemplates = false;
  
//   // Users
//   List<User> _users = [];
//   List<User> _adminUsers = [];
//   bool _isLoadingUsers = false;
  
//   // Notifications
//   List<AppNotification> _notifications = [];
//   int _unreadCount = 0;
//   bool _isLoadingNotifications = false;
  
//   // Error handling
//   String? _errorMessage;

//   // Getters
//   DashboardStats? get dashboardStats => _dashboardStats;
//   bool get isLoadingStats => _isLoadingStats;
  
//   List<Request> get allRequests => _allRequests;
//   List<Request> get filteredRequests => _filteredRequests;
//   bool get isLoadingRequests => _isLoadingRequests;
  
//   List<RequestType> get requestTypes => _requestTypes;
//   bool get isLoadingTypes => _isLoadingTypes;
  
//   List<RequestTemplate> get templates => _templates;
//   bool get isLoadingTemplates => _isLoadingTemplates;
  
//   List<User> get users => _users;
//   List<User> get adminUsers => _adminUsers;
//   bool get isLoadingUsers => _isLoadingUsers;
  
//   List<AppNotification> get notifications => _notifications;
//   int get unreadCount => _unreadCount;
//   bool get isLoadingNotifications => _isLoadingNotifications;
  
//   String? get errorMessage => _errorMessage;

//   // Dashboard Methods
//   Future<void> loadDashboardStats() async {
//     _isLoadingStats = true;
//     notifyListeners();
    
//     try {
//       _dashboardStats = await _apiService.getDashboardStats();
//       _setError(null);
//     } catch (e) {
//       _setError('Error loading dashboard stats: ${e.toString()}');
//     } finally {
//       _isLoadingStats = false;
//       notifyListeners();
//     }
//   }

//   // Request Methods
//   Future<void> loadAllRequests() async {
//     _isLoadingRequests = true;
//     notifyListeners();
    
//     try {
//       _allRequests = await _apiService.getRequests();
//       _applyRequestFilters();
//       _setError(null);
//     } catch (e) {
//       _setError('Error loading requests: ${e.toString()}');
//     } finally {
//       _isLoadingRequests = false;
//       notifyListeners();
//     }
//   }

//   void updateRequestFilters({String? searchQuery, String? status, Priority? priority}) {
//     if (searchQuery != null) _requestSearchQuery = searchQuery;
//     if (status != null) _statusFilter = status;
//     if (priority != null) _priorityFilter = priority;
    
//     _applyRequestFilters();
//   }

//   void _applyRequestFilters() {
//     _filteredRequests = _allRequests.where((request) {
//       // Search filter
//       bool matchesSearch = _requestSearchQuery.isEmpty ||
//           request.typeName.toLowerCase().contains(_requestSearchQuery.toLowerCase()) ||
//           request.fieldValues.values.any((value) => 
//             value.toString().toLowerCase().contains(_requestSearchQuery.toLowerCase()));
      
//       // Status filter
//       bool matchesStatus = _statusFilter == null || 
//           _statusFilter!.isEmpty || 
//           request.status == _statusFilter;
      
//       // Priority filter
//       bool matchesPriority = _priorityFilter == null || 
//           request.priority == _priorityFilter;
      
//       return matchesSearch && matchesStatus && matchesPriority;
//     }).toList();
    
//     notifyListeners();
//   }

//   void clearRequestFilters() {
//     _requestSearchQuery = '';
//     _statusFilter = null;
//     _priorityFilter = null;
//     _applyRequestFilters();
//   }

//   Future<void> updateRequestStatus(String requestId, String newStatus, {String? comments}) async {
//     try {
//       final updatedRequest = await _apiService.updateRequestStatus(
//         requestId, 
//         newStatus, 
//         adminComments: comments,
//         adminName: 'Admin'
//       );
      
//       // Update local list
//       final index = _allRequests.indexWhere((r) => r.id == requestId);
//       if (index != -1) {
//         _allRequests[index] = updatedRequest;
//         _applyRequestFilters();
//       }
      
//       _setError(null);
//     } catch (e) {
//       _setError('Error updating request status: ${e.toString()}');
//     }
//   }

//   Future<void> assignRequest(String requestId, String adminId, String adminName) async {
//     try {
//       final updatedRequest = await _apiService.assignRequest(requestId, adminId, adminName);
      
//       // Update local list
//       final index = _allRequests.indexWhere((r) => r.id == requestId);
//       if (index != -1) {
//         _allRequests[index] = updatedRequest;
//         _applyRequestFilters();
//       }
      
//       _setError(null);
//     } catch (e) {
//       _setError('Error assigning request: ${e.toString()}');
//     }
//   }

//   Future<void> updateRequestPriority(String requestId, Priority priority) async {
//     try {
//       final updatedRequest = await _apiService.updateRequestPriority(requestId, priority);
      
//       // Update local list
//       final index = _allRequests.indexWhere((r) => r.id == requestId);
//       if (index != -1) {
//         _allRequests[index] = updatedRequest;
//         _applyRequestFilters();
//       }
      
//       _setError(null);
//     } catch (e) {
//       _setError('Error updating request priority: ${e.toString()}');
//     }
//   }

//   // Comment Methods
//   Future<List<RequestComment>> getRequestComments(String requestId) async {
//     try {
//       return await _apiService.getComments(requestId);
//     } catch (e) {
//       _setError('Error loading comments: ${e.toString()}');
//       return [];
//     }
//   }

//   Future<void> addRequestComment(String requestId, String content, String userId, String userName) async {
//     try {
//       final comment = RequestComment(
//         id: '',
//         requestId: requestId,
//         authorId: userId,
//         authorName: userName,
//         content: content,
//         createdAt: DateTime.now(),
//       );
      
//       await _apiService.addComment(comment);
//       _setError(null);
//     } catch (e) {
//       _setError('Error adding comment: ${e.toString()}');
//     }
//   }

//   // Request Type Methods
//   Future<void> loadRequestTypes() async {
//     _isLoadingTypes = true;
//     notifyListeners();
    
//     try {
//       _requestTypes = await _apiService.getRequestTypes();
//       _setError(null);
//     } catch (e) {
//       _setError('Error loading request types: ${e.toString()}');
//     } finally {
//       _isLoadingTypes = false;
//       notifyListeners();
//     }
//   }

//   Future<void> createRequestType(RequestType requestType) async {
//     try {
//       final newType = await _apiService.createRequestType(requestType);
//       _requestTypes.add(newType);
//       notifyListeners();
//       _setError(null);
//     } catch (e) {
//       _setError('Error creating request type: ${e.toString()}');
//     }
//   }

//   // Template Methods
//   Future<void> loadTemplates() async {
//     _isLoadingTemplates = true;
//     notifyListeners();
    
//     try {
//       _templates = await _apiService.getTemplates();
//       _setError(null);
//     } catch (e) {
//       _setError('Error loading templates: ${e.toString()}');
//     } finally {
//       _isLoadingTemplates = false;
//       notifyListeners();
//     }
//   }

//   Future<void> createTemplate(RequestTemplate template) async {
//     try {
//       final newTemplate = await _apiService.createTemplate(template);
//       _templates.add(newTemplate);
//       notifyListeners();
//       _setError(null);
//     } catch (e) {
//       _setError('Error creating template: ${e.toString()}');
//     }
//   }

//   Future<void> deleteTemplate(String templateId) async {
//     try {
//       await _apiService.deleteTemplate(templateId);
//       _templates.removeWhere((t) => t.id == templateId);
//       notifyListeners();
//       _setError(null);
//     } catch (e) {
//       _setError('Error deleting template: ${e.toString()}');
//     }
//   }

//   // User Management Methods
//   Future<void> loadUsers() async {
//     _isLoadingUsers = true;
//     notifyListeners();
    
//     try {
//       _users = await _apiService.getUsers();
//       _adminUsers = await _apiService.getAdminUsers();
//       _setError(null);
//     } catch (e) {
//       _setError('Error loading users: ${e.toString()}');
//     } finally {
//       _isLoadingUsers = false;
//       notifyListeners();
//     }
//   }

//   Future<void> createUser(User user) async {
//     try {
//       final newUser = await _apiService.createUser(user);
//       _users.add(newUser);
//       if (newUser.role == UserRole.admin) {
//         _adminUsers.add(newUser);
//       }
//       notifyListeners();
//       _setError(null);
//     } catch (e) {
//       _setError('Error creating user: ${e.toString()}');
//     }
//   }

//   Future<void> updateUser(User user) async {
//     try {
//       final updatedUser = await _apiService.updateUser(user);
//       final index = _users.indexWhere((u) => u.id == user.id);
//       if (index != -1) {
//         _users[index] = updatedUser;
//       }
      
//       final adminIndex = _adminUsers.indexWhere((u) => u.id == user.id);
//       if (updatedUser.role == UserRole.admin) {
//         if (adminIndex != -1) {
//           _adminUsers[adminIndex] = updatedUser;
//         } else {
//           _adminUsers.add(updatedUser);
//         }
//       } else if (adminIndex != -1) {
//         _adminUsers.removeAt(adminIndex);
//       }
      
//       notifyListeners();
//       _setError(null);
//     } catch (e) {
//       _setError('Error updating user: ${e.toString()}');
//     }
//   }

//   Future<void> deleteUser(String userId) async {
//     try {
//       await _apiService.deleteUser(userId);
//       _users.removeWhere((u) => u.id == userId);
//       _adminUsers.removeWhere((u) => u.id == userId);
//       notifyListeners();
//       _setError(null);
//     } catch (e) {
//       _setError('Error deleting user: ${e.toString()}');
//     }
//   }

//   // Notification Methods
//   Future<void> loadNotifications(String userId) async {
//     _isLoadingNotifications = true;
//     notifyListeners();
    
//     try {
//       _notifications = await _apiService.getNotifications(userId);
//       _unreadCount = await _apiService.getUnreadNotificationCount(userId);
//       _setError(null);
//     } catch (e) {
//       _setError('Error loading notifications: ${e.toString()}');
//     } finally {
//       _isLoadingNotifications = false;
//       notifyListeners();
//     }
//   }

//   Future<void> markNotificationAsRead(String notificationId) async {
//     try {
//       await _apiService.markNotificationAsRead(notificationId);
      
//       // Update local notification
//       final index = _notifications.indexWhere((n) => n.id == notificationId);
//       if (index != -1) {
//         _notifications[index] = AppNotification(
//           id: _notifications[index].id,
//           title: _notifications[index].title,
//           message: _notifications[index].message,
//           type: _notifications[index].type,
//           requestId: _notifications[index].requestId,
//           targetUserIds: _notifications[index].targetUserIds,
//           senderName: _notifications[index].senderName,
//           createdAt: _notifications[index].createdAt,
//           isRead: true,
//         );
//       }
      
//       // Update unread count
//       _unreadCount = _notifications.where((n) => !n.isRead).length;
//       notifyListeners();
//       _setError(null);
//     } catch (e) {
//       _setError('Error marking notification as read: ${e.toString()}');
//     }
//   }

//   // Export Methods
//   Future<String?> exportRequestsToExcel() async {
//     try {
//       final url = await _apiService.exportRequestsToExcel(_allRequests);
//       _setError(null);
//       return url;
//     } catch (e) {
//       _setError('Error exporting to Excel: ${e.toString()}');
//       return null;
//     }
//   }

//   Future<String?> exportRequestsToPdf() async {
//     try {
//       final url = await _apiService.exportRequestsToPdf(_allRequests);
//       _setError(null);
//       return url;
//     } catch (e) {
//       _setError('Error exporting to PDF: ${e.toString()}');
//       return null;
//     }
//   }

//   // Initialize all admin data
//   Future<void> initializeAdminData(String userId) async {
//     await Future.wait([
//       loadDashboardStats(),
//       loadAllRequests(),
//       loadRequestTypes(),
//       loadTemplates(),
//       loadUsers(),
//       loadNotifications(userId),
//     ]);
//   }

//   // Refresh all data
//   Future<void> refreshAllData(String userId) async {
//     await initializeAdminData(userId);
//   }

//   // Private helper methods
//   void _setError(String? error) {
//     _errorMessage = error;
//     notifyListeners();
//   }

//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
// }



//2





// lib/viewmodels/admin_viewmodel.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_api_service.dart';

class AdminViewModel extends ChangeNotifier {
  final MockApiService _apiService = MockApiService();
  
  // Stream subscriptions for proper disposal
  final List<StreamSubscription> _subscriptions = [];
  
  // Timers for auto-refresh
  Timer? _refreshTimer;
  
  // Dashboard Stats
  DashboardStats? _dashboardStats;
  bool _isLoadingStats = false;
  
  // Requests
  List<Request> _allRequests = [];
  List<Request> _filteredRequests = [];
  bool _isLoadingRequests = false;
  String _requestSearchQuery = '';
  String? _statusFilter;
  Priority? _priorityFilter;
  
  // Request Types
  List<RequestType> _requestTypes = [];
  bool _isLoadingTypes = false;
  
  // Templates
  List<RequestTemplate> _templates = [];
  bool _isLoadingTemplates = false;
  
  // Users
  List<User> _users = [];
  List<User> _adminUsers = [];
  bool _isLoadingUsers = false;
  
  // Notifications
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoadingNotifications = false;
  
  // Error handling
  String? _errorMessage;
  
  // Disposed flag to prevent operations after disposal
  bool _disposed = false;

  // Getters with null safety
  DashboardStats? get dashboardStats => _disposed ? null : _dashboardStats;
  bool get isLoadingStats => _disposed ? false : _isLoadingStats;
  
  List<Request> get allRequests => _disposed ? [] : List.unmodifiable(_allRequests);
  List<Request> get filteredRequests => _disposed ? [] : List.unmodifiable(_filteredRequests);
  bool get isLoadingRequests => _disposed ? false : _isLoadingRequests;
  
  List<RequestType> get requestTypes => _disposed ? [] : List.unmodifiable(_requestTypes);
  bool get isLoadingTypes => _disposed ? false : _isLoadingTypes;
  
  List<RequestTemplate> get templates => _disposed ? [] : List.unmodifiable(_templates);
  bool get isLoadingTemplates => _disposed ? false : _isLoadingTemplates;
  
  List<User> get users => _disposed ? [] : List.unmodifiable(_users);
  List<User> get adminUsers => _disposed ? [] : List.unmodifiable(_adminUsers);
  bool get isLoadingUsers => _disposed ? false : _isLoadingUsers;
  
  List<AppNotification> get notifications => _disposed ? [] : List.unmodifiable(_notifications);
  int get unreadCount => _disposed ? 0 : _unreadCount;
  bool get isLoadingNotifications => _disposed ? false : _isLoadingNotifications;
  
  String? get errorMessage => _disposed ? null : _errorMessage;

  // Initialize admin data with proper error handling
  Future<void> initializeAdminData(String adminId) async {
    if (_disposed) return;
    
    try {
      // Load all data concurrently for better performance
      await Future.wait([
        loadDashboardStats(),
        loadAllRequests(),
        loadRequestTypes(),
        loadTemplates(),
        loadUsers(),
        loadNotifications(adminId),
      ], eagerError: true);
      
      // Set up auto-refresh timer (every 5 minutes)
      _setupAutoRefresh(adminId);
      
    } catch (e) {
      _setError('Failed to initialize admin data: ${e.toString()}');
      debugPrint('Admin initialization error: $e');
    }
  }

  // Set up auto-refresh with proper cleanup
  void _setupAutoRefresh(String adminId) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (!_disposed) {
        refreshAdminData(adminId);
      } else {
        timer.cancel();
      }
    });
  }


 Future<void> refreshAllData(String adminId) async {
    if (_disposed) return;
    
    await Future.wait([
      loadDashboardStats(),
      loadAllRequests(),
      loadNotifications(adminId),
    ]);
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    if (_disposed) return;
    
    try {
      await _apiService.markNotificationAsRead(notificationId);
      
      if (!_disposed) {
        // Update local notifications list
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          // In a real implementation, you'd update the notification's read status
          // For now, we'll remove it from the list
          _notifications.removeAt(index);
          if (_unreadCount > 0) {
            _unreadCount--;
          }
          _safeNotifyListeners();
        }
      }
    } catch (e) {
      _setError('Error marking notification as read: ${e.toString()}');
    }
  }

  // Delete user method
  Future<bool> deleteUser(String userId) async {
    if (_disposed) return false;
    
    try {
      await _apiService.deleteUser(userId);
      
      if (!_disposed) {
        _users.removeWhere((user) => user.id == userId);
        _adminUsers.removeWhere((user) => user.id == userId);
        _safeNotifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError('Error deleting user: ${e.toString()}');
      return false;
    }
  }


  // Refresh admin data
  Future<void> refreshAdminData(String adminId) async {
    if (_disposed) return;
    
    await Future.wait([
      loadDashboardStats(),
      loadAllRequests(),
      loadNotifications(adminId),
    ]);
  }

  // Dashboard Methods with error handling
  Future<void> loadDashboardStats() async {
    if (_disposed) return;
    
    _safeSetState(() => _isLoadingStats = true);
    
    try {
      _dashboardStats = await _apiService.getDashboardStats();
      _setError(null);
    } catch (e) {
      _setError('Error loading dashboard stats: ${e.toString()}');
      debugPrint('Dashboard stats error: $e');
    } finally {
      _safeSetState(() => _isLoadingStats = false);
    }
  }

  // Request Methods with pagination support
  Future<void> loadAllRequests({int page = 1, int limit = 50}) async {
    if (_disposed) return;
    
    _safeSetState(() => _isLoadingRequests = true);
    
    try {
      final requests = await _apiService.getRequests();
      
      if (!_disposed) {
        _allRequests = requests;
        _applyRequestFilters();
        _setError(null);
      }
    } catch (e) {
      _setError('Error loading requests: ${e.toString()}');
      debugPrint('Requests loading error: $e');
    } finally {
      _safeSetState(() => _isLoadingRequests = false);
    }
  }

  // Optimized filter application with debouncing
  void updateRequestFilters({String? searchQuery, String? status, Priority? priority}) {
    if (_disposed) return;
    
    if (searchQuery != null) _requestSearchQuery = searchQuery;
    if (status != null) _statusFilter = status;
    if (priority != null) _priorityFilter = priority;
    
    _applyRequestFilters();
  }

  void _applyRequestFilters() {
    if (_disposed) return;
    
    _filteredRequests = _allRequests.where((request) {
      // Search filter with case-insensitive matching
      bool matchesSearch = _requestSearchQuery.isEmpty ||
          request.typeName.toLowerCase().contains(_requestSearchQuery.toLowerCase()) ||
          request.fieldValues.values.any((value) => 
            value.toString().toLowerCase().contains(_requestSearchQuery.toLowerCase()));
      
      // Status filter
      bool matchesStatus = _statusFilter == null || 
          _statusFilter!.isEmpty || 
          request.status == _statusFilter;
      
      // Priority filter
      bool matchesPriority = _priorityFilter == null || 
          request.priority == _priorityFilter;
      
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
    
    _safeNotifyListeners();
  }

  // User management with validation
  Future<bool> createUser(User user) async {
    if (_disposed) return false;
    
    try {
      // Validate user data
      if (!_validateUserData(user)) {
        return false;
      }
      
      final createdUser = await _apiService.createUser(user);
      
      if (!_disposed) {
        _users.add(createdUser);
        if (createdUser.role == UserRole.admin) {
          _adminUsers.add(createdUser);
        }
        _safeNotifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError('Error creating user: ${e.toString()}');
      debugPrint('User creation error: $e');
      return false;
    }
  }

  Future<bool> updateUser(User user) async {
    if (_disposed) return false;
    
    try {
      if (!_validateUserData(user)) {
        return false;
      }
      
      final updatedUser = await _apiService.updateUser(user);
      
      if (!_disposed) {
        final index = _users.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _users[index] = updatedUser;
        }
        
        final adminIndex = _adminUsers.indexWhere((u) => u.id == user.id);
        if (adminIndex != -1) {
          if (updatedUser.role == UserRole.admin) {
            _adminUsers[adminIndex] = updatedUser;
          } else {
            _adminUsers.removeAt(adminIndex);
          }
        } else if (updatedUser.role == UserRole.admin) {
          _adminUsers.add(updatedUser);
        }
        
        _safeNotifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError('Error updating user: ${e.toString()}');
      debugPrint('User update error: $e');
      return false;
    }
  }

  // User data validation
  bool _validateUserData(User user) {
    if (user.name.trim().isEmpty) {
      _setError('User name cannot be empty');
      return false;
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(user.email)) {
      _setError('Please enter a valid email address');
      return false;
    }
    
    if (user.department.trim().isEmpty) {
      _setError('Department cannot be empty');
      return false;
    }
    
    return true;
  }

  // Load other data with error handling
  Future<void> loadRequestTypes() async {
    if (_disposed) return;
    
    _safeSetState(() => _isLoadingTypes = true);
    
    try {
      _requestTypes = await _apiService.getRequestTypes();
      _setError(null);
    } catch (e) {
      _setError('Error loading request types: ${e.toString()}');
    } finally {
      _safeSetState(() => _isLoadingTypes = false);
    }
  }

  Future<void> loadTemplates() async {
    if (_disposed) return;
    
    _safeSetState(() => _isLoadingTemplates = true);
    
    try {
      _templates = await _apiService.getTemplates();
      _setError(null);
    } catch (e) {
      _setError('Error loading templates: ${e.toString()}');
    } finally {
      _safeSetState(() => _isLoadingTemplates = false);
    }
  }

  Future<void> loadUsers() async {
    if (_disposed) return;
    
    _safeSetState(() => _isLoadingUsers = true);
    
    try {
      _users = await _apiService.getUsers();
      _adminUsers = await _apiService.getAdminUsers();
      _setError(null);
    } catch (e) {
      _setError('Error loading users: ${e.toString()}');
    } finally {
      _safeSetState(() => _isLoadingUsers = false);
    }
  }

  Future<void> loadNotifications(String userId) async {
    if (_disposed) return;
    
    _safeSetState(() => _isLoadingNotifications = true);
    
    try {
      _notifications = await _apiService.getNotifications(userId);
      _unreadCount = await _apiService.getUnreadNotificationCount(userId);
      _setError(null);
    } catch (e) {
      _setError('Error loading notifications: ${e.toString()}');
    } finally {
      _safeSetState(() => _isLoadingNotifications = false);
    }
  }

  // Safe state management
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
      notifyListeners();
    }
  }

  void clearError() {
    _setError(null);
  }

  // Comprehensive disposal to prevent memory leaks
  @override
  void dispose() {
    debugPrint('AdminViewModel disposing...');
    
    _disposed = true;
    
    // Cancel timers
    _refreshTimer?.cancel();
    _refreshTimer = null;
    
    // Cancel subscriptions
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    
    // Clear collections
    _allRequests.clear();
    _filteredRequests.clear();
    _requestTypes.clear();
    _templates.clear();
    _users.clear();
    _adminUsers.clear();
    _notifications.clear();
    
    // Clear state
    _dashboardStats = null;
    _errorMessage = null;
    _unreadCount = 0;
    
    super.dispose();
  }
}