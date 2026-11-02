import 'package:dio/dio.dart';
import 'package:ride_way_app/core/error/exceptions.dart';

class DioErrorHandler {
  static AppException handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();

      case DioExceptionType.connectionError:
        return NoInternetException();

      case DioExceptionType.badCertificate:
        return UnknownException('Security certificate error.');

      case DioExceptionType.cancel:
        return UnknownException('Request was cancelled.');

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.unknown:
      default:
        if (error.message?.contains('SocketException') ?? false) {
          return NoInternetException();
        }
        return UnknownException(error.message ?? 'Unexpected error occurred.');
    }
  }

  static AppException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String? serverMessage;
    if (data is Map<String, dynamic>) {
      serverMessage = data['message'] ?? data['error'];
    }

    switch (statusCode) {
      case 400:
        return ValidationException(serverMessage ?? 'Invalid request.');
      case 401:
        return UnauthorizedException(serverMessage ?? 'Session expired. Please login again.');
      case 403:
        return ForbiddenException(serverMessage ?? 'You don\'t have permission to do this.');
      case 404:
        return NotFoundException(serverMessage ?? 'Requested data not found.');
      case 422:
        return ValidationException(
          serverMessage ?? 'Please check your input.',
          errors: data is Map<String, dynamic> ? data['errors'] : null,
        );
      case 500:
      case 502:
      case 503:
        return ServerException(serverMessage ?? 'Server error. Please try again later.');
      default:
        return UnknownException(serverMessage ?? 'Something went wrong (code $statusCode).');
    }
  }
}