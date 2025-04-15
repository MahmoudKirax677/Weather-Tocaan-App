// lib/models/weather_model.dart
import 'package:hive/hive.dart';

part 'weather_model.g.dart'; // This will be generated by Hive

@HiveType(typeId: 0)
class WeatherModel {
  @HiveField(0)
  final String cityName;

  @HiveField(1)
  final double currentTemp;

  @HiveField(2)
  final double maxTemp;

  @HiveField(3)
  final double minTemp;

  @HiveField(4)
  final String conditionText;

  @HiveField(5)
  final String iconUrl;

  @HiveField(6)
  final DateTime lastUpdated; // To track when the data was cached

  WeatherModel({
    required this.cityName,
    required this.currentTemp,
    required this.maxTemp,
    required this.minTemp,
    required this.conditionText,
    required this.iconUrl,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
  return WeatherModel(
    cityName: json['location']['name'],
    currentTemp: json['current']['temp_c'],
    minTemp: json['current']['temp_c'], // since current.json doesn't return min/max, you can use same temp or hardcode fallback
    maxTemp: json['current']['temp_c'],
    conditionText: json['current']['condition']['text'],
    iconUrl: "https:${json['current']['condition']['icon']}",
    lastUpdated: DateTime.now(),
  );
}

}