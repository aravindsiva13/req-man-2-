import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:req_mvvm/models/models.dart';
import 'package:req_mvvm/models/template_models.dart';
import 'package:req_mvvm/viewmodels/admin_viewmodel.dart';
import 'package:req_mvvm/viewmodels/template_viewmodel.dart';

// Edit User Dialog
class EditUserDialog extends StatefulWidget {
  final User user;

  const EditUserDialog({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _departmentController;
  late UserRole _selectedRole;
  late UserStatus _selectedStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _departmentController = TextEditingController(text: widget.user.department);
    _selectedRole = widget.user.role;
    _selectedStatus = widget.user.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.edit, color: Colors.blue),
          const SizedBox(width: 8),
          const Text('Edit User'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Email is required';
                  if (!value!.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Department Field
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),
              
              // Role Selection
              DropdownButtonFormField<UserRole>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.security),
                ),
                items: UserRole.values.map((role) => DropdownMenuItem(
                  value: role,
                  child: Row(
                    children: [
                      Icon(
                        role == UserRole.admin ? Icons.admin_panel_settings : Icons.person,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(role.toString().split('.').last.toUpperCase()),
                    ],
                  ),
                )).toList(),
                onChanged: (role) => setState(() => _selectedRole = role!),
              ),
              const SizedBox(height: 16),
              
              // Status Selection
              DropdownButtonFormField<UserStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: UserStatus.values.map((status) => DropdownMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(status),
                        size: 16,
                        color: _getStatusColor(status),
                      ),
                      const SizedBox(width: 8),
                      Text(status.toString().split('.').last.toUpperCase()),
                    ],
                  ),
                )).toList(),
                onChanged: (status) => setState(() => _selectedStatus = status!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Update User'),
        ),
      ],
    );
  }

  IconData _getStatusIcon(UserStatus status) {
    switch (status) {
      case UserStatus.active: return Icons.check_circle;
      case UserStatus.inactive: return Icons.pause_circle;
      case UserStatus.suspended: return Icons.block;
    }
  }

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.active: return Colors.green;
      case UserStatus.inactive: return Colors.orange;
      case UserStatus.suspended: return Colors.red;
    }
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = widget.user.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: _selectedRole,
        status: _selectedStatus,
      );

      final adminViewModel = context.read<AdminViewModel>();
      await adminViewModel.updateUser(updatedUser);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

// Edit Request Type Dialog
class EditRequestTypeDialog extends StatefulWidget {
  final RequestType requestType;

  const EditRequestTypeDialog({Key? key, required this.requestType}) : super(key: key);

  @override
  _EditRequestTypeDialogState createState() => _EditRequestTypeDialogState();
}

