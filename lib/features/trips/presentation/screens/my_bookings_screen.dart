import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/my_bookings_cubit.dart';
import '../cubit/my_bookings_state.dart';
import '../widgets/booking_card.dart';
import '../../../../core/themes/theme_data.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyBookingsCubit>().loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<MyBookingsCubit, MyBookingsState>(
      builder: (context, state) {
        final upcomingCount = state.upcomingBookings.length;
        final completedCount = state.completedBookings.length;
        final cancelledCount = state.cancelledBookings.length;

        final tabLabels = [
          'trips.upcoming'.tr(args: ['$upcomingCount']),
          'trips.completed'.tr(args: ['$completedCount']),
          'trips.cancelled'.tr(args: ['$cancelledCount']),
        ];

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
            elevation: 0,
            title: Text(
              'trips.my_bookings'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : kColorPrimaryAction,
              ),
            ),
          ),
          body: Column(
            children: [
              // Segmented Tab Controller with Counters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: List.generate(tabLabels.length, (index) {
                      final isSelected = state.selectedTabIndex == index;
                      return Expanded(
                        child: Semantics(
                          selected: isSelected,
                          button: true,
                          child: GestureDetector(
                            onTap: () => context.read<MyBookingsCubit>().changeTab(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? kColorPrimaryAction
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tabLabels[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white70 : kColorPrimaryAction),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // Booking Cards Stream
              Expanded(
                child: _buildBookingsList(context, state, isDark),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingsList(BuildContext context, MyBookingsState state, bool isDark) {
    if (state.status == MyBookingsStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: kColorPrimaryAction),
      );
    }

    final activeList = state.activeFilteredBookings;

    if (activeList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.confirmation_number_outlined, size: 54, color: kColorSubtitle),
            const SizedBox(height: 12),
            Text(
              'trips.no_bookings'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : kColorPrimaryAction,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: activeList.length,
      itemBuilder: (context, index) {
        final booking = activeList[index];
        return BookingCard(
          booking: booking,
          onTapDetails: () {
            context.push('/booking-detail/${booking.id}');
          },
        );
      },
    );
  }
}
