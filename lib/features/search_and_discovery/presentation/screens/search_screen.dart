import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/database/api/api_end_points.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/header_row.dart';
import '../widgets/passenger_stepper.dart';
import '../widgets/recent_searches_widget.dart';
import '../widgets/saved_routes_widget.dart';
import '../widgets/station_swap_input.dart';
import '../../../../core/themes/theme_data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().loadDiscoveryData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final dateFormatted = DateFormat(
          'EEE, d MMM yyyy',
        ).format(state.departureDate);

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  HeaderRow(
                    userName:
                        CacheHelper.getData(ApiKeys.firstName) ??
                        '' + CacheHelper.getData(ApiKeys.lastName) ??
                        '',
                    unreadCount: state.unreadNotificationsCount,
                    onNotificationTap: () {},
                  ),
                  const SizedBox(height: 24),

                  // Main Headline
                  Text(
                    'search.headline'.tr(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Main Search Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],

                      border: Border.all(
                        color: isDark ? KColorDarkGold : Colors.grey,
                        // style: BorderStyle.none,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // From / To Stacked Inputs with swap button
                        StationSwapInput(
                          origin: state.originStation,
                          destination: state.destinationStation,
                          onSwap: () {
                            context.read<SearchCubit>().swapStations();
                          },
                        ),
                        const SizedBox(height: 16),

                        // Date Picker Trigger
                        GestureDetector(
                          onTap: () async {
                            final today = DateTime.now();

                            final picked = await showDatePicker(
                              context: context,
                              initialDate: today,
                              firstDate: today,
                              lastDate: DateTime(2030),
                              barrierColor: Colors.black.withAlpha(40),
                              barrierDismissible: false,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: isDark
                                        ? const ColorScheme.dark(
                                            primary: kColorAccentGold,
                                            onPrimary: Colors.black,
                                            surface: Color(0xFF2C2C2E),
                                            onSurface: Colors.white,
                                          )
                                        : const ColorScheme.light(
                                            primary: kColorAccentGold,
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (picked != null && mounted) {
                              context.read<SearchCubit>().updateDepartureDate(
                                picked,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2C2C2E)
                                  : const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF3A3A3C)
                                    : const Color(0xFFE5E5EA),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: kColorAccentGold,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'search.departure_date'.tr(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: kColorSubtitle,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      dateFormatted,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : kColorPrimaryAction,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Passenger Stepper Widget
                        PassengerStepper(
                          count: state.passengerCount,
                          onIncrement: () {
                            context.read<SearchCubit>().incrementPassengers();
                          },
                          onDecrement: () {
                            context.read<SearchCubit>().decrementPassengers();
                          },
                        ),
                        const SizedBox(height: 20),

                        // Primary Action Search Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: GestureDetector(
                            onTap: () {
                              context.push(
                                '/train-list',
                                extra: state.searchQuery,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: kColorPrimaryAction,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: isDark ? KColorDarkGold : Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'search.search_trains'.tr(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Recent Searches Section
                  RecentSearchesWidget(
                    recentSearches: state.recentSearches,
                    onClear: () {
                      context.read<SearchCubit>().clearRecentSearches();
                    },
                    onSelect: (recent) {
                      context.read<SearchCubit>().applyRecentSearch(recent);
                      context.push(
                        '/train-list',
                        extra: context.read<SearchCubit>().state.searchQuery,
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Saved Routes Section
                  SavedRoutesWidget(
                    savedRoutes: state.savedRoutes,
                    onSelect: (saved) {
                      context.read<SearchCubit>().applySavedRoute(saved);
                      context.push(
                        '/train-list',
                        extra: context.read<SearchCubit>().state.searchQuery,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
