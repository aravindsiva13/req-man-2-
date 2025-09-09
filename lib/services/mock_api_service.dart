// import 'dart:math';
// import '../models/models.dart';
// import '../models/template_models.dart';

// class MockApiServiceExtended {
//   final MockApiService _baseService = MockApiService();
  
//   // Delegate to base service
//   Future<User?> validateLogin(String email, String password) => _baseService.validateLogin(email, password);
//   Future<List<RequestType>> getRequestTypes() => _baseService.getRequestTypes();
//   Future<RequestType> getRequestTypeById(String id) => _baseService.getRequestTypeById(id);
//   Future<List<Request>> getRequests({String? userId, String? assignedAdminId}) => _baseService.getRequests(userId: userId, assignedAdminId: assignedAdminId);
//   Future<Request> createRequest(Request request) => _baseService.createRequest(request);
//   Future<Request> updateRequestStatus(String requestId, String newStatus, {String? adminComments, String? adminName}) => 
//     _baseService.updateRequestStatus(requestId, newStatus, adminComments: adminComments, adminName: adminName);
//   Future<Request> assignRequest(String requestId, String adminId, String adminName) => _baseService.assignRequest(requestId, adminId, adminName);
//   Future<Request> updateRequestPriority(String requestId, Priority priority) => _baseService.updateRequestPriority(requestId, priority);
//   Future<List<RequestTemplate>> getTemplates({String? typeId}) => _baseService.getTemplates(typeId: typeId);
//   Future<RequestTemplate> createTemplate(RequestTemplate template) => _baseService.createTemplate(template);
//   Future<void> deleteTemplate(String id) => _baseService.deleteTemplate(id);
//   Future<List<RequestComment>> getComments(String requestId, {bool includePrivate = false}) => _baseService.getComments(requestId, includePrivate: includePrivate);
//   Future<RequestComment> addComment(RequestComment comment) => _baseService.addComment(comment);
//   Future<DashboardStats> getDashboardStats() => _baseService.getDashboardStats();
//   Future<List<AppNotification>> getNotifications(String userId) => _baseService.getNotifications(userId);
//   Future<void> markNotificationAsRead(String notificationId) => _baseService.markNotificationAsRead(notificationId);
//   Future<int> getUnreadNotificationCount(String userId) => _baseService.getUnreadNotificationCount(userId);
//   Future<List<User>> getUsers() => _baseService.getUsers();
//   Future<List<User>> getAdminUsers() => _baseService.getAdminUsers();
//   Future<User> createUser(User user) => _baseService.createUser(user);
//   Future<User> updateUser(User user) => _baseService.updateUser(user);
//   Future<void> deleteUser(String id) => _baseService.deleteUser(id);
//   Future<List<Request>> searchRequests(String query, {String? status, Priority? priority, String? category}) => 
//     _baseService.searchRequests(query, status: status, priority: priority, category: category);
  
//   // Extended Template Operations
//   Future<List<ExtendedRequestTemplate>> getExtendedTemplates({String? typeId}) async {
//     await Future.delayed(Duration(milliseconds: 500));
    
//     final extendedTemplates = [
//       ExtendedRequestTemplate(
//         id: '1',
//         name: 'Standard Leave Request',
//         description: 'Template for common annual leave requests',
//         typeId: '1',
//         typeName: 'Leave Request',
//         fieldMappings: [
//           TemplateFieldMapping(
//             fieldId: '1',
//             fieldName: 'Leave Type',
//             defaultValue: 'Annual',
//             isLocked: false,
//           ),
//           TemplateFieldMapping(
//             fieldId: '4',
//             fieldName: 'Reason',
//             defaultValue: 'Personal time off',
//             isLocked: false,
//           ),
//         ],
//         metadata: {'category': 'HR', 'priority': 'standard'},
//         createdBy: '1',
//         createdByName: 'John Admin',
//         createdAt: DateTime.now().subtract(Duration(days: 10)),
//         isActive: true,
//         tags: ['leave', 'hr', 'standard'],
//         usageCount: 25,
//       ),
//       ExtendedRequestTemplate(
//         id: '2',
//         name: 'Emergency Leave',
//         description: 'Template for urgent leave requests',
//         typeId: '1',
//         typeName: 'Leave Request',
//         fieldMappings: [
//           TemplateFieldMapping(
//             fieldId: '1',
//             fieldName: 'Leave Type',
//             defaultValue: 'Emergency',
//             isLocked: true,
//           ),
//           TemplateFieldMapping(
//             fieldId: '4',
//             fieldName: 'Reason',
//             defaultValue: 'Family emergency',
//             isLocked: false,
//           ),
//         ],
//         metadata: {'category': 'HR', 'priority': 'urgent'},
//         createdBy: '1',
//         createdByName: 'John Admin',
//         createdAt: DateTime.now().subtract(Duration(days: 5)),
//         isActive: true,
//         tags: ['emergency', 'leave', 'urgent'],
//         usageCount: 8,
//       ),
//       ExtendedRequestTemplate(
//         id: '3',
//         name: 'Hardware Issue Report',
//         description: 'Template for common hardware problems',
//         typeId: '2',
//         typeName: 'IT Support',
//         fieldMappings: [
//           TemplateFieldMapping(
//             fieldId: '1',
//             fieldName: 'Issue Type',
//             defaultValue: 'Hardware',
//             isLocked: true,
//           ),
//           TemplateFieldMapping(
//             fieldId: '2',
//             fieldName: 'Priority',
//             defaultValue: 'High',
//             isLocked: false,
//           ),
//           TemplateFieldMapping(
//             fieldId: '3',
//             fieldName: 'Description',
//             defaultValue: 'Hardware malfunction - please provide details',
//             isLocked: false,
//           ),
//         ],
//         metadata: {'category': 'IT', 'priority': 'high'},
//         createdBy: '1',
//         createdByName: 'John Admin',
//         createdAt: DateTime.now().subtract(Duration(days: 15)),
//         isActive: true,
//         tags: ['hardware', 'it', 'support'],
//         usageCount: 18,
//       ),
//     ];

