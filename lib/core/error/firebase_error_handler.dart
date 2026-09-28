import 'package:firebase_core/firebase_core.dart';
import 'exceptions.dart';

class FirebaseErrorHandler {
  /// Handles Firestore Database Errors
  static ServerException handleFirestoreError(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return ServerException(
          'You do not have permission to access or modify this data.',
        );
      case 'not-found':
        return ServerException('The requested document was not found.');
      case 'already-exists':
        return ServerException(
          'The document you are trying to create already exists.',
        );
      case 'resource-exhausted':
        return ServerException(
          'Quota exceeded or server resources exhausted. Please try again later.',
        );
      case 'cancelled':
        return ServerException('The operation was cancelled.');
      case 'unavailable':
        return ServerException(
          'The Firestore service is currently unavailable. Check your internet connection.',
        );
      case 'deadline-exceeded':
        return ServerException(
          'The request took too long to complete. Please try again.',
        );
      case 'unauthenticated':
        return ServerException(
          'User is not authenticated. Please log in again.',
        );
      default:
        return ServerException(
          exception.message ?? 'An unexpected Firestore error occurred.',
        );
    }
  }

  /// Handles Firebase Messaging (FCM / Notifications) Errors
  static ServerException handleNotificationError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'messaging/invalid-apns-credentials':
          return ServerException(
            'Invalid APNs credentials for push notifications.',
          );
        case 'messaging/notifications-blocked':
        case 'permission-blocked':
          return ServerException(
            'Notification permissions are blocked by the user.',
          );
        case 'messaging/token-subscribe-failed':
          return ServerException(
            'Failed to subscribe to the notification topic.',
          );
        default:
          return ServerException(
            error.message ?? 'Failed to process push notification service.',
          );
      }
    } else {
      return ServerException(
        error.toString().contains('permission')
            ? 'Notification permissions were denied.'
            : 'An unexpected notification error occurred.',
      );
    }
  }
}