class _EditRequestTypeDialogState extends State<EditRequestTypeDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  
  late List<CustomField> _fields;
  late List<StatusWorkflow> _statusWorkflow;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    _nameController = TextEditingController(text: widget.requestType.name);
    _descriptionController = TextEditingController(text: widget.requestType.description);
    _categoryController = TextEditingController(text: widget.requestType.category);
    
    _fields = List.from(widget.requestType.fields);
    _statusWorkflow = List.from(widget.requestType.statusWorkflow);
    _isActive = widget.requestType.active;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

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
                  const Icon(Icons.edit, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Edit Request Type',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Switch(
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                    activeColor: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isActive ? 'Active' : 'Inactive',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              tabs: const [
                Tab(text: 'Basic Info', icon: Icon(Icons.info)),
                Tab(text: 'Custom Fields', icon: Icon(Icons.list)),
                Tab(text: 'Workflow', icon: Icon(Icons.route)),
              ],
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicInfoTab(),
                  _buildCustomFieldsTab(),
                  _buildWorkflowTab(),
                ],
              ),
            ),
            
            // Actions
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Request Type Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty == true ? 'Category is required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomFieldsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Custom Fields', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _addField,
                icon: const Icon(Icons.add),
                label: const Text('Add Field'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_fields.isEmpty)
            const Center(
              child: Text('No custom fields defined'),
            )
          else
            ReorderableListView(
              shrinkWrap: true,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final field = _fields.removeAt(oldIndex);
                  _fields.insert(newIndex, field);
                });
              },
              children: _fields.asMap().entries.map((entry) {
                final index = entry.key;
                final field = entry.value;
                return _buildFieldCard(field, index);
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildFieldCard(CustomField field, int index) {
    return Card(
      key: ValueKey(field.id),
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Icon(_getFieldTypeIcon(field.type)),
        title: Text(field.name),
        subtitle: Text(field.type.toString().split('.').last.toUpperCase()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (field.required)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('REQUIRED', style: TextStyle(fontSize: 10, color: Colors.red)),
              ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeField(index),
            ),
            const Icon(Icons.drag_handle),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildFieldEditor(field, index),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldEditor(CustomField field, int index) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: field.name,
                decoration: const InputDecoration(
                  labelText: 'Field Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _updateField(index, field.copyWith(name: value)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<FieldType>(
                value: field.type,
                decoration: const InputDecoration(
                  labelText: 'Field Type',
                  border: OutlineInputBorder(),
                ),
                items: FieldType.values.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last.toUpperCase()),
                )).toList(),
                onChanged: (type) => _updateField(index, field.copyWith(type: type)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (field.type == FieldType.dropdown) ...[
          const Text('Options:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...field.options.asMap().entries.map((entry) {
            final optionIndex = entry.key;
            final option = entry.value;
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: option,
                    decoration: InputDecoration(
                      labelText: 'Option ${optionIndex + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) => _updateFieldOption(index, optionIndex, value),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => _removeFieldOption(index, optionIndex),
                ),
              ],
            );
          }),
          ElevatedButton.icon(
            onPressed: () => _addFieldOption(index),
            icon: const Icon(Icons.add),
            label: const Text('Add Option'),
          ),
        ],
        
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Required Field'),
          value: field.required,
          onChanged: (value) => _updateField(index, field.copyWith(required: value)),
        ),
      ],
    );
  }

  Widget _buildWorkflowTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Status Workflow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _addStatus,
                icon: const Icon(Icons.add),
                label: const Text('Add Status'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_statusWorkflow.isEmpty)
            const Center(
              child: Text('No workflow statuses defined'),
            )
          else
            ReorderableListView(
              shrinkWrap: true,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final status = _statusWorkflow.removeAt(oldIndex);
                  _statusWorkflow.insert(newIndex, status);
                  // Update order values
                  for (int i = 0; i < _statusWorkflow.length; i++) {
                    _statusWorkflow[i] = StatusWorkflow(
                      id: _statusWorkflow[i].id,
                      name: _statusWorkflow[i].name,
                      color: _statusWorkflow[i].color,
                      order: i,
                      autoTransition: _statusWorkflow[i].autoTransition,
                      autoTransitionDays: _statusWorkflow[i].autoTransitionDays,
                    );
                  }
                });
              },
              children: _statusWorkflow.asMap().entries.map((entry) {
                final index = entry.key;
                final status = entry.value;
                return _buildStatusCard(status, index);
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(StatusWorkflow status, int index) {
    return Card(
      key: ValueKey(status.id),
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Color(int.parse(status.color.replaceFirst('#', '0xff'))),
            shape: BoxShape.circle,
          ),
        ),
        title: Text(status.name),
        subtitle: Text('Order: ${status.order + 1}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeStatus(index),
            ),
            const Icon(Icons.drag_handle),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  initialValue: status.name,
                  decoration: const InputDecoration(
                    labelText: 'Status Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _updateStatus(index, status.copyWith(name: value)),
                ),
                const SizedBox(height: 16),
                
                // Color picker (simplified)
                Row(
                  children: [
                    const Text('Color: '),
                    const SizedBox(width: 8),
                    ...['#FFA500', '#2196F3', '#4CAF50', '#F44336', '#9C27B0'].map((color) {
                      return GestureDetector(
                        onTap: () => _updateStatus(index, status.copyWith(color: color)),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Color(int.parse(color.replaceFirst('#', '0xff'))),
                            shape: BoxShape.circle,
                            border: status.color == color 
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _isLoading ? null : _updateRequestType,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Update Request Type'),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  IconData _getFieldTypeIcon(FieldType type) {
    switch (type) {
      case FieldType.text: return Icons.text_fields;
      case FieldType.number: return Icons.numbers;
      case FieldType.email: return Icons.email;
      case FieldType.date: return Icons.date_range;
      case FieldType.dropdown: return Icons.arrow_drop_down;
      case FieldType.checkbox: return Icons.check_box;
      case FieldType.textarea: return Icons.notes;
    }
  }

  void _addField() {
    setState(() {
      _fields.add(CustomField(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'New Field',
        type: FieldType.text,
        required: false,
      ));
    });
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
    });
  }

  void _updateField(int index, CustomField updatedField) {
    setState(() {
      _fields[index] = updatedField;
    });
  }

  void _addFieldOption(int fieldIndex) {
    final field = _fields[fieldIndex];
    final updatedOptions = List<String>.from(field.options)..add('New Option');
    _updateField(fieldIndex, CustomField(
      id: field.id,
      name: field.name,
      type: field.type,
      options: updatedOptions,
      required: field.required,
    ));
  }

  void _removeFieldOption(int fieldIndex, int optionIndex) {
    final field = _fields[fieldIndex];
    final updatedOptions = List<String>.from(field.options)..removeAt(optionIndex);
    _updateField(fieldIndex, CustomField(
      id: field.id,
      name: field.name,
      type: field.type,
      options: updatedOptions,
      required: field.required,
    ));
  }

  void _updateFieldOption(int fieldIndex, int optionIndex, String value) {
    final field = _fields[fieldIndex];
    final updatedOptions = List<String>.from(field.options);
    updatedOptions[optionIndex] = value;
    _updateField(fieldIndex, CustomField(
      id: field.id,
      name: field.name,
      type: field.type,
      options: updatedOptions,
      required: field.required,
    ));
  }

  void _addStatus() {
    setState(() {
      _statusWorkflow.add(StatusWorkflow(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'New Status',
        color: '#2196F3',
        order: _statusWorkflow.length,
      ));
    });
  }

  void _removeStatus(int index) {
    setState(() {
      _statusWorkflow.removeAt(index);
      // Update order values
      for (int i = 0; i < _statusWorkflow.length; i++) {
        _statusWorkflow[i] = StatusWorkflow(
          id: _statusWorkflow[i].id,
          name: _statusWorkflow[i].name,
          color: _statusWorkflow[i].color,
          order: i,
          autoTransition: _statusWorkflow[i].autoTransition,
          autoTransitionDays: _statusWorkflow[i].autoTransitionDays,
        );
      }
    });
  }

  void _updateStatus(int index, StatusWorkflow updatedStatus) {
    setState(() {
      _statusWorkflow[index] = updatedStatus;
    });
  }

  Future<void> _updateRequestType() async {
    if (!_formKey.currentState!.validate()) {
      _tabController.animateTo(0);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedRequestType = RequestType(
        id: widget.requestType.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
        active: _isActive,
        createdBy: widget.requestType.createdBy,
        createdAt: widget.requestType.createdAt,
        fields: _fields,
        statusWorkflow: _statusWorkflow,
      );

      // In a real app, this would call AdminViewModel.updateRequestType
      // For now, we'll simulate the update
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request type updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update request type: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

// Bulk Operations Dialog
class BulkOperationsDialog extends StatefulWidget {
  final List<String> selectedIds;
  final String entityType; // 'requests', 'users', 'templates'

  const BulkOperationsDialog({
    Key? key,
    required this.selectedIds,
    required this.entityType,
  }) : super(key: key);

  @override
  _BulkOperationsDialogState createState() => _BulkOperationsDialogState();
}

class _BulkOperationsDialogState extends State<BulkOperationsDialog> {
  BulkOperationType? _selectedOperation;
  final Map<String, dynamic> _parameters = {};
  bool _isExecuting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.playlist_add_check, color: Colors.blue),
          const SizedBox(width: 8),
          Text('Bulk Operations (${widget.selectedIds.length} items)'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select operation to perform on selected items:'),
            const SizedBox(height: 16),
            
            // Operation Selection
            DropdownButtonFormField<BulkOperationType>(
              value: _selectedOperation,
              decoration: const InputDecoration(
                labelText: 'Operation',
                border: OutlineInputBorder(),
              ),
              items: _getAvailableOperations().map((op) => DropdownMenuItem(
                value: op,
                child: Row(
                  children: [
                    Icon(_getOperationIcon(op), size: 16),
                    const SizedBox(width: 8),
                    Text(_getOperationName(op)),
                  ],
                ),
              )).toList(),
              onChanged: (operation) {
                setState(() {
                  _selectedOperation = operation;
                  _parameters.clear();
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Operation Parameters
            if (_selectedOperation != null)
              _buildParameterInputs(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isExecuting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (_selectedOperation == null || _isExecuting) ? null : _executeBulkOperation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: _isExecuting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Execute'),
        ),
      ],
    );
  }

  List<BulkOperationType> _getAvailableOperations() {
    switch (widget.entityType) {
      case 'requests':
        return [
          BulkOperationType.updateStatus,
          BulkOperationType.assignRequests,
          BulkOperationType.updatePriority,
          BulkOperationType.addTags,
          BulkOperationType.export,
        ];
      case 'users':
        return [
          BulkOperationType.updateStatus,
          BulkOperationType.export,
        ];
      case 'templates':
        return [
          BulkOperationType.addTags,
          BulkOperationType.delete,
          BulkOperationType.export,
        ];
      default:
        return [];
    }
  }

  Widget _buildParameterInputs() {
    switch (_selectedOperation!) {
      case BulkOperationType.updateStatus:
        return _buildStatusSelection();
      case BulkOperationType.assignRequests:
        return _buildAdminSelection();
      case BulkOperationType.updatePriority:
        return _buildPrioritySelection();
      case BulkOperationType.addTags:
        return _buildTagsInput();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStatusSelection() {
    final statuses = ['Pending', 'Under Review', 'In Progress', 'Approved', 'Completed', 'Rejected'];
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'New Status',
        border: OutlineInputBorder(),
      ),
      items: statuses.map((status) => DropdownMenuItem(
        value: status,
        child: Text(status),
      )).toList(),
      onChanged: (status) => _parameters['status'] = status,
    );
  }

  Widget _buildAdminSelection() {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Assign to Admin',
            border: OutlineInputBorder(),
          ),
          items: adminViewModel.adminUsers.map((admin) => DropdownMenuItem(
            value: admin.id,
            child: Text(admin.name),
          )).toList(),
          onChanged: (adminId) {
            final admin = adminViewModel.adminUsers.firstWhere((a) => a.id == adminId);
            _parameters['adminId'] = adminId;
            _parameters['adminName'] = admin.name;
          },
        );
      },
    );
  }

  Widget _buildPrioritySelection() {
    return DropdownButtonFormField<Priority>(
      decoration: const InputDecoration(
        labelText: 'New Priority',
        border: OutlineInputBorder(),
      ),
      items: Priority.values.map((priority) => DropdownMenuItem(
        value: priority,
        child: Row(
          children: [
            Icon(Icons.flag, color: _getPriorityColor(priority), size: 16),
            const SizedBox(width: 8),
            Text(priority.toString().split('.').last.toUpperCase()),
          ],
        ),
      )).toList(),
      onChanged: (priority) => _parameters['priority'] = priority,
    );
  }

  Widget _buildTagsInput() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Tags (comma separated)',
        border: OutlineInputBorder(),
        hintText: 'urgent, important, review',
      ),
      onChanged: (value) {
        _parameters['tags'] = value.split(',').map((tag) => tag.trim()).toList();
      },
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low: return Colors.green;
      case Priority.medium: return Colors.orange;
      case Priority.high: return Colors.red;
      case Priority.urgent: return Colors.purple;
    }
  }

  String _getOperationName(BulkOperationType type) {
    switch (type) {
      case BulkOperationType.updateStatus: return 'Update Status';
      case BulkOperationType.assignRequests: return 'Assign to Admin';
      case BulkOperationType.updatePriority: return 'Update Priority';
      case BulkOperationType.addTags: return 'Add Tags';
      case BulkOperationType.removeTags: return 'Remove Tags';
      case BulkOperationType.delete: return 'Delete Items';
      case BulkOperationType.export: return 'Export Data';
    }
  }

  IconData _getOperationIcon(BulkOperationType type) {
    switch (type) {
      case BulkOperationType.updateStatus: return Icons.update;
      case BulkOperationType.assignRequests: return Icons.person_add;
      case BulkOperationType.updatePriority: return Icons.flag;
      case BulkOperationType.addTags: return Icons.label;
      case BulkOperationType.removeTags: return Icons.label_off;
      case BulkOperationType.delete: return Icons.delete;
      case BulkOperationType.export: return Icons.download;
    }
  }

  Future<void> _executeBulkOperation() async {
    setState(() => _isExecuting = true);

    try {
      final templateViewModel = context.read<TemplateViewModel>();
      final request = BulkOperationRequest(
        type: _selectedOperation!,
        targetIds: widget.selectedIds,
        parameters: _parameters,
        executedBy: 'current_user',
      );

      final result = await templateViewModel.executeBulkOperation(_selectedOperation!, _parameters);

      if (mounted) {
        Navigator.pop(context, result);
        
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bulk operation completed successfully on ${widget.selectedIds.length} items'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bulk operation failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExecuting = false);
    }
  }
}

// Extension methods for CustomField
extension CustomFieldExtension on CustomField {
  CustomField copyWith({
    String? name,
    FieldType? type,
    List<String>? options,
    bool? required,
  }) {
    return CustomField(
      id: this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      options: options ?? this.options,
      required: required ?? this.required,
    );
  }
}

// Extension methods for StatusWorkflow
extension StatusWorkflowExtension on StatusWorkflow {
  StatusWorkflow copyWith({
    String? name,
    String? color,
    int? order,
    bool? autoTransition,
    int? autoTransitionDays,
  }) {
    return StatusWorkflow(
      id: this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      order: order ?? this.order,
      autoTransition: autoTransition ?? this.autoTransition,
      autoTransitionDays: autoTransitionDays ?? this.autoTransitionDays,
    );
  }
}