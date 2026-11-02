import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/database/cache/cache_helper.dart';
import 'package:ride_way_app/core/widgets/toast_app.dart';
import 'package:ride_way_app/payment/domain/entities/payment_method.dart';
import 'package:ride_way_app/payment/presentation/cubit/payment_cubit.dart';
import 'package:ride_way_app/payment/presentation/cubit/payment_state.dart';

import '../../../../core/themes/theme_data.dart';
import '../../domain/entities/payment_method.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../widgets/payment_method_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isNavigatingToWebView = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        BlocListener<BookingCubit, BookingState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == BookingStatus.paymentSuccess) {
              context.go('/booking-success');
              context.read<BookingCubit>().saveBookingTicket();
            } else if (state.status == BookingStatus.error &&
                state.errorMessage != null) {
              AppToast.showError(
                context: context,
                message: state.errorMessage!,
              );
              context.read<BookingCubit>().clearError();
            }
          },
        ),

        BlocListener<PaymentCubit, PaymentState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == PaymentStatus.awaitingUser,
          listener: (context, state) async {
            if (_isNavigatingToWebView) return;
            if (state.session == null || state.session!.url.isEmpty) return;

            _isNavigatingToWebView = true;

            try {
              final isPaid = await context.push<bool>(
                '/payment-webview',
                extra: state.session!.url,
              );

              if (context.mounted) {
                context.read<PaymentCubit>().confirm(
                  state.session!,
                  isPaid == true,
                );
                context.read<BookingCubit>().saveBookingTicket();
              }
            } catch (e) {
              debugPrint('NAV_ERROR: $e');
            } finally {
              if (mounted) _isNavigatingToWebView = false;
            }
          },
        ),

        BlocListener<PaymentCubit, PaymentState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == PaymentStatus.success,
          listener: (context, state) {
            context.go('/booking-success');
          },
        ),

        BlocListener<PaymentCubit, PaymentState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == PaymentStatus.error &&
              current.errorMessage != null,
          listener: (context, state) {
            AppToast.showError(context: context, message: state.errorMessage!);
          },
        ),
      ],
      child: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          final totalAmount = state.summary?.grandTotal ?? 623.0;
          final seatNumbers = state.selectedSeats
              .map((s) => s.seatNumber)
              .join(', ');

          return Scaffold(
            appBar: AppBar(
              backgroundColor: isDark
                  ? const Color(0xFF0F131A)
                  : kColorBackground,
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
                        _buildTripSummaryCard(
                          context,
                          state,
                          totalAmount,
                          seatNumbers,
                          isDark,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'booking.payment.select_method'.tr(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : kColorPrimaryAction,
                          ),
                        ),
                        const SizedBox(height: 14),
                        PaymentMethodCard(
                          type: PaymentMethodType.vodafoneCash,
                          selectedType: state.selectedPaymentMethod,
                          onSelected: (type) => context
                              .read<BookingCubit>()
                              .selectPaymentMethod(type),
                        ),
                        PaymentMethodCard(
                          type: PaymentMethodType.creditCard,
                          selectedType: state.selectedPaymentMethod,
                          onSelected: (type) => context
                              .read<BookingCubit>()
                              .selectPaymentMethod(type),
                        ),
                        PaymentMethodCard(
                          type: PaymentMethodType.cashAtStation,
                          selectedType: state.selectedPaymentMethod,
                          onSelected: (type) => context
                              .read<BookingCubit>()
                              .selectPaymentMethod(type),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                _buildBottomPaymentBar(context, state, totalAmount, isDark),
              ],
            ),
          );
        },
      ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: kColorAccentGold.withValues(alpha: 0.15),
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

  Widget _buildBottomPaymentBar(
    BuildContext context,
    BookingState bookingState,
    double totalAmount,
    bool isDark,
  ) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, paymentState) {
        final isLoading =
            bookingState.status == BookingStatus.paymentProcessing ||
            paymentState.status == PaymentStatus.loading;

        void handlePayment() {
          final bookingCubit = context.read<BookingCubit>();
          final paymentCubit = context.read<PaymentCubit>();
          final method = bookingCubit.state.selectedPaymentMethod;

          if (method == PaymentMethodType.cashAtStation) {
            bookingCubit.processPayment();
            return;
          }

          final userId = CacheHelper.getData('userId') ?? '1';

          paymentCubit.pay(
            userId: userId.toString(),
            amountEgp: totalAmount.round(),
            method: method,
          );
        }

        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : handlePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryAction,
                foregroundColor: Colors.white,
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
        );
      },
    );
  }
}
