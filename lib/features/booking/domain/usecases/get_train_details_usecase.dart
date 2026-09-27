import '../entities/train_detail.dart';
import '../repositories/booking_repository.dart';

class GetTrainDetailsUseCase {
  final BookingRepository repository;

  GetTrainDetailsUseCase(this.repository);

  Future<TrainDetail> execute(String trainId) {
    return repository.getTrainDetails(trainId);
  }
}
