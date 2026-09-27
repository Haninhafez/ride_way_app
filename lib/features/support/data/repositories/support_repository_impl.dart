import '../../domain/entities/faq_item.dart';
import '../../domain/entities/support_channel.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_data_source.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  SupportRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<FaqItem>> getFaqs() async {
    final faqs = await remoteDataSource.fetchFaqs();
    return faqs.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<FaqItem>> searchFaqs(String query) async {
    final faqs = await remoteDataSource.searchFaqs(query);
    return faqs.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<SupportChannel>> getSupportChannels() {
    return remoteDataSource.fetchSupportChannels();
  }

  @override
  Future<void> setAppLocale(String languageCode) {
    return remoteDataSource.setAppLocale(languageCode);
  }
}
