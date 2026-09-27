import '../../domain/entities/support_channel.dart';
import '../models/faq_dto.dart';

abstract class SupportRemoteDataSource {
  Future<List<FaqDTO>> fetchFaqs();
  Future<List<FaqDTO>> searchFaqs(String query);
  Future<List<SupportChannel>> fetchSupportChannels();
  Future<void> setAppLocale(String languageCode);
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  static const List<FaqDTO> _mockFaqs = [
    FaqDTO(
      id: 'faq-1',
      question: 'How early should I arrive at the station?',
      answer:
          'We recommend arriving at the station at least 30 minutes before your scheduled departure time. For intercity and Haramain High-Speed trains, please arrive 45 minutes early to allow sufficient time for security screening, ticket verification, and boarding. Passengers with Nafath verification requirements should arrive 60 minutes before departure.',
      category: 'Boarding & Travel',
    ),
    FaqDTO(
      id: 'faq-2',
      question: 'Can I change my booking?',
      answer:
          'Yes, you can modify your booking up to 2 hours before the scheduled departure time. Changes can be made through the "My Trips" section in the app or by calling our support center. Date and time changes are subject to seat availability and any applicable fare difference. A nominal modification fee of SAR 15 applies per passenger. Refundable tickets allow free changes up to 24 hours before departure.',
      category: 'Booking & Cancellation',
    ),
    FaqDTO(
      id: 'faq-3',
      question: 'What is Nafath verification?',
      answer:
          'Nafath is Saudi Arabia\'s national digital identity verification service. For domestic train travel, passengers aged 18 and above must complete Nafath verification during check-in. This involves a quick biometric face scan using your smartphone or at station kiosks. The process takes approximately 30 seconds and must be completed before boarding. Please ensure your national ID or Iqama is linked to your Nafath account prior to travel.',
      category: 'Verification & Security',
    ),
    FaqDTO(
      id: 'faq-4',
      question: 'What is your refund policy?',
      answer:
          'Refundable tickets: Full refund if cancelled 24+ hours before departure, 90% refund for 12-24 hours before, 70% for 2-12 hours before. Non-refundable tickets: No cash refund, but you may receive a 50% travel voucher valid for 6 months if cancelled 12+ hours before departure. Partial refunds are issued for partially used tickets. Refunds are processed to the original payment method within 5-7 business days. No-shows are not eligible for refunds or vouchers.',
      category: 'Booking & Cancellation',
    ),
    FaqDTO(
      id: 'faq-5',
      question: 'What is the luggage allowance?',
      answer:
          'Economy class passengers are allowed 2 pieces of luggage with a total weight not exceeding 30 kg, plus 1 carry-on bag (max 7 kg). Business and First class passengers enjoy 3 pieces totaling 50 kg plus 1 carry-on (max 10 kg). Excess luggage can be pre-booked at SAR 5 per kg or paid at the station at SAR 7 per kg, subject to availability. Oversized items (bicycles, strollers) should be declared in advance. For safety, all bags must fit in designated overhead bins or under-seat storage areas.',
      category: 'Boarding & Travel',
    ),
  ];

  static const List<SupportChannel> _mockChannels = [
    SupportChannel(
      type: SupportChannelType.call,
      availabilityText: '24/7',
      actionUrl: 'tel:920003344',
    ),
    SupportChannel(
      type: SupportChannelType.liveChat,
      availabilityText: '~2 min',
      actionUrl: 'https://support.rideway.sa/chat',
    ),
    SupportChannel(
      type: SupportChannelType.email,
      availabilityText: '~4 hrs',
      actionUrl: 'support@rideway.sa',
    ),
  ];

  @override
  Future<List<FaqDTO>> fetchFaqs() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockFaqs;
  }

  @override
  Future<List<FaqDTO>> searchFaqs(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final lowerQuery = query.toLowerCase().trim();
    if (lowerQuery.isEmpty) return _mockFaqs;
    return _mockFaqs.where((faq) {
      final qMatch = (faq.question ?? '').toLowerCase().contains(lowerQuery);
      final aMatch = (faq.answer ?? '').toLowerCase().contains(lowerQuery);
      final cMatch = (faq.category ?? '').toLowerCase().contains(lowerQuery);
      return qMatch || aMatch || cMatch;
    }).toList();
  }

  @override
  Future<List<SupportChannel>> fetchSupportChannels() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockChannels;
  }

  @override
  Future<void> setAppLocale(String languageCode) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return;
  }
}
