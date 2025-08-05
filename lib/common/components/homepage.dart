import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:silentsignal/common/components/search_report_page.dart';
import 'package:silentsignal/common/components/my_cases_page.dart';
import 'package:silentsignal/features/crime_report_form.dart';
import 'package:silentsignal/providers/user_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final String rawUsername = userProvider.user?['first_name'] ?? "Anonymous";
    final String username = toBeginningOfSentenceCase(rawUsername) ?? "Anonymous";

    String getGreeting() {
      final hour = DateTime.now().hour;

      if (hour >= 6 && hour < 12) {
        return 'Good Morning,';
      } else if (hour >= 12 && hour < 18) {
        return 'Good Afternoon,';
      } else {
        return 'Good Evening,';
      }
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Only horizontal padding
      child: Column(
        mainAxisSize: MainAxisSize.min, // Important: don't take more space than needed
        children: [
          // Greeting section
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getGreeting(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25), // Reduced from 35
          
          // Conditional card based on user authentication
          Card(
            child: InkWell(
              onTap: () {
                if (userProvider.user != null) {
                  // User is logged in - show My Cases
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyCasesPage()),
                  );
                } else {
                  // User is not logged in - show Track Case
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchReportPage()),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      userProvider.user != null ? Icons.folder : Icons.search,
                      size: 26,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      userProvider.user != null ? 'My Cases' : 'Track Case',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          
          // Two action cards in a row
          Row(
            children: [
              Expanded(
                child: Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CrimeReportForm()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.menu_book, size: 32),
                          SizedBox(height: 8),
                          Text(
                            'New tip?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: InkWell(
                    onTap: () {
                      // Add emergency functionality here
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.contact_emergency, size: 32, color: Colors.black),
                          SizedBox(height: 8),
                          Text(
                            'Emergency?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          
          // Community cards
          _buildCommunityCard(),
          const SizedBox(height: 16),
          _buildCommunityCard(),
          const SizedBox(height: 16),
          _buildCommunityCard(),
          
          // Add some bottom padding
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCommunityCard() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Community',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('https://via.placeholder.com/50'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Pigeon Car',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '3 hours ago',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4), 
                      const Text(
                        'Try something i want to see how it works?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
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
}