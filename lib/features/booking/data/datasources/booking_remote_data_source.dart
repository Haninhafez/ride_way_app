import '../models/booking_summary_model.dart';
import '../models/route_stop_model.dart';
import '../models/seat_model.dart';
import '../models/train_detail_model.dart';
import '../models/travel_class_model.dart';
import '../../domain/entities/seat.dart';

abstract class BookingRemoteDataSource {
  Future<TrainDetailModel> fetchTrainDetails(String trainId);
  Future<List<SeatModel>> fetchSeatsForCoach(String trainId, String coachNumber);
  Future<BookingSummaryModel> calculateSummary({
    required double basePrice,
    required int passengerCount,
  });
  Future<bool> processPaymentTransaction();
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  @override
  Future<TrainDetailModel> fetchTrainDetails(String trainId) async {
    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return const TrainDetailModel(
      id: 'SE-200',
      code: 'SE-200',
      name: 'Saudi Express',
      status: 'On time',
      departureTime: '06:30',
      arrivalTime: '12:45',
      duration: '6h 15m',
      departureStationCode: 'DMM',
      arrivalStationCode: 'JED',
      departureStationName: 'Dammam Central',
      arrivalStationName: 'Jeddah Sulaimaniyah',
      stops: [
        RouteStopModel(
          stationName: 'Dammam Central',
          stationCode: 'DMM',
          arrivalTime: '06:30',
          departureTime: '06:30',
          isDeparture: true,
          isPassed: true,
        ),
        RouteStopModel(
          stationName: 'Hafar Al-Batin North',
          stationCode: 'HFR',
          arrivalTime: '08:10',
          departureTime: '08:15',
          isPassed: false,
        ),
        RouteStopModel(
          stationName: 'Riyadh Al Malaz',
          stationCode: 'RUH',
          arrivalTime: '09:40',
          departureTime: '09:45',
          isPassed: false,
        ),
        RouteStopModel(
          stationName: 'King Abdullah Economic City',
          stationCode: 'KAEC',
          arrivalTime: '11:45',
          departureTime: '11:50',
          isPassed: false,
        ),
        RouteStopModel(
          stationName: 'Jeddah Sulaimaniyah',
          stationCode: 'JED',
          arrivalTime: '12:45',
          departureTime: '12:45',
          isDestination: true,
          isPassed: false,
        ),
      ],
      amenities: [
        'Wi-Fi',
        'Dining car',
        'Power outlets',
        'Quiet coach',
      ],
      classOptions: [
        TravelClassModel(
          id: 'economy',
          title: 'Economy',
          price: 145.0,
          availableSeats: 14,
          defaultCoachNumber: '6',
          perks: [
            'Standard comfortable seat',
            'Complimentary Wi-Fi',
            '1x 23kg Luggage',
          ],
        ),
        TravelClassModel(
          id: 'business',
          title: 'Business',
          price: 265.0,
          availableSeats: 6,
          defaultCoachNumber: '3',
          perks: [
            'Priority boarding & lounge access',
            'Extra legroom & wide recline',
            'Complimentary hot meal & beverages',
            'Power outlet at every seat',
          ],
        ),
        TravelClassModel(
          id: 'first',
          title: 'First Class',
          price: 420.0,
          availableSeats: 2,
          defaultCoachNumber: '1',
          perks: [
            'Private suite seating',
            'Gourmet dining menu',
            '2x 32kg Luggage + priority handle',
            'Dedicated steward service',
          ],
        ),
      ],
    );
  }

  @override
  Future<List<SeatModel>> fetchSeatsForCoach(String trainId, String coachNumber) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Generate seats for Coach 3 (Business), Coach 1 (First), Coach 6 (Economy)
    final List<SeatModel> seats = [];
    final rows = coachNumber == '1' ? 4 : (coachNumber == '3' ? 6 : 8);

    for (int r = 1; r <= rows; r++) {
      for (final letter in ['A', 'B', 'C', 'D']) {
        final seatNum = '$r$letter';
        final isOcc = (r == 1 && letter == 'C') ||
            (r == 2 && letter == 'B') ||
            (r == 4 && letter == 'A') ||
            (r == 5 && letter == 'D');

        final isAccessible = (r == 1 && letter == 'D');
        final type = (letter == 'A' || letter == 'D')
            ? SeatType.window
            : SeatType.aisle;

        seats.add(SeatModel(
          seatNumber: seatNum,
          coachNumber: coachNumber,
          isOccupied: isOcc,
          price: coachNumber == '1' ? 420.0 : (coachNumber == '3' ? 265.0 : 145.0),
          type: isAccessible ? SeatType.accessible : type,
          isAccessible: isAccessible,
        ));
      }
    }

    return seats;
  }

  @override
  Future<BookingSummaryModel> calculateSummary({
    required double basePrice,
    required int passengerCount,
  }) async {
    final subtotal = basePrice * passengerCount;
    const seatReservationFee = 20.0;
    const serviceFee = 12.0;
    final taxableAmount = subtotal + seatReservationFee + serviceFee;
    final vat = taxableAmount * 0.15;
    final grandTotal = taxableAmount + vat;

    return BookingSummaryModel(
      subtotal: subtotal,
      seatReservationFee: seatReservationFee,
      serviceFee: serviceFee,
      vat: double.parse(vat.toStringAsFixed(2)),
      grandTotal: double.parse(grandTotal.toStringAsFixed(2)),
    );
  }

  @override
  Future<bool> processPaymentTransaction() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }
}
