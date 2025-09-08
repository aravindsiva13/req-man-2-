import '../models/template_models.dart';
import 'mock_api_service.dart';

class FileService {
  final MockApiService _apiService = MockApiService();

  Future<List<FileAttachmentExtended>> uploadFiles(
    List<FileAttachmentExtended> files, 
    String requestId,
  ) async {
    // Simulate file upload with progress
    await Future.delayed(const Duration(seconds: 2));
    
    final uploadedFiles = <FileAttachmentExtended>[];
    for (final file in files) {
      final uploadedFile = FileAttachmentExtended(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: file.name,
        type: file.type,
        size: file.size,
        url: 'https://mock-storage.com/files/${DateTime.now().millisecondsSinceEpoch}',
        uploadedAt: DateTime.now(),
        uploadedBy: 'current_user',
        thumbnailUrl: file.isImage ? 'https://mock-storage.com/thumbnails/${DateTime.now().millisecondsSinceEpoch}' : '',
        isImage: file.isImage,
        isDocument: file.isDocument,
        description: file.description,
        tags: file.tags,
      );
      uploadedFiles.add(uploadedFile);
    }
    
    return uploadedFiles;
  }

  Future<void> deleteFile(String fileId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate file deletion
  }

  Future<String> generateDownloadUrl(String fileId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 'https://mock-storage.com/download/$fileId';
  }

  Future<List<FileAttachmentExtended>> getFilesByRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return mock files for demo
    return [
      FileAttachmentExtended(
        id: '1',
        name: 'requirements_document.pdf',
        type: 'application/pdf',
        size: 2 * 1024 * 1024, // 2MB
        url: 'https://mock-storage.com/files/1',
        uploadedAt: DateTime.now().subtract(const Duration(hours: 2)),
        uploadedBy: 'user_123',
        isDocument: true,
        description: 'Project requirements and specifications',
        tags: ['requirements', 'project'],
      ),
      FileAttachmentExtended(
        id: '2',
        name: 'screenshot.png',
        type: 'image/png',
        size: 1024 * 1024, // 1MB
        url: 'https://mock-storage.com/files/2',
        uploadedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        uploadedBy: 'user_123',
        thumbnailUrl: 'https://mock-storage.com/thumbnails/2',
        isImage: true,
        description: 'Error screenshot for reference',
        tags: ['screenshot', 'error'],
      ),
    ];
  }

  bool isImageFile(String fileName) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    final extension = '.${fileName.split('.').last.toLowerCase()}';
    return imageExtensions.contains(extension);
  }

  bool isDocumentFile(String fileName) {
    final docExtensions = ['.pdf', '.doc', '.docx', '.txt', '.rtf', '.odt'];
    final extension = '.${fileName.split('.').last.toLowerCase()}';
    return docExtensions.contains(extension);
  }

  String getFileTypeFromExtension(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf': return 'application/pdf';
      case 'doc': return 'application/msword';
      case 'docx': return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt': return 'text/plain';
      case 'jpg': case 'jpeg': return 'image/jpeg';
      case 'png': return 'image/png';
      case 'gif': return 'image/gif';
      case 'xls': return 'application/vnd.ms-excel';
      case 'xlsx': return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      default: return 'application/octet-stream';
    }
  }

  Future<FileAttachmentExtended> createMockFile(String fileName, int fileSize) async {
    final isImage = isImageFile(fileName);
    final isDoc = isDocumentFile(fileName);
    
    return FileAttachmentExtended(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: fileName,
      type: getFileTypeFromExtension(fileName),
      size: fileSize,
      url: 'https://mock-storage.com/files/${DateTime.now().millisecondsSinceEpoch}',
      uploadedAt: DateTime.now(),
      uploadedBy: 'current_user',
      thumbnailUrl: isImage ? 'https://mock-storage.com/thumbnails/${DateTime.now().millisecondsSinceEpoch}' : '',
      isImage: isImage,
      isDocument: isDoc,
    );
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  Future<bool> validateFile(FileAttachmentExtended file, {
    int maxSize = 10 * 1024 * 1024, // 10MB
    List<String> allowedTypes = const ['.pdf', '.doc', '.docx', '.txt', '.jpg', '.png'],
  }) async {
    // Size validation
    if (file.size > maxSize) return false;
    
    // Type validation
    final extension = '.${file.name.split('.').last.toLowerCase()}';
    return allowedTypes.contains(extension);
  }
}