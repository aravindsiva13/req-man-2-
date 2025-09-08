import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:req_mvvm/models/template_models.dart';
import 'package:req_mvvm/services/mock_api_service.dart';


// File Upload Widget with Drag & Drop
class FileUploadWidget extends StatefulWidget {
  final Function(List<FileAttachmentExtended>) onFilesSelected;
  final List<String> allowedExtensions;
  final int maxFileSize; // in bytes
  final int maxFiles;
  final bool showPreview;

  const FileUploadWidget({
    Key? key,
    required this.onFilesSelected,
    this.allowedExtensions = const ['.pdf', '.doc', '.docx', '.txt', '.jpg', '.png'],
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.maxFiles = 5,
    this.showPreview = true,
  }) : super(key: key);

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  final List<FileAttachmentExtended> _selectedFiles = [];
  bool _isDragOver = false;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload Area
        GestureDetector(
          onTap: _pickFiles,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: _isDragOver ? Colors.blue : Colors.grey.shade300,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
              color: _isDragOver ? Colors.blue.shade50 : Colors.grey.shade50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload,
                  size: 48,
                  color: _isDragOver ? Colors.blue : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  'Drop files here or click to browse',
                  style: TextStyle(
                    color: _isDragOver ? Colors.blue : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Max ${widget.maxFiles} files, ${_formatFileSize(widget.maxFileSize)} each',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Allowed: ${widget.allowedExtensions.join(', ')}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        
        // File List
        if (_selectedFiles.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Selected Files:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...(_selectedFiles.map((file) => _buildFileItem(file))),
        ],
        
        // Upload Progress
        if (_isUploading) ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          const Text('Uploading files...', style: TextStyle(color: Colors.blue)),
        ],
      ],
    );
  }

  Widget _buildFileItem(FileAttachmentExtended file) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getFileTypeColor(file.type),
          child: Icon(
            _getFileTypeIcon(file.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(file.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(file.formattedSize),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (file.isImage && widget.showPreview)
              IconButton(
                icon: const Icon(Icons.preview),
                onPressed: () => _previewFile(file),
              ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => _removeFile(file),
            ),
          ],
        ),
      ),
    );
  }

  void _pickFiles() async {
    // Simulate file picker
    try {
      final files = await _simulateFilePicker();
      for (final file in files) {
        if (_validateFile(file)) {
          setState(() {
            _selectedFiles.add(file);
          });
        }
      }
      widget.onFilesSelected(_selectedFiles);
    } catch (e) {
      _showError('Failed to select files: $e');
    }
  }

  Future<List<FileAttachmentExtended>> _simulateFilePicker() async {
    // Simulate file selection - in real app, use file_picker package
    await Future.delayed(const Duration(milliseconds: 500));
    
    final mockFiles = [
      FileAttachmentExtended(
        id: '1',
        name: 'document.pdf',
        type: 'application/pdf',
        size: 1024 * 1024, // 1MB
        url: 'mock://files/document.pdf',
        uploadedAt: DateTime.now(),
        uploadedBy: 'current_user',
        isDocument: true,
        thumbnailUrl: 'mock://thumbnails/document.pdf',
      ),
      FileAttachmentExtended(
        id: '2',
        name: 'image.jpg',
        type: 'image/jpeg',
        size: 512 * 1024, // 512KB
        url: 'mock://files/image.jpg',
        uploadedAt: DateTime.now(),
        uploadedBy: 'current_user',
        isImage: true,
        thumbnailUrl: 'mock://thumbnails/image.jpg',
      ),
    ];
    
    return [mockFiles.first]; // Return one random file
  }

  bool _validateFile(FileAttachmentExtended file) {
    // Check file count
    if (_selectedFiles.length >= widget.maxFiles) {
      _showError('Maximum ${widget.maxFiles} files allowed');
      return false;
    }
    
    // Check file size
    if (file.size > widget.maxFileSize) {
      _showError('File ${file.name} is too large (max ${_formatFileSize(widget.maxFileSize)})');
      return false;
    }
    
    // Check file extension
    final extension = '.${file.name.split('.').last.toLowerCase()}';
    if (!widget.allowedExtensions.contains(extension)) {
      _showError('File type $extension is not allowed');
      return false;
    }
    
    // Check for duplicates
    if (_selectedFiles.any((f) => f.name == file.name)) {
      _showError('File ${file.name} already selected');
      return false;
    }
    
    return true;
  }

  void _removeFile(FileAttachmentExtended file) {
    setState(() {
      _selectedFiles.remove(file);
    });
    widget.onFilesSelected(_selectedFiles);
  }

  void _previewFile(FileAttachmentExtended file) {
    showDialog(
      context: context,
      builder: (context) => FilePreviewDialog(file: file),
    );
  }

  IconData _getFileTypeIcon(String type) {
    if (type.startsWith('image/')) return Icons.image;
    if (type.contains('pdf')) return Icons.picture_as_pdf;
    if (type.contains('word') || type.contains('doc')) return Icons.description;
    if (type.contains('excel') || type.contains('sheet')) return Icons.table_chart;
    if (type.contains('text')) return Icons.text_snippet;
    return Icons.insert_drive_file;
  }

  Color _getFileTypeColor(String type) {
    if (type.startsWith('image/')) return Colors.green;
    if (type.contains('pdf')) return Colors.red;
    if (type.contains('word') || type.contains('doc')) return Colors.blue;
    if (type.contains('excel') || type.contains('sheet')) return Colors.orange;
    if (type.contains('text')) return Colors.purple;
    return Colors.grey;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

// File Preview Dialog
class FilePreviewDialog extends StatelessWidget {
  final FileAttachmentExtended file;

  const FilePreviewDialog({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Row(
                children: [
                  Icon(_getFileTypeIcon(file.type), color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${file.formattedSize} • ${file.type}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _buildPreviewContent(),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _downloadFile(context),
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                  const SizedBox(width: 16),
                  if (file.isImage)
                    ElevatedButton.icon(
                      onPressed: () => _showFullScreen(context),
                      icon: const Icon(Icons.fullscreen),
                      label: const Text('Full Screen'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (file.isImage) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Image.network(
            file.url,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image, size: 64, color: Colors.grey),
                const SizedBox(height: 8),
                Text('Could not load image', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getFileTypeIcon(file.type),
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Preview not available for this file type',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Download the file to view its contents',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  IconData _getFileTypeIcon(String type) {
    if (type.startsWith('image/')) return Icons.image;
    if (type.contains('pdf')) return Icons.picture_as_pdf;
    if (type.contains('word') || type.contains('doc')) return Icons.description;
    if (type.contains('excel') || type.contains('sheet')) return Icons.table_chart;
    if (type.contains('text')) return Icons.text_snippet;
    return Icons.insert_drive_file;
  }

  void _downloadFile(BuildContext context) {
    // Simulate download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${file.name}...')),
    );
  }

  void _showFullScreen(BuildContext context) {
    if (!file.isImage) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(file: file),
      ),
    );
  }
}

// Full Screen Image Viewer
class FullScreenImageViewer extends StatelessWidget {
  final FileAttachmentExtended file;

  const FullScreenImageViewer({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          file.name,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _downloadFile(context),
            icon: const Icon(Icons.download, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            file.url,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 64, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Could not load image',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _downloadFile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${file.name}...')),
    );
  }
}

// Attachment List Widget for displaying existing files
class AttachmentListWidget extends StatelessWidget {
  final List<FileAttachmentExtended> attachments;
  final bool showActions;
  final Function(FileAttachmentExtended)? onDelete;

  const AttachmentListWidget({
    Key? key,
    required this.attachments,
    this.showActions = true,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.attach_file, color: Colors.grey[400]),
            const SizedBox(width: 8),
            Text(
              'No attachments',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments (${attachments.length})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...attachments.map((attachment) => AttachmentTile(
          attachment: attachment,
          showActions: showActions,
          onDelete: onDelete,
        )),
      ],
    );
  }
}

class AttachmentTile extends StatelessWidget {
  final FileAttachmentExtended attachment;
  final bool showActions;
  final Function(FileAttachmentExtended)? onDelete;

  const AttachmentTile({
    Key? key,
    required this.attachment,
    this.showActions = true,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: _getFileTypeColor(attachment.type),
              child: Icon(
                _getFileTypeIcon(attachment.type),
                color: Colors.white,
                size: 20,
              ),
            ),
            if (attachment.isImage)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 8,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          attachment.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${attachment.formattedSize} • ${attachment.type}'),
            if (attachment.description != null) ...[
              const SizedBox(height: 2),
              Text(
                attachment.description!,
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
            if (attachment.tags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: attachment.tags.map((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(fontSize: 9, color: Colors.blue.shade800),
                  ),
                )).toList(),
              ),
            ],
          ],
        ),
        trailing: showActions
            ? PopupMenuButton<String>(
                onSelected: (value) => _handleAction(context, value),
                itemBuilder: (context) => [
                  if (attachment.isImage)
                    const PopupMenuItem(value: 'preview', child: Text('Preview')),
                  const PopupMenuItem(value: 'download', child: Text('Download')),
                  const PopupMenuItem(value: 'copy_link', child: Text('Copy Link')),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                ],
              )
            : null,
        onTap: () => _previewFile(context),
      ),
    );
  }

  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'preview':
        _previewFile(context);
        break;
      case 'download':
        _downloadFile(context);
        break;
      case 'copy_link':
        _copyLink(context);
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _previewFile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FilePreviewDialog(file: attachment),
    );
  }

  void _downloadFile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${attachment.name}...')),
    );
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: attachment.url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard')),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    if (onDelete == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Attachment'),
        content: Text('Are you sure you want to delete "${attachment.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete!(attachment);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  IconData _getFileTypeIcon(String type) {
    if (type.startsWith('image/')) return Icons.image;
    if (type.contains('pdf')) return Icons.picture_as_pdf;
    if (type.contains('word') || type.contains('doc')) return Icons.description;
    if (type.contains('excel') || type.contains('sheet')) return Icons.table_chart;
    if (type.contains('text')) return Icons.text_snippet;
    return Icons.insert_drive_file;
  }

  Color _getFileTypeColor(String type) {
    if (type.startsWith('image/')) return Colors.green;
    if (type.contains('pdf')) return Colors.red;
    if (type.contains('word') || type.contains('doc')) return Colors.blue;
    if (type.contains('excel') || type.contains('sheet')) return Colors.orange;
    if (type.contains('text')) return Colors.purple;
    return Colors.grey;
  }
}

// File Service for handling file operations
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
        url: 'https://mock-storage.com/files/${file.id}',
        uploadedAt: DateTime.now(),
        uploadedBy: 'current_user',
        thumbnailUrl: file.isImage ? 'https://mock-storage.com/thumbnails/${file.id}' : '',
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
}

// File Upload Progress Widget
class FileUploadProgress extends StatelessWidget {
  final String fileName;
  final double progress;
  final bool isCompleted;
  final String? error;

  const FileUploadProgress({
    Key? key,
    required this.fileName,
    required this.progress,
    this.isCompleted = false,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCompleted 
                      ? Icons.check_circle 
                      : error != null 
                          ? Icons.error 
                          : Icons.upload_file,
                  color: isCompleted 
                      ? Colors.green 
                      : error != null 
                          ? Colors.red 
                          : Colors.blue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fileName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  isCompleted 
                      ? 'Complete' 
                      : error != null 
                          ? 'Failed' 
                          : '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: isCompleted 
                        ? Colors.green 
                        : error != null 
                            ? Colors.red 
                            : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!isCompleted && error == null)
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
              ),
            if (error != null) ...[
              const SizedBox(height: 4),
              Text(
                error!,
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}