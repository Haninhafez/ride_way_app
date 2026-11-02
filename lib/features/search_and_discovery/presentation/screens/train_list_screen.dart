import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/search_query.dart';
import '../cubit/train_list_cubit.dart';
import '../cubit/train_list_state.dart';
import '../widgets/date_strip_bar.dart';
import '../widgets/sort_filter_bar.dart';
import '../widgets/train_card.dart';
import '../../../../core/themes/theme_data.dart';

class TrainListScreen extends StatefulWidget {
  final SearchQuery searchQuery;

  const TrainListScreen({super.key, required this.searchQuery});

  @override
  State<TrainListScreen> createState() => _TrainListScreenState();
}

class _TrainListScreenState extends State<TrainListScreen> {
  late SearchQuery _effectiveQuery;

  @override
  void initState() {
    super.initState();
    _effectiveQuery = widget.searchQuery;

    context.read<TrainListCubit>().executeSearch(_effectiveQuery);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<TrainListCubit, TrainListState>(
      builder: (context, state) {
        final query = state.query ?? _effectiveQuery;
        final dateStr = DateFormat('EEE, d MMM').format(state.selectedDate);

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${query.originStation.name} ➔ ${query.destinationStation.name}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : kColorPrimaryAction,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$dateStr · ${query.passengerCount} ${'booking.passengers'.tr()}',
                  style: const TextStyle(fontSize: 12, color: kColorSubtitle),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: DateStripBar(
                  selectedDate: state.selectedDate,
                  onDateSelected: (newDate) {
                    context.read<TrainListCubit>().changeDate(newDate);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: !isDark ? KColorDarkGold : kColorAccentGold,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SortFilterBar(
                    activeSort: state.sortBy,
                    maxPriceFilter: state.maxPriceFilter,
                    onSortChanged: (sortBy) {
                      context.read<TrainListCubit>().changeSortBy(sortBy);
                    },
                    onFilterApplied: (maxPrice) {
                      context.read<TrainListCubit>().applyPriceFilter(maxPrice);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(child: _buildBodyContent(context, state, isDark)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    TrainListState state,
    bool isDark,
  ) {
    final trains = state.filteredTrains;
    log(trains.toString());
    if (state.status == TrainListStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: kColorPrimaryAction),
      );
    }

    if (state.status == TrainListStatus.empty || state.filteredTrains.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.train_outlined, size: 64, color: kColorSubtitle),
              const SizedBox(height: 16),
              Text(
                'train_list.no_results'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'train_list.no_results_sub'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: kColorSubtitle),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<TrainListCubit>().applyPriceFilter(null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorPrimaryAction,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('train_list.reset_filters'.tr()),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: trains.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 4),
            child: Text(
              'train_list.trains_available'.tr(
                args: ['${state.filteredTrains.length}'],
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kColorSubtitle,
              ),
            ),
          );
        }

        final train = state.filteredTrains[index - 1];
        return TrainCard(
          train: train,
          onViewDetails: () {
            log('trainId=${train.trainCode}');
            context.push('/train-details?trainId=${train.id}');
          },
        );
      },
    );
  }
}
