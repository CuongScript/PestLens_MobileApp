import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/services/famer_service.dart';

class WeatherInfoSection extends StatefulWidget {
  const WeatherInfoSection({Key? key}) : super(key: key);

  @override
  _WeatherInfoSectionState createState() => _WeatherInfoSectionState();
}

class _WeatherInfoSectionState extends State<WeatherInfoSection> {
  final FarmerService _farmerService = FarmerService();
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String? _errorMessage;
  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    _mounted = true;
    _fetchWeatherData();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final weatherData = await _farmerService.fetchWeatherForNinhThuan();
      if (_mounted) {
        setState(() {
          _weatherData = weatherData;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      if (_mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Weather information is not available';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 6.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWeatherItem(Icons.thermostat_rounded,
                '${_weatherData!['temperature'].toStringAsFixed(1)}°C'),
            _buildWeatherItem(Icons.air_rounded,
                '${_weatherData!['windSpeed'].toStringAsFixed(1)} km/h'),
            _buildWeatherItem(
                Icons.water_drop_rounded, '${_weatherData!['humidity']}%'),
          ],
        ),
      );
    }
  }

  Widget _buildWeatherItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 30,
          color: fontTitleColor,
          weight: 100,
        ),
        const SizedBox(height: 4),
        Text(text, style: CustomTextStyles.subtitle),
      ],
    );
  }
}
