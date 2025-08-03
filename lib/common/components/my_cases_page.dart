import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:silentsignal/providers/user_provider.dart';
import 'package:silentsignal/services/api_service.dart';
import 'package:silentsignal/common/components/search_report_page.dart';
import 'package:silentsignal/features/crime_report_form.dart';

class MyCasesPage extends StatefulWidget {
  const MyCasesPage({super.key});

  @override
  State<MyCasesPage> createState() => _MyCasesPageState();
}

class _MyCasesPageState extends State<MyCasesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> _reports = [];
  List<Map<String, dynamic>> _filteredReports = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;
  String _statusFilter = 'all';
  Map<String, dynamic>? _selectedReport;
  bool _showReportModal = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterReports);
    _fetchUserReports();
  }

  Future<void> _fetchUserReports() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?['id'];
    
    if (userId == null) {
      setState(() {
        _error = 'User not authenticated';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
      final response = await apiService.get(endpoint: '/crimeReports/user/$userId');

      if (response['status'] == 'error') {
        setState(() {
          _error = response['message'] ?? 'Failed to load reports';
          _reports = [];
          _filteredReports = [];
        });
      } else {
        final reports = response['reports'] ?? response;
        setState(() {
          _reports = List<Map<String, dynamic>>.from(reports);
          _filteredReports = List<Map<String, dynamic>>.from(reports);
          _error = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load reports: $e';
        _reports = [];
        _filteredReports = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterReports() {
    final searchTerm = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredReports = _reports.where((report) {
        final matchesSearch = searchTerm.isEmpty ||
            (report['subject_name']?.toString().toLowerCase().contains(searchTerm) ?? false) ||
            (report['description']?.toString().toLowerCase().contains(searchTerm) ?? false) ||
            (report['crime_type']?.toString().toLowerCase().contains(searchTerm) ?? false) ||
            (report['reference_token']?.toString().toLowerCase().contains(searchTerm) ?? false);
        
        final matchesStatus = _statusFilter == 'all' || report['status'] == _statusFilter;
        
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _setStatusFilter(String status) {
    setState(() {
      _statusFilter = status;
    });
    _filterReports();
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency?.toUpperCase()) {
      case 'LOW':
        return Colors.green;
      case 'MEDIUM':
        return Colors.orange;
      case 'HIGH':
        return Colors.red;
      case 'CRITICAL':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'UNDER_REVIEW':
        return Colors.blue;
      case 'INVESTIGATING':
        return Colors.purple;
      case 'RESOLVED':
        return Colors.green;
      case 'CLOSED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusDescription(String status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return 'Your report has been received and is awaiting review by legal experts.';
      case 'UNDER_REVIEW':
        return 'Legal experts are currently reviewing your report for priority assessment.';
      case 'INVESTIGATING':
        return 'Your report has been approved and is now being investigated by law enforcement.';
      case 'RESOLVED':
        return 'The investigation has been completed and the case is resolved.';
      case 'CLOSED':
        return 'This case has been closed.';
      default:
        return 'Status information not available.';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'My Cases',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            onPressed: _isRefreshing ? null : () async {
              setState(() {
                _isRefreshing = true;
              });
              await _fetchUserReports();
              setState(() {
                _isRefreshing = false;
              });
            },
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF8FAFC), Color(0xFFE0E7FF)],
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.blue.shade600,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My Cases',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Track your submitted crime reports (${_reports.length})',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                                         ElevatedButton.icon(
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const CrimeReportForm()),
                         );
                       },
                       icon: const Icon(Icons.add),
                       label: const Text('Report New Crime'),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.blue.shade600,
                         foregroundColor: Colors.white,
                         elevation: 0,
                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                  ],
                ),
              ],
            ),
          ),

          // Filters Section
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: [
                // Search and Filter Row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search your reports...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.blue.shade500),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _statusFilter,
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                          const DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
                          const DropdownMenuItem(value: 'UNDER_REVIEW', child: Text('Under Review')),
                          const DropdownMenuItem(value: 'INVESTIGATING', child: Text('Investigating')),
                          const DropdownMenuItem(value: 'RESOLVED', child: Text('Resolved')),
                          const DropdownMenuItem(value: 'CLOSED', child: Text('Closed')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            _setStatusFilter(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Reports List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading your cases...'),
                      ],
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              style: TextStyle(color: Colors.red.shade600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchUserReports,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      )
                    : _filteredReports.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 48, color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isNotEmpty || _statusFilter != 'all'
                                      ? 'No matching reports found'
                                      : 'No reports yet',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _searchController.text.isNotEmpty || _statusFilter != 'all'
                                      ? 'Try adjusting your search criteria.'
                                      : 'You haven\'t submitted any crime reports yet.',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (_searchController.text.isEmpty && _statusFilter == 'all') ...[
                                  const SizedBox(height: 16),
                                                                   ElevatedButton.icon(
                                   onPressed: () {
                                     Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) => const CrimeReportForm()),
                                     );
                                   },
                                   icon: const Icon(Icons.add),
                                   label: const Text('Report Your First Crime'),
                                 ),
                                ],
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _filteredReports.length,
                            itemBuilder: (context, index) {
                              final report = _filteredReports[index];
                              return _buildReportCard(report);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and badges
            Row(
              children: [
                Expanded(
                  child: Text(
                    report['subject_name'] ?? 'Untitled Report',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getUrgencyColor(report['urgency_level']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getUrgencyColor(report['urgency_level']).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    report['urgency_level'] ?? 'MEDIUM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getUrgencyColor(report['urgency_level']),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(report['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(report['status']).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    (report['status'] ?? 'PENDING').toString().replaceAll('_', ' '),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(report['status']),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Description
            if (report['description'] != null) ...[
              Text(
                report['description'].toString().length > 150
                    ? '${report['description'].toString().substring(0, 150)}...'
                    : report['description'].toString(),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            // Report details grid
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        Icons.description,
                        'Reference',
                        report['reference_token'] ?? 'N/A',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailItem(
                        Icons.calendar_today,
                        'Submitted',
                        _formatDate(report['created_at']),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        Icons.location_on,
                        'Location',
                        report['location_address'] ?? 'Not specified',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailItem(
                        Icons.security,
                        'Crime Type',
                        report['crime_type'] ?? 'Not specified',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Status description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                _getStatusDescription(report['status']),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
                        // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchReportPage(
                        initialReferenceToken: report['reference_token'],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.message, size: 16),
                label: const Text('Track & Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 