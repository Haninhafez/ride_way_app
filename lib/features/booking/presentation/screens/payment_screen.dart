import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/payment_method.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../widgets/payment_method_card.dart';
import '../../../../core/themes/theme_data.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state.status == BookingStatus.paymentSuccess) {
          context.go('/booking-success');
        } else if (state.status == BookingStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        final totalAmount = state.summary?.grandTotal ?? 623.0;
        final seatNumbers = state.selectedSeats.map((s) => s.seatNumber).join(', ');

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'booking.payment.title'.tr(),
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
                      // Trip & Total Due Card
                      _buildTripSummaryCard(context, state, totalAmount, seatNumbers, isDark),
                      const SizedBox(height: 24),

                      // Select Payment Method Header
                      Text(
                        'booking.payment.select_method'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : kColorPrimaryAction,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Payment Method Cards
                      PaymentMethodCard(
                        type: PaymentMethodType.mada,
                        selectedType: state.selectedPaymentMethod,
                        onSelected: (type) => context.read<BookingCubit>().selectPaymentMethod(type),
                      ),
                      PaymentMethodCard(
                        type: PaymentMethodType.applePay,
                        selectedType: state.selectedPaymentMethod,
                        onSelected: (type) => context.read<BookingCubit>().selectPaymentMethod(type),
                      ),
                      PaymentMethodCard(
                        type: PaymentMethodType.creditCard,
                        selectedType: state.selectedPaymentMethod,
                        onSelected: (type) => context.read<BookingCubit>().selectPaymentMethod(type),
                      ),
                      PaymentMethodCard(
                        type: PaymentMethodType.cashAtStation,
                        selectedType: state.selectedPaymentMethod,
                        onSelected: (type) => context.read<BookingCubit>().selectPaymentMethod(type),
                      ),
                      const SizedBox(height: 16),

                      // Dynamic Payment Fields (CVV input when card is selected)
                      if (state.selectedPaymentMethod == PaymentMethodType.mada ||
                          state.selectedPaymentMethod == PaymentMethodType.creditCard)
                        _buildCvvInputCard(context, state, isDark),
                    ],
                  ),
                ),
              ),

              // Bottom Action Area
              _buildBottomPaymentBar(context, state, totalAmount, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTripSummaryCard(
    BuildContext context,
    BookingState state,
    double totalAmount,
    String seats,
    bool isDark,
  ) {
    final train = state.trainDetail;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'booking.payment.trip_summary'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kColorSubtitle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kColorAccentGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  state.selectedClass?.title ?? 'Business',
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
          Row(
            children: [
              const Icon(Icons.train, color: kColorPrimaryAction, size: 22),
              const SizedBox(width: 10),
              Text(
                '${train?.departureStationCode ?? "DMM"} ➔ ${train?.arrivalStationCode ?? "JED"}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : kColorPrimaryAction,
                ),
              ),
              const Spacer(),
              Text(
                'Seats: $seats',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : kColorPrimaryAction,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'booking.payment.total_due'.tr(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : kColorPrimaryAction,
                ),
              ),
              Text(
                'SAR ${totalAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 22,
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

  Widget _buildCvvInputCard(BuildContext context, BookingState state, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'booking.payment.cvv_label'.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : kColorPrimaryAction,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 140,
            child: TextFormField(
              initialValue: state.cardCvv,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'booking.payment.cvv_hint'.tr(),
                counterText: '',
                prefixIcon: const Icon(Icons.lock_outline, size: 18),
                filled: true,
                fillColor: isDark ? const Color(0xFF2C2C2E) : kColorFieldFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kColorBorder),
                ),
              ),
              onChanged: (val) => context.read<BookingCubit>().updateCvv(val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPaymentBar(
    BuildContext context,
    BookingState state,
    double totalAmount,
    bool isDark,
  ) {
    final isLoading = state.status == BookingStatus.paymentProcessing;

    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<BookingCubit>().processPayment();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryAction,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'booking.payment.pay_now'.tr(
                        args: ['SAR ${totalAmount.toStringAsFixed(0)}'],
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'booking.payment.cancellation_policy'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: kColorSubtitle,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
