// core/errors/app_exceptions.dart

/// Base class for all app exceptions.
/// Every custom exception has a user-friendly message
/// that you can show directly in a SnackBar or Text widget.
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

/// No internet connection at all (checked before calling the API)
class NoInternetException extends AppException {
  NoInternetException([String message = 'No internet connection. Please check your network.'])
      : super(message);
}

/// Request took too long (connect / send / receive timeout)
class TimeoutException extends AppException {
  TimeoutException([String message = 'The request took too long. Please try again.'])
      : super(message);
}

/// Wrong email/password, missing token, expired token (401)
class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Session expired. Please login again.'])
      : super(message);
}

/// User is logged in but not allowed to do this action (403)
class ForbiddenException extends AppException {
  ForbiddenException([String message = 'You don\'t have permission to do this.'])
      : super(message);
}

/// Resource not found (404)
class NotFoundException extends AppException {
  NotFoundException([String message = 'Requested data not found.'])
      : super(message);
}

/// Validation errors from backend (422) - wrong form data etc.
class ValidationException extends AppException {
  final Map<String, dynamic>? errors; // e.g. {"email": ["already taken"]}
  ValidationException(String message, {this.errors}) : super(message);
}

/// Server crashed or returned 500/502/503
class ServerException extends AppException {
  ServerException([String message = 'Something went wrong on our server. Please try again later.'])
      : super(message);
}

/// Response body wasn't valid JSON / fields missing (fromJson failed)
class ParsingException extends AppException {
  ParsingException([String message = 'Unexpected response format.'])
      : super(message);
}

/// Local storage / cache errors (SharedPreferences, Hive, etc.)
class CacheException extends AppException {
  CacheException([String message = 'Failed to load saved data.'])
      : super(message);
}

/// Anything else we didn't expect
class UnknownException extends AppException {
  UnknownException([String message = 'Unexpected error occurred.'])
      : super(message);
}