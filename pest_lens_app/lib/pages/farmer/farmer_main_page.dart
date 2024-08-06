import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/insect_listview.dart';
import 'package:pest_lens_app/components/my_bar_chart.dart';
import 'package:pest_lens_app/components/my_line_chart.dart';
import 'package:pest_lens_app/components/weather_info_section.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:pest_lens_app/components/my_calendar_picker.dart';
import 'package:pest_lens_app/components/my_camera_box.dart';

class FarmerMainPage extends StatefulWidget {
  const FarmerMainPage({super.key});

  @override
  State<FarmerMainPage> createState() {
    return _FarmerMainPageState();
  }
}

class _FarmerMainPageState extends State<FarmerMainPage> {
  final PageController _pageController = PageController();
  DateTimeRange? _selectedDateRange;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showCalendarPicker() {
    showDialog(
      context: context,
      builder: (context) => MyCalendarPicker(
        onDateRangeSelected: (range) {
          setState(() {
            _selectedDateRange = range;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FARM NAME',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const WeatherInfoSection(
              windSpeed: 20,
              humidity: 40,
              temperature: 30,
            ),
            const SizedBox(
              height: 16,
            ),
            ExpandablePageView(
              controller: _pageController,
              children: [
                MyLineChart(onCalendarButtonPressed: _showCalendarPicker),
                MyBarChart(onCalendarButtonPressed: _showCalendarPicker),
                const MyCameraBox(
                    url:
                        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '22/5-28/5/2024', // change to correct date range
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Quantity',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: InsectListView(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