//     if (typeId != null) {
//       return extendedTemplates.where((t) => t.typeId == typeId).toList();
//     }
    
//     return extendedTemplates;
//   }

//   Future<ExtendedRequestTemplate> createExtendedTemplate(ExtendedRequestTemplate template) async {
//     await Future.delayed(Duration(milliseconds: 800));
    
//     final newTemplate = ExtendedRequestTemplate(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       name: template.name,
//       description: template.description,
//       typeId: template.typeId,
//       typeName: template.typeName,
//       fieldMappings: template.fieldMappings,
//       metadata: template.metadata,
//       createdBy: template.createdBy,
//       createdByName: template.createdByName,
//       createdAt: DateTime.now(),
//       isActive: true,
//       tags: template.tags,
//       usageCount: 0,
//     );
    
//     return newTemplate;
//   }

//   Future<ExtendedRequestTemplate> updateExtendedTemplate(ExtendedRequestTemplate template) async {
//     await Future.delayed(Duration(milliseconds: 600));
    
//     return template.copyWith(
//       updatedAt: DateTime.now(),
//     );
//   }

//   Future<void> incrementTemplateUsage(String templateId) async {
//     await Future.delayed(Duration(milliseconds: 200));
//     // Simulate usage increment
//   }

//   // Template Categories
//   Future<List<TemplateCategory>> getTemplateCategories() async {
//     await Future.delayed(Duration(milliseconds: 300));
    
//     return [
//       TemplateCategory(
//         id: '1',
//         name: 'Human Resources',
//         description: 'HR-related request templates',
//         color: '#2196F3',
//         requestTypeIds: ['1'],
//       ),
//       TemplateCategory(
//         id: '2',
//         name: 'Information Technology',
//         description: 'IT support and technical templates',
//         color: '#4CAF50',
//         requestTypeIds: ['2'],
//       ),
//       TemplateCategory(
//         id: '3',
//         name: 'Finance & Accounting',
//         description: 'Financial request templates',
//         color: '#FF9800',
//         requestTypeIds: [],
//       ),
//     ];
//   }

//   // Template Usage Statistics
//   Future<List<TemplateUsageStats>> getTemplateUsageStats() async {
//     await Future.delayed(Duration(milliseconds: 400));
    
//     return [
//       TemplateUsageStats(
//         templateId: '1',
//         templateName: 'Standard Leave Request',
//         totalUsage: 25,
//         monthlyUsage: 8,
//         weeklyUsage: 3,
//         lastUsed: DateTime.now().subtract(Duration(hours: 4)),
//         topUsers: ['Jane User', 'Mike Chen', 'Sarah Johnson'],
//       ),
//       TemplateUsageStats(
//         templateId: '3',
//         templateName: 'Hardware Issue Report',
//         totalUsage: 18,
//         monthlyUsage: 12,
//         weeklyUsage: 4,
//         lastUsed: DateTime.now().subtract(Duration(hours: 2)),
//         topUsers: ['Jane User', 'Alex Wilson'],
//       ),
//       TemplateUsageStats(
//         templateId: '2',
//         templateName: 'Emergency Leave',
//         totalUsage: 8,
//         monthlyUsage: 3,
//         weeklyUsage: 1,
//         lastUsed: DateTime.now().subtract(Duration(days: 3)),
//         topUsers: ['Mike Chen'],
//       ),
//     ];
//   }

//   // Bulk Operations
//   Future<BulkOperationResult> executeBulkOperation(BulkOperationRequest request) async {
//     await Future.delayed(Duration(milliseconds: 2000)); // Simulate processing time
    
//     final random = Random();
//     final successCount = request.targetIds.length - random.nextInt(2); // Most succeed
//     final failureCount = request.targetIds.length - successCount;
    
//     final errors = <String>[];
//     if (failureCount > 0) {
//       errors.add('Some items could not be processed due to validation errors');
//     }
    
//     return BulkOperationResult(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       type: request.type,
//       totalItems: request.targetIds.length,
//       successCount: successCount,
//       failureCount: failureCount,
//       errors: errors,
//       executedAt: DateTime.now(),
//       executedBy: request.executedBy,
//     );
//   }

//   // File Operations
//   Future<List<FileAttachmentExtended>> getFilesByRequest(String requestId) async {
//     await Future.delayed(Duration(milliseconds: 400));
    
//     return [
//       FileAttachmentExtended(
//         id: '1',
//         name: 'requirements_document.pdf',
//         type: 'application/pdf',
//         size: 2 * 1024 * 1024, // 2MB
//         url: 'https://mock-storage.com/files/1',
//         uploadedAt: DateTime.now().subtract(Duration(hours: 2)),
//         uploadedBy: 'user_123',
//         thumbnailUrl: 'https://mock-storage.com/thumbnails/1',
//         isImage: false,
//         isDocument: true,
//         description: 'Project requirements and specifications',
//         tags: ['requirements', 'project'],
//       ),
//       FileAttachmentExtended(
//         id: '2',
//         name: 'error_screenshot.png',
//         type: 'image/png',
//         size: 1024 * 1024, // 1MB
//         url: 'https://mock-storage.com/files/2',
//         uploadedAt: DateTime.now().subtract(Duration(minutes: 30)),
//         uploadedBy: 'user_123',
//         thumbnailUrl: 'https://mock-storage.com/thumbnails/2',
//         isImage: true,
//         isDocument: false,
//         description: 'Screenshot showing the error condition',
//         tags: ['screenshot', 'error', 'bug'],
//       ),
//     ];
//   }

//   Future<FileAttachmentExtended> uploadFile(FileAttachmentExtended file, String requestId) async {
//     await Future.delayed(Duration(milliseconds: 1500));
    
