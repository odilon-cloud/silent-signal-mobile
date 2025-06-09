import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/community_page.dart';
import 'package:silentsignal/common/components/emergency_page.dart';
import 'package:silentsignal/common/components/event_page.dart';
import 'package:silentsignal/common/components/homepage.dart';
import 'package:silentsignal/common/components/profile_page.dart';
import 'package:silentsignal/common/components/search_report_page.dart';

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
    const CommunityPage(),
    const EmergencyPage(),
    const EventsPage(),
    const ProfilePage(),
  ];

  void _openProfileImage() {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false, // Remove default back button
          actions: [
            // Add X button in the corner
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          // Navigate to a crime reports search page or show a dialog
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchReportPage()),
          );
        },
      )
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Hero(
            tag: 'profileImage',
            child: Image.asset(
              'assets/profile.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // Adjust height as needed
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/logos/logo_silent_signal.png',
                  height: 60,
                  width: 60,
                ),
              ),
              const Padding(
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
  
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
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
            icon: Icon(Icons.alarm_sharp),
            label: '',
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