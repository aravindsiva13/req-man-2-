import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../viewmodels/admin_viewmodel.dart';

void showCreateRequestTypeForm(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => CreateRequestTypeDialog(),
  );
}

class CreateRequestTypeDialog extends StatefulWidget {
  @override
  _CreateRequestTypeDialogState createState() => _CreateRequestTypeDialogState();
}

class _CreateRequestTypeDialogState extends State<CreateRequestTypeDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<CustomField> _fields = [];
  bool _isLoading = false;

  // Predefined categories for suggestions
  final List<String> _categoryOptions = [
    'HR', 'IT', 'Finance', 'Operations', 'Marketing', 
    'Legal', 'Procurement', 'Facilities', 'Training'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Create Request Type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
            Container(
              color: Colors.grey.shade100,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.green,
                tabs: const [
                  Tab(icon: Icon(Icons.info), text: 'Basic Info'),
                  Tab(icon: Icon(Icons.build), text: 'Custom Fields'),
                  Tab(icon: Icon(Icons.preview), text: 'Preview'),
                ],
              ),
            ),
            
            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBasicInfoTab(),
                    _buildCustomFieldsTab(),
                    _buildPreviewTab(),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  if (_tabController.index > 0) ...[
                    OutlinedButton.icon(
                      onPressed: () {
                        _tabController.animateTo(_tabController.index - 1);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (_tabController.index < 2) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_tabController.index == 0) {
                          if (_validateBasicInfo()) {
                            _tabController.animateTo(1);
                          }
                        } else {
                          _tabController.animateTo(2);
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ] else ...[
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _createRequestType,
                      icon: _isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isLoading ? 'Creating...' : 'Create Request Type'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Provide the essential details for your new request type.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Request Type Name
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Request Type Name *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
              hintText: 'e.g., Leave Request, IT Support, Purchase Order',
            ),
            validator: (value) {
              if (value?.isEmpty == true) {
                return 'Please enter a request type name';
              }
              if (value!.length < 3) {
                return 'Name must be at least 3 characters';
              }
              return null;
            },
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          
          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
              alignLabelWithHint: true,
              hintText: 'Describe what this request type is used for...',
            ),
            maxLines: 4,
            validator: (value) {
              if (value?.isEmpty == true) {
                return 'Please enter a description';
              }
              if (value!.length < 10) {
                return 'Description must be at least 10 characters';
              }
              return null;
            },
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 20),
          
          // Category with Autocomplete
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return _categoryOptions;
              }
              return _categoryOptions.where((option) {
                return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              _categoryController.text = selection;
            },
            fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
              _categoryController.addListener(() {
                controller.text = _categoryController.text;
              });
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                onEditingComplete: onEditingComplete,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                  hintText: 'Select or type a category',
                ),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter a category';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  _categoryController.text = value;
                },
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 200,
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.category, size: 16),
                          title: Text(option),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Steps',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'After creating the basic information, you can add custom fields to collect specific data for this request type.',
                        style: TextStyle(color: Colors.blue.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomFieldsTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Custom Fields',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Design the form fields users will fill out',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _addCustomField,
                icon: const Icon(Icons.add),
                label: const Text('Add Field'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          if (_fields.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.build_circle,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No custom fields added yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Click "Add Field" to create form fields that users\nwill fill out when submitting this request type.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: _addCustomField,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Your First Field'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  return _buildFieldCard(_fields[index], index);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFieldCard(CustomField field, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Field Type Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getFieldTypeColor(field.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getFieldTypeIcon(field.type),
                color: _getFieldTypeColor(field.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            
            // Field Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        field.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (field.required) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'REQUIRED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    field.type.toString().split('.').last.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  if (field.options.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Options: ${field.options.take(3).join(", ")}${field.options.length > 3 ? "..." : ""}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _editCustomField(index),
                  icon: const Icon(Icons.edit, size: 20),
                  tooltip: 'Edit Field',
                ),
                IconButton(
                  onPressed: () => _deleteCustomField(index),
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  tooltip: 'Delete Field',
                ),
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This is how your request type will appear to users.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Preview Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.assignment, color: Colors.blue.shade700),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameController.text.isEmpty ? 'Request Type Name' : _nameController.text,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _categoryController.text.isEmpty ? 'Category' : _categoryController.text,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    _descriptionController.text.isEmpty 
                        ? 'Request description will appear here...'
                        : _descriptionController.text,
                    style: TextStyle(
                      color: _descriptionController.text.isEmpty ? Colors.grey : Colors.black87,
                    ),
                  ),
                  
                  if (_fields.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Form Fields',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Preview Fields
                    ..._fields.map((field) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildPreviewField(field),
                    )),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Ready to Create',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Your request type "${_nameController.text}" with ${_fields.length} custom fields is ready to be created.',
                  style: TextStyle(color: Colors.green.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewField(CustomField field) {
    switch (field.type) {
      case FieldType.text:
      case FieldType.email:
        return TextFormField(
          decoration: InputDecoration(
            labelText: '${field.name}${field.required ? ' *' : ''}',
            border: const OutlineInputBorder(),
            enabled: false,
          ),
        );
      
      case FieldType.textarea:
        return TextFormField(
          decoration: InputDecoration(
            labelText: '${field.name}${field.required ? ' *' : ''}',
            border: const OutlineInputBorder(),
            enabled: false,
          ),
          maxLines: 3,
        );
      
      case FieldType.dropdown:
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '${field.name}${field.required ? ' *' : ''}',
            border: const OutlineInputBorder(),
          ),
          items: field.options.map((option) => DropdownMenuItem(
            value: option,
            child: Text(option),
          )).toList(),
          onChanged: null,
        );
      
      case FieldType.checkbox:
        return CheckboxListTile(
          title: Text('${field.name}${field.required ? ' *' : ''}'),
          value: false,
          onChanged: null,
          controlAffinity: ListTileControlAffinity.leading,
        );
      
      case FieldType.date:
        return TextFormField(
          decoration: InputDecoration(
            labelText: '${field.name}${field.required ? ' *' : ''}',
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
            enabled: false,
          ),
        );
      
      case FieldType.number:
        return TextFormField(
          decoration: InputDecoration(
            labelText: '${field.name}${field.required ? ' *' : ''}',
            border: const OutlineInputBorder(),
            enabled: false,
          ),
          keyboardType: TextInputType.number,
        );
    }
  }

  bool _validateBasicInfo() {
    return _formKey.currentState?.validate() ?? false;
  }

  IconData _getFieldTypeIcon(FieldType type) {
    switch (type) {
      case FieldType.text:
        return Icons.text_fields;
      case FieldType.number:
        return Icons.numbers;
      case FieldType.email:
        return Icons.email;
      case FieldType.date:
        return Icons.date_range;
      case FieldType.dropdown:
        return Icons.arrow_drop_down_circle;
      case FieldType.checkbox:
        return Icons.check_box;
      case FieldType.textarea:
        return Icons.notes;
    }
  }

  Color _getFieldTypeColor(FieldType type) {
    switch (type) {
      case FieldType.text:
        return Colors.blue;
      case FieldType.number:
        return Colors.orange;
      case FieldType.email:
        return Colors.red;
      case FieldType.date:
        return Colors.purple;
      case FieldType.dropdown:
        return Colors.green;
      case FieldType.checkbox:
        return Colors.teal;
      case FieldType.textarea:
        return Colors.indigo;
    }
  }

  void _addCustomField() {
    _showFieldEditor();
  }

  void _editCustomField(int index) {
    _showFieldEditor(field: _fields[index], index: index);
  }

  void _deleteCustomField(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Field'),
        content: Text('Are you sure you want to delete "${_fields[index].name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _fields.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFieldEditor({CustomField? field, int? index}) {
    showDialog(
      context: context,
      builder: (context) => FieldEditorDialog(
        field: field,
        onSave: (newField) {
          setState(() {
            if (index != null) {
              _fields[index] = newField;
            } else {
              _fields.add(newField);
            }
          });
        },
      ),
    );
  }

  Future<void> _createRequestType() async {
    if (!_validateBasicInfo()) {
      _tabController.animateTo(0);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final adminViewModel = context.read<AdminViewModel>();
      
      final requestType = RequestType(
        id: '', // Will be generated by the service
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
        createdBy: 'Admin', // Should come from auth context
        createdAt: DateTime.now(),
        fields: _fields,
        statusWorkflow: [
          StatusWorkflow(id: '1', name: 'Pending', color: '#FFA500', order: 0),
          StatusWorkflow(id: '2', name: 'Under Review', color: '#2196F3', order: 1),
          StatusWorkflow(id: '3', name: 'Approved', color: '#4CAF50', order: 2),
          StatusWorkflow(id: '4', name: 'Rejected', color: '#F44336', order: 3),
        ],
      );

      await adminViewModel.createRequestType(requestType);
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Request type "${requestType.name}" created successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Failed to create request type: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

// Field Editor Dialog
class FieldEditorDialog extends StatefulWidget {
  final CustomField? field;
  final Function(CustomField) onSave;

  const FieldEditorDialog({Key? key, this.field, required this.onSave}) : super(key: key);

  @override
  _FieldEditorDialogState createState() => _FieldEditorDialogState();
}

class _FieldEditorDialogState extends State<FieldEditorDialog> {
  final _nameController = TextEditingController();
  final _optionsController = TextEditingController();
  FieldType _selectedType = FieldType.text;
  bool _isRequired = false;
  List<String> _options = [];

  @override
  void initState() {
    super.initState();
    if (widget.field != null) {
      _nameController.text = widget.field!.name;
      _selectedType = widget.field!.type;
      _isRequired = widget.field!.required;
      _options = List.from(widget.field!.options);
      _optionsController.text = _options.join('\n');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _optionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(widget.field == null ? Icons.add : Icons.edit),
          const SizedBox(width: 8),
          Text(widget.field == null ? 'Add Custom Field' : 'Edit Custom Field'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Field Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<FieldType>(
                decoration: const InputDecoration(
                  labelText: 'Field Type *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                value: _selectedType,
                items: FieldType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getFieldTypeIcon(type), size: 20),
                        const SizedBox(width: 8),
                        Text(type.toString().split('.').last.toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    if (value != FieldType.dropdown) {
                      _options.clear();
                      _optionsController.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Required Field'),
                subtitle: const Text('Users must fill this field'),
                value: _isRequired,
                onChanged: (value) {
                  setState(() {
                    _isRequired = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (_selectedType == FieldType.dropdown) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _optionsController,
                  decoration: const InputDecoration(
                    labelText: 'Options (one per line) *',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.list),
                    hintText: 'Option 1\nOption 2\nOption 3',
                  ),
                  maxLines: 4,
                  onChanged: (value) {
                    _options = value.split('\n').where((s) => s.trim().isNotEmpty).toList();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveField,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save Field'),
        ),
      ],
    );
  }

  IconData _getFieldTypeIcon(FieldType type) {
    switch (type) {
      case FieldType.text:
        return Icons.text_fields;
      case FieldType.number:
        return Icons.numbers;
      case FieldType.email:
        return Icons.email;
      case FieldType.date:
        return Icons.date_range;
      case FieldType.dropdown:
        return Icons.arrow_drop_down;
      case FieldType.checkbox:
        return Icons.check_box;
      case FieldType.textarea:
        return Icons.notes;
    }
  }

  void _saveField() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a field name')),
      );
      return;
    }

    if (_selectedType == FieldType.dropdown && _options.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add options for dropdown field')),
      );
      return;
    }

    final field = CustomField(
      id: widget.field?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      type: _selectedType,
      required: _isRequired,
      options: _selectedType == FieldType.dropdown ? _options : [],
    );

    widget.onSave(field);
    Navigator.pop(context);
  }
}