//     return FileAttachmentExtended(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       name: file.name,
//       type: file.type,
//       size: file.size,
//       url: 'https://mock-storage.com/files/${DateTime.now().millisecondsSinceEpoch}',
//       uploadedAt: DateTime.now(),
//       uploadedBy: 'current_user',
//       thumbnailUrl: file.isImage ? 'https://mock-storage.com/thumbnails/${DateTime.now().millisecondsSinceEpoch}' : '',
//       isImage: file.isImage,
//       isDocument: file.isDocument,
//       description: file.description,
//       tags: file.tags,
//     );
//   }

//   Future<void> deleteFile(String fileId) async {
//     await Future.delayed(Duration(milliseconds: 300));
//     // Simulate file deletion
//   }

//   // Edit History
//   Future<List<EditHistory>> getEditHistory(String entityType, String entityId) async {
//     await Future.delayed(Duration(milliseconds: 300));
    
//     return [
//       EditHistory(
//         id: '1',
//         entityType: entityType,
//         entityId: entityId,
//         fieldName: 'status',
//         oldValue: 'Pending',
//         newValue: 'In Progress',
//         editedBy: 'admin_1',
//         editedByName: 'John Admin',
//         editedAt: DateTime.now().subtract(Duration(hours: 2)),
//         reason: 'Started working on the request',
//       ),
//       EditHistory(
//         id: '2',
//         entityType: entityType,
//         entityId: entityId,
//         fieldName: 'priority',
//         oldValue: 'Medium',
//         newValue: 'High',
//         editedBy: 'admin_1',
//         editedByName: 'John Admin',
//         editedAt: DateTime.now().subtract(Duration(hours: 1)),
//         reason: 'Escalated due to urgency',
//       ),
//     ];
//   }

//   Future<void> logEdit(EditHistory edit) async {
//     await Future.delayed(Duration(milliseconds: 200));
//     // Simulate logging edit
//   }

//   // Advanced Analytics Data
//   Future<List<RequestTrendExtended>> getRequestTrendsExtended(AnalyticsTimeframe timeframe) async {
//     await Future.delayed(Duration(milliseconds: 600));
    
//     final trends = <RequestTrendExtended>[];
//     final days = timeframe.endDate.difference(timeframe.startDate).inDays;
    
//     for (int i = 0; i < days; i++) {
//       final date = timeframe.startDate.add(Duration(days: i));
//       final random = Random();
      
//       final total = 5 + random.nextInt(10);
//       final completed = (total * 0.7).round();
//       final pending = (total * 0.2).round();
//       final rejected = total - completed - pending;
      
//       trends.add(RequestTrendExtended(
//         date: date,
//         requestCount: total,
//         completedCount: completed,
//         pendingCount: pending,
//         rejectedCount: rejected,
//         avgResolutionTime: 1.5 + random.nextDouble() * 2, // 1.5-3.5 days
//       ));
//     }
    
//     return trends;
//   }

//   Future<List<CategoryPerformance>> getCategoryPerformance() async {
//     await Future.delayed(Duration(milliseconds: 400));
    
//     return [
//       CategoryPerformance(
//         category: 'IT Support',
//         totalRequests: 45,
//         completedRequests: 42,
//         completionRate: 93.3,
//         avgResolutionDays: 2.1,
//         topIssues: ['Hardware failure', 'Software bugs', 'Network issues'],
//       ),
//       CategoryPerformance(
//         category: 'HR',
//         totalRequests: 28,
//         completedRequests: 26,
//         completionRate: 92.9,
//         avgResolutionDays: 1.8,
//         topIssues: ['Leave requests', 'Benefits inquiry', 'Training requests'],
//       ),
//       CategoryPerformance(
//         category: 'Finance',
//         totalRequests: 15,
//         completedRequests: 14,
//         completionRate: 93.3,
//         avgResolutionDays: 3.2,
//         topIssues: ['Expense reports', 'Budget requests', 'Invoice issues'],
//       ),
//     ];
//   }

//   Future<List<UserProductivity>> getUserProductivity() async {
//     await Future.delayed(Duration(milliseconds: 400));
    
//     return [
//       UserProductivity(
//         userId: '2',
//         userName: 'Jane User',
//         department: 'HR',
//         requestsSubmitted: 12,
//         requestsCompleted: 11,
//         avgResponseTime: 2.3,
//         templatesCreated: 3,
//       ),
//       UserProductivity(
//         userId: '4',
//         userName: 'Sarah Johnson',
//         department: 'Marketing',
//         requestsSubmitted: 8,
//         requestsCompleted: 8,
//         avgResponseTime: 1.8,
//         templatesCreated: 1,
//       ),
//       UserProductivity(
//         userId: '5',
//         userName: 'Mike Chen',
//         department: 'Finance',
//         requestsSubmitted: 15,
//         requestsCompleted: 13,
//         avgResponseTime: 3.1,
//         templatesCreated: 2,
//       ),
//     ];
//   }

//   // System Settings
//   Future<SystemSettings> getSystemSettings() async {
//     await Future.delayed(Duration(milliseconds: 300));
    
//     return SystemSettings(
//       id: '1',
//       organizationName: 'Acme Corporation',
//       primaryColor: '#2196F3',
//       logoUrl: 'https://mock-storage.com/logo.png',
//       featureFlags: {
//         'advancedAnalytics': true,
//         'bulkOperations': true,
//         'fileAttachments': true,
//         'templates': true,
//         'notifications': true,
//       },
//       configurations: {
//         'maxFileSize': 10 * 1024 * 1024, // 10MB
//         'maxFilesPerRequest': 5,
//         'autoAssignment': true,
//         'emailNotifications': true,
//         'slaEnabled': true,
//         'defaultSlaHours': 24,
//       },
//       lastUpdated: DateTime.now().subtract(Duration(days: 7)),
//       updatedBy: 'admin_1',
//     );
//   }

