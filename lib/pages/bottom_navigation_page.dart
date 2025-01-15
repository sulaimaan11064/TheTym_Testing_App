import 'package:firstapp/pages/add_task_page.dart';
import 'package:firstapp/pages/calender_page.dart';
import 'package:firstapp/pages/dashboard_page.dart';
import 'package:firstapp/pages/profile/profile_page.dart';
import 'package:firstapp/pages/project/add_project_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    AddTaskPage(),
    AddProjectPage(),
    CalenderPage(),
    ProfilePage()
  ];

  void _onTabTapped(int index) {
    // if (index == 4) {
    //   logout();
    // } else {
      setState(() {
        _currentIndex = index;
      });
   // }
  }

  void logout() {
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomNavHeight = screenHeight * 0.10;

    return Scaffold(
      body: _pages[_currentIndex],  
      bottomNavigationBar: Container(
        color: Colors.black,  
        height: bottomNavHeight, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.task, 'Task', 1),
            _buildNavItem(Icons.file_copy, 'Project', 2),
            _buildNavItem(Icons.calendar_month, 'Event', 3),
            _buildNavItem(Icons.person, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  // Helper method to build each navigation item
Widget _buildNavItem(IconData icon, String label, int index) {
  bool isSelected = _currentIndex == index;

  return GestureDetector(
    onTap: () => _onTabTapped(index),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8), 
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF72162) : Colors.transparent, 
            borderRadius: BorderRadius.circular(12), 
            border: Border.all(
              color: isSelected ? const Color(0xFFF72162)  : Colors.transparent, 
              width: 1.5, 
            ),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white, 
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color:  Colors.white,
          ),
        ),
      ],
    ),
  );
}

}
