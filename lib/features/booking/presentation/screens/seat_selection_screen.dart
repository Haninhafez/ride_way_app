import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../widgets/seat_grid_view.dart';
import '../widgets/sticky_bottom_action_bar.dart';
import '../../../../core/themes/theme_data.dart';

class SeatSelectionScreen extends StatelessWidget {
  const SeatSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final selectedClassPrice = state.selectedClass?.price ?? 265.0;
        final totalCalc = selectedClassPrice * state.passengerCount;

        final seatNumbers = state.selectedSeats.map((s) => s.seatNumber).join(', ');
        final isComplete = state.selectedSeats.length == state.passengerCount;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'booking.seat_selection.title'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : kColorPrimaryAction,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: SeatGridView(
                    selectedCoach: state.selectedCoachNumber,
                    seats: state.coachSeats,
                    selectedSeats: state.selectedSeats,
                    passengers: state.passengers,
                    onCoachSelected: (coachNum) {
                      context.read<BookingCubit>().loadSeatsForCoach(coachNum);
                    },
                    onSeatTapped: (seat) {
                      context.read<BookingCubit>().toggleSeatSelection(seat);
                    },
                  ),
                ),
              ),

              // Sticky Bottom Action Bar
              StickyBottomActionBar(
                title: 'SAR ${totalCalc.toStringAsFixed(0)}',
                subtitle: 'booking.seat_selection.seats_selected'.tr(
                      args: ['${state.selectedSeats.length}', '${state.passengerCount}'],
                    ) +
                    (seatNumbers.isNotEmpty ? ' · $seatNumbers' : ''),
                primaryButtonText: 'booking.seat_selection.continue_passenger'.tr(),
                onPressed: isComplete
                    ? () {
                        context.push('/passenger-details');
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
