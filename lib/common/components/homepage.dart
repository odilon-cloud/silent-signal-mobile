import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:silentsignal/features/crime_report_form.dart';
import 'package:silentsignal/providers/user_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context); // Get user provider
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
                     Text(
                      getGreeting(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal
                      )
                     ),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              // First single card
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Courage above all things is the first quality of a warrior',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ), 
                ),
              ),
              const SizedBox(height: 25),
              
              // Two cards in a row
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: InkWell( // Added InkWell for tap functionality
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CrimeReportForm()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Row(
                            children: [
                              Icon(Icons.menu_book),
                              SizedBox(width: 8), // Added spacing between icon and text
                              Text(
                                'New tip?',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          )
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: const Row(
                          children: [
                            Icon(Icons.contact_emergency),
                            SizedBox(width: 8), // Added spacing between icon and text
                            Text(
                              'Emergency?',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              
              // Fourth single card
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: const Column(
                  children: [
                    Text(
                      'Community',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
              const SizedBox(height: 16),
              
              // Fifth single card
              Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: const Column(
                  children: [
                    Text(
                      'Community',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
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
      ),
    );
  }
}
