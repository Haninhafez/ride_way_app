import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/faq_item.dart';
import '../../domain/repositories/support_repository.dart';
import '../../domain/usecases/get_faqs_usecase.dart';
import '../../domain/usecases/search_faqs_usecase.dart';
import 'help_support_state.dart';

class HelpSupportCubit extends Cubit<HelpSupportState> {
  final GetFaqsUseCase getFaqsUseCase;
  final SearchFaqsUseCase searchFaqsUseCase;
  final SupportRepository supportRepository;

  HelpSupportCubit({
    required this.getFaqsUseCase,
    required this.searchFaqsUseCase,
    required this.supportRepository,
  }) : super(HelpSupportState.initial());

  Future<void> loadInitialData() async {
    emit(state.copyWith(status: HelpSupportStatus.loading));
    try {
      final faqs = await getFaqsUseCase.execute();
      final channels = await supportRepository.getSupportChannels();

      emit(state.copyWith(
        status: HelpSupportStatus.loaded,
        faqs: faqs,
        filteredFaqs: faqs,
        channels: channels,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HelpSupportStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> updateSearchQuery(String query) async {
    emit(state.copyWith(searchQuery: query));
    if (query.trim().isEmpty) {
      emit(state.copyWith(filteredFaqs: state.faqs));
      return;
    }
    try {
      final results = await searchFaqsUseCase.execute(query);
      emit(state.copyWith(filteredFaqs: results));
    } catch (e) {
      emit(state.copyWith(filteredFaqs: const []));
    }
  }

  void toggleFaqExpanded(String faqId) {
    final updatedFaqs = state.faqs.map((faq) {
      if (faq.id == faqId) {
        return faq.toggleExpanded();
      }
      return faq;
    }).toList();

    final updatedFilteredFaqs = state.filteredFaqs.map((faq) {
      if (faq.id == faqId) {
        return faq.toggleExpanded();
      }
      return faq;
    }).toList();

    emit(state.copyWith(
      faqs: updatedFaqs,
      filteredFaqs: updatedFilteredFaqs,
    ));
  }

  Future<void> setLanguage(String code) async {
    if (code != 'en' && code != 'ar') return;
    try {
      await supportRepository.setAppLocale(code);
      emit(state.copyWith(selectedLanguage: code));
    } catch (e) {
      // Ignore locale change errors
    }
  }

  void clearSearch() {
    emit(state.copyWith(
      searchQuery: '',
      filteredFaqs: state.faqs,
    ));
  }
}
