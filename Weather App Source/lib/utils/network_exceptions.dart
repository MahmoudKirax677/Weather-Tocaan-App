import 'package:dio/dio.dart';

class NetworkExceptions implements Exception {
  final String message;
  
  const NetworkExceptions(this.message);

  // Default error creators
  static NetworkExceptions defaultError([String? message]) => 
      NetworkExceptions(message ?? 'Something went wrong');
  
  static NetworkExceptions noInternetConnection() => 
      const NetworkExceptions('No internet connection');
      
  static NetworkExceptions badRequest([String? message]) => 
      NetworkExceptions(message ?? 'Bad request');
      
  static NetworkExceptions notFound(String reason) => 
      NetworkExceptions(reason);
      
  static NetworkExceptions requestCancelled() => 
      const NetworkExceptions('Request was cancelled');
      
  static NetworkExceptions methodNotAllowed() => 
      const NetworkExceptions('Method not allowed');
      
  static NetworkExceptions conflict() => 
      const NetworkExceptions('Conflict occurred');
      
  static NetworkExceptions unauthorizedRequest() => 
      const NetworkExceptions('Unauthorized request');
      
  static NetworkExceptions noData() => 
      const NetworkExceptions('No data available');
      
  static NetworkExceptions invalidEmail() => 
      const NetworkExceptions('Invalid email address');
      
  static NetworkExceptions userNotFound() => 
      const NetworkExceptions('User not found');
      
  static NetworkExceptions invalidPassword() => 
      const NetworkExceptions('Invalid password');
      
  static NetworkExceptions invalidInput() => 
      const NetworkExceptions('Invalid input');
      
  static NetworkExceptions invalidResponse() => 
      const NetworkExceptions('Invalid response from server');
      
  static NetworkExceptions requestTimeout() => 
      const NetworkExceptions('Request timeout');
      
  static NetworkExceptions serviceUnavailable() => 
      const NetworkExceptions('Service unavailable');
      
  static NetworkExceptions forbidden() => 
      const NetworkExceptions('Access forbidden');
      
  static NetworkExceptions internalServerError() => 
      const NetworkExceptions('Internal server error');
      
  static NetworkExceptions badCertificate() => 
      const NetworkExceptions('Bad certificate');
      
  static NetworkExceptions connectionError() => 
      const NetworkExceptions('Connection error');

  /// Converts DioException to NetworkExceptions
  static NetworkExceptions fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return requestCancelled();
        
      case DioExceptionType.connectionTimeout:
        return const NetworkExceptions('Connection timeout');
        
      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return noInternetConnection();
        }
        return defaultError(error.error?.toString());
        
      case DioExceptionType.receiveTimeout:
        return const NetworkExceptions('Receive timeout');
        
      case DioExceptionType.sendTimeout:
        return const NetworkExceptions('Send timeout');
        
      case DioExceptionType.badCertificate:
        return badCertificate();
        
      case DioExceptionType.connectionError:
        return connectionError();
        
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        
        switch (statusCode) {
          case 400:
            return badRequest(_extractErrorMessage(data));
          case 401:
            return unauthorizedRequest();
          case 403:
            return forbidden();
          case 404:
            return notFound("API not found");
          case 405:
            return methodNotAllowed();
          case 408:
            return requestTimeout();
          case 409:
            return conflict();
          case 422:
            return invalidInput();
          case 500:
            return internalServerError();
          case 503:
            return serviceUnavailable();
          default:
            return defaultError(
              'Received invalid status code: $statusCode'
            );
        }
        
      default:
        return defaultError('Unexpected error occurred');
    }
  }

  /// Handles unexpected errors
  static NetworkExceptions unexpectedError(String message) {
    return NetworkExceptions(message);
  }

  /// Returns the error message
  static String getErrorMessage(NetworkExceptions exception) {
    return exception.message;
  }
  
  /// Extract error message from response data
  static String _extractErrorMessage(dynamic data) {
    if (data == null) return 'Unknown error';
    
    if (data is Map) {
      final message = data['message'] ?? 
                     data['error'] ?? 
                     data['errors']?.toString();
      if (message != null) return message.toString();
    }
    
    if (data is String) return data;
    
    return 'Unknown error';
  }

  @override
  String toString() => message;
}