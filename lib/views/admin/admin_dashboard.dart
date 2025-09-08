// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:req_mvvm/views/admin/create_user_form.dart';
// import 'package:req_mvvm/views/admin/request_management_dialog.dart';
// import '../../models/models.dart';
// import '../../viewmodels/admin_viewmodel.dart';
// import '../../viewmodels/auth_viewmodel.dart';
// import '../shared/shared_widgets.dart';
// import '../auth/login_screen.dart';



// class AdminDashboard extends StatefulWidget {
//   final User currentUser;

//   const AdminDashboard({Key? key, required this.currentUser}) : super(key: key);

//   @override
//   _AdminDashboardState createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 7, vsync: this);
    
//     // Initialize admin data
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<AdminViewModel>().initializeAdminData(widget.currentUser.id);
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Dashboard'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           _buildNotificationIcon(),
//           _buildProfileMenu(),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           isScrollable: true,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           indicatorColor: Colors.white,
//           tabs: const [
//             Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
//             Tab(icon: Icon(Icons.assignment), text: 'Requests'),
//             Tab(icon: Icon(Icons.category), text: 'Types'),
//             Tab(icon: Icon(Icons.description), text: 'Templates'),
//             Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
//             Tab(icon: Icon(Icons.people), text: 'Users'),
//           ],
//         ),
//       ),
//       body: Consumer<AdminViewModel>(
//         builder: (context, adminViewModel, child) {
//           if (adminViewModel.errorMessage != null) {
//             return ErrorDisplay(
//               message: adminViewModel.errorMessage!,
//               onRetry: () {
//                 adminViewModel.clearError();
//                 adminViewModel.refreshAllData(widget.currentUser.id);
//               },
//             );
//           }

