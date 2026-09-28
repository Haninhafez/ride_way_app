// core/error/exception_to_failure_mapper.dart



import 'package:ride_way_app/core/error/exceptions.dart';
import 'package:ride_way_app/core/error/failures.dart';


Failure mapExceptionToFailure(AppException exception) {
  switch (exception.runtimeType) {
    case NoInternetException:
      return NetworkFailure(exception.message);

    case TimeoutException:
      return TimeoutFailure(exception.message);

    case UnauthorizedException:
      return AuthenticationFailure(exception.message);

    case ForbiddenException:
      return AuthorizationFailure(exception.message);

    case NotFoundException:
      return NotFoundFailure(exception.message);

    case ValidationException:
      return ValidationFailure(exception.message);

    case ServerException:
      return ServerFailure(exception.message);

    case CacheException:
      return CacheFailure(exception.message);

    // ParsingException, UnknownException, وأي حاجة تانية مش متوقعة
    default:
      return UnknownFailure(exception.message);
  }
}