import 'package:dio/dio.dart';
import '../models/weather_model.dart';
import '../utils/app_constants.dart';
abstract class IWeatherService {
  /// Fetch weather data for a specific city.
  Future<WeatherModel> fetchWeather(String city);
}
/// Service responsible for calling the Weather API using Dio.
class WeatherApiService implements IWeatherService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  @override
  Future<WeatherModel> fetchWeather(String city) async {
    try {
      final response = await _dio.get(
        '/current.json', //api endpoint for current weather
        queryParameters: {
          'key': AppConstants.apiKey,
          'q': city,
          'days': 1,
        },
      );

      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      // Handle known API error
      final errorMsg = e.response?.data['error']['message'] ??
          'Failed to fetch weather data';
      throw Exception(errorMsg);
    } catch (e) {
      // Handle unknown errors
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}
