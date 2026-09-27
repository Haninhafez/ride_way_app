class ApiEndPoints {
  static const String login = 'http://authenticationtest.runasp.net/Auth/login';
  static const String register =
      'http://authenticationtest.runasp.net/Auth/register';
  static const String refreshToken =
      'http://authenticationtest.runasp.net/Auth/refresh';
  static const String revokeToken =
      'http://authenticationtest.runasp.net/Auth/revoke-refresh-token';
  static const String stations = 'https://dummyjson.com/c/bfa6-97a2-49db-bb81';

  // Search / Trains
  static const String trainsSearch =
      "https://dummyjson.com/c/9cf2-3b5f-4eae-a4ea";
  static const String trainDetails =
      "https://dummyjson.com/c/be71-4399-4b4f-851d";

  // Seats
  static const String trainSeats =
      "https://dummyjson.com/c/caca-e79c-4f86-97bf";

  // Booking
  static const String bookingCreate =
      "https://dummyjson.com/c/4a38-25b4-4eb2-91a4";

  // Payment
  static const String paymentSuccess =
      "https://dummyjson.com/c/aaf6-e2e1-4e91-830b";
  static const String paymentFailure =
      "https://dummyjson.com/c/4982-ead5-454d-928c";

  // Ticket
  static const String ticket = "https://dummyjson.com/c/a238-de7e-4839-a310";

  // My Bookings
  static const String myBookings =
      "https://dummyjson.com/c/5da5-b4ef-429e-b558";

  // Notifications
  static const String notifications =
      "https://dummyjson.com/c/bd34-d0ea-4cfd-b225";

  // Empty / Error States
  static const String trainsSearchEmpty =
      "https://dummyjson.com/c/15fe-aa89-4fc7-8b90";
  static const String trainsSearchError = "";
  static const String myBookingsEmpty = "";
  static const String notificationsEmpty = "";
  static const String genericNetworkError = "";
}

class ApiKeys {
  static const String id = "id";
  static const String email = 'email';
  static const String token = 'token';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String expiresIn = 'expiresIn';
  static const String refreshToken = 'refreshToken';
  static const String refreshTokenExpiration = 'refreshTokenExpiration';
}
