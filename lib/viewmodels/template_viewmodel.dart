import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/template_models.dart';
import '../services/mock_api_service.dart';

class TemplateViewModel extends ChangeNotifier {
  final MockApiService _apiService = MockApiService();
  
  // Template Management
  List<ExtendedRequestTemplate> _templates = [];
  List<TemplateCategory> _categories = [];
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  
  // Template Designer State
  ExtendedRequestTemplate? _currentTemplate;
  RequestType? _selectedRequestType;
  List<TemplateFieldMapping> _fieldMappings = [];
  
  // Bulk Operations
  List<String> _selectedTemplateIds = [];
  bool _isBulkOperating = false;
  BulkOperationResult? _lastBulkResult;
  
  // Analytics
  List<TemplateUsageStats> _usageStats = [];
  bool _isLoadingStats = false;
  
  // Error handling
  String? _errorMessage;

  // Getters
  List<ExtendedRequestTemplate> get templates => _templates;
  List<ExtendedRequestTemplate> get activeTemplates => 
    _templates.where((t) => t.isActive).toList();
  List<TemplateCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  
  ExtendedRequestTemplate? get currentTemplate => _currentTemplate;
  RequestType? get selectedRequestType => _selectedRequestType;
  List<TemplateFieldMapping> get fieldMappings => _fieldMappings;
  
  List<String> get selectedTemplateIds => _selectedTemplateIds;
  bool get isBulkOperating => _isBulkOperating;
  BulkOperationResult? get lastBulkResult => _lastBulkResult;
  
  List<TemplateUsageStats> get usageStats => _usageStats;
  bool get isLoadingStats => _isLoadingStats;
  String? get errorMessage => _errorMessage;

