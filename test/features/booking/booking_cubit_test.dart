import 'package:flutter_test/flutter_test.dart';
import 'package:ride_way_app/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:ride_way_app/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:ride_way_app/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:ride_way_app/features/booking/domain/entities/payment_method.dart';
import 'package:ride_way_app/features/booking/domain/entities/seat.dart';
import 'package:ride_way_app/features/booking/domain/usecases/get_train_details_usecase.dart';
import 'package:ride_way_app/features/booking/domain/usecases/process_payment_usecase.dart';
import 'package:ride_way_app/features/booking/domain/usecases/select_seat_usecase.dart';
import 'package:ride_way_app/features/booking/domain/usecases/validate_passengers_usecase.dart';
import 'package:ride_way_app/features/booking/presentation/cubit/booking_cubit.dart';

void main() {
  late BookingCubit cubit;
  late BookingRepositoryImpl repository;

  setUp(() {
    final remoteDataSource = BookingRemoteDataSourceImpl();
    final localDataSource = BookingLocalDataSourceImpl();
    repository = BookingRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    cubit = BookingCubit(
      getTrainDetailsUseCase: GetTrainDetailsUseCase(repository),
      selectSeatUseCase: SelectSeatUseCase(repository),
      validatePassengersUseCase: ValidatePassengersUseCase(repository),
      processPaymentUseCase: ProcessPaymentUseCase(repository),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('loadTrainDetails initializes train SE-200 and Business class correctly', () async {
    await cubit.loadTrainDetails('SE-200');

    expect(cubit.state.trainDetail, isNotNull);
    expect(cubit.state.trainDetail!.code, equals('SE-200'));
    expect(cubit.state.selectedClass!.id, equals('business'));
    expect(cubit.state.selectedSeats.length, equals(2));
    expect(cubit.state.passengers.length, equals(2));
    expect(cubit.state.summary, isNotNull);
  });

  test('toggleSeatSelection updates selectedSeats and passenger assignments', () async {
    await cubit.loadTrainDetails('SE-200');

    const newSeat = Seat(
      seatNumber: '2B',
      coachNumber: '3',
      isOccupied: false,
      price: 265.0,
    );

    cubit.toggleSeatSelection(newSeat);

    expect(cubit.state.selectedSeats.contains(newSeat), isTrue);
    expect(cubit.state.passengers.any((p) => p.assignedSeat == newSeat), isTrue);
  });

  test('selectPaymentMethod updates selected payment method', () {
    cubit.selectPaymentMethod(PaymentMethodType.applePay);
    expect(cubit.state.selectedPaymentMethod, equals(PaymentMethodType.applePay));
  });
}
