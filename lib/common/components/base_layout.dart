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
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
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

  // Method to build the app header
  Widget _buildAppHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10), // Reduced from 20
          child: Image.asset(
            'assets/logos/logo_silent_signal.png',
            height: 50, // Reduced from 60
            width: 50,  // Reduced from 60
          ),
        ),
        const SizedBox(height: 8), // Reduced from 10
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _openProfileImage,
                child: const Hero(
                  tag: 'profileImage',
                  child: CircleAvatar(
                    radius: 18, // Slightly smaller
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                ),
              ),
              const Icon(Icons.notifications_none_rounded, color: Colors.black, size: 30), // Reduced from 35
            ],
          ),
        ),
        const SizedBox(height: 12), // Reduced from 20
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Special handling for HomePage (index 0) - scrolling header
    if (_selectedIndex == 0) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App header that scrolls with content (only for HomePage)
              SliverToBoxAdapter(
                child: _buildAppHeader(),
              ),
              
              // HomePage content that scrolls with the header
              SliverToBoxAdapter(
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    }
    
    // For all other pages - fixed header
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed header for other pages
          Container(
            color: Colors.transparent,
            child: SafeArea(
              child: _buildAppHeader(),
            ),
          ),
          
          // Page content - takes remaining space
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }
}

