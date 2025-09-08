// Template-specific models for the Request Management System

// Template Field Mapping Model
import 'package:req_mvvm/models/models.dart';

class TemplateFieldMapping {
  final String fieldId;
  final String fieldName;
  final dynamic defaultValue;
  final bool isLocked; // Cannot be changed when using template
  final String? validationRule;

  TemplateFieldMapping({
    required this.fieldId,
    required this.fieldName,
    this.defaultValue,
    this.isLocked = false,
    this.validationRule,
  });

  TemplateFieldMapping copyWith({
    String? fieldId,
    String? fieldName,
    dynamic defaultValue,
    bool? isLocked,
    String? validationRule,
  }) {
    return TemplateFieldMapping(
      fieldId: fieldId ?? this.fieldId,
      fieldName: fieldName ?? this.fieldName,
      defaultValue: defaultValue ?? this.defaultValue,
      isLocked: isLocked ?? this.isLocked,
      validationRule: validationRule ?? this.validationRule,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldId': fieldId,
      'fieldName': fieldName,
      'defaultValue': defaultValue,
      'isLocked': isLocked,
      'validationRule': validationRule,
    };
  }

  factory TemplateFieldMapping.fromJson(Map<String, dynamic> json) {
    return TemplateFieldMapping(
      fieldId: json['fieldId'],
      fieldName: json['fieldName'],
      defaultValue: json['defaultValue'],
      isLocked: json['isLocked'] ?? false,
      validationRule: json['validationRule'],
    );
  }
}

// Extended Template Model
class ExtendedRequestTemplate {
  final String id;
  final String name;
  final String description;
  final String typeId;
  final String typeName;
  final List<TemplateFieldMapping> fieldMappings;
  final Map<String, dynamic> metadata;
  final String createdBy;
  final String createdByName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final List<String> tags;
  final int usageCount;

  ExtendedRequestTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.typeId,
    required this.typeName,
    required this.fieldMappings,
    this.metadata = const {},
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.tags = const [],
    this.usageCount = 0,
  });

  ExtendedRequestTemplate copyWith({
    String? name,
    String? description,
    List<TemplateFieldMapping>? fieldMappings,
    Map<String, dynamic>? metadata,
    DateTime? updatedAt,
    bool? isActive,
    List<String>? tags,
    int? usageCount,
  }) {
    return ExtendedRequestTemplate(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      typeId: this.typeId,
      typeName: this.typeName,
      fieldMappings: fieldMappings ?? this.fieldMappings,
      metadata: metadata ?? this.metadata,
      createdBy: this.createdBy,
      createdByName: this.createdByName,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      tags: tags ?? this.tags,
      usageCount: usageCount ?? this.usageCount,
    );
  }

  // Get predefined values for compatibility with existing RequestTemplate
  Map<String, dynamic> get predefinedValues {
    final Map<String, dynamic> values = {};
    for (final mapping in fieldMappings) {
      if (mapping.defaultValue != null) {
        values[mapping.fieldId] = mapping.defaultValue;
      }
    }
    return values;
  }
}

// Template Category Model
class TemplateCategory {
  final String id;
  final String name;
  final String description;
  final String color;
  final List<String> requestTypeIds;

  TemplateCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    this.requestTypeIds = const [],
  });
}

// Template Usage Statistics
class TemplateUsageStats {
  final String templateId;
  final String templateName;
  final int totalUsage;
  final int monthlyUsage;
  final int weeklyUsage;
  final DateTime lastUsed;
  final List<String> topUsers;

  TemplateUsageStats({
    required this.templateId,
    required this.templateName,
    required this.totalUsage,
    required this.monthlyUsage,
    required this.weeklyUsage,
    required this.lastUsed,
    this.topUsers = const [],
  });
}

// File Attachment Model (Enhanced)
class FileAttachmentExtended extends FileAttachment {
  final String thumbnailUrl;
  final bool isImage;
  final bool isDocument;
  final String? description;
  final List<String> tags;

