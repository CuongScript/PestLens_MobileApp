import 'package:flutter/material.dart';
import 'package:pest_lens_app/pages/farmer/farmer_main_page.dart';
import 'package:pest_lens_app/pages/farmer/insect_lookup_page.dart';
import 'package:pest_lens_app/pages/common/setting_page.dart';

class FarmerTabPage extends StatefulWidget {
  const FarmerTabPage({super.key});

  @override
  State<FarmerTabPage> createState() => _FarmerTabPageState();
}

class _FarmerTabPageState extends State<FarmerTabPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    FarmerMainPage(),
    Text(
      "Insect Information Page",
      style: TextStyle(
        fontSize: 40,
      ),
    ),
    InsectLookupPage(),
    Text(
      "Notification Page",
      style: TextStyle(
        fontSize: 40,
      ),
    ),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    if (index != 2) {
      // 2 is reserved for FAB
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildNavBarItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? const Color(0xFF0064c3) : Colors.grey,
        size: 30,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }

  List<Widget> _buildBottomNavBarItems() {
    return [
      _buildNavBarItem(Icons.home_filled, 0),
      _buildNavBarItem(Icons.search_outlined, 1),
      const SizedBox(width: 40), // Space for FAB
      _buildNavBarItem(Icons.notifications_none_rounded, 3),
      _buildNavBarItem(Icons.settings_outlined, 4),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _selectedIndex = 2; // Navigate to InsectLookupPage
            });
          },
          backgroundColor: const Color(0xFF0064c3),
          shape: const CircleBorder(),
          elevation: 4,
          child: const Icon(
            Icons.camera_alt_outlined,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 12,
          child: SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildBottomNavBarItems(),
            ),
          ),
        ),
      ),
    );
  }
}
