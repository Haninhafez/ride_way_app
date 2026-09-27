import '../models/booking_dto.dart';
import '../models/notification_dto.dart';
import '../models/passenger_seat_dto.dart';
import '../models/payment_summary_dto.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/trip_notification.dart';

abstract class TripsRemoteDataSource {
  Future<List<BookingDTO>> fetchMyBookings();
  Future<BookingDTO?> fetchBookingDetail(String bookingIdOrRef);
  Future<bool> cancelBookingTransaction(String bookingIdOrRef);
  Future<List<NotificationDTO>> fetchNotifications();
  Future<void> markNotificationRead(String id);
}

class TripsRemoteDataSourceImpl implements TripsRemoteDataSource {
  final List<BookingDTO> _mockBookings = [
    BookingDTO(
      id: 'b1',
      bookingRef: 'RW-8842-KQ',
      status: BookingStatusType.upcoming,
      trainCode: 'SE-200',
      trainName: 'Saudi Express',
      origin: 'DMM',
      destination: 'JED',
      originName: 'Dammam Central',
      destinationName: 'Jeddah Sulaimaniyah',
      travelDate: DateTime(2026, 8, 14),
      departureTime: '06:15',
      arrivalTime: '14:25',
      duration: '8h 10m',
      platform: '3',
      coach: '3',
      travelClass: 'Business',
      passengers: const [
        PassengerSeatDTO(passengerName: 'Nasser Al-Harbi', passengerType: 'Adult', seatNumber: '12A'),
        PassengerSeatDTO(passengerName: 'Layla Al-Harbi', passengerType: 'Adult', seatNumber: '12B'),
      ],
      paymentSummary: const PaymentSummaryDTO(
        paymentMethod: 'Mada •••• 4417',
        fareSubtotal: 530.0,
        feesAndVat: 93.0,
        totalPaid: 623.0,
      ),
      qrCodeData: 'RW-8842-KQ-DIGITAL-BOARDING-PASS',
    ),
    BookingDTO(
      id: 'b2',
      bookingRef: 'RW-9102-MB',
      status: BookingStatusType.upcoming,
      trainCode: 'HD-110',
      trainName: 'Haramain Highspeed',
      origin: 'JED',
      destination: 'KAEC',
      originName: 'Jeddah Sulaimaniyah',
      destinationName: 'King Abdullah Economic City',
      travelDate: DateTime(2026, 8, 20),
      departureTime: '13:00',
      arrivalTime: '13:45',
      duration: '45m',
      platform: '1',
      coach: '1',
      travelClass: 'First Class',
      passengers: const [
        PassengerSeatDTO(passengerName: 'Nasser Al-Harbi', passengerType: 'Adult', seatNumber: '4A'),
      ],
      paymentSummary: const PaymentSummaryDTO(
        paymentMethod: 'Apple Pay',
        fareSubtotal: 195.0,
        feesAndVat: 0.0,
        totalPaid: 195.0,
      ),
      qrCodeData: 'RW-9102-MB-DIGITAL-BOARDING-PASS',
    ),
    BookingDTO(
      id: 'b3',
      bookingRef: 'RW-7621-AB',
      status: BookingStatusType.completed,
      trainCode: 'SE-204',
      trainName: 'Saudi Express',
      origin: 'DMM',
      destination: 'RUH',
      originName: 'Dammam Central',
      destinationName: 'Riyadh Al Malaz',
      travelDate: DateTime(2026, 8, 1),
      departureTime: '09:30',
      arrivalTime: '13:45',
      duration: '4h 15m',
      platform: '2',
      coach: '4',
      travelClass: 'Economy',
      passengers: const [
        PassengerSeatDTO(passengerName: 'Nasser Al-Harbi', passengerType: 'Adult', seatNumber: '14B'),
      ],
      paymentSummary: const PaymentSummaryDTO(
        paymentMethod: 'Mada •••• 4417',
        fareSubtotal: 145.0,
        feesAndVat: 20.0,
        totalPaid: 165.0,
      ),
      qrCodeData: 'RW-7621-AB-DIGITAL-BOARDING-PASS',
    ),
    BookingDTO(
      id: 'b4',
      bookingRef: 'RW-6510-XP',
      status: BookingStatusType.completed,
      trainCode: 'SE-100',
      trainName: 'Saudi Express',
      origin: 'RUH',
      destination: 'DMM',
      originName: 'Riyadh Al Malaz',
      destinationName: 'Dammam Central',
      travelDate: DateTime(2026, 7, 15),
      departureTime: '17:00',
      arrivalTime: '21:15',
      duration: '4h 15m',
      platform: '1',
      coach: '2',
      travelClass: 'Business',
      passengers: const [
        PassengerSeatDTO(passengerName: 'Nasser Al-Harbi', passengerType: 'Adult', seatNumber: '8A'),
      ],
      paymentSummary: const PaymentSummaryDTO(
        paymentMethod: 'Mada •••• 4417',
        fareSubtotal: 265.0,
        feesAndVat: 35.0,
        totalPaid: 300.0,
      ),
      qrCodeData: 'RW-6510-XP-DIGITAL-BOARDING-PASS',
    ),
    BookingDTO(
      id: 'b5',
      bookingRef: 'RW-5109-CN',
      status: BookingStatusType.cancelled,
      trainCode: 'SE-310',
      trainName: 'Night Express',
      origin: 'DMM',
      destination: 'JED',
      originName: 'Dammam Central',
      destinationName: 'Jeddah Sulaimaniyah',
      travelDate: DateTime(2026, 6, 10),
      departureTime: '22:00',
      arrivalTime: '06:10',
      duration: '8h 10m',
      platform: '4',
      coach: '6',
      travelClass: 'Economy',
      passengers: const [
        PassengerSeatDTO(passengerName: 'Nasser Al-Harbi', passengerType: 'Adult', seatNumber: '20C'),
      ],
      paymentSummary: const PaymentSummaryDTO(
        paymentMethod: 'Mada •••• 4417',
        fareSubtotal: 130.0,
        feesAndVat: 15.0,
        totalPaid: 145.0,
      ),
      qrCodeData: 'RW-5109-CN-DIGITAL-BOARDING-PASS',
    ),
  ];

