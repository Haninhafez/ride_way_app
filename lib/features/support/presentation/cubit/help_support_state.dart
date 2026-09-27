import 'package:equatable/equatable.dart';
import '../../domain/entities/faq_item.dart';
import '../../domain/entities/support_channel.dart';

enum HelpSupportStatus { initial, loading, loaded, error }

class HelpSupportState extends Equatable {
  final HelpSupportStatus status;
  final String searchQuery;
  final List<FaqItem> faqs;
  final List<FaqItem> filteredFaqs;
  final List<SupportChannel> channels;
  final String selectedLanguage;
  final String? errorMessage;

  const HelpSupportState({
    this.status = HelpSupportStatus.initial,
    this.searchQuery = '',
    this.faqs = const [],
    this.filteredFaqs = const [],
    this.channels = const [],
    this.selectedLanguage = 'en',
    this.errorMessage,
  });

  factory HelpSupportState.initial() {
    return const HelpSupportState();
  }

  HelpSupportState copyWith({
    HelpSupportStatus? status,
    String? searchQuery,
    List<FaqItem>? faqs,
    List<FaqItem>? filteredFaqs,
    List<SupportChannel>? channels,
    String? selectedLanguage,
    String? errorMessage,
  }) {
    return HelpSupportState(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      faqs: faqs ?? this.faqs,
      filteredFaqs: filteredFaqs ?? this.filteredFaqs,
      channels: channels ?? this.channels,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        searchQuery,
        faqs,
        filteredFaqs,
        channels,
        selectedLanguage,
        errorMessage,
      ];
}
