import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../viewmodels/admin_viewmodel.dart';

class RequestManagementDialog extends StatefulWidget {
  final Request request;

  const RequestManagementDialog({Key? key, required this.request}) : super(key: key);

  @override
  _RequestManagementDialogState createState() => _RequestManagementDialogState();
}

class _RequestManagementDialogState extends State<RequestManagementDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _commentsController = TextEditingController();
  String? _selectedStatus;
  Priority? _selectedPriority;
  String? _selectedAdminId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedStatus = widget.request.status;
    _selectedPriority = widget.request.priority;
    _selectedAdminId = widget.request.assignedAdminId;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.assignment, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage Request #${widget.request.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.request.typeName} - ${widget.request.category}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Tabs
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(icon: Icon(Icons.settings), text: 'Actions'),
                Tab(icon: Icon(Icons.info), text: 'Details'),
                Tab(icon: Icon(Icons.comment), text: 'Comments'),
              ],
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActionsTab(),
                  _buildDetailsTab(),
                  _buildCommentsTab(),
                ],
              ),
            ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsTab() {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Update Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.track_changes, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Status Management',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flag),
                        ),
                        value: _selectedStatus,
                        items: _getAvailableStatuses().map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(status),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Priority Update Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.priority_high, color: Colors.orange),
                          const SizedBox(width: 8),
                          const Text(
                            'Priority Management',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<Priority>(
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flag),
                        ),
                        value: _selectedPriority,
                        items: Priority.values.map((priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  color: _getPriorityColor(priority),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(priority.toString().split('.').last.toUpperCase()),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Assignment Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_add, color: Colors.green),
                          const SizedBox(width: 8),
                          const Text(
                            'Assignment',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Assign to Admin',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        value: _selectedAdminId,
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Unassigned'),
                          ),
                          ...adminViewModel.adminUsers.map((admin) {
                            return DropdownMenuItem<String>(
                              value: admin.id,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    child: Text(
                                      admin.name.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(admin.name),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedAdminId = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Comments Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.note_add, color: Colors.purple),
                          const SizedBox(width: 8),
                          const Text(
                            'Admin Comments',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _commentsController,
                        decoration: const InputDecoration(
                          labelText: 'Add comments (optional)',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.comment),
                        ),
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Request Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Request ID', '#${widget.request.id}'),
                  _buildInfoRow('Type', widget.request.typeName),
                  _buildInfoRow('Category', widget.request.category),
                  _buildInfoRow('Current Status', widget.request.status),
                  _buildInfoRow('Priority', widget.request.priority.toString().split('.').last.toUpperCase()),
                  _buildInfoRow('Submitted', _formatDateTime(widget.request.submittedAt)),
                  if (widget.request.dueDate != null)
                    _buildInfoRow('Due Date', _formatDate(widget.request.dueDate!)),
                  if (widget.request.assignedAdminName != null)
                    _buildInfoRow('Assigned To', widget.request.assignedAdminName!),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Field Values Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...widget.request.fieldValues.entries.map((entry) {
                    return _buildInfoRow(
                      _getFieldDisplayName(entry.key),
                      entry.value.toString(),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          // Tags Card
          if (widget.request.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tags',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: widget.request.tags.map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.blue.shade50,
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
          
          // Status History Card
          if (widget.request.statusHistory.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status History',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...widget.request.statusHistory.map((history) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_right, color: Colors.grey, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black87),
                                  children: [
                                    if (history.fromStatus.isNotEmpty) ...[
                                      TextSpan(text: history.fromStatus),
                                      const TextSpan(text: ' → '),
                                    ],
                                    TextSpan(
                                      text: history.toStatus,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: ' by ${history.changedBy}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              _formatDateTime(history.changedAt),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Add Comment Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Comment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _commentsController,
                    decoration: const InputDecoration(
                      labelText: 'Write your comment...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _addComment,
                      icon: const Icon(Icons.send),
                      label: const Text('Add Comment'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Comments List
          Expanded(
            child: Card(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.comment, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Comments',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<RequestComment>>(
                      future: _loadComments(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.comment_outlined, size: 48, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('No comments yet', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          );
                        }
                        
                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final comment = snapshot.data![index];
                            return _buildCommentItem(comment);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildCommentItem(RequestComment comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              child: Text(
                comment.authorName.substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.authorName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _formatDateTime(comment.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(comment.content),
        ),
      ],
    );
  }

  List<String> _getAvailableStatuses() {
    return [
      'Pending',
      'Under Review',
      'In Progress',
      'Approved',
      'Completed',
      'Rejected',
      'On Hold',
    ];
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'under review':
      case 'in progress':
        return Colors.blue;
      case 'approved':
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'on hold':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
      case Priority.urgent:
        return Colors.purple;
    }
  }

  String _getFieldDisplayName(String fieldId) {
    return fieldId.replaceAll('_', ' ').split(' ').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<List<RequestComment>> _loadComments() async {
    try {
      final adminViewModel = context.read<AdminViewModel>();
      return await adminViewModel.getRequestComments(widget.request.id);
    } catch (e) {
      return [];
    }
  }

  Future<void> _addComment() async {
    if (_commentsController.text.trim().isEmpty) return;
    
    try {
      final adminViewModel = context.read<AdminViewModel>();
      await adminViewModel.addRequestComment(
        widget.request.id,
        _commentsController.text.trim(),
        '1', // Current admin ID - should come from auth context
        'Admin', // Current admin name - should come from auth context
      );
      
      _commentsController.clear();
      setState(() {}); // Refresh comments
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $e')),
      );
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final adminViewModel = context.read<AdminViewModel>();
      bool hasChanges = false;
      
      // Update status if changed
      if (_selectedStatus != widget.request.status) {
        await adminViewModel.updateRequestStatus(
          widget.request.id,
          _selectedStatus!,
          comments: _commentsController.text.trim().isNotEmpty 
              ? _commentsController.text.trim() 
              : null,
        );
        hasChanges = true;
      }
      
      // Update priority if changed
      if (_selectedPriority != widget.request.priority) {
        await adminViewModel.updateRequestPriority(widget.request.id, _selectedPriority!);
        hasChanges = true;
      }
      
      // Update assignment if changed
      if (_selectedAdminId != widget.request.assignedAdminId) {
        final selectedAdmin = _selectedAdminId != null
            ? adminViewModel.adminUsers.firstWhere((admin) => admin.id == _selectedAdminId)
            : null;
        await adminViewModel.assignRequest(
          widget.request.id,
          _selectedAdminId ?? '',
          selectedAdmin?.name ?? '',
        );
        hasChanges = true;
      }
      
      if (hasChanges) {
        Navigator.pop(context, true); // Return true to indicate changes were made
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request updated successfully')),
        );
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update request: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}