//           return TabBarView(
//             controller: _tabController,
//             children: [
//               _OverviewTab(),
//               _RequestsTab(),
//               _RequestTypesTab(),
//               _TemplatesTab(),
//               _AnalyticsTab(),
//               _UsersTab(),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildNotificationIcon() {
//     return Consumer<AdminViewModel>(
//       builder: (context, adminViewModel, child) {
//         return Stack(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.notifications),
//               onPressed: () => _showNotifications(context, adminViewModel),
//             ),
//             if (adminViewModel.unreadCount > 0)
//               Positioned(
//                 right: 8,
//                 top: 8,
//                 child: Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   constraints: const BoxConstraints(
//                     minWidth: 16,
//                     minHeight: 16,
//                   ),
//                   child: Text(
//                     '${adminViewModel.unreadCount}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildProfileMenu() {
//     return PopupMenuButton<String>(
//       onSelected: (value) {
//         switch (value) {
//           case 'profile':
//             _showProfile();
//             break;
//           case 'settings':
//             _showSettings();
//             break;
//           case 'logout':
//             _logout();
//             break;
//         }
//       },
//       itemBuilder: (context) => [
//         const PopupMenuItem(
//           value: 'profile',
//           child: Row(
//             children: [
//               Icon(Icons.person),
//               SizedBox(width: 8),
//               Text('Profile'),
//             ],
//           ),
//         ),
//         const PopupMenuItem(
//           value: 'settings',
//           child: Row(
//             children: [
//               Icon(Icons.settings),
//               SizedBox(width: 8),
//               Text('Settings'),
//             ],
//           ),
//         ),
//         const PopupMenuItem(
//           value: 'logout',
//           child: Row(
//             children: [
//               Icon(Icons.logout),
//               SizedBox(width: 8),
//               Text('Logout'),
//             ],
//           ),
//         ),
//       ],
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircleAvatar(
//               radius: 16,
//               child: Text(widget.currentUser.name.substring(0, 1).toUpperCase()),
//             ),
//             const SizedBox(width: 4),
//             const Icon(Icons.arrow_drop_down),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showNotifications(BuildContext context, AdminViewModel adminViewModel) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => NotificationBottomSheet(
//         notifications: adminViewModel.notifications,
//         onMarkAsRead: (id) => adminViewModel.markNotificationAsRead(id),
//       ),
//     );
//   }

//   void _showProfile() {
//     showDialog(
//       context: context,
//       builder: (context) => UserProfileDialog(user: widget.currentUser),
//     );
//   }

//   void _showSettings() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Settings coming soon!')),
//     );
//   }

//   void _logout() {
//     context.read<AuthViewModel>().logout();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//       (route) => false,
//     );
//   }
// }

// // Tab Widgets
// class _OverviewTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AdminViewModel>(
//       builder: (context, adminViewModel, child) {
//         if (adminViewModel.isLoadingStats) {
//           return const LoadingIndicator();
//         }

//         final stats = adminViewModel.dashboardStats;
//         if (stats == null) {
//           return const Center(child: Text('No data available'));
//         }

//         return RefreshIndicator(
//           onRefresh: () => adminViewModel.loadDashboardStats(),
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             physics: const AlwaysScrollableScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildQuickStats(stats),
//                 const SizedBox(height: 24),
//                 _buildQuickActions(context),
//                 const SizedBox(height: 24),
//                 _buildRequestsChart(stats),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildQuickStats(DashboardStats stats) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Quick Stats',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         GridView.count(
//           crossAxisCount: 2,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           childAspectRatio: 1.5,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           children: [
//             StatCard(
//               title: 'Total Requests',
//               value: stats.totalRequests.toString(),
//               icon: Icons.assignment,
//               color: Colors.blue,
//             ),
//             StatCard(
//               title: 'Pending',
//               value: stats.pendingRequests.toString(),
//               icon: Icons.pending,
//               color: Colors.orange,
//             ),
//             StatCard(
//               title: 'In Progress',
//               value: stats.inProgressRequests.toString(),
//               icon: Icons.work,
//               color: Colors.purple,
//             ),
//             StatCard(
//               title: 'Completed',
//               value: stats.completedRequests.toString(),
//               icon: Icons.check_circle,
//               color: Colors.green,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildQuickActions(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Quick Actions',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: [
//             ActionButton(
//               icon: Icons.add,
//               label: 'New Request Type',
//               color: Colors.green,
//               onPressed: () => _showCreateRequestTypeDialog(context),
//             ),
//             ActionButton(
//               icon: Icons.download,
//               label: 'Export Data',
//               color: Colors.blue,
//               onPressed: () => _showExportDialog(context),
//             ),
//             ActionButton(
//               icon: Icons.send,
//               label: 'Send Notification',
//               color: Colors.orange,
//               onPressed: () => _showSendNotificationDialog(context),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRequestsChart(DashboardStats stats) {
//     return Row(
//       children: [
//         Expanded(
//           child: Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'By Status',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),
//                   ...stats.requestsByStatus.entries.map((entry) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(entry.key),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               entry.value.toString(),
//                               style: const TextStyle(color: Colors.white, fontSize: 12),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'By Category',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),
//                   ...stats.requestsByCategory.entries.map((entry) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(entry.key),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               entry.value.toString(),
//                               style: const TextStyle(color: Colors.white, fontSize: 12),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showCreateRequestTypeDialog(BuildContext context) {
//     _showCreateRequestTypeForm(context);
//   }

//   void _showExportDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => _ExportDialog(),
//     );
//   }

//   void _showSendNotificationDialog(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Send notification feature coming soon!')),
//     );
//   }
// }

// class _RequestsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AdminViewModel>(
//       builder: (context, adminViewModel, child) {
//         if (adminViewModel.isLoadingRequests) {
//           return const LoadingIndicator();
//         }

//         return Column(
//           children: [
//             _buildFiltersSection(context, adminViewModel),
//             Expanded(
//               child: adminViewModel.filteredRequests.isEmpty
//                   ? const EmptyState(
//                       icon: Icons.assignment,
//                       title: 'No requests found',
//                       subtitle: 'Try adjusting your filters',
//                     )
//                   : RefreshIndicator(
//                       onRefresh: () => adminViewModel.loadAllRequests(),
//                       child: ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: adminViewModel.filteredRequests.length,
//                         itemBuilder: (context, index) {
//                           final request = adminViewModel.filteredRequests[index];
//                           return RequestCard(
//                             request: request,
//                             onTap: () => _showRequestManagement(context, request),
//                           );
//                         },
//                       ),
//                     ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildFiltersSection(BuildContext context, AdminViewModel adminViewModel) {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               decoration: const InputDecoration(
//                 hintText: 'Search requests...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 adminViewModel.updateRequestFilters(searchQuery: value);
//               },
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(
//                       labelText: 'Status',
//                       border: OutlineInputBorder(),
//                     ),
//                     value: null,
//                     onChanged: (value) {
//                       adminViewModel.updateRequestFilters(status: value);
//                     },
//                     items: const [
//                       DropdownMenuItem(value: null, child: Text('All')),
//                       DropdownMenuItem(value: 'Pending', child: Text('Pending')),
//                       DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
//                       DropdownMenuItem(value: 'Completed', child: Text('Completed')),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: DropdownButtonFormField<Priority>(
//                     decoration: const InputDecoration(
//                       labelText: 'Priority',
//                       border: OutlineInputBorder(),
//                     ),
//                     value: null,
//                     onChanged: (value) {
//                       adminViewModel.updateRequestFilters(priority: value);
//                     },
//                     items: [
//                       const DropdownMenuItem(value: null, child: Text('All')),
//                       ...Priority.values.map((priority) => DropdownMenuItem(
//                         value: priority,
//                         child: Text(priority.toString().split('.').last.toUpperCase()),
//                       )),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _showRequestManagement(BuildContext context, Request request) async {
//     final result = await showDialog<bool>(
//       context: context,
//       builder: (context) => RequestManagementDialog(request: request),
//     );
    
//     // If changes were made, refresh the requests list
//     if (result == true) {
//       context.read<AdminViewModel>().loadAllRequests();
//     }
//   }
// }

// class _RequestTypesTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AdminViewModel>(
//       builder: (context, adminViewModel, child) {
//         if (adminViewModel.isLoadingTypes) {
//           return const LoadingIndicator();
//         }

//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   const Expanded(
//                     child: Text(
//                       'Request Types',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _showCreateRequestTypeForm(context),
//                     icon: const Icon(Icons.add),
//                     label: const Text('Create Type'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: adminViewModel.requestTypes.isEmpty
//                   ? const EmptyState(
//                       icon: Icons.category,
//                       title: 'No request types found',
//                       subtitle: 'Create your first request type',
//                     )
//                   : RefreshIndicator(
//                       onRefresh: () => adminViewModel.loadRequestTypes(),
//                       child: ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: adminViewModel.requestTypes.length,
//                         itemBuilder: (context, index) {
//                           final type = adminViewModel.requestTypes[index];
//                           return RequestTypeCard(
//                             requestType: type,
//                             onEdit: () => _editRequestType(context, type),
//                             onDelete: () => _deleteRequestType(context, type),
//                           );
//                         },
//                       ),
//                     ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showCreateRequestTypeForm(BuildContext context) {
//     _showCreateRequestTypeForm(context);
//   }

//   void _editRequestType(BuildContext context, RequestType type) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Edit ${type.name} feature coming soon!')),
//     );
//   }

//   void _deleteRequestType(BuildContext context, RequestType type) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Request Type'),
//         content: Text('Are you sure you want to delete "${type.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Delete feature coming soon!')),
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TemplatesTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AdminViewModel>(
//       builder: (context, adminViewModel, child) {
//         if (adminViewModel.isLoadingTemplates) {
//           return const LoadingIndicator();
//         }

//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   const Expanded(
//                     child: Text(
//                       'Templates',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _showCreateTemplateDialog(context),
//                     icon: const Icon(Icons.add),
//                     label: const Text('Create Template'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: adminViewModel.templates.isEmpty
//                   ? const EmptyState(
//                       icon: Icons.description,
//                       title: 'No templates found',
//                       subtitle: 'Create templates to speed up request creation',
//                     )
//                   : RefreshIndicator(
//                       onRefresh: () => adminViewModel.loadTemplates(),
//                       child: ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: adminViewModel.templates.length,
//                         itemBuilder: (context, index) {
//                           final template = adminViewModel.templates[index];
//                           return TemplateCard(
//                             template: template,
//                             onEdit: () => _editTemplate(context, template),
//                             onDelete: () => _deleteTemplate(context, template, adminViewModel),
//                           );
//                         },
//                       ),
//                     ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showCreateTemplateDialog(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Create template feature coming soon!')),
//     );
//   }

//   void _editTemplate(BuildContext context, RequestTemplate template) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Edit ${template.name} feature coming soon!')),
//     );
//   }

//   void _deleteTemplate(BuildContext context, RequestTemplate template, AdminViewModel adminViewModel) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Template'),
//         content: Text('Are you sure you want to delete "${template.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await adminViewModel.deleteTemplate(template.id);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _AnalyticsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AdminViewModel>(
//       builder: (context, adminViewModel, child) {
//         if (adminViewModel.isLoadingStats) {
//           return const LoadingIndicator();
//         }

//         final stats = adminViewModel.dashboardStats;
//         if (stats == null) {
//           return const Center(child: Text('No analytics data available'));
//         }

//         return RefreshIndicator(
//           onRefresh: () => adminViewModel.loadDashboardStats(),
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Analytics Dashboard',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 24),
//                 _buildAnalyticsMetrics(stats),
//                 const SizedBox(height: 24),
//                 _buildTopPerformers(stats),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAnalyticsMetrics(DashboardStats stats) {
//     return GridView.count(
//       crossAxisCount: 2,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       childAspectRatio: 1.2,
//       mainAxisSpacing: 16,
//       crossAxisSpacing: 16,
//       children: [
//         MetricCard(
//           title: 'Total Requests',
//           value: stats.totalRequests.toString(),
//           icon: Icons.assignment,
//           color: Colors.blue,
//         ),
//         MetricCard(
//           title: 'Overdue',
//           value: stats.overdueRequests.toString(),
//           icon: Icons.warning,
//           color: Colors.red,
//         ),
//         MetricCard(
//           title: 'Avg. Resolution',
//           value: '2.3 days',
//           icon: Icons.timer,
//           color: Colors.green,
//         ),
//         MetricCard(
//           title: 'Satisfaction',
//           value: '4.2/5',
//           icon: Icons.star,
//           color: Colors.orange,
//         ),
//       ],
//     );
//   }

//   Widget _buildTopPerformers(DashboardStats stats) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Top Performers',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             if (stats.topPerformers.isEmpty)
//               const Text('No performance data available')
//             else
//               ...stats.topPerformers.map((performer) => ListTile(
//                 leading: CircleAvatar(
//                   child: Text(performer.completedRequests.toString()),
//                 ),
//                 title: Text(performer.adminName),
//                 trailing: Text('${performer.completedRequests} requests'),
//               )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _UsersTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AdminViewModel>(
//       builder: (context, adminViewModel, child) {
//         if (adminViewModel.isLoadingUsers) {
//           return const LoadingIndicator();
//         }

//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   const Expanded(
//                     child: Text(
//                       'Users',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _showCreateUserForm(context),
//                     icon: const Icon(Icons.add),
//                     label: const Text('Add User'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: adminViewModel.users.isEmpty
//                   ? const EmptyState(
//                       icon: Icons.people,
//                       title: 'No users found',
//                       subtitle: 'Add users to get started',
//                     )
//                   : RefreshIndicator(
//                       onRefresh: () => adminViewModel.loadUsers(),
//                       child: ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: adminViewModel.users.length,
//                         itemBuilder: (context, index) {
//                           final user = adminViewModel.users[index];
//                           return UserCard(
//                             user: user,
//                             onEdit: () => _editUser(context, user),
//                             onDelete: () => _deleteUser(context, user, adminViewModel),
//                           );
//                         },
//                       ),
//                     ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showCreateUserForm(BuildContext context) {
//     showCreateUserForm(context);
//   }

//   void _editUser(BuildContext context, User user) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Edit ${user.name} feature coming soon!')),
//     );
//   }

//   void _deleteUser(BuildContext context, User user, AdminViewModel adminViewModel) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete User'),
//         content: Text('Are you sure you want to delete "${user.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await adminViewModel.deleteUser(user.id);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Delete', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Enhanced Export Dialog
// class _ExportDialog extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AdminViewModel>(
//       builder: (context, adminViewModel, child) {
//         return AlertDialog(
//           title: const Row(
//             children: [
//               Icon(Icons.file_download, color: Colors.blue),
//               SizedBox(width: 8),
//               Text('Export Data'),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.table_chart, color: Colors.green),
//                 title: const Text('Export to Excel'),
//                 subtitle: const Text('Download requests as Excel file'),
//                 onTap: () => _exportToExcel(context, adminViewModel),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
//                 title: const Text('Export to PDF'),
//                 subtitle: const Text('Download requests as PDF file'),
//                 onTap: () => _exportToPdf(context, adminViewModel),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _exportToExcel(BuildContext context, AdminViewModel adminViewModel) async {
//     Navigator.pop(context);
    
//     try {
//       final url = await adminViewModel.exportRequestsToExcel();
//       if (url != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Excel export completed successfully!'),
//             action: SnackBarAction(
//               label: 'VIEW',
//               onPressed: () {
//                 // In a real app, this would open the file
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('File saved: $url')),
//                 );
//               },
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Export failed: $e')),
//       );
//     }
//   }

//   Future<void> _exportToPdf(BuildContext context, AdminViewModel adminViewModel) async {
//     Navigator.pop(context);
    
//     try {
//       final url = await adminViewModel.exportRequestsToPdf();
//       if (url != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('PDF export completed successfully!'),
//             action: SnackBarAction(
//               label: 'VIEW',
//               onPressed: () {
//                 // In a real app, this would open the file
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('File saved: $url')),
//                 );
//               },
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Export failed: $e')),
//       );
//     }
//   }
// }

// // Create Request Type Form
// void _showCreateRequestTypeForm(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => _CreateRequestTypeDialog(),
//   );
// }

// class _CreateRequestTypeDialog extends StatefulWidget {
//   @override
//   __CreateRequestTypeDialogState createState() => __CreateRequestTypeDialogState();
// }

// class __CreateRequestTypeDialogState extends State<_CreateRequestTypeDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _categoryController = TextEditingController();
//   final List<CustomField> _fields = [];
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _categoryController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.all(16),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.9,
//         height: MediaQuery.of(context).size.height * 0.8,
//         child: Column(
//           children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: const BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.add_circle, color: Colors.white),
//                   const SizedBox(width: 8),
//                   const Expanded(
//                     child: Text(
//                       'Create Request Type',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Form Content
//             Expanded(
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Basic Information Card
//                       Card(
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Basic Information',
//                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 16),
//                               TextFormField(
//                                 controller: _nameController,
//                                 decoration: const InputDecoration(
//                                   labelText: 'Request Type Name *',
//                                   border: OutlineInputBorder(),
//                                   prefixIcon: Icon(Icons.title),
//                                 ),
//                                 validator: (value) {
//                                   if (value?.isEmpty == true) {
//                                     return 'Please enter a name';
//                                   }
//                                   return null;
//                                 },
//                                 textCapitalization: TextCapitalization.words,
//                               ),
//                               const SizedBox(height: 16),
//                               TextFormField(
//                                 controller: _descriptionController,
//                                 decoration: const InputDecoration(
//                                   labelText: 'Description *',
//                                   border: OutlineInputBorder(),
//                                   prefixIcon: Icon(Icons.description),
//                                   alignLabelWithHint: true,
//                                 ),
//                                 maxLines: 3,
//                                 validator: (value) {
//                                   if (value?.isEmpty == true) {
//                                     return 'Please enter a description';
//                                   }
//                                   return null;
//                                 },
//                                 textCapitalization: TextCapitalization.sentences,
//                               ),
//                               const SizedBox(height: 16),
//                               TextFormField(
//                                 controller: _categoryController,
//                                 decoration: const InputDecoration(
//                                   labelText: 'Category *',
//                                   border: OutlineInputBorder(),
//                                   prefixIcon: Icon(Icons.category),
//                                   hintText: 'e.g., HR, IT, Finance',
//                                 ),
//                                 validator: (value) {
//                                   if (value?.isEmpty == true) {
//                                     return 'Please enter a category';
//                                   }
//                                   return null;
//                                 },
//                                 textCapitalization: TextCapitalization.words,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
                      
//                       const SizedBox(height: 16),
                      
//                       // Custom Fields Card
//                       Card(
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   const Text(
//                                     'Custom Fields',
//                                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                                   ),
//                                   TextButton.icon(
//                                     onPressed: _addCustomField,
//                                     icon: const Icon(Icons.add),
//                                     label: const Text('Add Field'),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               if (_fields.isEmpty)
//                                 const Center(
//                                   child: Text(
//                                     'No custom fields added yet.\nClick "Add Field" to create form fields.',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                 )
//                               else
//                                 ..._fields.asMap().entries.map((entry) {
//                                   final index = entry.key;
//                                   final field = entry.value;
//                                   return _buildFieldPreview(field, index);
//                                 }),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
            
//             // Action Buttons
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 border: Border(top: BorderSide(color: Colors.grey.shade300)),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _createRequestType,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: _isLoading
//                           ? const SizedBox(
//                               width: 16,
//                               height: 16,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Text('Create Request Type'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFieldPreview(CustomField field, int index) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       color: Colors.grey.shade50,
//       child: ListTile(
//         leading: Icon(_getFieldTypeIcon(field.type)),
//         title: Text(field.name),
//         subtitle: Text(
//           '${field.type.toString().split('.').last.toUpperCase()}${field.required ? ' (Required)' : ''}',
//         ),
//         trailing: PopupMenuButton<String>(
//           onSelected: (value) {
//             if (value == 'edit') {
//               _editCustomField(index);
//             } else if (value == 'delete') {
//               _deleteCustomField(index);
//             }
//           },
//           itemBuilder: (context) => [
//             const PopupMenuItem(value: 'edit', child: Text('Edit')),
//             const PopupMenuItem(value: 'delete', child: Text('Delete')),
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _getFieldTypeIcon(FieldType type) {
//     switch (type) {
//       case FieldType.text:
//         return Icons.text_fields;
//       case FieldType.number:
//         return Icons.numbers;
//       case FieldType.email:
//         return Icons.email;
//       case FieldType.date:
//         return Icons.date_range;
//       case FieldType.dropdown:
//         return Icons.arrow_drop_down;
//       case FieldType.checkbox:
//         return Icons.check_box;
//       case FieldType.textarea:
//         return Icons.notes;
//     }
//   }

//   void _addCustomField() {
//     _showFieldEditor();
//   }

//   void _editCustomField(int index) {
//     _showFieldEditor(field: _fields[index], index: index);
//   }

//   void _deleteCustomField(int index) {
//     setState(() {
//       _fields.removeAt(index);
//     });
//   }

//   void _showFieldEditor({CustomField? field, int? index}) {
//     showDialog(
//       context: context,
//       builder: (context) => _FieldEditorDialog(
//         field: field,
//         onSave: (newField) {
//           setState(() {
//             if (index != null) {
//               _fields[index] = newField;
//             } else {
//               _fields.add(newField);
//             }
//           });
//         },
//       ),
//     );
//   }

//   Future<void> _createRequestType() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final adminViewModel = context.read<AdminViewModel>();
      
//       final requestType = RequestType(
//         id: '', // Will be generated by the service
//         name: _nameController.text.trim(),
//         description: _descriptionController.text.trim(),
//         category: _categoryController.text.trim(),
//         createdBy: 'Admin', // Should come from auth context
//         createdAt: DateTime.now(),
//         fields: _fields,
//         statusWorkflow: [
//           StatusWorkflow(id: '1', name: 'Pending', color: '#FFA500', order: 0),
//           StatusWorkflow(id: '2', name: 'Under Review', color: '#2196F3', order: 1),
//           StatusWorkflow(id: '3', name: 'Approved', color: '#4CAF50', order: 2),
//           StatusWorkflow(id: '4', name: 'Rejected', color: '#F44336', order: 3),
//         ],
//       );

//       await adminViewModel.createRequestType(requestType);
      
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Request type created successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to create request type: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }

// // Field Editor Dialog
// class _FieldEditorDialog extends StatefulWidget {
//   final CustomField? field;
//   final Function(CustomField) onSave;

//   const _FieldEditorDialog({this.field, required this.onSave});

//   @override
//   __FieldEditorDialogState createState() => __FieldEditorDialogState();
// }

// class __FieldEditorDialogState extends State<_FieldEditorDialog> {
//   final _nameController = TextEditingController();
//   final _optionsController = TextEditingController();
//   FieldType _selectedType = FieldType.text;
//   bool _isRequired = false;
//   List<String> _options = [];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.field != null) {
//       _nameController.text = widget.field!.name;
//       _selectedType = widget.field!.type;
//       _isRequired = widget.field!.required;
//       _options = List.from(widget.field!.options);
//       _optionsController.text = _options.join('\n');
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _optionsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.field == null ? 'Add Custom Field' : 'Edit Custom Field'),
//       content: SizedBox(
//         width: 400,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Field Name',
//                 border: OutlineInputBorder(),
//               ),
//               textCapitalization: TextCapitalization.words,
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<FieldType>(
//               decoration: const InputDecoration(
//                 labelText: 'Field Type',
//                 border: OutlineInputBorder(),
//               ),
//               value: _selectedType,
//               items: FieldType.values.map((type) {
//                 return DropdownMenuItem(
//                   value: type,
//                   child: Text(type.toString().split('.').last.toUpperCase()),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedType = value!;
//                   if (value != FieldType.dropdown) {
//                     _options.clear();
//                     _optionsController.clear();
//                   }
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             CheckboxListTile(
//               title: const Text('Required Field'),
//               value: _isRequired,
//               onChanged: (value) {
//                 setState(() {
//                   _isRequired = value ?? false;
//                 });
//               },
//               controlAffinity: ListTileControlAffinity.leading,
//             ),
//             if (_selectedType == FieldType.dropdown) ...[
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _optionsController,
//                 decoration: const InputDecoration(
//                   labelText: 'Options (one per line)',
//                   border: OutlineInputBorder(),
//                   alignLabelWithHint: true,
//                 ),
//                 maxLines: 4,
//                 onChanged: (value) {
//                   _options = value.split('\n').where((s) => s.trim().isNotEmpty).toList();
//                 },
//               ),
//             ],
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _saveField,
//           child: const Text('Save'),
//         ),
//       ],
//     );
//   }

//   void _saveField() {
//     if (_nameController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a field name')),
//       );
//       return;
//     }

//     if (_selectedType == FieldType.dropdown && _options.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please add options for dropdown field')),
//       );
//       return;
//     }

//     final field = CustomField(
//       id: widget.field?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
//       name: _nameController.text.trim(),
//       type: _selectedType,
//       required: _isRequired,
//       options: _selectedType == FieldType.dropdown ? _options : [],
//     );

//     widget.onSave(field);
//     Navigator.pop(context);
//   }
// }

// // Create User Form
// void _showCreateUserForm(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => _CreateUserDialog(),
//   );
// }

// class _CreateUserDialog extends StatefulWidget {
//   @override
//   __CreateUserDialogState createState() => __CreateUserDialogState();
// }

// class __CreateUserDialogState extends State<_CreateUserDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _departmentController = TextEditingController();
//   UserRole _selectedRole = UserRole.user;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _departmentController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Row(
//         children: [
//           Icon(Icons.person_add, color: Colors.green),
//           SizedBox(width: 8),
//           Text('Create New User'),
//         ],
//       ),
//       content: SizedBox(
//         width: 400,
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Full Name *',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 validator: (value) {
//                   if (value?.isEmpty == true) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//                 textCapitalization: TextCapitalization.words,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email Address *',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value?.isEmpty == true) {
//                     return 'Please enter an email';
//                   }
//                   if (!value!.contains('@')) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password *',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.lock),
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value?.isEmpty == true) {
//                     return 'Please enter a password';
//                   }
//                   if (value!.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _departmentController,
//                 decoration: const InputDecoration(
//                   labelText: 'Department *',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.business),
//                   hintText: 'e.g., IT, HR, Finance',
//                 ),
//                 validator: (value) {
//                   if (value?.isEmpty == true) {
//                     return 'Please enter a department';
//                   }
//                   return null;
//                 },
//                 textCapitalization: TextCapitalization.words,
//               ),
//               const SizedBox(height: 16),
//               DropdownButtonFormField<UserRole>(
//                 decoration: const InputDecoration(
//                   labelText: 'Role',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.admin_panel_settings),
//                 ),
//                 value: _selectedRole,
//                 items: UserRole.values.map((role) {
//                   return DropdownMenuItem(
//                     value: role,
//                     child: Row(
//                       children: [
//                         Icon(
//                           role == UserRole.admin ? Icons.admin_panel_settings : Icons.person,
//                           size: 20,
//                           color: role == UserRole.admin ? Colors.purple : Colors.blue,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(role.toString().split('.').last.toUpperCase()),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedRole = value!;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _isLoading ? null : _createUser,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             foregroundColor: Colors.white,
//           ),
//           child: _isLoading
//               ? const SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 )
//               : const Text('Create User'),
//         ),
//       ],
//     );
//   }

//   Future<void> _createUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final adminViewModel = context.read<AdminViewModel>();
      
//       final user = User(
//         id: '', // Will be generated by the service
//         name: _nameController.text.trim(),
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//         role: _selectedRole,
//         department: _departmentController.text.trim(),
//         createdAt: DateTime.now(),
//         active: true,
//         permissions: _selectedRole == UserRole.admin 
//             ? ['manage_users', 'manage_requests', 'view_analytics']
//             : ['create_requests', 'view_own_requests'],
//       );

//       await adminViewModel.createUser(user);
      
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User created successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to create user: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }



//2



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../models/template_models.dart';
import '../../viewmodels/admin_viewmodel.dart';
import '../../viewmodels/template_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../shared/shared_widgets.dart';
import '../auth/login_screen.dart';
import 'template_management_dialog.dart';
import '../components/advanced_analytics.dart';
import '../shared/edit_dialogs.dart';

class AdminDashboard extends StatefulWidget {
  final User currentUser;

  const AdminDashboard({Key? key, required this.currentUser}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this); // Changed from 6 to 7
    
    // Initialize admin data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminViewModel>().initializeAdminData(widget.currentUser.id);
      context.read<TemplateViewModel>().loadTemplates(); // Load templates
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          _buildNotificationIcon(),
          _buildAdvancedAnalyticsButton(),
          _buildProfileMenu(),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.assignment), text: 'Requests'),
            Tab(icon: Icon(Icons.category), text: 'Types'),
            Tab(icon: Icon(Icons.description), text: 'Templates'), // New tab
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'), // New tab
          ],
        ),
      ),
      body: Consumer<AdminViewModel>(
        builder: (context, adminViewModel, child) {
          if (adminViewModel.errorMessage != null) {
            return ErrorDisplay(
              message: adminViewModel.errorMessage!,
              onRetry: () {
                adminViewModel.clearError();
                adminViewModel.refreshAllData(widget.currentUser.id);
              },
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _OverviewTab(),
              _RequestsTab(),
              _RequestTypesTab(),
              _TemplatesTab(), // New tab
              _AnalyticsTab(),
              _UsersTab(),
              _SettingsTab(), // New tab
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => _showNotifications(context, adminViewModel),
            ),
            if (adminViewModel.unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${adminViewModel.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAdvancedAnalyticsButton() {
    return IconButton(
      icon: const Icon(Icons.analytics_outlined),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdvancedAnalyticsDashboard(),
          ),
        );
      },
      tooltip: 'Advanced Analytics',
    );
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'profile':
            _showProfile();
            break;
          case 'settings':
            _showSettings();
            break;
          case 'logout':
            _logout();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 8),
              Text('Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              child: Text(widget.currentUser.name.substring(0, 1).toUpperCase()),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context, AdminViewModel adminViewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NotificationBottomSheet(
        notifications: adminViewModel.notifications,
        onMarkAsRead: (id) => adminViewModel.markNotificationAsRead(id),
      ),
    );
  }

  void _showProfile() {
    showDialog(
      context: context,
      builder: (context) => UserProfileDialog(user: widget.currentUser),
    );
  }

  void _showSettings() {
    _tabController.animateTo(6); // Navigate to settings tab
  }

  void _logout() {
    context.read<AuthViewModel>().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}

