// import 'package:dio/dio.dart';

// /// Attaches "Authorization: Bearer <token>" to every outgoing request
// /// automatically. Registered ONCE on the shared Dio instance in DI.
// class AuthInterceptor extends Interceptor {
//   final TokenLocalDataSource tokenLocalDataSource;

//   AuthInterceptor(this.tokenLocalDataSource);

//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     // Skip attaching the token for requests explicitly marked as public
//     if (options.extra['skipAuth'] == true) {
//       return handler.next(options);
//     }

//     final token = await tokenLocalDataSource.getToken();
//     if (token != null && token.isNotEmpty) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }

//     handler.next(options);
//   }

//   @override
//   void onError(
//     DioException err,
//     ErrorInterceptorHandler handler,
//   ) async {
//     // Token expired/invalid -> clear it so the app can redirect to login
//     if (err.response?.statusCode == 401) {
//       await tokenLocalDataSource.deleteToken();
//     }

//     handler.next(err);
//   }
// }
