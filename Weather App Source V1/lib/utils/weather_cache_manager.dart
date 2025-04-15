 import 'package:hive/hive.dart';
import '../models/weather_model.dart';

class WeatherCacheManager {
  static const String _boxName = 'weatherBox';
  static const Duration _cacheDuration = Duration(hours: 1); // Cache validity

  // Get the Hive box
  Box<WeatherModel> _getBox() => Hive.box<WeatherModel>(_boxName);

  // Cache weather data for a city
  Future<void> cacheWeather(String cityName, WeatherModel weather) async {
    final box = _getBox();
    await box.put(cityName.toLowerCase(), weather);
  }

  // Retrieve cached weather data for a city
  WeatherModel? getCachedWeather(String cityName) {
    final box = _getBox();
    final cachedWeather = box.get(cityName.toLowerCase());
    if (cachedWeather != null) {
      // Check if the cache is still valid (within 1 hour)
      final timeDifference = DateTime.now().difference(cachedWeather.lastUpdated);
      if (timeDifference <= _cacheDuration) {
        return cachedWeather;
      } else {
        // Cache is expired, delete it
        box.delete(cityName.toLowerCase());
      }
    }
    return null;
  }

  // Clear cache for a specific city
  Future<void> clearCache(String cityName) async {
    final box = _getBox();
    await box.delete(cityName.toLowerCase());
  }

  // Clear all cached data
  Future<void> clearAllCache() async {
    final box = _getBox();
    await box.clear();
  }
}