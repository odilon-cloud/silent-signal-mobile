import 'package:flutter/material.dart';
import 'package:silentsignal/features/crime_report_form.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int _selectedIndex = 0;

  // Add your pages here
  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120), // Adjust height as needed
        child: AppBar(
          //backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/logos/logo_silent_signal.png',
                  height: 60,
                  width: 60,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/profile.png'),
                    ),
                    Icon(Icons.notifications_none_rounded, color: Colors.black, size:35),
                  ],
                ),
                ),
            ],
          ),
        ),
        ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Community',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
         
        ],
      ),
    );
  }
}

// Example page widgets
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => CrimeReportForm()),
//               );
//             },
//             child: const Text('Report crime'),
//           ),
//         ],
//       ),
//     );
//   }
// }

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 16),
              
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
                  const SizedBox(width: 16),
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
              const SizedBox(height: 16),
              
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

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search Page'));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Page'));
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings Page'));
  }
}