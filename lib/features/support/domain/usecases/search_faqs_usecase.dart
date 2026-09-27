import '../entities/faq_item.dart';
import '../repositories/support_repository.dart';

class SearchFaqsUseCase {
  final SupportRepository repository;

  SearchFaqsUseCase(this.repository);

  Future<List<FaqItem>> execute(String query) {
    return repository.searchFaqs(query);
  }
}
