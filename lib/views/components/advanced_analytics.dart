import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:req_mvvm/models/models.dart';
import 'package:req_mvvm/models/template_models.dart';
import 'package:req_mvvm/viewmodels/admin_viewmodel.dart';
import 'package:req_mvvm/views/shared/shared_widgets.dart';


class AdvancedAnalyticsDashboard extends StatefulWidget {
  const AdvancedAnalyticsDashboard({Key? key}) : super(key: key);

  @override
  _AdvancedAnalyticsDashboardState createState() => _AdvancedAnalyticsDashboardState();
}

class _AdvancedAnalyticsDashboardState extends State<AdvancedAnalyticsDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  AnalyticsTimeframe _selectedTimeframe = AnalyticsTimeframe(
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now(),
    label: 'Last 30 Days',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Advanced Analytics'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Performance', icon: Icon(Icons.trending_up)),
            Tab(text: 'Users', icon: Icon(Icons.people)),
            Tab(text: 'Forecasting', icon: Icon(Icons.analytics)),
          ],
        ),
        actions: [
          _buildTimeframeSelector(),
          const SizedBox(width: 16),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildPerformanceTab(),
          _buildUsersTab(),
          _buildForecastingTab(),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    return PopupMenuButton<AnalyticsTimeframe>(
      onSelected: (timeframe) {
        setState(() {
          _selectedTimeframe = timeframe;
        });
      },
      itemBuilder: (context) => [
        AnalyticsTimeframe(
          startDate: DateTime.now().subtract(const Duration(days: 7)),
          endDate: DateTime.now(),
          label: 'Last 7 Days',
        ),
        AnalyticsTimeframe(
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now(),
          label: 'Last 30 Days',
        ),
        AnalyticsTimeframe(
          startDate: DateTime.now().subtract(const Duration(days: 90)),
          endDate: DateTime.now(),
          label: 'Last 3 Months',
        ),
        AnalyticsTimeframe(
          startDate: DateTime.now().subtract(const Duration(days: 365)),
          endDate: DateTime.now(),
          label: 'Last Year',
        ),
      ].map((timeframe) => PopupMenuItem(
        value: timeframe,
        child: Text(timeframe.label),
      )).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_selectedTimeframe.label, style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        if (adminViewModel.isLoadingStats) {
          return const LoadingIndicator();
        }

        final stats = adminViewModel.dashboardStats;
        if (stats == null) return const Center(child: Text('No data available'));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Key Metrics Row
              _buildKeyMetricsGrid(stats),
              const SizedBox(height: 24),
              
              // Charts Row
              Row(
                children: [
                  Expanded(child: _buildRequestTrendChart(stats)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCategoryDistributionChart(stats)),
                ],
              ),
              const SizedBox(height: 24),
              
              // Status Distribution
              _buildStatusDistributionChart(stats),
              const SizedBox(height: 24),
              
              // Recent Activity
              _buildRecentActivitySection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKeyMetricsGrid(DashboardStats stats) {
    final metrics = [
      _MetricData('Total Requests', stats.totalRequests.toString(), Icons.assignment, Colors.blue, '+12%'),
      _MetricData('Resolution Rate', '${((stats.completedRequests / stats.totalRequests) * 100).toInt()}%', Icons.check_circle, Colors.green, '+5%'),
      _MetricData('Avg. Response Time', '2.3 hours', Icons.schedule, Colors.orange, '-15%'),
      _MetricData('Customer Satisfaction', '4.2/5.0', Icons.star, Colors.purple, '+8%'),
      _MetricData('Overdue Requests', stats.overdueRequests.toString(), Icons.warning, Colors.red, '-3%'),
      _MetricData('Active Users', '156', Icons.people, Colors.teal, '+7%'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) => _buildMetricCard(metrics[index]),
    );
  }

  Widget _buildMetricCard(_MetricData metric) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(metric.icon, color: metric.color, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: metric.trend.startsWith('+') ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    metric.trend,
                    style: TextStyle(
                      fontSize: 10,
                      color: metric.trend.startsWith('+') ? Colors.green.shade800 : Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              metric.value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: metric.color,
              ),
            ),
            Text(
              metric.title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestTrendChart(DashboardStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request Trends',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildSimpleLineChart(stats.trends),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleLineChart(List<RequestTrend> trends) {
    if (trends.isEmpty) return const Center(child: Text('No data'));
    
    final maxValue = trends.map((t) => t.requestCount).reduce((a, b) => a > b ? a : b).toDouble();
    
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _LineChartPainter(trends, maxValue),
    );
  }

  Widget _buildCategoryDistributionChart(DashboardStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Distribution',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildPieChart(stats.requestsByCategory),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, int> data) {
    if (data.isEmpty) return const Center(child: Text('No data'));
    
    final total = data.values.reduce((a, b) => a + b);
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
    
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: const Size(150, 150),
            painter: _PieChartPainter(data, colors),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          children: data.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final categoryData = entry.value;
            final percentage = ((categoryData.value / total) * 100).toInt();
            
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text('${categoryData.key} ($percentage%)', style: const TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusDistributionChart(DashboardStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: _buildBarChart(stats.requestsByStatus),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(Map<String, int> data) {
    if (data.isEmpty) return const Center(child: Text('No data'));
    
    final maxValue = data.values.reduce((a, b) => a > b ? a : b).toDouble();
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.entries.map((entry) {
        final height = (entry.value / maxValue) * 250;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(entry.value.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: _getStatusColor(entry.key),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ),
                const SizedBox(height: 8),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentActivitySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(5, (index) {
              final activities = [
                _ActivityData(Icons.assignment, 'New request created', 'IT Support - Hardware issue', '2 min ago'),
                _ActivityData(Icons.check_circle, 'Request completed', 'Leave Request approved', '15 min ago'),
                _ActivityData(Icons.person_add, 'User assigned', 'John Admin assigned to ticket #123', '30 min ago'),
                _ActivityData(Icons.update, 'Status updated', 'Request moved to In Progress', '1 hour ago'),
                _ActivityData(Icons.comment, 'Comment added', 'Follow-up question on ticket #122', '2 hours ago'),
              ];
              
              return _buildActivityItem(activities[index]);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(_ActivityData activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade100,
            child: Icon(activity.icon, size: 16, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(activity.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(activity.timestamp, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceMetrics(),
          const SizedBox(height: 24),
          _buildCategoryPerformance(),
          const SizedBox(height: 24),
          _buildAdminPerformance(),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildPerformanceCard('Avg. Resolution Time', '2.3 days', Icons.timer, Colors.blue, '15% faster'),
                _buildPerformanceCard('First Response Time', '4.2 hours', Icons.reply, Colors.green, '23% faster'),
                _buildPerformanceCard('Resolution Rate', '94.2%', Icons.check_circle, Colors.orange, '+2.1%'),
                _buildPerformanceCard('Escalation Rate', '5.8%', Icons.trending_up, Colors.red, '-1.2%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                change,
                style: TextStyle(
                  fontSize: 10,
                  color: change.startsWith('+') || change.contains('faster') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPerformance() {
    final categories = [
      CategoryPerformance(
        category: 'IT Support',
        totalRequests: 45,
        completedRequests: 42,
        completionRate: 93.3,
        avgResolutionDays: 2.1,
        topIssues: ['Hardware', 'Software', 'Network'],
      ),
      CategoryPerformance(
        category: 'HR',
        totalRequests: 28,
        completedRequests: 26,
        completionRate: 92.9,
        avgResolutionDays: 1.8,
        topIssues: ['Leave', 'Benefits', 'Training'],
      ),
      CategoryPerformance(
        category: 'Finance',
        totalRequests: 15,
        completedRequests: 14,
        completionRate: 93.3,
        avgResolutionDays: 3.2,
        topIssues: ['Expense', 'Budget', 'Invoice'],
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Performance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...categories.map((category) => _buildCategoryPerformanceItem(category)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPerformanceItem(CategoryPerformance category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                category.category,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCompletionRateColor(category.completionRate),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${category.completionRate.toStringAsFixed(1)}%',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: ${category.totalRequests}'),
                    Text('Completed: ${category.completedRequests}'),
                    Text('Avg. Resolution: ${category.avgResolutionDays} days'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Top Issues:', style: TextStyle(fontWeight: FontWeight.w500)),
                    ...category.topIssues.map((issue) => Text('• $issue', style: const TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminPerformance() {
    return Consumer<AdminViewModel>(
      builder: (context, adminViewModel, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Performance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (adminViewModel.dashboardStats?.topPerformers.isNotEmpty == true)
                  ...adminViewModel.dashboardStats!.topPerformers.map((performer) => 
                    _buildAdminPerformanceItem(performer)
                  )
                else
                  const Center(child: Text('No performance data available')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminPerformanceItem(TopPerformer performer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(performer.adminName.substring(0, 1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  performer.adminName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${performer.completedRequests} requests completed',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '#${performer.completedRequests > 15 ? '1' : performer.completedRequests > 10 ? '2' : '3'}',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    final userProductivity = [
      UserProductivity(
        userId: '1',
        userName: 'John Smith',
        department: 'IT',
        requestsSubmitted: 12,
        requestsCompleted: 11,
        avgResponseTime: 2.3,
        templatesCreated: 3,
      ),
      UserProductivity(
        userId: '2',
        userName: 'Sarah Johnson',
        department: 'HR',
        requestsSubmitted: 8,
        requestsCompleted: 8,
        avgResponseTime: 1.8,
        templatesCreated: 1,
      ),
      UserProductivity(
        userId: '3',
        userName: 'Mike Chen',
        department: 'Finance',
        requestsSubmitted: 15,
        requestsCompleted: 13,
        avgResponseTime: 3.1,
        templatesCreated: 2,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Productivity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...userProductivity.map((user) => _buildUserProductivityItem(user)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProductivityItem(UserProductivity user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(user.userName.substring(0, 1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  user.department,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildUserMetric('Submitted', user.requestsSubmitted.toString(), Colors.blue),
                  const SizedBox(width: 16),
                  _buildUserMetric('Completed', user.requestsCompleted.toString(), Colors.green),
                  const SizedBox(width: 16),
                  _buildUserMetric('Templates', user.templatesCreated.toString(), Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildForecastingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildForecastChart(),
          const SizedBox(height: 24),
          _buildPredictiveInsights(),
          const SizedBox(height: 24),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildForecastChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request Volume Forecast',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Predicted request volume for the next 30 days',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildForecastLineChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastLineChart() {
    // Generate mock forecast data
    final forecastData = List.generate(30, (index) {
      final baseValue = 5 + (index * 0.1);
      final randomVariation = (index % 7 == 0) ? 2 : 0; // Weekend dips
      return RequestTrend(
        date: DateTime.now().add(Duration(days: index)),
        requestCount: (baseValue + randomVariation).round(),
      );
    });

    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: _ForecastChartPainter(forecastData),
    );
  }

  Widget _buildPredictiveInsights() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Predictive Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              Icons.trending_up,
              'Peak Volume Expected',
              'Next Tuesday is predicted to have 35% higher request volume',
              Colors.orange,
            ),
            _buildInsightItem(
              Icons.warning,
              'Resource Alert',
              'IT support may be understaffed during next week\'s peak',
              Colors.red,
            ),
            _buildInsightItem(
              Icons.schedule,
              'Response Time Risk',
              'Current trends suggest response times may increase by 15%',
              Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(IconData icon, String title, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              '1',
              'Schedule Additional Staff',
              'Add 2 IT support agents for next Tuesday to handle predicted volume spike',
              'High Impact',
              Colors.red,
            ),
            _buildRecommendationItem(
              '2',
              'Create Template',
              'Common hardware issues could benefit from a standardized template',
              'Medium Impact',
              Colors.orange,
            ),
            _buildRecommendationItem(
              '3',
              'Process Optimization',
              'Automate status updates for leave requests to reduce manual work',
              'Low Impact',
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String priority, String title, String description, String impact, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                priority,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        impact,
                        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'in progress': case 'under review': return Colors.blue;
      case 'completed': case 'approved': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.grey;
    }
  }

  Color _getCompletionRateColor(double rate) {
    if (rate >= 95) return Colors.green;
    if (rate >= 90) return Colors.orange;
    return Colors.red;
  }
}

// Data Classes
class _MetricData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;

  _MetricData(this.title, this.value, this.icon, this.color, this.trend);
}

class _ActivityData {
  final IconData icon;
  final String title;
  final String description;
  final String timestamp;

  _ActivityData(this.icon, this.title, this.description, this.timestamp);
}

// Custom Painters
class _LineChartPainter extends CustomPainter {
  final List<RequestTrend> data;
  final double maxValue;

  _LineChartPainter(this.data, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i].requestCount / maxValue) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Notification Center Dialog
class NotificationCenterDialog extends StatefulWidget {
  const NotificationCenterDialog({Key? key}) : super(key: key);

  @override
  _NotificationCenterDialogState createState() => _NotificationCenterDialogState();
}

class _NotificationCenterDialogState extends State<NotificationCenterDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Notification Center',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              tabs: const [
                Tab(text: 'All', icon: Icon(Icons.notifications)),
                Tab(text: 'Unread', icon: Icon(Icons.circle)),
                Tab(text: 'Settings', icon: Icon(Icons.settings)),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllNotifications(),
                  _buildUnreadNotifications(),
                  _buildNotificationSettings(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllNotifications() {
    final mockNotifications = List.generate(10, (index) => AppNotification(
      id: index.toString(),
      title: 'Notification ${index + 1}',
      message: 'This is notification message ${index + 1}',
      type: NotificationType.values[index % 4],
      targetUserIds: ['current_user'],
      senderName: 'System',
      createdAt: DateTime.now().subtract(Duration(hours: index)),
      isRead: index % 3 == 0,
    ));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockNotifications.length,
      itemBuilder: (context, index) => _buildNotificationItem(mockNotifications[index]),
    );
  }

  Widget _buildUnreadNotifications() {
    final unreadNotifications = List.generate(3, (index) => AppNotification(
      id: index.toString(),
      title: 'Unread Notification ${index + 1}',
      message: 'This is an unread notification message',
      type: NotificationType.values[index % 4],
      targetUserIds: ['current_user'],
      senderName: 'System',
      createdAt: DateTime.now().subtract(Duration(minutes: index * 30)),
      isRead: false,
    ));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: unreadNotifications.length,
      itemBuilder: (context, index) => _buildNotificationItem(unreadNotifications[index]),
    );
  }

  Widget _buildNotificationSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notification Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive notifications via email'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive push notifications'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Request Updates'),
            subtitle: const Text('Notify when requests are updated'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text('Assignment Notifications'),
            subtitle: const Text('Notify when requests are assigned'),
            value: false,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(_getNotificationIcon(notification.type), color: Colors.white),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatNotificationTime(notification.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: notification.isRead 
            ? null 
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.info: return Colors.blue;
      case NotificationType.warning: return Colors.orange;
      case NotificationType.error: return Colors.red;
      case NotificationType.success: return Colors.green;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.info: return Icons.info;
      case NotificationType.warning: return Icons.warning;
      case NotificationType.error: return Icons.error;
      case NotificationType.success: return Icons.check_circle;
    }
  }

  String _formatNotificationTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class _PieChartPainter extends CustomPainter {
  final Map<String, int> data;
  final List<Color> colors;

  _PieChartPainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final total = data.values.reduce((a, b) => a + b);
    
    double startAngle = 0;
    
    data.entries.toList().asMap().entries.forEach((entry) {
      final index = entry.key;
      final categoryData = entry.value;
      
      final sweepAngle = (categoryData.value / total) * 2 * 3.14159;
      
      final paint = Paint()
        ..color = colors[index % colors.length]
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ForecastChartPainter extends CustomPainter {
  final List<RequestTrend> data;

  _ForecastChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final forecastPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final maxValue = data.map((d) => d.requestCount).reduce((a, b) => a > b ? a : b).toDouble();
    final path = Path();
    
    // Draw historical data (first 15 days) with solid line
    for (int i = 0; i < 15 && i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i].requestCount / maxValue) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
    
    // Draw forecast data (remaining days) with dashed line
    final forecastPath = Path();
    for (int i = 14; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i].requestCount / maxValue) * size.height;
      
      if (i == 14) {
        forecastPath.moveTo(x, y);
      } else {
        forecastPath.lineTo(x, y);
      }
    }
    canvas.drawPath(forecastPath, forecastPaint);
  }
@override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Settings Dialog for Analytics
class AnalyticsSettingsDialog extends StatefulWidget {
  const AnalyticsSettingsDialog({Key? key}) : super(key: key);

  @override
  _AnalyticsSettingsDialogState createState() => _AnalyticsSettingsDialogState();
}

class _AnalyticsSettingsDialogState extends State<AnalyticsSettingsDialog> {
  bool _showTrends = true;
  bool _autoRefresh = false;
  int _refreshInterval = 30;
  String _defaultTimeframe = 'Last 30 Days';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Analytics Settings',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text(
                'Show Trend Lines',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('Display trend indicators on charts'),
              value: _showTrends,
              onChanged: (value) => setState(() => _showTrends = value),
            ),
            SwitchListTile(
              title: const Text(
                'Auto Refresh',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('Automatically refresh data'),
              value: _autoRefresh,
              onChanged: (value) => setState(() => _autoRefresh = value),
            ),
            if (_autoRefresh)
              ListTile(
                title: const Text(
                  'Refresh Interval',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: DropdownButton<int>(
                  value: _refreshInterval,
                  items: [15, 30, 60, 120].map((minutes) => DropdownMenuItem(
                    value: minutes,
                    child: Text('$minutes minutes'),
                  )).toList(),
                  onChanged: (value) => setState(() => _refreshInterval = value!),
                ),
              ),
            ListTile(
              title: const Text(
                'Default Timeframe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: DropdownButton<String>(
                value: _defaultTimeframe,
                items: ['Last 7 Days', 'Last 30 Days', 'Last 3 Months', 'Last Year']
                    .map((timeframe) => DropdownMenuItem(
                      value: timeframe,
                      child: Text(timeframe),
                    )).toList(),
                onChanged: (value) => setState(() => _defaultTimeframe = value!),
              ),
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
          onPressed: () => Navigator.pop(context, {
            'showTrends': _showTrends,
            'autoRefresh': _autoRefresh,
            'refreshInterval': _refreshInterval,
            'defaultTimeframe': _defaultTimeframe,
          }),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// Export Options Dialog
class ExportAnalyticsDialog extends StatefulWidget {
  const ExportAnalyticsDialog({Key? key}) : super(key: key);

  @override
  _ExportAnalyticsDialogState createState() => _ExportAnalyticsDialogState();
}

class _ExportAnalyticsDialogState extends State<ExportAnalyticsDialog> {
  String _format = 'PDF';
  String _timeframe = 'Current View';
  bool _includeCharts = true;
  bool _includeMetrics = true;
  bool _includeDetails = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Export Analytics',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Export Format',
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(),
              ),
              value: _format,
              items: ['PDF', 'Excel', 'CSV', 'PNG'].map((format) => 
                DropdownMenuItem(value: format, child: Text(format))
              ).toList(),
              onChanged: (value) => setState(() => _format = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Time Range',
                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(),
              ),
              value: _timeframe,
              items: ['Current View', 'Last 7 Days', 'Last 30 Days', 'Custom Range']
                  .map((range) => DropdownMenuItem(value: range, child: Text(range)))
                  .toList(),
              onChanged: (value) => setState(() => _timeframe = value!),
            ),
            const SizedBox(height: 16),
            const Text(
              'Include in Export:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: const Text(
                'Charts & Graphs',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              value: _includeCharts,
              onChanged: (value) => setState(() => _includeCharts = value!),
            ),
            CheckboxListTile(
              title: const Text(
                'Key Metrics',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              value: _includeMetrics,
              onChanged: (value) => setState(() => _includeMetrics = value!),
            ),
            CheckboxListTile(
              title: const Text(
                'Detailed Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              value: _includeDetails,
              onChanged: (value) => setState(() => _includeDetails = value!),
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
          onPressed: () => Navigator.pop(context, {
            'format': _format,
            'timeframe': _timeframe,
            'includeCharts': _includeCharts,
            'includeMetrics': _includeMetrics,
            'includeDetails': _includeDetails,
          }),
          child: const Text('Export'),
        ),
      ],
    );
  }
}

// Filter Panel for Advanced Analytics
class AnalyticsFilterPanel extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;

  const AnalyticsFilterPanel({
    Key? key,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  _AnalyticsFilterPanelState createState() => _AnalyticsFilterPanelState();
}

class _AnalyticsFilterPanelState extends State<AnalyticsFilterPanel> {
  List<String> _selectedCategories = [];
  List<String> _selectedStatuses = [];
  List<Priority> _selectedPriorities = [];
  DateTimeRange? _dateRange;

  final List<String> _categories = ['IT Support', 'HR', 'Finance', 'Operations'];
  final List<String> _statuses = ['Pending', 'In Progress', 'Completed', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Categories Filter
            const Text(
              'Categories',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _categories.map((category) => FilterChip(
                label: Text(category),
                selected: _selectedCategories.contains(category),
                onSelected: (selected) => _toggleCategory(category),
              )).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Status Filter
            const Text(
              'Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _statuses.map((status) => FilterChip(
                label: Text(status),
                selected: _selectedStatuses.contains(status),
                onSelected: (selected) => _toggleStatus(status),
              )).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Priority Filter
            const Text(
              'Priority',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: Priority.values.map((priority) => FilterChip(
                label: Text(priority.toString().split('.').last.toUpperCase()),
                selected: _selectedPriorities.contains(priority),
                onSelected: (selected) => _togglePriority(priority),
              )).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Date Range
            ElevatedButton.icon(
              onPressed: _selectDateRange,
              icon: const Icon(Icons.date_range),
              label: Text(_dateRange == null 
                  ? 'Select Date Range' 
                  : '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
    _notifyFiltersChanged();
  }

  void _toggleStatus(String status) {
    setState(() {
      if (_selectedStatuses.contains(status)) {
        _selectedStatuses.remove(status);
      } else {
        _selectedStatuses.add(status);
      }
    });
    _notifyFiltersChanged();
  }

  void _togglePriority(Priority priority) {
    setState(() {
      if (_selectedPriorities.contains(priority)) {
        _selectedPriorities.remove(priority);
      } else {
        _selectedPriorities.add(priority);
      }
    });
    _notifyFiltersChanged();
  }

  void _clearFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedStatuses.clear();
      _selectedPriorities.clear();
      _dateRange = null;
    });
    _notifyFiltersChanged();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
      _notifyFiltersChanged();
    }
  }

  void _notifyFiltersChanged() {
    widget.onFiltersChanged({
      'categories': _selectedCategories,
      'statuses': _selectedStatuses,
      'priorities': _selectedPriorities,
      'dateRange': _dateRange,
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}