  final List<NotificationDTO> _mockNotifications = [
    NotificationDTO(
      id: 'n1',
      type: NotificationType.delay,
      title: 'Train SE-200 Delayed',
      message: 'SE-200 is delayed by 15 minutes due to track maintenance at DMM. Departure updated to 06:30.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      isUnread: true,
    ),
    NotificationDTO(
      id: 'n2',
      type: NotificationType.reminder,
      title: 'Upcoming Departure Reminder',
      message: 'Your train SE-200 to Jeddah departs in 2 hours from Platform 3.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isUnread: true,
    ),
    NotificationDTO(
      id: 'n3',
      type: NotificationType.confirmation,
      title: 'Booking Confirmed RW-8842-KQ',
      message: 'Your booking for 2 passengers from Dammam to Jeddah is confirmed.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isUnread: false,
    ),
    NotificationDTO(
      id: 'n4',
      type: NotificationType.payment,
      title: 'Payment Successful',
      message: 'SAR 623.00 processed via Mada •••• 4417.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isUnread: false,
    ),
    NotificationDTO(
      id: 'n5',
      type: NotificationType.refund,
      title: 'Refund Processed',
      message: 'SAR 145.00 refunded for cancelled booking RW-5109-CN.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isUnread: false,
    ),
  ];

  @override
  Future<List<BookingDTO>> fetchMyBookings() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockBookings;
  }

  @override
  Future<BookingDTO?> fetchBookingDetail(String bookingIdOrRef) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockBookings.firstWhere(
      (b) => b.id == bookingIdOrRef || b.bookingRef == bookingIdOrRef,
      orElse: () => _mockBookings.first,
    );
  }

  @override
  Future<bool> cancelBookingTransaction(String bookingIdOrRef) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockBookings.indexWhere((b) => b.id == bookingIdOrRef || b.bookingRef == bookingIdOrRef);
    if (index >= 0) {
      final old = _mockBookings[index];
      _mockBookings[index] = BookingDTO(
        id: old.id,
        bookingRef: old.bookingRef,
        status: BookingStatusType.cancelled,
        trainCode: old.trainCode,
        trainName: old.trainName,
        origin: old.origin,
        destination: old.destination,
        originName: old.originName,
        destinationName: old.destinationName,
        travelDate: old.travelDate,
        departureTime: old.departureTime,
        arrivalTime: old.arrivalTime,
        duration: old.duration,
        platform: old.platform,
        coach: old.coach,
        travelClass: old.travelClass,
        passengers: old.passengers,
        paymentSummary: old.paymentSummary,
        qrCodeData: old.qrCodeData,
      );
      return true;
    }
    return false;
  }

  @override
  Future<List<NotificationDTO>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockNotifications;
  }

  @override
  Future<void> markNotificationRead(String id) async {
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index >= 0) {
      final old = _mockNotifications[index];
      _mockNotifications[index] = NotificationDTO(
        id: old.id,
        type: old.type,
        title: old.title,
        message: old.message,
        timestamp: old.timestamp,
        isUnread: false,
      );
    }
  }
}
