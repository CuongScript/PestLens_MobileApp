import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/insect_listview.dart';
import 'package:pest_lens_app/components/my_bar_chart.dart';
import 'package:pest_lens_app/components/my_line_chart.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/weather_info_section.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:pest_lens_app/components/my_calendar_picker.dart';
import 'package:pest_lens_app/components/my_camera_box.dart';
import 'package:pest_lens_app/models/insect_count_model.dart';
import 'package:pest_lens_app/models/insect_model.dart';
import 'package:pest_lens_app/services/insect_record_service.dart';
import 'package:pest_lens_app/utils/config.dart';

class FarmerMainPage extends StatefulWidget {
  const FarmerMainPage({super.key});

  @override
  State<FarmerMainPage> createState() {
    return _FarmerMainPageState();
  }
}

class _FarmerMainPageState extends State<FarmerMainPage> {
  final PageController _pageController = PageController();
  final InsectRecordService _insectRecordService = InsectRecordService();
  List<InsectCountModel> _insectData = [];
  List<Insect> _processedInsectData = [];
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 3));
  DateTime _endDate = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 59, 59);
  Timer? _dataUpdateTimer;
  bool _isDefaultMode = true;

  @override
  void initState() {
    super.initState();
    _fetchInsectData();
    _startDataUpdateTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dataUpdateTimer?.cancel();
    super.dispose();
  }

  void _startDataUpdateTimer() {
    _dataUpdateTimer = Timer.periodic(const Duration(hours: 1), (timer) {
      if (_isDefaultMode) {
        _fetchInsectData();
      }
    });
  }

  Future<void> _fetchInsectData() async {
    try {
      final data = await _insectRecordService.fetchInsectDataRecords(
          _startDate, _endDate);

      setState(() {
        _insectData = data;
        _processedInsectData = _insectRecordService.processInsectData(data);
      });
    } catch (e) {
      print('Error fetching insect data: $e');
      setState(() {
        _insectData = [];
        _processedInsectData = [];
      });
    }
  }

  void _showCalendarPicker() {
    showDialog(
      context: context,
      builder: (context) => MyCalendarPicker(
        onDateRangeSelected: (range) {
          if (range != null) {
            if (range.end.difference(range.start).inDays > 30) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please select a range of 30 days or less '),
              ));
              return;
            }
            setState(() {
              _startDate = range.start;
              _endDate = range.end.add(const Duration(hours: 23, minutes: 59));
              _isDefaultMode = false;
            });

            _fetchInsectData();
          }
        },
        onDefaultModeSelected: _resetToDefaultMode,
      ),
    );
  }

  void _resetToDefaultMode() {
    setState(() {
      _startDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      _endDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 23, 59, 59);
      _isDefaultMode = true;
    });
    _fetchInsectData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryBackgroundColor,
          title: const Text('PH Farm', style: CustomTextStyles.pageTitle),
          elevation: 0,
          actions: [
            if (!_isDefaultMode)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _resetToDefaultMode,
              ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const WeatherInfoSection(),
            const SizedBox(
              height: 8,
            ),
            ExpandablePageView(
              controller: _pageController,
              children: [
                MyLineChart(
                    insectData: _insectData,
                    startDate: _startDate,
                    endDate: _endDate,
                    onCalendarButtonPressed: _showCalendarPicker),
                MyBarChart(onCalendarButtonPressed: _showCalendarPicker),
                const MyCameraBox(
                  url: Config.camera1APIUrl,
                  title: "Camera Feed 1",
                ),
                const MyCameraBox(
                  url: Config.camera2APIUrl,
                  title: "Camera Feed 2",
                  token: Config.camera2Token,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_startDate.day}/${_startDate.month}/${_startDate.year}-${_endDate.day}/${_endDate.month}/${_endDate.year}',
                          style: const TextStyle(
                            color: Color(0xFF0064c3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            color: Color(0xFF0064c3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: InsectListView(insects: _processedInsectData),
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
