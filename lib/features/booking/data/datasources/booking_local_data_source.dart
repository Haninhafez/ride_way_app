import '../models/passenger_model.dart';

abstract class BookingLocalDataSource {
  Future<void> saveDraftPassengers(List<PassengerModel> passengers);
  Future<List<PassengerModel>?> getDraftPassengers();
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  List<PassengerModel>? _cachedPassengers;

  @override
  Future<void> saveDraftPassengers(List<PassengerModel> passengers) async {
    _cachedPassengers = passengers;
  }

  @override
  Future<List<PassengerModel>?> getDraftPassengers() async {
    return _cachedPassengers;
  }
}
