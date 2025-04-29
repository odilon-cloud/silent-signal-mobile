import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Card(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: const Column(
                          children: [
                            Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commnity',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the top
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage('your_image_url_here'),
                                ),
                                SizedBox(width: 12),
                                Expanded( // Added Expanded to prevent overflow
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                        
                                            Text(
                                              'Pigeon Car',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        
                                          SizedBox(width: 6 ),
                                          Text(
                                            '3 hours ago',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4), 
                                      Text(
                                        'Try something  i want to see how it works?',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Left side: Like and Comment icons
                                          Row(
                                            children: [
                                              // Like button
                                              Icon(
                                                Icons.thumb_up_outlined,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 12),
                                              // Comment button
                                              Icon(
                                                Icons.chat_bubble_outline,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          // Right side: Share icon
                                          Icon(
                                            Icons.share_outlined,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
            ]
          )
        )
      ) 
    );
  }
}