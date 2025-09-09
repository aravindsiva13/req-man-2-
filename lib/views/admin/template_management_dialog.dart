import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:req_mvvm/models/models.dart';
import 'package:req_mvvm/models/template_models.dart';
import 'package:req_mvvm/viewmodels/admin_viewmodel.dart';
import 'package:req_mvvm/viewmodels/template_viewmodel.dart';
import 'package:req_mvvm/views/shared/shared_widgets.dart';


class TemplateManagementDialog extends StatefulWidget {
  final ExtendedRequestTemplate? existingTemplate;
  final String? initialTypeId;

  const TemplateManagementDialog({
    Key? key,
    this.existingTemplate,
    this.initialTypeId,
  }) : super(key: key);

  @override
  _TemplateManagementDialogState createState() => _TemplateManagementDialogState();
}

class _TemplateManagementDialogState extends State<TemplateManagementDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  
  RequestType? _selectedRequestType;
  List<String> _tags = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _isEditing = widget.existingTemplate != null;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeForm();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _initializeForm() async {
    final templateViewModel = context.read<TemplateViewModel>();
    final adminViewModel = context.read<AdminViewModel>();
    
    if (_isEditing && widget.existingTemplate != null) {
      final template = widget.existingTemplate!;
      _nameController.text = template.name;
      _descriptionController.text = template.description;
      _tags = List.from(template.tags);
      
      // Load request type
      try {
        _selectedRequestType = adminViewModel.requestTypes
            .firstWhere((type) => type.id == template.typeId);
        templateViewModel.initializeDesigner(_selectedRequestType!, existingTemplate: template);
      } catch (e) {
        // Request type not found
      }
    } else if (widget.initialTypeId != null) {
      try {
        _selectedRequestType = adminViewModel.requestTypes
            .firstWhere((type) => type.id == widget.initialTypeId);
        templateViewModel.initializeDesigner(_selectedRequestType!);
      } catch (e) {
        // Request type not found
      }
    }
    
    setState(() {});
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
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.description, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    _isEditing ? 'Edit Template' : 'Create Template',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
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
                Tab(text: 'Field Mapping', icon: Icon(Icons.settings)),
                Tab(text: 'Preview', icon: Icon(Icons.preview)),
              ],
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicInfoTab(),
                  _buildFieldMappingTab(),
                  _buildPreviewTab(),
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
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Request Type Selection
                if (!_isEditing) ...[
                  const Text('Request Type *', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<RequestType>(
                    value: _selectedRequestType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select request type',
                    ),
                    items: adminViewModel.requestTypes.map((type) => 
                      DropdownMenuItem(
                        value: type,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(type.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(type.category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      )
                    ).toList(),
                    validator: (value) => value == null ? 'Please select a request type' : null,
                    onChanged: (type) {
                      setState(() {
                        _selectedRequestType = type;
                      });
                      if (type != null) {
                        context.read<TemplateViewModel>().initializeDesigner(type);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('Request Type: ${_selectedRequestType?.name ?? 'Unknown'}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Template Name
                const Text('Template Name *', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter template name',
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Template name is required' : null,
                ),
                const SizedBox(height: 16),
                
                // Description
                const Text('Description *', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Describe what this template is for',
                  ),
                  maxLines: 3,
                  validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
                ),
                const SizedBox(height: 16),
                
                // Tags
                const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tagsController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add tag',
                        ),
                        onFieldSubmitted: _addTag,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _addTag(_tagsController.text),
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: _tags.map((tag) => Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _removeTag(tag),
                    )).toList(),
                  ),
                
                const SizedBox(height: 24),
                if (_selectedRequestType != null)
                  ElevatedButton(
                    onPressed: () => _tabController.animateTo(1),
                    child: const Text('Configure Field Mappings →'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFieldMappingTab() {
    return Consumer<TemplateViewModel>(
      builder: (context, templateViewModel, child) {
        if (_selectedRequestType == null) {
          return const Center(
            child: Text('Please select a request type first'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configure Default Values',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('Set default values and lock fields for this template'),
              const SizedBox(height: 16),
              
              ...templateViewModel.fieldMappings.map((mapping) {
                final field = _selectedRequestType!.fields
                    .firstWhere((f) => f.id == mapping.fieldId);
                return _buildFieldMappingCard(field, mapping, templateViewModel);
              }),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _tabController.animateTo(0),
                    child: const Text('← Back'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _tabController.animateTo(2),
                    child: const Text('Preview →'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFieldMappingCard(CustomField field, TemplateFieldMapping mapping, TemplateViewModel templateViewModel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getFieldIcon(field.type), size: 20),
                const SizedBox(width: 8),
                Text(
                  field.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (field.required)
                  const Text(' *', style: TextStyle(color: Colors.red)),
                const Spacer(),
                Row(
                  children: [
                    const Text('Lock Field'),
                    Switch(
                      value: mapping.isLocked,
                      onChanged: (value) {
                        templateViewModel.updateFieldMapping(
                          field.id,
                          mapping.defaultValue,
                          isLocked: value,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildFieldValueInput(field, mapping, templateViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldValueInput(CustomField field, TemplateFieldMapping mapping, TemplateViewModel templateViewModel) {
    switch (field.type) {
      case FieldType.text:
      case FieldType.email:
      case FieldType.textarea:
        return TextFormField(
          initialValue: mapping.defaultValue?.toString() ?? '',
          decoration: InputDecoration(
            labelText: 'Default value',
            border: const OutlineInputBorder(),
            hintText: mapping.isLocked ? 'This value will be locked' : 'Optional default value',
          ),
          maxLines: field.type == FieldType.textarea ? 3 : 1,
          onChanged: (value) => templateViewModel.updateFieldMapping(field.id, value),
        );
      
      case FieldType.number:
        return TextFormField(
          initialValue: mapping.defaultValue?.toString() ?? '',
          decoration: const InputDecoration(
            labelText: 'Default value',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final numValue = double.tryParse(value);
            templateViewModel.updateFieldMapping(field.id, numValue ?? value);
          },
        );
      
      case FieldType.dropdown:
        return DropdownButtonFormField<String>(
          value: mapping.defaultValue,
          decoration: const InputDecoration(
            labelText: 'Default value',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('No default')),
            ...field.options.map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            )),
          ],
          onChanged: (value) => templateViewModel.updateFieldMapping(field.id, value),
        );
      
      case FieldType.checkbox:
        return CheckboxListTile(
          title: const Text('Default checked'),
          value: mapping.defaultValue == true,
          onChanged: (value) => templateViewModel.updateFieldMapping(field.id, value),
        );
      
      case FieldType.date:
        return Row(
          children: [
            Expanded(
              child: Text(
                mapping.defaultValue != null
                    ? 'Default: ${_formatDate(mapping.defaultValue)}'
                    : 'No default date set',
              ),
            ),
            ElevatedButton(
              onPressed: () => _selectDefaultDate(field.id, templateViewModel),
              child: const Text('Set Date'),
            ),
          ],
        );
    }
  }

  Widget _buildPreviewTab() {
    return Consumer<TemplateViewModel>(
      builder: (context, templateViewModel, child) {
        if (_selectedRequestType == null) {
          return const Center(
            child: Text('Please configure the template first'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Template Preview',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('This is how the template will appear to users'),
              const SizedBox(height: 16),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nameController.text.isEmpty ? 'Template Name' : _nameController.text,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedRequestType!.name,
                        style: const TextStyle(color: Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _descriptionController.text.isEmpty 
                            ? 'Template description' 
                            : _descriptionController.text,
                      ),
                      if (_tags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 4,
                          children: _tags.map((tag) => Chip(
                            label: Text(tag, style: const TextStyle(fontSize: 10)),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              const Text('Form Fields:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              
              ...templateViewModel.fieldMappings.map((mapping) {
                final field = _selectedRequestType!.fields
                    .firstWhere((f) => f.id == mapping.fieldId);
                return _buildPreviewField(field, mapping);
              }),
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _tabController.animateTo(1),
                child: const Text('← Back to Field Mapping'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreviewField(CustomField field, TemplateFieldMapping mapping) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(_getFieldIcon(field.type), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(field.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (field.required) const Text(' *', style: TextStyle(color: Colors.red)),
                      if (mapping.isLocked) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('LOCKED', style: TextStyle(fontSize: 10, color: Colors.orange)),
                        ),
                      ],
                    ],
                  ),
                  if (mapping.defaultValue != null)
                    Text(
                      'Default: ${mapping.defaultValue}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Consumer<TemplateViewModel>(
      builder: (context, templateViewModel, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const Spacer(),
              if (templateViewModel.errorMessage != null) ...[
                Expanded(
                  child: Text(
                    templateViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              ElevatedButton(
                onPressed: (templateViewModel.isCreating || templateViewModel.isUpdating) 
                    ? null 
                    : _saveTemplate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: (templateViewModel.isCreating || templateViewModel.isUpdating)
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_isEditing ? 'Update Template' : 'Create Template'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper Methods
  IconData _getFieldIcon(FieldType type) {
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _selectDefaultDate(String fieldId, TemplateViewModel templateViewModel) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      templateViewModel.updateFieldMapping(fieldId, picked);
    }
  }

  Future<void> _saveTemplate() async {
    if (!_formKey.currentState!.validate()) {
      _tabController.animateTo(0);
      return;
    }

    if (_selectedRequestType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a request type')),
      );
      return;
    }

    final templateViewModel = context.read<TemplateViewModel>();
    
    if (!templateViewModel.validateTemplate(_nameController.text, _descriptionController.text)) {
      return;
    }

    final template = ExtendedRequestTemplate(
      id: _isEditing ? widget.existingTemplate!.id : '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      typeId: _selectedRequestType!.id,
      typeName: _selectedRequestType!.name,
      fieldMappings: templateViewModel.fieldMappings,
      metadata: {
        'created_from': 'template_dialog',
        'version': '1.0',
      },
      createdBy: 'current_user', // Should be passed from auth
      createdByName: 'Current User', // Should be passed from auth
      createdAt: _isEditing ? widget.existingTemplate!.createdAt : DateTime.now(),
      updatedAt: _isEditing ? DateTime.now() : null,
      tags: _tags,
      usageCount: _isEditing ? widget.existingTemplate!.usageCount : 0,
    );

    bool success;
    if (_isEditing) {
      success = await templateViewModel.updateTemplate(template);
    } else {
      success = await templateViewModel.createTemplate(template);
    }

    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing 
                ? 'Template updated successfully!' 
                : 'Template created successfully!',
          ),
        ),
      );
    }
  }
}

// Template List Widget for integration
class TemplateListWidget extends StatelessWidget {
  final Function(ExtendedRequestTemplate)? onTemplateSelected;
  final bool showActions;

  const TemplateListWidget({
    Key? key,
    this.onTemplateSelected,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TemplateViewModel>(
      builder: (context, templateViewModel, child) {
        if (templateViewModel.isLoading) {
          return const LoadingIndicator();
        }

        if (templateViewModel.templates.isEmpty) {
          return const EmptyState(
            icon: Icons.description,
            title: 'No templates found',
            subtitle: 'Create templates to speed up request creation',
          );
        }

        return ListView.builder(
          itemCount: templateViewModel.templates.length,
          itemBuilder: (context, index) {
            final template = templateViewModel.templates[index];
            return TemplateListTile(
              template: template,
              onTap: onTemplateSelected != null 
                  ? () => onTemplateSelected!(template)
                  : null,
              showActions: showActions,
            );
          },
        );
      },
    );
  }
}

class TemplateListTile extends StatelessWidget {
  final ExtendedRequestTemplate template;
  final VoidCallback? onTap;
  final bool showActions;

  const TemplateListTile({
    Key? key,
    required this.template,
    this.onTap,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: template.isActive ? Colors.blue : Colors.grey,
          child: const Icon(Icons.description, color: Colors.white),
        ),
        title: Text(
          template.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(template.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    template.typeName,
                    style: TextStyle(fontSize: 10, color: Colors.blue.shade800),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${template.usageCount} uses',
                    style: TextStyle(fontSize: 10, color: Colors.green.shade800),
                  ),
                ),
                if (!template.isActive) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'INACTIVE',
                      style: TextStyle(fontSize: 10, color: Colors.red.shade800),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: showActions 
            ? PopupMenuButton<String>(
                onSelected: (value) => _handleAction(context, value, template),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(template.isActive ? 'Deactivate' : 'Activate'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  void _handleAction(BuildContext context, String action, ExtendedRequestTemplate template) {
    final templateViewModel = context.read<TemplateViewModel>();
    
    switch (action) {
      case 'edit':
        showDialog(
          context: context,
          builder: (context) => TemplateManagementDialog(existingTemplate: template),
        );
        break;
      case 'toggle':
        templateViewModel.toggleTemplateStatus(template.id);
        break;
      case 'delete':
        _showDeleteConfirmation(context, template, templateViewModel);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, ExtendedRequestTemplate template, TemplateViewModel templateViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Template'),
        content: Text('Are you sure you want to delete "${template.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await templateViewModel.deleteTemplate(template.id);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Template deleted successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}