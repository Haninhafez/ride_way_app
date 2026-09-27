import '../entities/faq_item.dart';
import '../entities/support_channel.dart';

abstract class SupportRepository {
  Future<List<FaqItem>> getFaqs();
  Future<List<FaqItem>> searchFaqs(String query);
  Future<List<SupportChannel>> getSupportChannels();
  Future<void> setAppLocale(String languageCode);
}
