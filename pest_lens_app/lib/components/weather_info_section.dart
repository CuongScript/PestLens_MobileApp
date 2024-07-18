import 'package:flutter/material.dart';

class WeatherInfoSection extends StatelessWidget {
  final double temperature;
  final double windSpeed;
  final int humidity;

  const WeatherInfoSection({
    super.key,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE3ECFE),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Icon(Icons.thermostat_outlined, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    '$temperature°C',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.air, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    '$windSpeed km/h',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.water_drop_outlined, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    '$humidity%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