//   Future<SystemSettings> updateSystemSettings(SystemSettings settings) async {
//     await Future.delayed(Duration(milliseconds: 500));
    
//     return settings;
//   }

//   // Notification Operations (Enhanced)
//   Future<void> createNotification(AppNotification notification) async {
//     await Future.delayed(Duration(milliseconds: 200));
//     // Simulate notification creation
//   }

//   Future<void> sendBulkNotification(String title, String message, List<String> userIds) async {
//     await Future.delayed(Duration(milliseconds: 800));
//     // Simulate bulk notification sending
//   }

//   // Search Enhancement
//   Future<List<Request>> advancedSearch({
//     String? query,
//     List<String>? statuses,
//     List<Priority>? priorities,
//     List<String>? categories,
//     List<String>? assignedAdmins,
//     DateTime? fromDate,
//     DateTime? toDate,
//     List<String>? tags,
//   }) async {
//     await Future.delayed(Duration(milliseconds: 600));
    
//     // Simulate advanced search with filters
//     // In real implementation, this would query the database with complex filters
//     return getRequests().then((requests) {
//       return requests.where((request) {
//         // Apply all filters
//         bool matches = true;
        
//         if (query != null && query.isNotEmpty) {
//           matches = matches && (
//             request.typeName.toLowerCase().contains(query.toLowerCase()) ||
//             request.fieldValues.values.any((value) => 
//               value.toString().toLowerCase().contains(query.toLowerCase()))
//           );
//         }
        
//         if (statuses != null && statuses.isNotEmpty) {
//           matches = matches && statuses.contains(request.status);
//         }
        
//         if (priorities != null && priorities.isNotEmpty) {
//           matches = matches && priorities.contains(request.priority);
//         }
        
//         if (categories != null && categories.isNotEmpty) {
//           matches = matches && categories.contains(request.category);
//         }
        
//         if (assignedAdmins != null && assignedAdmins.isNotEmpty) {
//           matches = matches && request.assignedAdminId != null && 
//                    assignedAdmins.contains(request.assignedAdminId);
//         }
        
//         if (fromDate != null) {
//           matches = matches && request.submittedAt.isAfter(fromDate);
//         }
        
//         if (toDate != null) {
//           matches = matches && request.submittedAt.isBefore(toDate);
//         }
        
//         if (tags != null && tags.isNotEmpty) {
//           matches = matches && request.tags.any((tag) => tags.contains(tag));
//         }
        
//         return matches;
//       }).toList();
//     });
//   }

//   // Performance Metrics
//   Future<Map<String, dynamic>> getPerformanceMetrics(AnalyticsTimeframe timeframe) async {
//     await Future.delayed(Duration(milliseconds: 500));
    
//     return {
//       'avgResolutionTime': 2.3, // days
//       'firstResponseTime': 4.2, // hours
//       'resolutionRate': 94.2, // percentage
//       'escalationRate': 5.8, // percentage
//       'customerSatisfaction': 4.2, // out of 5
//       'slaCompliance': 89.5, // percentage
//       'totalRequests': 156,
//       'completedRequests': 147,
//       'overdueRequests': 12,
//     };
//   }

//   // Export Enhancement
//   Future<String> exportAdvancedReport({
//     required String format, // 'excel', 'pdf', 'csv'
//     required List<String> requestIds,
//     Map<String, dynamic>? filters,
//     List<String>? includeFields,
//   }) async {
//     await Future.delayed(Duration(milliseconds: 2000));
    
//     final timestamp = DateTime.now().millisecondsSinceEpoch;
//     return 'https://mock-storage.com/exports/advanced_report_$timestamp.$format';
//   }

//   // Auto-completion suggestions
//   Future<List<String>> getAutocompleteSuggestions(String field, String query) async {
//     await Future.delayed(Duration(milliseconds: 200));
    
//     switch (field) {
//       case 'tags':
//         return ['urgent', 'hardware', 'software', 'leave', 'benefits', 'training', 'expense']
//             .where((tag) => tag.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       case 'categories':
//         return ['IT Support', 'HR', 'Finance', 'Operations', 'Marketing']
//             .where((cat) => cat.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       case 'departments':
//         return ['IT', 'HR', 'Finance', 'Operations', 'Marketing', 'Sales']
//             .where((dept) => dept.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       default:
//         return [];
//     }
//   }

//   // Validation helpers
//   Future<bool> validateUniqueTemplateName(String name, {String? excludeId}) async {
//     await Future.delayed(Duration(milliseconds: 300));
    
//     final templates = await getExtendedTemplates();
//     return !templates.any((t) => t.name.toLowerCase() == name.toLowerCase() && t.id != excludeId);
//   }

//   Future<bool> validateUniqueEmail(String email, {String? excludeUserId}) async {
//     await Future.delayed(Duration(milliseconds: 300));
    
//     final users = await getUsers();
//     return !users.any((u) => u.email.toLowerCase() == email.toLowerCase() && u.id != excludeUserId);
//   }

//   // Audit Trail
//   Future<List<EditHistory>> getAuditTrail({
//     String? entityType,
//     String? entityId,
//     String? userId,
//     DateTime? fromDate,
//     DateTime? toDate,
//   }) async {
//     await Future.delayed(Duration(milliseconds: 400));
    
//     // Return mock audit trail data
//     return List.generate(10, (index) {
//       return EditHistory(
//         id: index.toString(),
//         entityType: entityType ?? ['request', 'user', 'template'][index % 3],
//         entityId: '${index + 1}',
//         fieldName: ['status', 'priority', 'name', 'description'][index % 4],
//         oldValue: 'Old Value $index',
//         newValue: 'New Value $index',
//         editedBy: 'admin_${(index % 3) + 1}',
//         editedByName: ['John Admin', 'Jane Manager', 'Mike Supervisor'][index % 3],
//         editedAt: DateTime.now().subtract(Duration(hours: index)),
//         reason: index % 2 == 0 ? 'System update' : null,
//       );
//     });
//   }
// }


