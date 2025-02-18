import 'package:flutter/material.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

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
                    'Settings',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 40),          
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.contacts),
                      Text(
                        'Personal info',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined),
                    ],
                  ),
                ),
              ),
             const SizedBox(height: 16),
              
            
          
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}