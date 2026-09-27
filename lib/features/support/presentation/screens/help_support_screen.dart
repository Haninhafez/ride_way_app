import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ride_way_app/features/support/data/datasources/support_remote_data_source.dart';
import 'package:ride_way_app/features/support/data/repositories/support_repository_impl.dart';
import 'package:ride_way_app/features/support/domain/entities/faq_item.dart';
import 'package:ride_way_app/features/support/domain/entities/support_channel.dart';
import 'package:ride_way_app/features/support/domain/repositories/support_repository.dart';
import 'package:ride_way_app/features/support/domain/usecases/get_faqs_usecase.dart';
import 'package:ride_way_app/features/support/domain/usecases/search_faqs_usecase.dart';
import 'package:ride_way_app/features/support/presentation/cubit/help_support_cubit.dart';
import 'package:ride_way_app/features/support/presentation/cubit/help_support_state.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    final SupportRemoteDataSource remoteDataSource =
        SupportRemoteDataSourceImpl();
    final SupportRepository supportRepository =
        SupportRepositoryImpl(remoteDataSource: remoteDataSource);
    final GetFaqsUseCase getFaqsUseCase = GetFaqsUseCase(supportRepository);
    final SearchFaqsUseCase searchFaqsUseCase =
        SearchFaqsUseCase(supportRepository);

    return BlocProvider(
      create: (_) => HelpSupportCubit(
        getFaqsUseCase: getFaqsUseCase,
        searchFaqsUseCase: searchFaqsUseCase,
        supportRepository: supportRepository,
      )..loadInitialData(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<HelpSupportCubit>();
          return Scaffold(
            backgroundColor: kColorBackground,
            appBar: AppBar(
              backgroundColor: kColorBackground,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_back_ios,
                  color: kColorPrimaryAction,
                  size: 20,
                ),
              ),
              title: const Text(
                'Help & support',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: kColorPrimaryAction,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Semantics(
                    label: 'Search help topics',
                    textField: true,
                    child: CustomTextField(
                      hint: 'Search help topics',
                      prefixIcon: Icons.search,
                      onChanged: cubit.updateSearchQuery,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Contact us',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kColorPrimaryAction,
                    ),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<HelpSupportCubit, HelpSupportState>(
                    builder: (context, state) {
                      return Row(
                        children: state.channels.asMap().entries.map((entry) {
                          final index = entry.key;
                          final channel = entry.value;
                          final isLast = index == state.channels.length - 1;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: isLast ? 0 : 8),
                              child: _ChannelCard(channel: channel),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Frequently asked',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kColorPrimaryAction,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: BlocBuilder<HelpSupportCubit, HelpSupportState>(
                      builder: (context, state) {
                        return Column(
                          children: state.filteredFaqs.map((faq) {
                            return _FaqTile(
                              faq: faq,
                              onTap: () => cubit.toggleFaqExpanded(faq.id),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: BlocBuilder<HelpSupportCubit, HelpSupportState>(
                      builder: (context, state) {
                        return ListTile(
                          minTileHeight: 48,
                          leading: const Icon(
                            Icons.translate_outlined,
                            color: kColorAccentGold,
                            size: 22,
                          ),
                          title: const Text(
                            'Language',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: SegmentedButton<String>(
                            segments: const [
                              ButtonSegment<String>(
                                value: 'en',
                                label: Text('English'),
                              ),
                              ButtonSegment<String>(
                                value: 'ar',
                                label: Text('العربية'),
                              ),
                            ],
                            selected: {state.selectedLanguage},
                            onSelectionChanged: (s) =>
                                cubit.setLanguage(s.first),
                            style: SegmentedButton.styleFrom(
                              foregroundColor: kColorPrimaryAction,
                              selectedForegroundColor: Colors.white,
                              selectedBackgroundColor: kColorPrimaryAction,
                              side: const BorderSide(color: kColorBorder),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _SettingsTile(
                          icon: Icons.description_outlined,
                          title: 'Terms of service',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy policy',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({required this.channel});

  final SupportChannel channel;

  String get _typeLabel {
    switch (channel.type) {
      case SupportChannelType.call:
        return 'Call';
      case SupportChannelType.liveChat:
        return 'Live chat';
      case SupportChannelType.email:
        return 'Email';
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData cardIcon;
    switch (channel.type) {
      case SupportChannelType.call:
        cardIcon = Icons.phone;
        break;
      case SupportChannelType.liveChat:
        cardIcon = Icons.chat_outlined;
        break;
      case SupportChannelType.email:
        cardIcon = Icons.email_outlined;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            cardIcon,
            color: kColorAccentGold,
            size: 22,
          ),
          const SizedBox(height: 8),
          Text(
            _typeLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kColorPrimaryAction,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFBEFE3),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              channel.availabilityText,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: kColorAccentGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.faq,
    required this.onTap,
  });

  final FaqItem faq;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      expanded: faq.isExpanded,
      child: Theme(
        data: Theme.of(context).copyWith(
          expansionTileTheme: const ExpansionTileThemeData(
            tilePadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            childrenPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            iconColor: kColorSubtitle,
            collapsedIconColor: kColorSubtitle,
          ),
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          onExpansionChanged: (_) => onTap(),
          title: Text(
            faq.question,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: kColorPrimaryAction,
            ),
          ),
          trailing: AnimatedRotation(
            turns: faq.isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isRtl
                  ? (faq.isExpanded
                      ? Icons.arrow_back_ios
                      : Icons.arrow_forward_ios)
                  : Icons.expand_more,
              color: kColorSubtitle,
              size: 18,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq.answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: kColorSubtitle,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return ListTile(
      minTileHeight: 48,
      leading: Icon(
        icon,
        color: kColorSubtitle,
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: kColorPrimaryAction,
        ),
      ),
      trailing: Icon(
        isRtl ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
        size: 14,
        color: kColorSubtitle,
      ),
      onTap: onTap,
    );
  }
}
