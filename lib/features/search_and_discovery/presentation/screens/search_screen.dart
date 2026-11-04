import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/widgets/toast_app.dart';
import 'package:ride_way_app/features/account/presentation/cubit/profile_cubit.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/entities/recent_search.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/entities/saved_route.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/entities/station.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/header_row.dart';
import '../widgets/passenger_stepper.dart';
import '../widgets/station_swap_input.dart';
import '../widgets/favorite_routes_widget.dart';
import '../widgets/recent_searches_widget.dart';
import '../../../../core/themes/theme_data.dart';

// ── Static dummy data (UI-only, no backend) ───────────────────────────────────

final _kDummySavedRoutes = [
  const SavedRoute(
    id: '1',
    originCode: 'RUH',
    destinationCode: 'JED',
    originName: 'Riyadh',
    destinationName: 'Jeddah',
    note: 'Weekly commute',
    dailyTrainsCount: 12,
  ),
  const SavedRoute(
    id: '2',
    originCode: 'DMM',
    destinationCode: 'RUH',
    originName: 'Dammam',
    destinationName: 'Riyadh',
    note: 'Business trip',
    dailyTrainsCount: 8,
  ),
  const SavedRoute(
    id: '3',
    originCode: 'JED',
    destinationCode: 'MED',
    originName: 'Jeddah',
    destinationName: 'Madinah',
    note: 'Weekend',
    dailyTrainsCount: 6,
  ),
  const SavedRoute(
    id: '4',
    originCode: 'RUH',
    destinationCode: 'DMM',
    originName: 'Riyadh',
    destinationName: 'Dammam',
    note: 'Regular',
    dailyTrainsCount: 10,
  ),
];

final _kDummyRecentSearches = [
  RecentSearch(
    id: '1',
    originCode: 'RUH',
    destinationCode: 'JED',
    originName: 'Riyadh',
    destinationName: 'Jeddah',
    departureDate: DateTime(2026, 8, 14),
    passengerCount: 2,
  ),
  RecentSearch(
    id: '2',
    originCode: 'DMM',
    destinationCode: 'RUH',
    originName: 'Dammam',
    destinationName: 'Riyadh',
    departureDate: DateTime(2026, 8, 20),
    passengerCount: 1,
  ),
  RecentSearch(
    id: '3',
    originCode: 'JED',
    destinationCode: 'MED',
    originName: 'Jeddah',
    destinationName: 'Madinah',
    departureDate: DateTime(2026, 9, 5),
    passengerCount: 3,
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

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
        final firstName = context
            .select<ProfileCubit, String>(
              (c) => c.state.profile?.firstName ?? '',
            )
            .trim();
        final lastName = context
            .select<ProfileCubit, String>(
              (c) => c.state.profile?.lastName ?? '',
            )
            .trim();

        return Scaffold(
          backgroundColor: isDark ? kColorBackgroundnew : kColorBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──────────────────────────────────────────────
                  HeaderRow(
                    userName: '$firstName $lastName',
                    unreadCount: state.unreadNotificationsCount,
                    onNotificationTap: () {
                      context.push('/notification');
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Headline ─────────────────────────────────────────────
                  Text(
                    'search.headline'.tr(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Search card ──────────────────────────────────────────
                  _SearchCard(state: state, isDark: isDark),
                  const SizedBox(height: 28),

                  // ── Favourite routes ─────────────────────────────────────
                  FavoriteRoutesWidget(routes: _kDummySavedRoutes, state: state,),
                  const SizedBox(height: 28),

                  // ── Recent searches ──────────────────────────────────────
                  RecentSearchesWidget(
                    recentSearches: _kDummyRecentSearches,
                    onClear: () {}, // UI only
                    onSelect: (_) {
                      
                    }, state: state, // UI only
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Search card (station + date + passengers + button) ───────────────────────

class _SearchCard extends StatelessWidget {
  final SearchState state;
  final bool isDark;

  const _SearchCard({required this.state, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? KColorDarkGold : const Color(0xFFE5E5EA),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Station swap
          StationSwapInput(
            origin:
                state.fromStation ??
                const Station(
                  name: 'Dammam',
                  city: 'Dammam',
                  code: '',
                  nameAr: '',
                  lat: 0,
                  lng: 0,
                ),
            destination:
                state.toStation ??
                const Station(
                  name: 'Riyadh',
                  city: 'Riyadh',
                  code: '',
                  nameAr: '',
                  lat: 0,
                  lng: 0,
                ),
            onSwap: () => context.read<SearchCubit>().swapStations(),
          ),
          const SizedBox(height: 16),

          // Date picker row
          _DateRow(isDark: isDark, state: state),
          const SizedBox(height: 16),

          // Passengers
          PassengerStepper(
            count: state.passengerCount,
            onIncrement: () =>
                context.read<SearchCubit>().incrementPassengers(),
            onDecrement: () =>
                context.read<SearchCubit>().decrementPassengers(),
          ),
          const SizedBox(height: 20),

          // Search button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                if (state.searchQuery == null) {
                  AppToast.showError(
                    context: context,
                    message: 'Please select a station and date',
                  );
                  return;
                }
                context.push('/train-list', extra: state.searchQuery);
              },
              icon: const Icon(Icons.search, color: Colors.white, size: 20),
              label: Text(
                'search.search_trains'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryAction,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Date row ──────────────────────────────────────────────────────────────────

class _DateRow extends StatelessWidget {
  final bool isDark;
  final SearchState state;

  const _DateRow({required this.isDark, required this.state});

  @override
  Widget build(BuildContext context) {
    final dateLabel = state.departureDate != null
        ? DateFormat('EEE, d MMM yyyy').format(state.departureDate!)
        : 'search.departure_date'.tr();

    return GestureDetector(
      onTap: () async {
        final today = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: today,
          firstDate: today,
          lastDate: DateTime(2030),
          builder: (ctx, child) {
            return Theme(
              data: Theme.of(ctx).copyWith(
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
                      ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && context.mounted) {
          context.read<SearchCubit>().updateDepartureDate(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA),
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
                  dateLabel,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : kColorPrimaryAction,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
