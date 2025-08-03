import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:silentsignal/services/api_service.dart';

// Community Post Model
class CommunityPost {
  final int userId;
  final String title;
  final String content;
  final String thumbnail;
  final String authorName; // Default will be set to "Pigeon Car"
  final String? timeAgo;
  
  CommunityPost({
    required this.userId,
    required this.title,
    required this.content,
    required this.thumbnail,
    this.authorName = "Pigeon Car", // Default author name
    this.timeAgo,
  });
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<CommunityPost> posts = [];
  bool isLoading = false;
  String? errorMessage;
  Timer? _refreshTimer;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _fetchPosts();
    
    // Set up periodic refresh every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchPosts(silent: true);
    });
    
    // Set up pull-to-refresh
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < -100) {
        // User pulled down enough to trigger refresh
        _fetchPosts();
      }
    });
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }
  
  Future<void> _fetchPosts({bool silent = false}) async {
    if (!silent) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }
    
    try {
      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
      
      final response = await apiService.get(
        endpoint: '/community-posts',
        // Add any query parameters if needed
        // queryParameters: {'limit': 20, 'page': 1}
      );
      print(response);
      
      if (response != null) {
        final fetchedPosts = (response as List)
            .map((postData) => CommunityPost(
                  userId: postData['user_id'],
                  title: postData['title'] ?? '',
                  content: postData['content'] ?? '',
                  thumbnail: postData['thumbnail'] ?? '',
                  // Default "Pigeon Car" will be used if not overridden
                  authorName: postData['authorName'] ?? "Pigeon Car",
                  // Using the correct field name created_at (with underscore) as per backend schema
                  timeAgo: postData['created_at'] != null 
                      ? _calculateTimeAgo(postData['created_at'])
                      : 'Just now',
                ))
            .toList();
            
        setState(() {
          posts = fetchedPosts;
          isLoading = false;
        });
      } else {
        if (!silent) {
          setState(() {
            errorMessage = response['message'] ?? 'Failed to load posts';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (!silent) {
        setState(() {
          errorMessage = 'Something went wrong. Please try again in a moment.';
          isLoading = false;
        });
      }
    }
  }
  
  // Helper function to convert timestamps to "time ago" format
  String _calculateTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Just now';
    
    DateTime postTime;
    try {
      // Handle different timestamp formats
      if (timestamp is String) {
        // ISO format from database (created_at DateTime @default(now()))
        postTime = DateTime.parse(timestamp);
      } else if (timestamp is int) {
        postTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is Map) {
        // Handle potential nested timestamp objects
        if (timestamp['_seconds'] != null) {
          // Firestore timestamp format
          int seconds = timestamp['_seconds'];
          int nanoseconds = timestamp['_nanoseconds'] ?? 0;
          postTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000 + (nanoseconds ~/ 1000000));
        } else {
          return 'Just now';
        }
      } else {
        return 'Just now';
      }
      
      final difference = DateTime.now().difference(postTime);
      
      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${(difference.inDays / 7).floor()}w ago';
      }
    } catch (e) {
      print('Error calculating time ago: $e');
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Community',  
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Dynamic list of posts
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _fetchPosts(),
                child: isLoading && posts.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null && posts.isEmpty
                        ? Center(child: Text(errorMessage!))
                        : posts.isEmpty
                            ? const Center(child: Text('No community posts yet'))
                            : ListView.builder(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  final post = posts[index];
                                  return CommunityPostWidget(post: post);
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }
}

class CommunityPostWidget extends StatelessWidget {
  final CommunityPost post;
  
  const CommunityPostWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Thumbnail if available
          if (post.thumbnail.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  post.thumbnail,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    );
                  },
                ),
              ),
            ),
          
          // Content
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          // Author and time info
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(
                  post.authorName, // Now always available with default value
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                if (post.timeAgo != null)
                  Row(
                    children: [
                      const SizedBox(width: 6),
                      Text(
                        post.timeAgo!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          
          // Interaction buttons
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Like and Comment icons
              Row(
                children: [
                  // Like button (icon only)
                  Icon(
                    Icons.thumb_up_outlined,
                    size: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 12),
                  // Comment button (icon only)
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
              // Right side: Share icon
              Icon(
                Icons.forward_10_outlined,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


