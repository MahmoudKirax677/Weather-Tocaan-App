import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import '../models/weather_model.dart';
import '../services/weather_api_service.dart';
import '../utils/network_exceptions.dart';
import '../utils/weather_cache_manager.dart';
import '../utils/app_constants.dart';

 /// including fetching from API, loading from cache, and state management.
class WeatherController extends GetxController {
  final WeatherApiService _apiService = WeatherApiService(); // Weather API service
  final WeatherCacheManager _cacheManager = WeatherCacheManager(); // Local cache manager

  var weatherList = <WeatherModel>[].obs; // Observable list of weather data
  var isLoading = false.obs;              // Indicates if loading is in progress
  var errorMessage = ''.obs;              // Holds error messages
  var isFromCache = false.obs;            // Flag to show if data is from cache
  var lastUpdateText = ''.obs;            // Last updated time as formatted text

  Timer? _debounce; // Debounce timer for search input

  @override
  void onInit() {
    super.onInit();
    _loadCachedData(); // Load cached weather data on controller initialization
  }

  /// Loads cached data from Hive box if available
  void _loadCachedData() {
    final box = Hive.box<WeatherModel>('weatherBox');
    if (box.isNotEmpty) {
      weatherList.value = box.values.toList();
      isFromCache.value = true;
      final last = box.values.first.lastUpdated;
      lastUpdateText.value = _formatTimeAgo(last);
    }
  }

  /// Debounced version of fetchWeather to reduce API calls during typing
  void fetchWeatherDebounced(String city) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      fetchWeather(city);
    });
  }

  /// Fetches weather data for the given city, handles both cache and API fallback
  Future<void> fetchWeather(String city) async {
    isLoading.value = true;
    errorMessage.value = '';
    isFromCache.value = false;

    try {
      // Check cache first
      final cachedWeather = _cacheManager.getCachedWeather(city);
      if (cachedWeather != null) {
        weatherList.insert(0, cachedWeather);
        isFromCache.value = true;
        lastUpdateText.value = _formatTimeAgo(cachedWeather.lastUpdated);
        isLoading.value = false;
        return;
      }

      // No valid cache, fetch from API
      final weather = await _apiService.fetchWeather(city);
      await _cacheManager.cacheWeather(city, weather);
      weatherList.insert(0, weather);
      lastUpdateText.value = _formatTimeAgo(weather.lastUpdated);
    } on NetworkExceptions catch (e) {
      // If custom network exception occurs
      errorMessage.value = NetworkExceptions.getErrorMessage(e);
      _showErrorSnackBar(e);
    } catch (e) {
      // For unknown API format or missing location issues
      final fallbackMessage = e.toString().toLowerCase();
      final isLocationError = fallbackMessage.contains('no matching location');

      final exception = isLocationError
          ? NetworkExceptions.noData()
          : NetworkExceptions.unexpectedError('Something went wrong');

      errorMessage.value = NetworkExceptions.getErrorMessage(exception);
      _showErrorSnackBar(exception);
    } finally {
      isLoading.value = false;
    }
  }

  /// Formats DateTime into human-readable "time ago" style
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes <= 10) return 'Fresh';
    if (diff.inMinutes <= 60) return 'Stale';
    return 'Expired';
  }

  /// Displays a stylized snackbar error based on the exception type
  void _showErrorSnackBar(NetworkExceptions exception) {
    String message;
    Color backgroundColor;
    IconData icon;

    // Define snackbar content based on exception message
    switch (exception.message) {
      case 'No data available':
        message = 'No weather data available for this location.';
        backgroundColor = AppConstants.primaryColor.withOpacity(0.8);
        icon = Icons.warning;
        break;
      case 'No internet connection':
        message = 'Please check your internet connection and try again.';
        backgroundColor = AppConstants.primaryColor.withOpacity(0.9);
        icon = Icons.wifi_off;
        break;
      case 'Request timeout':
      case 'Connection timeout':
      case 'Receive timeout':
      case 'Send timeout':
        message = 'The request timed out. Please try again later.';
        backgroundColor = AppConstants.primaryColor.withOpacity(0.95);
        icon = Icons.timer_off;
        break;
      case 'Bad request':
      case 'Invalid input':
        message = 'Invalid city name. Please enter a valid city.';
        backgroundColor = AppConstants.primaryColor.withOpacity(0.9);
        icon = Icons.error_outline;
        break;
      case 'Unauthorized request':
        message = 'Invalid API key. Please contact support.';
        backgroundColor = AppConstants.primaryColor;
        icon = Icons.lock;
        break;
      case 'API not found':
        message = 'Weather service not found. Please try again later.';
        backgroundColor = AppConstants.primaryColor.withOpacity(0.85);
        icon = Icons.cloud_off;
        break;
      case 'Internal server error':
      case 'Service unavailable':
        message = 'Weather service is currently unavailable. Try again later.';
        backgroundColor = AppConstants.primaryColor.withOpacity(0.8);
        icon = Icons.cloud_off;
        break;
      default:
        message = exception.message;
        backgroundColor = AppConstants.primaryColor.withOpacity(0.7);
        icon = Icons.error;
    }

    // Show the snackbar with custom style
    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 10,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Text(
          'Dismiss',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}