// Tab Widgets
class _OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        if (adminViewModel.isLoadingStats) {
          return const LoadingIndicator();
        }

        final stats = adminViewModel.dashboardStats;
        if (stats == null) {
          return const Center(child: Text('No data available'));
        }

        return RefreshIndicator(
          onRefresh: () => adminViewModel.loadDashboardStats(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickStats(stats),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                _buildRequestsChart(stats),
                const SizedBox(height: 24),
                _buildTemplateUsageOverview(context), // New section
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickStats(DashboardStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            StatCard(
              title: 'Total Requests',
              value: stats.totalRequests.toString(),
              icon: Icons.assignment,
              color: Colors.blue,
            ),
            StatCard(
              title: 'Pending',
              value: stats.pendingRequests.toString(),
              icon: Icons.pending,
              color: Colors.orange,
            ),
            StatCard(
              title: 'In Progress',
              value: stats.inProgressRequests.toString(),
              icon: Icons.work,
              color: Colors.purple,
            ),
            StatCard(
              title: 'Completed',
              value: stats.completedRequests.toString(),
              icon: Icons.check_circle,
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionButton(
              icon: Icons.add,
              label: 'New Request Type',
              color: Colors.green,
              onPressed: () => _showCreateRequestTypeDialog(context),
            ),
            ActionButton(
              icon: Icons.description,
              label: 'New Template',
              color: Colors.blue,
              onPressed: () => _showCreateTemplateDialog(context),
            ),
            ActionButton(
              icon: Icons.download,
              label: 'Export Data',
              color: Colors.purple,
              onPressed: () => _showExportDialog(context),
            ),
            ActionButton(
              icon: Icons.analytics,
              label: 'Advanced Analytics',
              color: Colors.teal,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdvancedAnalyticsDashboard()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequestsChart(DashboardStats stats) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'By Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...stats.requestsByStatus.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              entry.value.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'By Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...stats.requestsByCategory.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              entry.value.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateUsageOverview(BuildContext context) {
    return Consumer<TemplateViewModel>(
      builder: (context, templateViewModel, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Template Usage',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => DefaultTabController.of(context)?.animateTo(3),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (templateViewModel.templates.isEmpty)
                  const Text('No templates created yet')
                else
                  ...templateViewModel.getPopularTemplates(limit: 3).map((template) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.description, color: Colors.blue, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(template.name)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${template.usageCount} uses',
                              style: TextStyle(fontSize: 10, color: Colors.blue.shade800),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCreateRequestTypeDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create request type feature coming soon!')),
    );
  }

  void _showCreateTemplateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const TemplateManagementDialog(),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ExportDialog(),
    );
  }
}

class _RequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        if (adminViewModel.isLoadingRequests) {
          return const LoadingIndicator();
        }

        return Column(
          children: [
            _buildFiltersSection(context, adminViewModel),
            _buildBulkActionsBar(context, adminViewModel),
            Expanded(
              child: adminViewModel.filteredRequests.isEmpty
                  ? const EmptyState(
                      icon: Icons.assignment,
                      title: 'No requests found',
                      subtitle: 'Try adjusting your filters',
                    )
                  : RefreshIndicator(
                      onRefresh: () => adminViewModel.loadAllRequests(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: adminViewModel.filteredRequests.length,
                        itemBuilder: (context, index) {
                          final request = adminViewModel.filteredRequests[index];
                          return RequestCard(
                            request: request,
                            onTap: () => _showRequestDetails(context, request),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFiltersSection(BuildContext context, AdminViewModel adminViewModel) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search requests...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                adminViewModel.updateRequestFilters(searchQuery: value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    value: null,
                    onChanged: (value) {
                      adminViewModel.updateRequestFilters(status: value);
                    },
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                      DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                      DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<Priority>(
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    value: null,
                    onChanged: (value) {
                      adminViewModel.updateRequestFilters(priority: value);
                    },
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ...Priority.values.map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority.toString().split('.').last.toUpperCase()),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkActionsBar(BuildContext context, AdminViewModel adminViewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () => _showBulkOperationsDialog(context),
            icon: const Icon(Icons.playlist_add_check),
            label: const Text('Bulk Actions'),
          ),
          const SizedBox(width: 16),
          Text('${adminViewModel.filteredRequests.length} requests'),
        ],
      ),
    );
  }

  void _showRequestDetails(BuildContext context, Request request) {
    showDialog(
      context: context,
      builder: (context) => RequestDetailsDialog(request: request),
    );
  }

  void _showBulkOperationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BulkOperationsDialog(
        selectedIds: ['1', '2'], // Demo IDs
        entityType: 'requests',
      ),
    );
  }
}

class _RequestTypesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        if (adminViewModel.isLoadingTypes) {
          return const LoadingIndicator();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Request Types',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateTypeDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Type'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: adminViewModel.requestTypes.isEmpty
                  ? const EmptyState(
                      icon: Icons.category,
                      title: 'No request types found',
                      subtitle: 'Create your first request type',
                    )
                  : RefreshIndicator(
                      onRefresh: () => adminViewModel.loadRequestTypes(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: adminViewModel.requestTypes.length,
                        itemBuilder: (context, index) {
                          final type = adminViewModel.requestTypes[index];
                          return RequestTypeCard(
                            requestType: type,
                            onEdit: () => _editRequestType(context, type),
                            onDelete: () => _deleteRequestType(context, type),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showCreateTypeDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create request type feature coming soon!')),
    );
  }

  void _editRequestType(BuildContext context, RequestType type) {
    showDialog(
      context: context,
      builder: (context) => EditRequestTypeDialog(requestType: type),
    );
  }

  void _deleteRequestType(BuildContext context, RequestType type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Request Type'),
        content: Text('Are you sure you want to delete "${type.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete feature coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// New Templates Tab
class _TemplatesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TemplateViewModel>(
      builder: (context, templateViewModel, child) {
        if (templateViewModel.isLoading) {
          return const LoadingIndicator();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Templates',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const TemplateManagementDialog(),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Template'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: templateViewModel.templates.isEmpty
                  ? const EmptyState(
                      icon: Icons.description,
                      title: 'No templates found',
                      subtitle: 'Create templates to speed up request creation',
                    )
                  : RefreshIndicator(
                      onRefresh: () => templateViewModel.loadTemplates(),
                      child: TemplateListWidget(showActions: true),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _AnalyticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        if (adminViewModel.isLoadingStats) {
          return const LoadingIndicator();
        }

        final stats = adminViewModel.dashboardStats;
        if (stats == null) {
          return const Center(child: Text('No analytics data available'));
        }

        return RefreshIndicator(
          onRefresh: () => adminViewModel.loadDashboardStats(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Analytics Dashboard',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdvancedAnalyticsDashboard()),
                      ),
                      icon: const Icon(Icons.analytics),
                      label: const Text('Advanced View'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildAnalyticsMetrics(stats),
                const SizedBox(height: 24),
                _buildTopPerformers(stats),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsMetrics(DashboardStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        MetricCard(
          title: 'Total Requests',
          value: stats.totalRequests.toString(),
          icon: Icons.assignment,
          color: Colors.blue,
        ),
        MetricCard(
          title: 'Overdue',
          value: stats.overdueRequests.toString(),
          icon: Icons.warning,
          color: Colors.red,
        ),
        MetricCard(
          title: 'Avg. Resolution',
          value: '2.3 days',
          icon: Icons.timer,
          color: Colors.green,
        ),
        MetricCard(
          title: 'Satisfaction',
          value: '4.2/5',
          icon: Icons.star,
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildTopPerformers(DashboardStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Performers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (stats.topPerformers.isEmpty)
              const Text('No performance data available')
            else
              ...stats.topPerformers.map((performer) => ListTile(
                leading: CircleAvatar(
                  child: Text(performer.completedRequests.toString()),
                ),
                title: Text(performer.adminName),
                trailing: Text('${performer.completedRequests} requests'),
              )),
          ],
        ),
      ),
    );
  }
}
class _UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        if (adminViewModel.isLoadingUsers) {
          return const LoadingIndicator();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Users',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateUserDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add User'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // User Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildUserStatCard(
                      'Total Users',
                      adminViewModel.users.length.toString(),
                      Colors.blue,
                      Icons.people,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildUserStatCard(
                      'Admins',
                      adminViewModel.adminUsers.length.toString(),
                      Colors.purple,
                      Icons.admin_panel_settings,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildUserStatCard(
                      'Active',
                      adminViewModel.users.where((u) => u.status == UserStatus.active).length.toString(),
                      Colors.green,
                      Icons.check_circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildUserStatCard(
                      'Inactive',
                      adminViewModel.users.where((u) => u.status != UserStatus.active).length.toString(),
                      Colors.orange,
                      Icons.pause_circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Search and Filter Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search users...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // Implement search functionality
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<UserRole>(
                              decoration: const InputDecoration(
                                labelText: 'Role',
                                border: OutlineInputBorder(),
                              ),
                              value: null,
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Roles')),
                                ...UserRole.values.map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role.toString().split('.').last.toUpperCase()),
                                )),
                              ],
                              onChanged: (value) {
                                // Implement role filtering
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<UserStatus>(
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(),
                              ),
                              value: null,
                              items: [
                                const DropdownMenuItem(value: null, child: Text('All Statuses')),
                                ...UserStatus.values.map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status.toString().split('.').last.toUpperCase()),
                                )),
                              ],
                              onChanged: (value) {
                                // Implement status filtering
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () => _showBulkUserActions(context, adminViewModel),
                            icon: const Icon(Icons.playlist_add_check),
                            label: const Text('Bulk Actions'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: adminViewModel.users.isEmpty
                  ? const EmptyState(
                      icon: Icons.people,
                      title: 'No users found',
                      subtitle: 'Add users to get started',
                    )
                  : RefreshIndicator(
                      onRefresh: () => adminViewModel.loadUsers(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: adminViewModel.users.length,
                        itemBuilder: (context, index) {
                          final user = adminViewModel.users[index];
                          return UserCard(
                            user: user,
                            onEdit: () => _editUser(context, user),
                            onDelete: () => _deleteUser(context, user, adminViewModel),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _CreateUserDialog(),
    );
  }

  void _editUser(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(user: user),
    );
  }

  void _deleteUser(BuildContext context, User user, AdminViewModel adminViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${user.name}"?'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone. All user data will be permanently deleted.',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await adminViewModel.deleteUser(user.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User "${user.name}" deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBulkUserActions(BuildContext context, AdminViewModel adminViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk User Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Activate Selected Users'),
              onTap: () {
                Navigator.pop(context);
                _performBulkAction(context, 'activate', adminViewModel);
              },
            ),
            ListTile(
              leading: const Icon(Icons.pause_circle, color: Colors.orange),
              title: const Text('Deactivate Selected Users'),
              onTap: () {
                Navigator.pop(context);
                _performBulkAction(context, 'deactivate', adminViewModel);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('Send Notification to All'),
              onTap: () {
                Navigator.pop(context);
                _showSendNotificationDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.purple),
              title: const Text('Export User List'),
              onTap: () {
                Navigator.pop(context);
                _exportUserList(context, adminViewModel);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _performBulkAction(BuildContext context, String action, AdminViewModel adminViewModel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bulk $action feature coming soon!')),
    );
  }

  void _showSendNotificationDialog(BuildContext context) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Notification to All Users'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Notification Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification sent to all users!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _exportUserList(BuildContext context, AdminViewModel adminViewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export User List'),
        content: const Text('Choose export format:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting to Excel...')),
              );
            },
            child: const Text('Excel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting to PDF...')),
              );
            },
            child: const Text('PDF'),
          ),
        ],
      ),
    );
  }
}

// Create User Dialog
class _CreateUserDialog extends StatefulWidget {
  @override
  __CreateUserDialogState createState() => __CreateUserDialogState();
}

class __CreateUserDialogState extends State<_CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _departmentController = TextEditingController();
  
  UserRole _selectedRole = UserRole.user;
  UserStatus _selectedStatus = UserStatus.active;
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.person_add, color: Colors.green),
          SizedBox(width: 8),
          Text('Create New User'),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password *',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                  obscureText: !_showPassword,
                  validator: (value) {
                    if (value?.isEmpty == true) return 'Password is required';
                    if (value!.length < 6) return 'Password must be at least 6 characters';
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
                
                // Role and Status Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<UserRole>(
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
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<UserStatus>(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Create User'),
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

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newUser = User(
        id: '', // Will be generated by the service
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole,
        status: _selectedStatus,
        createdAt: DateTime.now(),
        department: _departmentController.text.trim().isEmpty ? 'General' : _departmentController.text.trim(),
        active: _selectedStatus == UserStatus.active,
        permissions: _selectedRole == UserRole.admin 
            ? ['manage_users', 'create_request_types', 'update_status']
            : ['create_requests', 'view_own_requests'],
      );

      final adminViewModel = context.read<AdminViewModel>();
      await adminViewModel.createUser(newUser);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User "${newUser.name}" created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create user: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}