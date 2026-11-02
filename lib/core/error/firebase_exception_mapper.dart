import 'package:cloud_firestore/cloud_firestore.dart';
import 'failures.dart';

Failure mapFirebaseException(FirebaseException e) {
  switch (e.code) {
    case 'unavailable':
    case 'network-request-failed':
      return NetworkFailure(
        e.message ?? 'No connection to Firestore. Check your network.',
      );

    case 'permission-denied':
      return PermissionFailure(
        e.message ?? 'You do not have permission to access this data.',
      );
    case 'unauthenticated':
      return AuthenticationFailure(
        e.message ?? 'You must be signed in to perform this action.',
      );

    case 'not-found':
      return NotFoundFailure(
        e.message ?? 'The requested document does not exist.',
      );

    case 'resource-exhausted':
      return ServerFailure(
        e.message ?? 'Firestore quota exceeded. Please try again later.',
      );

    case 'deadline-exceeded':
      return TimeoutFailure(
        e.message ?? 'The request took too long. Please try again.',
      );

    case 'already-exists':
      return ConflictFailure(
        e.message ?? 'The document already exists.',
      );

    case 'cancelled':
      return ServerFailure(e.message ?? 'The operation was cancelled.');

    default:
      return ServerFailure(
        e.message ?? 'An unexpected Firestore error occurred (${e.code}).',
      );
  }
}