  FileAttachmentExtended({
    required String id,
    required String name,
    required String type,
    required int size,
    required String url,
    required DateTime uploadedAt,
    required String uploadedBy,
    this.thumbnailUrl = '',
    this.isImage = false,
    this.isDocument = false,
    this.description,
    this.tags = const [],
  }) : super(
          id: id,
          name: name,
          type: type,
          size: size,
          url: url,
          uploadedAt: uploadedAt,
          uploadedBy: uploadedBy,
        );

  String get formattedSize {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}

// Bulk Operation Models
enum BulkOperationType {
  updateStatus,
  assignRequests,
  updatePriority,
  addTags,
  removeTags,
  delete,
  export,
}

class BulkOperationRequest {
  final BulkOperationType type;
  final List<String> targetIds;
  final Map<String, dynamic> parameters;
  final String executedBy;

  BulkOperationRequest({
    required this.type,
    required this.targetIds,
    required this.parameters,
    required this.executedBy,
  });
}

class BulkOperationResult {
  final String id;
  final BulkOperationType type;
  final int totalItems;
  final int successCount;
  final int failureCount;
  final List<String> errors;
  final DateTime executedAt;
  final String executedBy;

  BulkOperationResult({
    required this.id,
    required this.type,
    required this.totalItems,
    required this.successCount,
    required this.failureCount,
    this.errors = const [],
    required this.executedAt,
    required this.executedBy,
  });

  bool get isCompleteSuccess => failureCount == 0;
  bool get isPartialSuccess => successCount > 0 && failureCount > 0;
  bool get isCompleteFailure => successCount == 0;
}

// Edit History Model
class EditHistory {
  final String id;
  final String entityType; // 'user', 'request_type', 'template', etc.
  final String entityId;
  final String fieldName;
  final dynamic oldValue;
  final dynamic newValue;
  final String editedBy;
  final String editedByName;
  final DateTime editedAt;
  final String? reason;

  EditHistory({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.fieldName,
    this.oldValue,
    this.newValue,
    required this.editedBy,
    required this.editedByName,
    required this.editedAt,
    this.reason,
  });
}

// Advanced Analytics Models
class AnalyticsTimeframe {
  final DateTime startDate;
  final DateTime endDate;
  final String label;

  AnalyticsTimeframe({
    required this.startDate,
    required this.endDate,
    required this.label,
  });
}

class RequestTrendExtended {
  final DateTime date;
  final int requestCount;
  final int completedCount;
  final int pendingCount;
  final int rejectedCount;
  final double avgResolutionTime;

  RequestTrendExtended({
    required this.date,
    required this.requestCount,
    required this.completedCount,
    required this.pendingCount,
    required this.rejectedCount,
    required this.avgResolutionTime,
  });
}

class CategoryPerformance {
  final String category;
  final int totalRequests;
  final int completedRequests;
  final double completionRate;
  final double avgResolutionDays;
  final List<String> topIssues;

  CategoryPerformance({
    required this.category,
    required this.totalRequests,
    required this.completedRequests,
    required this.completionRate,
    required this.avgResolutionDays,
    this.topIssues = const [],
  });
}

class UserProductivity {
  final String userId;
  final String userName;
  final String department;
  final int requestsSubmitted;
  final int requestsCompleted;
  final double avgResponseTime;
  final int templatesCreated;

  UserProductivity({
    required this.userId,
    required this.userName,
    required this.department,
    required this.requestsSubmitted,
    required this.requestsCompleted,
    required this.avgResponseTime,
    required this.templatesCreated,
  });
}

// System Settings Model
class SystemSettings {
  final String id;
  final String organizationName;
  final String primaryColor;
  final String logoUrl;
  final Map<String, bool> featureFlags;
  final Map<String, dynamic> configurations;
  final DateTime lastUpdated;
  final String updatedBy;

  SystemSettings({
    required this.id,
    required this.organizationName,
    required this.primaryColor,
    required this.logoUrl,
    required this.featureFlags,
    required this.configurations,
    required this.lastUpdated,
    required this.updatedBy,
  });
}