  // Template CRUD Operations
  Future<void> loadTemplates() async {
    _setLoading(true);
    try {
      final templates = await _apiService.getExtendedTemplates();
      _templates = templates;
      _setError(null);
    } catch (e) {
      _setError('Failed to load templates: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTemplatesByType(String typeId) async {
    _setLoading(true);
    try {
      final templates = await _apiService.getExtendedTemplates(typeId: typeId);
      _templates = templates;
      _setError(null);
    } catch (e) {
      _setError('Failed to load templates: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createTemplate(ExtendedRequestTemplate template) async {
    _setCreating(true);
    try {
      final newTemplate = await _apiService.createExtendedTemplate(template);
      _templates.insert(0, newTemplate);
      _clearDesigner();
      _setError(null);
      return true;
    } catch (e) {
      _setError('Failed to create template: $e');
      return false;
    } finally {
      _setCreating(false);
    }
  }

  Future<bool> updateTemplate(ExtendedRequestTemplate template) async {
    _setUpdating(true);
    try {
      final updatedTemplate = await _apiService.updateExtendedTemplate(template);
      final index = _templates.indexWhere((t) => t.id == template.id);
      if (index != -1) {
        _templates[index] = updatedTemplate;
      }
      _setError(null);
      return true;
    } catch (e) {
      _setError('Failed to update template: $e');
      return false;
    } finally {
      _setUpdating(false);
    }
  }

  Future<bool> deleteTemplate(String templateId) async {
    try {
      await _apiService.deleteTemplate(templateId);
      _templates.removeWhere((t) => t.id == templateId);
      _setError(null);
      return true;
    } catch (e) {
      _setError('Failed to delete template: $e');
      return false;
    }
  }

  Future<bool> toggleTemplateStatus(String templateId) async {
    try {
      final template = _templates.firstWhere((t) => t.id == templateId);
      final updatedTemplate = template.copyWith(isActive: !template.isActive);
      return await updateTemplate(updatedTemplate);
    } catch (e) {
      _setError('Failed to toggle template status: $e');
      return false;
    }
  }

  // Template Designer Operations
  void initializeDesigner(RequestType requestType, {ExtendedRequestTemplate? existingTemplate}) {
    _selectedRequestType = requestType;
    _currentTemplate = existingTemplate;
    
    if (existingTemplate != null) {
      _fieldMappings = List.from(existingTemplate.fieldMappings);
    } else {
      _fieldMappings = requestType.fields.map((field) => 
        TemplateFieldMapping(
          fieldId: field.id,
          fieldName: field.name,
        )
      ).toList();
    }
    notifyListeners();
  }

  void updateFieldMapping(String fieldId, dynamic defaultValue, {bool? isLocked}) {
    final index = _fieldMappings.indexWhere((m) => m.fieldId == fieldId);
    if (index != -1) {
      _fieldMappings[index] = _fieldMappings[index].copyWith(
        defaultValue: defaultValue,
        isLocked: isLocked,
      );
      notifyListeners();
    }
  }

  void removeFieldMapping(String fieldId) {
    _fieldMappings.removeWhere((m) => m.fieldId == fieldId);
    notifyListeners();
  }

  void addCustomValidation(String fieldId, String rule) {
    final index = _fieldMappings.indexWhere((m) => m.fieldId == fieldId);
    if (index != -1) {
      _fieldMappings[index] = _fieldMappings[index].copyWith(validationRule: rule);
      notifyListeners();
    }
  }

  void _clearDesigner() {
    _currentTemplate = null;
    _selectedRequestType = null;
    _fieldMappings.clear();
    notifyListeners();
  }

  // Validation
  bool validateTemplate(String name, String description) {
    if (name.trim().isEmpty) {
      _setError('Template name is required');
      return false;
    }
    if (description.trim().isEmpty) {
      _setError('Template description is required');
      return false;
    }
    if (_fieldMappings.isEmpty) {
      _setError('At least one field mapping is required');
      return false;
    }
    return true;
  }

  // Categories
  Future<void> loadCategories() async {
    try {
      _categories = await _apiService.getTemplateCategories();
      _setError(null);
    } catch (e) {
      _setError('Failed to load categories: $e');
    }
  }

  // Bulk Operations
  void toggleTemplateSelection(String templateId) {
    if (_selectedTemplateIds.contains(templateId)) {
      _selectedTemplateIds.remove(templateId);
    } else {
      _selectedTemplateIds.add(templateId);
    }
    notifyListeners();
  }

  void selectAllTemplates() {
    _selectedTemplateIds = _templates.map((t) => t.id).toList();
    notifyListeners();
  }

  void clearSelection() {
    _selectedTemplateIds.clear();
    notifyListeners();
  }

  Future<bool> executeBulkOperation(BulkOperationType type, Map<String, dynamic> parameters) async {
    if (_selectedTemplateIds.isEmpty) {
      _setError('No templates selected');
      return false;
    }

    _setBulkOperating(true);
    try {
      final request = BulkOperationRequest(
        type: type,
        targetIds: List.from(_selectedTemplateIds),
        parameters: parameters,
        executedBy: 'current_user', // Should be passed from auth
      );
      
      _lastBulkResult = await _apiService.executeBulkOperation(request);
      
      // Refresh templates after bulk operation
      await loadTemplates();
      clearSelection();
      
      _setError(null);
      return _lastBulkResult!.isCompleteSuccess;
    } catch (e) {
      _setError('Bulk operation failed: $e');
      return false;
    } finally {
      _setBulkOperating(false);
    }
  }

  // Analytics
  Future<void> loadUsageStats() async {
    _setLoadingStats(true);
    try {
      _usageStats = await _apiService.getTemplateUsageStats();
      _setError(null);
    } catch (e) {
      _setError('Failed to load usage statistics: $e');
    } finally {
      _setLoadingStats(false);
    }
  }

  // Search and Filter
  List<ExtendedRequestTemplate> searchTemplates(String query) {
    if (query.isEmpty) return _templates;
    
    return _templates.where((template) {
      return template.name.toLowerCase().contains(query.toLowerCase()) ||
             template.description.toLowerCase().contains(query.toLowerCase()) ||
             template.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  List<ExtendedRequestTemplate> filterByCategory(String category) {
    if (category.isEmpty) return _templates;
    return _templates.where((t) => t.typeName == category).toList();
  }

  List<ExtendedRequestTemplate> filterByUsage(int minUsage) {
    return _templates.where((t) => t.usageCount >= minUsage).toList();
  }

  // Utility Methods
  Future<void> incrementUsageCount(String templateId) async {
    try {
      await _apiService.incrementTemplateUsage(templateId);
      final index = _templates.indexWhere((t) => t.id == templateId);
      if (index != -1) {
        _templates[index] = _templates[index].copyWith(
          usageCount: _templates[index].usageCount + 1
        );
        notifyListeners();
      }
    } catch (e) {
      // Silent failure for usage tracking
    }
  }

  ExtendedRequestTemplate? getTemplateById(String id) {
    try {
      return _templates.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ExtendedRequestTemplate> getPopularTemplates({int limit = 5}) {
    final sorted = List<ExtendedRequestTemplate>.from(_templates);
    sorted.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return sorted.take(limit).toList();
  }

  List<ExtendedRequestTemplate> getRecentTemplates({int limit = 5}) {
    final sorted = List<ExtendedRequestTemplate>.from(_templates);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }

  // State Management
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setCreating(bool creating) {
    _isCreating = creating;
    notifyListeners();
  }

  void _setUpdating(bool updating) {
    _isUpdating = updating;
    notifyListeners();
  }

  void _setBulkOperating(bool operating) {
    _isBulkOperating = operating;
    notifyListeners();
  }

  void _setLoadingStats(bool loading) {
    _isLoadingStats = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}