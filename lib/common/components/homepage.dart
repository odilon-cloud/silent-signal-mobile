import 'package:flutter/material.dart';
import 'package:silentsignal/features/crime_report_form.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                    'Good Afternoon,',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
              ),
              const Text(
                    'Anonymous',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
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
                            MaterialPageRoute(builder: (context) => CrimeReportForm()),
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
                  child: const Text(
                    'Fourth Card',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Fifth single card
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'Fifth Card',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
