import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final weatherData = await _farmerService.fetchWeatherForNinhThuan();
      setState(() {
        _weatherData = weatherData;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Weather information is not available';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3ECFE),
        borderRadius: BorderRadius.circular(8.0),
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
          padding: const EdgeInsets.all(16.0),
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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildWeatherItem(Icons.thermostat_outlined,
                '${_weatherData!['temperature'].toStringAsFixed(1)}°C'),
            _buildWeatherItem(Icons.air,
                '${_weatherData!['windSpeed'].toStringAsFixed(1)} km/h'),
            _buildWeatherItem(
                Icons.water_drop_outlined, '${_weatherData!['humidity']}%'),
          ],
        ),
      );
    }
  }

  Widget _buildWeatherItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
