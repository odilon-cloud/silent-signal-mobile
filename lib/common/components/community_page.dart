// import 'package:flutter/material.dart';

// class CommunityPage extends StatelessWidget {
//   const CommunityPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//                Align(
//                 alignment: Alignment.centerLeft,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                             const Align(
//                               alignment: Alignment.centerLeft,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Commnity',
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                     Container(
//                       width: double.infinity,
//                       decoration: const BoxDecoration(
//                         color: Colors.transparent,
//                         border: Border(
//                           bottom: BorderSide(
//                             color: Colors.grey,
//                             width: 1.0,
//                           ),
//                         ),
//                       ),
//                       padding: const EdgeInsets.all(16.0),
//                       child: const Column(
//                         children: [
//                           SizedBox(height: 35),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the top
//                             children: [
//                               CircleAvatar(
//                                 radius: 25,
//                                 backgroundImage: NetworkImage('your_image_url_here'),
//                               ),
//                               SizedBox(width: 12),
//                               Expanded( // Added Expanded to prevent overflow
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
                                      
//                                           Text(
//                                             'Pigeon Car',
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
                                      
//                                         SizedBox(width: 6),
//                                         Text(
//                                           '3 hours ago',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 4), 
//                                     Text(
//                                       'Try something  i want to see how it works?',
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     SizedBox(height: 12),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         // Left side: Like and Comment icons
//                                         Row(
//                                           children: [
//                                             // Like button
//                                             Icon(
//                                               Icons.thumb_up_outlined,
//                                               size: 20,
//                                               color: Colors.grey,
//                                             ),
//                                             SizedBox(width: 12),
//                                             // Comment button
//                                             Icon(
//                                               Icons.chat_bubble_outline,
//                                               size: 20,
//                                               color: Colors.grey,
//                                             ),
//                                           ],
//                                         ),
//                                         // Right side: Share icon
//                                         Icon(
//                                           Icons.share_outlined,
//                                           size: 20,
//                                           color: Colors.grey,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 35),
//             ]
//           )
//         )
//       ) 
//     );
//   }
// }


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
  final String? authorName; // Optional for displaying who posted
  final String? timeAgo; // Optional for displaying when posted
  final int? likes;
  final int? comments;
  
  CommunityPost({
    required this.userId,
    required this.title,
    required this.content,
    required this.thumbnail,
    this.authorName,
    this.timeAgo,
    this.likes,
    this.comments,
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
      
      if (response['success'] == true && response['data'] != null) {
        final fetchedPosts = (response['data'] as List)
            .map((postData) => CommunityPost(
                  userId: postData['user_id'] ,
                  title: postData['title'] ?? '',
                  content: postData['content'] ?? '',
                  thumbnail: postData['thumbnail'] ?? '',
                  authorName: postData['authorName'],
                  timeAgo: _calculateTimeAgo(postData['createdAt']),
                  likes: postData['likesCount'],
                  comments: postData['commentsCount'],
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
          errorMessage = 'Error connecting to server: $e';
          isLoading = false;
        });
      }
    }
  }
  
  // Helper function to convert timestamps to "time ago" format
  String _calculateTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Unknown time';
    
    DateTime postTime;
    try {
      // Handle different timestamp formats
      if (timestamp is String) {
        postTime = DateTime.parse(timestamp);
      } else if (timestamp is int) {
        postTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else {
        return 'Unknown time';
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
      return 'Unknown time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Community',  // Fixed typo from 'Commnity'
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
        onPressed: _fetchPosts,
        child: const Icon(Icons.refresh),
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
          
          // Author and time info if available
          if (post.authorName != null || post.timeAgo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  if (post.authorName != null)
                    Text(
                      post.authorName!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  if (post.authorName != null && post.timeAgo != null)
                    const SizedBox(width: 6),
                  if (post.timeAgo != null)
                    Text(
                      post.timeAgo!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          
          // Interaction buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Like and Comment icons
              Row(
                children: [
                  // Like button with count
                  Row(
                    children: [
                      const Icon(
                        Icons.thumb_up_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      if (post.likes != null && post.likes! > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            '${post.likes}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Comment button with count
                  Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        size: 20,
                        color: Colors.grey,
                      ),
                      if (post.comments != null && post.comments! > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            '${post.comments}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              // Right side: Share icon
              const Icon(
                Icons.share_outlined,
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