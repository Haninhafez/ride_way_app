import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../widgets/booking_summary_card.dart';
import '../widgets/passenger_details_card.dart';
import '../widgets/seat_hold_countdown.dart';
import '../widgets/sticky_bottom_action_bar.dart';
import '../../../../core/themes/theme_data.dart';

class PassengerDetailsScreen extends StatelessWidget {
  const PassengerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state.status == BookingStatus.passengersValidated) {
          context.push('/payment');
        } else if (state.status == BookingStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        final summary = state.summary;
        final grandTotal = summary?.grandTotal ?? 623.0;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'booking.passenger_details.title'.tr(),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seat-Hold Countdown Banner
                      SeatHoldCountdown(formattedTime: state.formattedHoldTime),
                      const SizedBox(height: 20),

                      // Passengers Header
                      Text(
                        'booking.passenger_details.title'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : kColorPrimaryAction,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Collapsible Passenger Details Cards
                      ...List.generate(state.passengers.length, (index) {
                        final passenger = state.passengers[index];
                        final isExpanded = state.expandedPassengerIndex == index;
                        return PassengerDetailsCard(
                          passenger: passenger,
                          isExpanded: isExpanded,
                          onToggleExpand: () {
                            context.read<BookingCubit>().togglePassengerExpanded(index);
                          },
                          onChanged: (name, id) {
                            context.read<BookingCubit>().updatePassengerInfo(
                                  index,
                                  fullName: name,
                                  nationalIdOrPassport: id,
                                );
                          },
                        );
                      }),
                      const SizedBox(height: 16),

                      // Contact Details Form Card
                      _buildContactCard(context, state, isDark),
                      const SizedBox(height: 24),

                      // Fare / Booking Summary Card
                      if (summary != null) BookingSummaryCard(summary: summary),
                    ],
                  ),
                ),
              ),

              // Sticky Bottom Action Bar
              StickyBottomActionBar(
                title: 'SAR ${grandTotal.toStringAsFixed(0)}',
                subtitle: 'booking.summary.total'.tr(),
                primaryButtonText: 'booking.passenger_details.continue_payment'.tr(),
                isLoading: state.status == BookingStatus.loading,
                onPressed: () {
                  context.read<BookingCubit>().validatePassengersAndProceed();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactCard(BuildContext context, BookingState state, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.contact_mail_outlined, size: 20, color: kColorAccentGold),
              const SizedBox(width: 8),
              Text(
                'booking.passenger_details.contact_card'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: state.contactEmail,
            decoration: InputDecoration(
              labelText: 'booking.passenger_details.email'.tr(),
              hintText: 'nasser.harbi@example.com',
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: isDark ? const Color(0xFF2C2C2E) : kColorFieldFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kColorBorder),
              ),
            ),
            onChanged: (val) {
              context.read<BookingCubit>().updateContactInfo(email: val);
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: state.contactPhone,
            decoration: InputDecoration(
              labelText: 'booking.passenger_details.mobile'.tr(),
              hintText: '501234567',
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Text(
                  '+966 ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : kColorPrimaryAction,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              filled: true,
              fillColor: isDark ? const Color(0xFF2C2C2E) : kColorFieldFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kColorBorder),
              ),
            ),
            onChanged: (val) {
              context.read<BookingCubit>().updateContactInfo(phone: val);
            },
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: state.saveTravellers,
            contentPadding: EdgeInsets.zero,
            activeColor: kColorPrimaryAction,
            title: Text(
              'booking.passenger_details.save_travellers'.tr(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : kColorPrimaryAction,
              ),
            ),
            onChanged: (val) {
              context.read<BookingCubit>().updateContactInfo(saveTravellers: val);
            },
          ),
        ],
      ),
    );
  }
}
