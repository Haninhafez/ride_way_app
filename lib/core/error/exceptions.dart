
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  NoInternetException([super.message = 'No internet connection. Please check your network.']);
}

class TimeoutException extends AppException {
  TimeoutException([super.message = 'The request took too long. Please try again.']);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Session expired. Please login again.']);
}

class ForbiddenException extends AppException {
  ForbiddenException([super.message = 'You don\'t have permission to do this.']);
}

class NotFoundException extends AppException {
  NotFoundException([super.message = 'Requested data not found.']);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors; 
  ValidationException(super.message, {this.errors});
}

class ServerException extends AppException {
  ServerException([super.message = 'Something went wrong on our server. Please try again later.']);
}

class ParsingException extends AppException {
  ParsingException([super.message = 'Unexpected response format.']);
}

class CacheException extends AppException {
  CacheException([super.message = 'Failed to load saved data.']);
}

class UnknownException extends AppException {
  UnknownException([super.message = 'Unexpected error occurred.']);
}