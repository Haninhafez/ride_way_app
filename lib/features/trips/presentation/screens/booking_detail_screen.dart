import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/booking.dart';
import '../cubit/booking_detail_cubit.dart';
import '../cubit/booking_detail_state.dart';
import '../widgets/cancel_booking_bottom_sheet.dart';
import '../../../../core/themes/theme_data.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingDetailCubit>().loadDetail(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<BookingDetailCubit, BookingDetailState>(
      listener: (context, state) {
        if (state.status == BookingDetailStatus.cancelled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking successfully cancelled.')),
          );
        } else if (state.status == BookingDetailStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        final booking = state.booking;

        if (state.status == BookingDetailStatus.loading && booking == null) {
          return Scaffold(
            appBar: AppBar(title: Text('trips.booking_title'.tr())),
            body: const Center(
              child: CircularProgressIndicator(color: kColorPrimaryAction),
            ),
          );
        }

        if (booking == null) {
          return Scaffold(
            appBar: AppBar(title: Text('trips.booking_title'.tr())),
            body: const Center(child: Text('Booking detail unavailable.')),
          );
        }

        final isUpcoming = booking.status == BookingStatusType.upcoming;
        final dateStr = DateFormat('EEE, d MMM yyyy').format(booking.travelDate);

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'trips.booking_title'.tr(),
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
                      // Trip Overview Card
                      _buildTripOverviewCard(context, booking, dateStr, isDark),
                      const SizedBox(height: 20),

                      // Passenger & Seat Allocation Card
                      _buildPassengersCard(context, booking, isDark),
                      const SizedBox(height: 20),

                      // Payment Breakdown Card
                      _buildPaymentCard(context, booking, isDark),
                      const SizedBox(height: 24),

                      // Destructive Action: Cancel Booking Button (for upcoming bookings)
                      if (isUpcoming)
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) => CancelBookingBottomSheet(
                                  booking: booking,
                                  onConfirmCancel: () {
                                    context.read<BookingDetailCubit>().cancelCurrentBooking();
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.cancel_outlined, size: 18, color: Color(0xFFD93838)),
                            label: Text(
                              'trips.cancel_booking'.tr(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD93838),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Primary Sticky Pill Button: "Open digital ticket"
              if (isUpcoming)
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 16,
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push('/digital-ticket/${booking.id}');
                      },
                      icon: const Icon(Icons.qr_code_2, color: Colors.white, size: 22),
                      label: Text(
                        'trips.open_digital_ticket'.tr(),
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
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTripOverviewCard(BuildContext context, Booking booking, String dateStr, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kColorPrimaryAction,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      booking.trainCode,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${booking.originName} ➔ ${booking.destinationName}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEFE3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  booking.travelClass,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kColorAccentGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              dateStr,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kColorSubtitle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Departure & Arrival Columns (RTL naturally swaps sides, platform badge stays centered)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'trips.departs'.tr(),
                    style: const TextStyle(fontSize: 12, color: kColorSubtitle),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.departureTime,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                  Text(
                    booking.origin,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: kColorSubtitle,
                    ),
                  ),
                ],
              ),

              // Platform Badge (Stays Centered)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kColorAccentGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kColorAccentGold, width: 1),
                    ),
                    child: Text(
                      'trips.platform'.tr(args: [booking.platform]),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kColorAccentGold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    booking.duration,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kColorSubtitle,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'trips.arrives'.tr(),
                    style: const TextStyle(fontSize: 12, color: kColorSubtitle),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.arrivalTime,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                  Text(
                    booking.destination,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: kColorSubtitle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassengersCard(BuildContext context, Booking booking, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people_outline, size: 20, color: kColorAccentGold),
              const SizedBox(width: 8),
              Text(
                'trips.passengers_and_seats'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...booking.passengers.map((p) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.passengerName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : kColorPrimaryAction,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.passengerType,
                        style: const TextStyle(
                          fontSize: 12,
                          color: kColorSubtitle,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kColorAccentGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Seat ${p.seatNumber}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kColorAccentGold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Booking booking, bool isDark) {
    final pm = booking.paymentSummary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined, size: 20, color: kColorAccentGold),
              const SizedBox(width: 8),
              Text(
                'trips.payment_summary'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRow('Booking Ref', booking.bookingRef, isDark),
          const SizedBox(height: 8),
          _buildRow('Payment Method', pm.paymentMethod, isDark),
          const SizedBox(height: 8),
          _buildRow('trips.fare'.tr(), 'SAR ${pm.fareSubtotal.toStringAsFixed(0)}', isDark),
          const SizedBox(height: 8),
          _buildRow('trips.fees_and_vat'.tr(), 'SAR ${pm.feesAndVat.toStringAsFixed(0)}', isDark),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'trips.total_paid'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
              Text(
                'SAR ${pm.totalPaid.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: kColorSubtitle),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : kColorPrimaryAction,
          ),
        ),
      ],
    );
  }
}
