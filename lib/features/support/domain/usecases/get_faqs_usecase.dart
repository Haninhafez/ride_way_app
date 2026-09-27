import '../entities/faq_item.dart';
import '../repositories/support_repository.dart';

class GetFaqsUseCase {
  final SupportRepository repository;

  GetFaqsUseCase(this.repository);

  Future<List<FaqItem>> execute() {
    return repository.getFaqs();
  }
}
