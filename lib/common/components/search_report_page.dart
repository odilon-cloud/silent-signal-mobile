import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:silentsignal/services/api_service.dart';
import 'package:silentsignal/providers/user_provider.dart';
import 'package:provider/provider.dart';


class SearchReportPage extends StatefulWidget {
  final String? initialReferenceToken;
  
  const SearchReportPage({super.key, this.initialReferenceToken});

  @override
  State<SearchReportPage> createState() => _SearchReportPageState();
}

class _SearchReportPageState extends State<SearchReportPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _messagesScrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  Map<String, dynamic>? _foundReport;
  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _media = [];
  bool _isLoading = false;
  bool _isLoadingMessages = false;
  bool _isSendingMessage = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    // If initial reference token is provided, set it and search automatically
    if (widget.initialReferenceToken != null) {
      _searchController.text = widget.initialReferenceToken!;
      // Delay the search to ensure the widget is fully built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchReport();
      });
    }
  }

  void _onSearchChanged() {
    // Clear previous results when search changes
    if (_foundReport != null) {
      setState(() {
        _foundReport = null;
        _messages = [];
        _media = [];
        _error = null;
      });
    }
  }

  Future<void> _searchReport() async {
    if (!_formKey.currentState!.validate()) return;

    final referenceToken = _searchController.text.trim();
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
      final response = await apiService.get(endpoint: '/crimeReports/search/$referenceToken');

      if (response['status'] == 'error') {
        setState(() {
          _error = response['message'] ?? 'Report not found';
          _foundReport = null;
        });
      } else {
        // Check if the report has a user and if current user is not logged in
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final reportHasUser = response['user_id'] != null && response['user_id'].toString().isNotEmpty;
        final currentUser = userProvider.user;
        
        if (reportHasUser && currentUser == null) {
          setState(() {
            _error = 'This report requires authentication. Please log in to view it.';
            _foundReport = null;
          });
        } else {
          setState(() {
            _foundReport = response;
            _error = null;
          });
          // Fetch messages and media for this report
          await Future.wait([
            _fetchMessages(),
            _fetchMedia(),
          ]);
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to search report: $e';
        _foundReport = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMessages() async {
    if (_foundReport == null) return;

    setState(() {
      _isLoadingMessages = true;
    });

    try {
      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
      final response = await apiService.get(
        endpoint: '/crimeReports/${_foundReport!['id']}/messages/anonymous',
      );
      print('Messages response: $response');

      if (response != null) {
        if (response is Map<String, dynamic>) {
          if (response['status'] != 'error' && response['data'] != null) {
            // If response has a 'data' field containing the messages array
            final messagesData = response['data'];
            if (messagesData is List) {
              setState(() {
                _messages = messagesData.cast<Map<String, dynamic>>();
              });
            } else {
              setState(() {
                _messages = [];
              });
            }
          } else {
            setState(() {
              _messages = [];
            });
          }
        } else if (response is List) {
          // If response is directly a list
          setState(() {
            _messages = response.cast<Map<String, dynamic>>();
          });
        } else {
          // If response is a single message or different structure
          setState(() {
            _messages = [];
          });
        }
      } else {
        setState(() {
          _messages = [];
        });
      }

      // Scroll to bottom of messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_messagesScrollController.hasClients) {
          _messagesScrollController.animateTo(
            _messagesScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        _messages = [];
      });
    } finally {
      setState(() {
        _isLoadingMessages = false;
      });
    }
  }

  Future<void> _fetchMedia() async {
    if (_foundReport == null) return;

    try {
      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
      final response = await apiService.get(
        endpoint: '/media/report/${_foundReport!['id']}',
      );
      print('Media response: $response');

      if (response != null) {
        if (response is Map<String, dynamic>) {
          if (response['status'] != 'error' && response['data'] != null) {
            // If response has a 'data' field containing the media array
            final mediaData = response['data'];
            if (mediaData is List) {
              setState(() {
                _media = mediaData.cast<Map<String, dynamic>>();
              });
            } else {
              setState(() {
                _media = [];
              });
            }
          } else {
            setState(() {
              _media = [];
            });
          }
        } else if (response is List) {
          // If response is directly a list
          setState(() {
            _media = response.cast<Map<String, dynamic>>();
          });
        } else {
          // If response is a single media item or different structure
          setState(() {
            _media = [];
          });
        }
      } else {
        setState(() {
          _media = [];
        });
      }
    } catch (e) {
      print('Error fetching media: $e');
      setState(() {
        _media = [];
      });
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _foundReport == null) return;

    setState(() {
      _isSendingMessage = true;
    });

    try {
      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
      final response = await apiService.post(
        endpoint: '/crimeReports/${_foundReport!['id']}/messages/anonymous',
        data: {
          'message': message,
          'reference_token': _foundReport!['reference_token'],
        },
      );

      if (response['status'] != 'error') {
        setState(() {
          _messages.add(response);
          _messageController.clear();
        });
        // Scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_messagesScrollController.hasClients) {
            _messagesScrollController.animateTo(
              _messagesScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        setState(() {
          _error = 'Failed to send message';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to send message: $e';
      });
    } finally {
      setState(() {
        _isSendingMessage = false;
      });
    }
  }

  List<Map<String, dynamic>> _getStatusSteps() {
    final allStatuses = ['PENDING', 'UNDER_REVIEW', 'INVESTIGATING', 'RESOLVED'];
    final currentStatus = _foundReport?['status'] ?? 'PENDING';
    final currentStatusIndex = allStatuses.indexOf(currentStatus);
    
    return allStatuses.asMap().entries.map((entry) {
      final index = entry.key;
      final status = entry.value;
      return {
        'status': status,
        'isCompleted': index <= currentStatusIndex,
        'isCurrent': index == currentStatusIndex,
      };
    }).toList();
  }

  IconData _getStatusIcon(String status, bool isCompleted, bool isCurrent) {
    if (isCompleted) {
      return Icons.check_circle;
    } else if (isCurrent) {
      switch (status) {
        case 'PENDING':
          return Icons.schedule;
        case 'UNDER_REVIEW':
        case 'INVESTIGATING':
          return Icons.visibility;
        default:
          return Icons.info;
      }
    } else {
      return Icons.info;
    }
  }

  Color _getStatusColor(String status, bool isCompleted, bool isCurrent) {
    if (isCompleted) {
      return Colors.green;
    } else if (isCurrent) {
      switch (status) {
        case 'PENDING':
          return Colors.orange;
        case 'UNDER_REVIEW':
        case 'INVESTIGATING':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    } else {
      return Colors.grey;
    }
  }

  Color _getStatusBadgeColor(String status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'UNDER_REVIEW':
        return Colors.blue;
      case 'INVESTIGATING':
        return Colors.purple;
      case 'RESOLVED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusBadgeIcon(String status) {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return Icons.schedule;
      case 'UNDER_REVIEW':
      case 'INVESTIGATING':
        return Icons.visibility;
      case 'RESOLVED':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'PENDING':
        return 'Your report has been received and is awaiting review';
      case 'UNDER_REVIEW':
        return 'Law enforcement is reviewing your report';
      case 'INVESTIGATING':
        return 'Active investigation is underway';
      case 'RESOLVED':
        return 'Case has been resolved';
      default:
        return 'Status updated';
    }
  }

  bool _isLawEnforcement(Map<String, dynamic> user) {
    return user['role'] == 'law_enforcer' || user['role'] == 'admin';
  }

  String _formatMessageTime(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }



  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    _messagesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Track Your Case',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF8FAFC), Color(0xFFE0E7FF)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Track Your Case',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your case reference to check the status of your report and communicate anonymously with law enforcement.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Search Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 24,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Enter Case Reference',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _searchController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Case reference is required';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(value.trim())) {
                            return 'Invalid case reference format';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your case reference (e.g., abc123xyz)',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
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
                            borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          suffixIcon: _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This was provided when you submitted your report',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _searchReport,
                          icon: const Icon(Icons.search),
                          label: Text(_isLoading ? 'Searching...' : 'Track Case'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_foundReport != null) ...[
              const SizedBox(height: 24),

              // Case Overview Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shield,
                                size: 24,
                                color: Colors.blue.shade600,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Case Overview',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusBadgeColor(_foundReport!['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getStatusBadgeColor(_foundReport!['status']).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getStatusBadgeIcon(_foundReport!['status']),
                                  size: 16,
                                  color: _getStatusBadgeColor(_foundReport!['status']),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _foundReport!['status']?.toString().replaceAll('_', ' ') ?? 'PENDING',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusBadgeColor(_foundReport!['status']),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                      child: _buildCaseDetails(),
                    ),
                  ],
                ),
              ),

              // Evidence Media Section
              if (_media.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.photo_library,
                              size: 24,
                              color: Colors.blue.shade600,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Submitted Evidence',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildMediaGrid(),
                      ],
                    ),
                  ),
                ),
              ],

              // Status Timeline
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.timeline,
                            size: 24,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Case Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildStatusTimeline(),
                    ],
                  ),
                ),
              ),

              // Anonymous Communication
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.message,
                            size: 24,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Anonymous Communication',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Communicate securely with law enforcement. Your identity remains anonymous.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildChatSection(),
                    ],
                  ),
                ),
              ),
            ],

            // Help Section
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need Help?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildHelpSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Case Reference
        Text(
          'Case Reference',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                _foundReport!['reference_token'] ?? 'N/A',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                // Copy to clipboard
                // You can implement clipboard functionality here
              },
              icon: const Icon(Icons.copy, size: 16),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Submitted Date
        Text(
          'Submitted',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatMessageTime(_foundReport!['created_at'] ?? ''),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        // Crime Type
        Text(
          'Crime Type',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _foundReport!['crime_type'] ?? 'Not specified',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        
        // Urgency Level
        Text(
          'Urgency Level',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          (_foundReport!['urgency_level'] ?? 'Medium').toString().toLowerCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        // Subject
        if (_foundReport!['subject_name'] != null) ...[
          Text(
            'Subject',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _foundReport!['subject_name'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
        ],
        
        // Description
        if (_foundReport!['description'] != null) ...[
          Text(
            'Description',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _foundReport!['description'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ],
      ],
    );
  }

  Widget _buildMediaGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5,
      ),
      itemCount: _media.length,
      itemBuilder: (context, index) {
        final media = _media[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              media['file_path'] ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade100,
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusTimeline() {
    final statusSteps = _getStatusSteps();
    
    return Column(
      children: statusSteps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == statusSteps.length - 1;
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getStatusColor(step['status'], step['isCompleted'], step['isCurrent']).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getStatusColor(step['status'], step['isCompleted'], step['isCurrent']),
                  width: 2,
                ),
              ),
              child: Icon(
                _getStatusIcon(step['status'], step['isCompleted'], step['isCurrent']),
                size: 16,
                color: _getStatusColor(step['status'], step['isCompleted'], step['isCurrent']),
              ),
            ),
            
            // Connecting Line
            if (!isLast) ...[
              const SizedBox(width: 16),
              Container(
                width: 2,
                height: 40,
                color: step['isCompleted'] ? Colors.green : Colors.grey.shade300,
              ),
              const SizedBox(width: 16),
            ] else ...[
              const SizedBox(width: 16),
            ],
            
            // Status Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        step['status'].toString().replaceAll('_', ' '),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: step['isCompleted'] 
                              ? Colors.green.shade700 
                              : step['isCurrent'] 
                                  ? Colors.blue.shade700 
                                  : Colors.grey.shade500,
                        ),
                      ),
                      if (step['isCurrent']) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Current',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStatusDescription(step['status']),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildChatSection() {
    return Column(
      children: [
        // Messages Area
        Container(
          height: 320,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _isLoadingMessages
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Loading messages...'),
                    ],
                  ),
                )
              : _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.message,
                            size: 48,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No messages yet',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Start a conversation with law enforcement',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _messagesScrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isLawEnforcement = _isLawEnforcement(message['user'] ?? {});
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: isLawEnforcement 
                                ? MainAxisAlignment.start 
                                : MainAxisAlignment.end,
                            children: [
                              if (isLawEnforcement) ...[
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 280),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.verified_user,
                                            size: 16,
                                            color: Colors.blue.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Law Enforcement',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        message['message'] ?? '',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatMessageTime(message['created_at'] ?? ''),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 280),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.green.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 16,
                                            color: Colors.green.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Reporter',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        message['message'] ?? '',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatMessageTime(message['created_at'] ?? ''),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
        ),
        
        const SizedBox(height: 12),
        
        // Message Input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
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
                enabled: !_isSendingMessage,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _isSendingMessage ? null : _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSendingMessage
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send, size: 20),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Privacy Notice
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              Icon(
                Icons.shield,
                size: 20,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anonymous & Secure',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    Text(
                      'All messages are encrypted and your identity is never revealed. Only your case reference is used for communication.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildHelpItem(
                icon: Icons.search,
                title: "Can't Find Your Case?",
                description: "Make sure you're using the exact reference token provided when you submitted your report.",
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildHelpItem(
                icon: Icons.message,
                title: "Anonymous Communication",
                description: "All communication remains anonymous. Your identity is never revealed to law enforcement.",
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildHelpItem(
                icon: Icons.shield,
                title: "Secure & Private",
                description: "All data is encrypted and your privacy is our top priority.",
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