//2


import 'dart:math';
import '../models/models.dart';
import '../models/template_models.dart';

class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal() {
    _initializeSampleData();
  }

  // Mock data storage
  final List<User> _users = [];
  final List<RequestType> _requestTypes = [];
  final List<Request> _requests = [];
  final List<RequestTemplate> _templates = [];
  final List<RequestComment> _comments = [];
  final List<AppNotification> _notifications = [];
  
  // Counters
  int _userCounter = 4;
  int _requestCounter = 2;
  int _typeCounter = 2;
  int _templateCounter = 1;
  int _commentCounter = 1;
  int _notificationCounter = 0;
  int _historyCounter = 3;

  void _initializeSampleData() {
    // Initialize sample users
    _users.addAll([
      User(
        id: '1',
        name: 'John Admin',
        email: 'admin@example.com',
        password: 'password123',
        role: UserRole.admin,
        status: UserStatus.active,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        lastLoginAt: DateTime.now().subtract(Duration(hours: 2)),
        profileData: {'department': 'IT', 'designation': 'System Administrator'},
        permissions: ['manage_users', 'create_request_types', 'update_status'],
        department: 'IT',
        active: true,
      ),
      User(
        id: '2',
        name: 'Jane User',
        email: 'user@example.com',
        password: 'password123',
        role: UserRole.user,
        status: UserStatus.active,
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        lastLoginAt: DateTime.now().subtract(Duration(days: 1)),
        profileData: {'department': 'HR', 'designation': 'HR Assistant'},
        permissions: ['create_requests', 'view_own_requests'],
        department: 'HR',
        active: true,
      ),
      User(
        id: '3',
        name: 'Mike Manager',
        email: 'manager@example.com',
        password: 'password123',
        role: UserRole.admin,
        status: UserStatus.active,
        createdAt: DateTime.now().subtract(Duration(days: 45)),
        lastLoginAt: DateTime.now().subtract(Duration(hours: 8)),
        profileData: {'department': 'Operations', 'designation': 'Operations Manager'},
        permissions: ['manage_requests', 'assign_requests', 'view_analytics'],
        department: 'Operations',
        active: true,
      ),
    ]);

    // Initialize sample request types
    _requestTypes.addAll([
      RequestType(
        id: '1',
        name: 'Leave Request',
        description: 'Request for time off',
        category: 'HR',
        createdBy: 'John Admin',
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        fields: [
          CustomField(id: '1', name: 'Leave Type', type: FieldType.dropdown, 
            options: ['Annual', 'Sick', 'Personal', 'Emergency'], required: true),
          CustomField(id: '2', name: 'Start Date', type: FieldType.date, required: true),
          CustomField(id: '3', name: 'End Date', type: FieldType.date, required: true),
          CustomField(id: '4', name: 'Reason', type: FieldType.textarea, required: true),
        ],
        statusWorkflow: [
          StatusWorkflow(id: '1', name: 'Pending', color: '#FFA500', order: 0),
          StatusWorkflow(id: '2', name: 'Under Review', color: '#2196F3', order: 1),
          StatusWorkflow(id: '3', name: 'Approved', color: '#4CAF50', order: 2),
          StatusWorkflow(id: '4', name: 'Rejected', color: '#F44336', order: 3),
        ],
      ),
      RequestType(
        id: '2',
        name: 'IT Support',
        description: 'Technical support requests',
        category: 'IT',
        createdBy: 'John Admin',
        createdAt: DateTime.now().subtract(Duration(days: 25)),
        fields: [
          CustomField(id: '1', name: 'Issue Type', type: FieldType.dropdown, 
            options: ['Hardware', 'Software', 'Network', 'Account'], required: true),
          CustomField(id: '2', name: 'Priority', type: FieldType.dropdown, 
            options: ['Low', 'Medium', 'High', 'Critical'], required: true),
          CustomField(id: '3', name: 'Description', type: FieldType.textarea, required: true),
        ],
        statusWorkflow: [
          StatusWorkflow(id: '1', name: 'Open', color: '#FFA500', order: 0),
          StatusWorkflow(id: '2', name: 'In Progress', color: '#2196F3', order: 1),
          StatusWorkflow(id: '3', name: 'Resolved', color: '#4CAF50', order: 2),
          StatusWorkflow(id: '4', name: 'Closed', color: '#9E9E9E', order: 3),
        ],
      ),
    ]);

    // Initialize sample requests
    _requests.addAll([
      Request(
        id: '1',
        typeId: '1',
        typeName: 'Leave Request',
        category: 'HR',
        fieldValues: {
          'Leave Type': 'Annual',
          'Start Date': '2024-03-15',
          'End Date': '2024-03-20',
          'Reason': 'Family vacation',
        },
        status: 'Pending',
        priority: Priority.medium,
        submittedBy: '2',
        submittedAt: DateTime.now().subtract(Duration(days: 2)),
        dueDate: DateTime.now().add(Duration(days: 5)),
        tags: ['vacation', 'family'],
        statusHistory: [
          StatusChangeHistory(
            id: '1',
            fromStatus: '',
            toStatus: 'Pending',
            changedBy: 'Jane User',
            changedAt: DateTime.now().subtract(Duration(days: 2)),
          ),
        ],
      ),
      Request(
        id: '2',
        typeId: '2',
        typeName: 'IT Support',
        category: 'IT',
        fieldValues: {
          'Issue Type': 'Hardware',
          'Priority': 'High',
          'Description': 'Laptop screen is flickering',
        },
        status: 'In Progress',
        priority: Priority.high,
        submittedBy: '2',
        submittedAt: DateTime.now().subtract(Duration(days: 1)),
        assignedAdminId: '1',
        assignedAdminName: 'John Admin',
        tags: ['hardware', 'urgent'],
        statusHistory: [
          StatusChangeHistory(
            id: '2',
            fromStatus: '',
            toStatus: 'Open',
            changedBy: 'Jane User',
            changedAt: DateTime.now().subtract(Duration(days: 1)),
          ),
          StatusChangeHistory(
            id: '3',
            fromStatus: 'Open',
            toStatus: 'In Progress',
            changedBy: 'John Admin',
            changedAt: DateTime.now().subtract(Duration(hours: 4)),
          ),
        ],
      ),
    ]);

    // Initialize sample templates
    _templates.addAll([
      RequestTemplate(
        id: '1',
        name: 'Standard Leave Request',
        description: 'Template for common leave requests',
        typeId: '1',
        predefinedValues: {'Leave Type': 'Annual'},
        createdBy: '1',
        createdAt: DateTime.now().subtract(Duration(days: 10)),
      ),
    ]);

    // Initialize sample comments
    _comments.addAll([
      RequestComment(
        id: '1',
        requestId: '2',
        authorId: '1',
        authorName: 'John Admin',
        content: 'I\'ll look into this hardware issue. Can you bring your laptop to the IT office?',
        createdAt: DateTime.now().subtract(Duration(hours: 3)),
      ),
    ]);
  }

  // Authentication
  Future<User?> validateLogin(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    try {
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password && u.status == UserStatus.active
      );
      
      // Update last login
      final userIndex = _users.indexWhere((u) => u.id == user.id);
      if (userIndex != -1) {
        _users[userIndex] = user.copyWith(lastLoginAt: DateTime.now());
      }
      
      return _users[userIndex];
    } catch (e) {
      return null;
    }
  }

  // Request Types
  Future<List<RequestType>> getRequestTypes() async {
    await Future.delayed(Duration(milliseconds: 300));
    return List.from(_requestTypes.where((type) => type.active));
  }

  Future<RequestType> getRequestTypeById(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _requestTypes.firstWhere((type) => type.id == id);
  }

  Future<RequestType> createRequestType(RequestType requestType) async {
    await Future.delayed(Duration(milliseconds: 500));
    final newType = RequestType(
      id: (++_typeCounter).toString(),
      name: requestType.name,
      description: requestType.description,
      category: requestType.category,
      createdBy: requestType.createdBy,
      createdAt: DateTime.now(),
      fields: requestType.fields,
      statusWorkflow: requestType.statusWorkflow,
    );
    _requestTypes.add(newType);
    return newType;
  }

  // Requests
  Future<List<Request>> getRequests({String? userId, String? assignedAdminId}) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    var filteredRequests = List<Request>.from(_requests);
    
    if (userId != null) {
      filteredRequests = filteredRequests.where((r) => r.submittedBy == userId).toList();
    }
    
    if (assignedAdminId != null) {
      filteredRequests = filteredRequests.where((r) => r.assignedAdminId == assignedAdminId).toList();
    }
    
    return filteredRequests..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
  }

  Future<Request> createRequest(Request request) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final newRequest = Request(
      id: (++_requestCounter).toString(),
      typeId: request.typeId,
      typeName: request.typeName,
      category: request.category,
      fieldValues: request.fieldValues,
      status: 'Pending',
      priority: request.priority,
      submittedBy: request.submittedBy,
      submittedAt: DateTime.now(),
      dueDate: request.dueDate,
      tags: request.tags,
      statusHistory: [
        StatusChangeHistory(
          id: (++_historyCounter).toString(),
          fromStatus: '',
          toStatus: 'Pending',
          changedBy: request.submittedBy,
          changedAt: DateTime.now(),
        ),
      ],
    );
    
    _requests.add(newRequest);
    
    // Send notification to admins
    final adminUsers = _users.where((u) => u.role == UserRole.admin).toList();
    _sendNotificationToUsers(
      adminUsers.map((u) => u.id).toList(),
      'New Request Submitted',
      'A new ${request.typeName} request has been submitted.',
      requestId: newRequest.id,
    );
    
    return newRequest;
  }

  Future<Request> updateRequestStatus(String requestId, String newStatus, 
      {String? adminComments, String? adminName}) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final requestIndex = _requests.indexWhere((r) => r.id == requestId);
    if (requestIndex == -1) {
      throw Exception('Request not found');
    }
    
    final currentRequest = _requests[requestIndex];
    final oldStatus = currentRequest.status;
    
    final updatedHistory = List<StatusChangeHistory>.from(currentRequest.statusHistory);
    updatedHistory.add(
      StatusChangeHistory(
        id: (++_historyCounter).toString(),
        fromStatus: oldStatus,
        toStatus: newStatus,
        changedBy: adminName ?? 'System',
        changedAt: DateTime.now(),
        comments: adminComments,
      ),
    );
    
    _requests[requestIndex] = currentRequest.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
      adminComments: adminComments,
      statusHistory: updatedHistory,
    );
    
    // Send notification to request submitter
    _sendNotificationToUsers(
      [currentRequest.submittedBy],
      'Request Status Updated',
      'Your request status has been changed to $newStatus.',
      requestId: requestId,
    );
    
    return _requests[requestIndex];
  }

  Future<Request> assignRequest(String requestId, String adminId, String adminName) async {
    await Future.delayed(Duration(milliseconds: 300));
    
    final requestIndex = _requests.indexWhere((r) => r.id == requestId);
    if (requestIndex == -1) {
      throw Exception('Request not found');
    }
    
    _requests[requestIndex] = _requests[requestIndex].copyWith(
      assignedAdminId: adminId,
      assignedAdminName: adminName,
      updatedAt: DateTime.now(),
    );
    
    // Send notification to assigned admin
    _sendNotificationToUsers(
      [adminId],
      'Request Assigned',
      'A new request has been assigned to you.',
      requestId: requestId,
    );
    
    return _requests[requestIndex];
  }

  Future<Request> updateRequestPriority(String requestId, Priority priority) async {
    await Future.delayed(Duration(milliseconds: 300));
    
    final requestIndex = _requests.indexWhere((r) => r.id == requestId);
    if (requestIndex == -1) {
      throw Exception('Request not found');
    }
    
    _requests[requestIndex] = _requests[requestIndex].copyWith(
      priority: priority,
      updatedAt: DateTime.now(),
    );
    
    return _requests[requestIndex];
  }

  // Templates
  Future<List<RequestTemplate>> getTemplates({String? typeId}) async {
    await Future.delayed(Duration(milliseconds: 300));
    
    if (typeId != null) {
      return _templates.where((t) => t.typeId == typeId).toList();
    }
    return List.from(_templates);
  }

  Future<RequestTemplate> createTemplate(RequestTemplate template) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final newTemplate = RequestTemplate(
      id: (++_templateCounter).toString(),
      name: template.name,
      description: template.description,
      typeId: template.typeId,
      predefinedValues: template.predefinedValues,
      createdBy: template.createdBy,
      createdAt: DateTime.now(),
    );
    
    _templates.add(newTemplate);
    return newTemplate;
  }

  Future<void> deleteTemplate(String id) async {
    await Future.delayed(Duration(milliseconds: 300));
    _templates.removeWhere((template) => template.id == id);
  }

  // Comments
  Future<List<RequestComment>> getComments(String requestId, {bool includePrivate = false}) async {
    await Future.delayed(Duration(milliseconds: 300));
    
    var comments = _comments.where((c) => c.requestId == requestId).toList();
    
    if (!includePrivate) {
      comments = comments.where((c) => !c.isPrivate).toList();
    }
    
    return comments..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<RequestComment> addComment(RequestComment comment) async {
    await Future.delayed(Duration(milliseconds: 300));
    final newComment = RequestComment(
      id: (++_commentCounter).toString(),
      requestId: comment.requestId,
      authorId: comment.authorId,
      authorName: comment.authorName,
      content: comment.content,
      createdAt: DateTime.now(),
      isPrivate: comment.isPrivate,
    );
    _comments.add(newComment);
    return newComment;
  }

  Future<void> deleteComment(String commentId) async {
    await Future.delayed(Duration(milliseconds: 300));
    _comments.removeWhere((c) => c.id == commentId);
  }

  // Dashboard Analytics
  Future<DashboardStats> getDashboardStats() async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final totalRequests = _requests.length;
    final pendingRequests = _requests.where((r) => 
      r.status.toLowerCase().contains('pending')).length;
    final inProgressRequests = _requests.where((r) => 
      r.status.toLowerCase().contains('review') || 
      r.status.toLowerCase().contains('progress')).length;
    final completedRequests = _requests.where((r) => 
      ['approved', 'completed', 'delivered'].any((s) => r.status.toLowerCase().contains(s))).length;
    final overdueRequests = _requests.where((r) => r.isOverdue).length;
    
    // Group by category
    final requestsByCategory = <String, int>{};
    for (final request in _requests) {
      requestsByCategory[request.category] = 
        (requestsByCategory[request.category] ?? 0) + 1;
    }
    
    // Group by status
    final requestsByStatus = <String, int>{};
    for (final request in _requests) {
      requestsByStatus[request.status] = 
        (requestsByStatus[request.status] ?? 0) + 1;
    }
    
    // Group by priority
    final requestsByPriority = <String, int>{};
    for (final request in _requests) {
      final priority = request.priority.toString().split('.').last;
      requestsByPriority[priority] = 
        (requestsByPriority[priority] ?? 0) + 1;
    }
    
    // Top performers (mock data)
    final topPerformers = [
      TopPerformer(adminId: '1', adminName: 'John Admin', completedRequests: 15),
      TopPerformer(adminId: '3', adminName: 'Mike Manager', completedRequests: 12),
    ];
    
    // Request trends (mock data for last 30 days)
    final trends = <RequestTrend>[];
    for (int i = 29; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final count = Random().nextInt(5) + 1;
      trends.add(RequestTrend(date: date, requestCount: count));
    }
    
    return DashboardStats(
      totalRequests: totalRequests,
      pendingRequests: pendingRequests,
      inProgressRequests: inProgressRequests,
      completedRequests: completedRequests,
      overdueRequests: overdueRequests,
      requestsByCategory: requestsByCategory,
      requestsByStatus: requestsByStatus,
      requestsByPriority: requestsByPriority,
      topPerformers: topPerformers,
      trends: trends,
    );
  }

  // Notifications
  Future<List<AppNotification>> getNotifications(String userId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _notifications
        .where((n) => n.targetUserIds.contains(userId))
        .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = AppNotification(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        type: _notifications[index].type,
        requestId: _notifications[index].requestId,
        targetUserIds: _notifications[index].targetUserIds,
        senderName: _notifications[index].senderName,
        createdAt: _notifications[index].createdAt,
        isRead: true,
      );
    }
  }

  Future<int> getUnreadNotificationCount(String userId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final notifications = await getNotifications(userId);
    return notifications.where((n) => !n.isRead).length;
  }

  // Users
  Future<List<User>> getUsers() async {
    await Future.delayed(Duration(milliseconds: 500));
    return List.from(_users);
  }

  Future<List<User>> getAdminUsers() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _users.where((user) => user.role == UserRole.admin).toList();
  }

  Future<User> createUser(User user) async {
    await Future.delayed(Duration(milliseconds: 500));
    final newUser = User(
      id: (++_userCounter).toString(),
      name: user.name,
      email: user.email,
      password: user.password,
      role: user.role,
      status: user.status,
      createdAt: DateTime.now(),
      profileData: user.profileData,
      permissions: user.permissions,
      department: user.department,
      active: user.active,
    );
    _users.add(newUser);
    return newUser;
  }

  Future<User> updateUser(User user) async {
    await Future.delayed(Duration(milliseconds: 500));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      return user;
    }
    throw Exception('User not found');
  }

  Future<void> deleteUser(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    _users.removeWhere((user) => user.id == id);
  }

  // Search
  Future<List<Request>> searchRequests(String query, {
    String? status,
    Priority? priority,
    String? category,
  }) async {
    await Future.delayed(Duration(milliseconds: 400));
    
    var results = List<Request>.from(_requests);
    
    // Text search
    if (query.isNotEmpty) {
      results = results.where((request) {
        return request.typeName.toLowerCase().contains(query.toLowerCase()) ||
               request.fieldValues.values.any((value) => 
                 value.toString().toLowerCase().contains(query.toLowerCase()));
      }).toList();
    }
    
    // Status filter
    if (status != null && status.isNotEmpty) {
      results = results.where((r) => r.status == status).toList();
    }
    
    // Priority filter
    if (priority != null) {
      results = results.where((r) => r.priority == priority).toList();
    }
    
    // Category filter
    if (category != null && category.isNotEmpty) {
      results = results.where((r) => r.category == category).toList();
    }
    
    return results..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
  }

  // Export functionality (mock)
  Future<String> exportRequestsToExcel(List<Request> requests) async {
    await Future.delayed(Duration(milliseconds: 1000));
    return 'mock://exports/requests_${DateTime.now().millisecondsSinceEpoch}.xlsx';
  }

  Future<String> exportRequestsToPdf(List<Request> requests) async {
    await Future.delayed(Duration(milliseconds: 1000));
    return 'mock://exports/requests_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  // Priority 2 Extensions
  Future<List<ExtendedRequestTemplate>> getExtendedTemplates({String? typeId}) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final extendedTemplates = [
      ExtendedRequestTemplate(
        id: '1',
        name: 'Standard Leave Request',
        description: 'Template for common annual leave requests',
        typeId: '1',
        typeName: 'Leave Request',
        fieldMappings: [
          TemplateFieldMapping(
            fieldId: '1',
            fieldName: 'Leave Type',
            defaultValue: 'Annual',
            isLocked: false,
          ),
          TemplateFieldMapping(
            fieldId: '4',
            fieldName: 'Reason',
            defaultValue: 'Personal time off',
            isLocked: false,
          ),
        ],
        metadata: {'category': 'HR', 'priority': 'standard'},
        createdBy: '1',
        createdByName: 'John Admin',
        createdAt: DateTime.now().subtract(Duration(days: 10)),
        isActive: true,
        tags: ['leave', 'hr', 'standard'],
        usageCount: 25,
      ),
    ];

    if (typeId != null) {
      return extendedTemplates.where((t) => t.typeId == typeId).toList();
    }
    
    return extendedTemplates;
  }

  Future<ExtendedRequestTemplate> createExtendedTemplate(ExtendedRequestTemplate template) async {
    await Future.delayed(Duration(milliseconds: 800));
    
    final newTemplate = ExtendedRequestTemplate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: template.name,
      description: template.description,
      typeId: template.typeId,
      typeName: template.typeName,
      fieldMappings: template.fieldMappings,
      metadata: template.metadata,
      createdBy: template.createdBy,
      createdByName: template.createdByName,
      createdAt: DateTime.now(),
      isActive: true,
      tags: template.tags,
      usageCount: 0,
    );
    
    return newTemplate;
  }

  Future<ExtendedRequestTemplate> updateExtendedTemplate(ExtendedRequestTemplate template) async {
    await Future.delayed(Duration(milliseconds: 600));
    
    return template.copyWith(
      updatedAt: DateTime.now(),
    );
  }

  Future<void> incrementTemplateUsage(String templateId) async {
    await Future.delayed(Duration(milliseconds: 200));
  }

  Future<List<TemplateCategory>> getTemplateCategories() async {
    await Future.delayed(Duration(milliseconds: 300));
    
    return [
      TemplateCategory(
        id: '1',
        name: 'Human Resources',
        description: 'HR-related request templates',
        color: '#2196F3',
        requestTypeIds: ['1'],
      ),
    ];
  }

  Future<List<TemplateUsageStats>> getTemplateUsageStats() async {
    await Future.delayed(Duration(milliseconds: 400));
    
    return [
      TemplateUsageStats(
        templateId: '1',
        templateName: 'Standard Leave Request',
        totalUsage: 25,
        monthlyUsage: 8,
        weeklyUsage: 3,
        lastUsed: DateTime.now().subtract(Duration(hours: 4)),
        topUsers: ['Jane User', 'Mike Chen', 'Sarah Johnson'],
      ),
    ];
  }

  Future<BulkOperationResult> executeBulkOperation(BulkOperationRequest request) async {
    await Future.delayed(Duration(milliseconds: 2000));
    
    final random = Random();
    final successCount = request.targetIds.length - random.nextInt(2);
    final failureCount = request.targetIds.length - successCount;
    
    final errors = <String>[];
    if (failureCount > 0) {
      errors.add('Some items could not be processed due to validation errors');
    }
    
    return BulkOperationResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: request.type,
      totalItems: request.targetIds.length,
      successCount: successCount,
      failureCount: failureCount,
      errors: errors,
      executedAt: DateTime.now(),
      executedBy: request.executedBy,
    );
  }

  // Helper method for sending notifications
  void _sendNotificationToUsers(List<String> userIds, String title, String message, 
      {String? requestId}) {
    final notification = AppNotification(
      id: (++_notificationCounter).toString(),
      title: title,
      message: message,
      requestId: requestId,
      targetUserIds: userIds,
      senderName: 'System',
      createdAt: DateTime.now(),
    );
    _notifications.add(notification);
  }
}