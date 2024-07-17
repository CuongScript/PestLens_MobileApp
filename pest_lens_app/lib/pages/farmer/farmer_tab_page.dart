import 'package:flutter/material.dart';
import 'package:pest_lens_app/pages/farmer/farmer_main_page.dart';
import 'package:pest_lens_app/pages/farmer/insect_lookup_page.dart';
import 'package:pest_lens_app/pages/user/setting_page.dart';

class FarmerTabPage extends StatefulWidget {
  const FarmerTabPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FarmerTabPageState();
  }
}

class _FarmerTabPageState extends State<FarmerTabPage> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const FarmerMainPage();

    var activePageTitle = 'Farmer';

    if (_selectedPageIndex == 1) {
      activePage = const Center(
        child: InsectLookupPage(),
      );
      activePageTitle = 'Upload';
    } else if (_selectedPageIndex == 2) {
      activePage = const Center(child: SettingsPage());
      activePageTitle = 'Settings';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.upload_sharp,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: '',
          )
        ],
      ),
    );
  }
}
