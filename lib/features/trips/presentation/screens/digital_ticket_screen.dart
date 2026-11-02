import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/themes/theme_data.dart';
import '../../../../core/widgets/toast_app.dart';
import '../../domain/entities/booking.dart';
import '../cubit/digital_ticket_cubit.dart';
import '../cubit/digital_ticket_state.dart';
import '../widgets/cancel_booking_bottom_sheet.dart';
import '../widgets/qr_code_widget.dart';

class DigitalTicketScreen extends StatefulWidget {
  final String bookingId;

  const DigitalTicketScreen({super.key, required this.bookingId});

  @override
  State<DigitalTicketScreen> createState() => _DigitalTicketScreenState();
}

class _DigitalTicketScreenState extends State<DigitalTicketScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<DigitalTicketCubit>();
    cubit.screenshotController = _screenshotController;
    cubit.loadTicket(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<DigitalTicketCubit, DigitalTicketState>(
      listener: (context, state) {
        if (state.status == DigitalTicketStatus.downloaded &&
            state.message != null) {
          AppToast.showSuccess(
            context: context,
            message: 'trips.ticket_saved'.tr(),
          );
          context.read<DigitalTicketCubit>().clearMessage();
        }
        if (state.status == DigitalTicketStatus.error &&
            state.errorMessage != null) {
          AppToast.showError(context: context, message: state.errorMessage!);
          context.read<DigitalTicketCubit>().clearMessage();
        }
        if (state.status == DigitalTicketStatus.cancelled) {
          AppToast.showSuccess(
            context: context,
            message: 'Booking cancelled successfully.',
          );
        }
      },
      builder: (context, state) {
        if (state.status == DigitalTicketStatus.loading &&
            state.booking == null) {
          return Scaffold(
            backgroundColor: isDark
                ? const Color(0xFF0F131A)
                : kColorBackground,
            appBar: _buildAppBar(context, null, isDark),
            body: const Center(
              child: CircularProgressIndicator(color: kColorPrimaryAction),
            ),
          );
        }

        if (state.booking == null) {
          return Scaffold(
            backgroundColor: isDark
                ? const Color(0xFF0F131A)
                : kColorBackground,
            appBar: _buildAppBar(context, null, isDark),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 56,
                    color: kColorSubtitle,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.errorMessage ?? 'Ticket not found.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white70 : kColorPrimaryAction,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context
                        .read<DigitalTicketCubit>()
                        .loadTicket(widget.bookingId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorPrimaryAction,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final booking = state.booking!;
        final isBusy =
            state.status == DigitalTicketStatus.downloading ||
            state.status == DigitalTicketStatus.sharing ||
            state.status == DigitalTicketStatus.loading;
        final isCancelled = booking.status == BookingStatusType.cancelled;
        final isUpcoming = booking.status == BookingStatusType.upcoming;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
          appBar: _buildAppBar(context, booking.bookingRef, isDark),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    children: [
                      if (isCancelled) ...[
                        _CancelledBanner(isDark: isDark),
                        const SizedBox(height: 16),
                      ],

                      Screenshot(
                        controller: _screenshotController,
                        child: _TicketCard(
                          booking: booking,
                          isDark: isDark,
                          shareUrl: state.shareUrl,
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (!isCancelled) _BoardingReminder(isDark: isDark),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              _BottomBar(
                isDark: isDark,
                isBusy: isBusy,
                isUpcoming: isUpcoming,
                isCancelled: isCancelled,
                booking: booking,
                onShare: () => context.read<DigitalTicketCubit>().shareTicket(),
                onDownload: () =>
                    context.read<DigitalTicketCubit>().downloadTicket(),
                onCancel: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => CancelBookingBottomSheet(
                    booking: booking,
                    onConfirmCancel: () =>
                        context.read<DigitalTicketCubit>().cancelTicket(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, String? bookingRef, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => context.go('/home'),
        color: isDark ? Colors.white : kColorPrimaryAction,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'trips.digital_ticket_title'.tr(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : kColorPrimaryAction,
            ),
          ),
          if (bookingRef != null)
            Text(
              bookingRef,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: kColorSubtitle,
                letterSpacing: 0.8,
              ),
            ),
        ],
      ),
    );
  }
}


class _TicketCard extends StatelessWidget {
  final Booking booking;
  final bool isDark;

  final String? shareUrl;

  const _TicketCard({
    required this.booking,
    required this.isDark,
    this.shareUrl,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEE, d MMM yyyy').format(booking.travelDate);
    final seatNumbers = booking.passengers.map((p) => p.seatNumber).join(', ');

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _TicketHeader(booking: booking),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _RouteRow(booking: booking, isDark: isDark),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MetaCell(label: 'Date', value: dateStr, isDark: isDark),
                    _MetaCell(
                      label: 'trips.coach'.tr(),
                      value: 'C${booking.coach}',
                      isDark: isDark,
                    ),
                    _MetaCell(
                      label: 'trips.seats'.tr(),
                      value: seatNumbers,
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MetaCell(
                      label: 'Passengers',
                      value: '${booking.passengers.length}',
                      isDark: isDark,
                    ),
                    _MetaCell(
                      label: 'Duration',
                      value: booking.duration,
                      isDark: isDark,
                    ),
                    _MetaCell(
                      label: 'Total',
                      value:
                          'SAR ${booking.paymentSummary.totalPaid.toStringAsFixed(0)}',
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _TearLine(isDark: isDark),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                QRCodeWidget(
                  qrData: shareUrl ?? 'https://YOUR_DOMAIN/ticket/pending',
                  bookingRef: booking.bookingRef,
                ),
                const SizedBox(height: 12),
                Text(
                  booking.paymentSummary.paymentMethod,
                  style: const TextStyle(fontSize: 12, color: kColorSubtitle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _TicketHeader extends StatelessWidget {
  final Booking booking;
  const _TicketHeader({required this.booking});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    switch (booking.status) {
      case BookingStatusType.upcoming:
        statusColor = kColorSuccess;
        statusLabel = 'Upcoming';
      case BookingStatusType.completed:
        statusColor = kColorSubtitle;
        statusLabel = 'Completed';
      case BookingStatusType.cancelled:
        statusColor = const Color(0xFFD93838);
        statusLabel = 'Cancelled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: kColorPrimaryAction,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.directions_train,
                color: kColorAccentGold,
                size: 22,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.trainCode,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    booking.trainName,
                    style: const TextStyle(fontSize: 11, color: kColorSubtitle),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: kColorAccentGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kColorAccentGold, width: 1),
                ),
                child: Text(
                  booking.travelClass,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: kColorAccentGold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _RouteRow extends StatelessWidget {
  final Booking booking;
  final bool isDark;
  const _RouteRow({required this.booking, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.origin,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : kColorPrimaryAction,
                    height: 1.1,
                  ),
                ),
                Text(
                  booking.originName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: kColorSubtitle,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.departureTime,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : kColorPrimaryAction,
                  ),
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Text(
                booking.duration,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: kColorSubtitle,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: kColorAccentGold,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(width: 28, height: 1.5, color: kColorAccentGold),
                  const Icon(Icons.train, size: 18, color: kColorAccentGold),
                  Container(width: 28, height: 1.5, color: kColorAccentGold),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: kColorAccentGold,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Expanded(
          child: Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  booking.destination,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : kColorPrimaryAction,
                    height: 1.1,
                  ),
                ),
                Text(
                  booking.destinationName,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 11,
                    color: kColorSubtitle,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.arrivalTime,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : kColorPrimaryAction,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class _MetaCell extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  const _MetaCell({
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: kColorSubtitle),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : kColorPrimaryAction,
          ),
        ),
      ],
    );
  }
}


class _TearLine extends StatelessWidget {
  final bool isDark;
  const _TearLine({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 20,
              height: 24,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F131A) : kColorBackground,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(12),
                ),
              ),
            ),
            Container(
              width: 20,
              height: 24,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F131A) : kColorBackground,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final count = (constraints.maxWidth / 10).floor();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  count,
                  (_) => Container(
                    width: 5,
                    height: 1.5,
                    color: isDark
                        ? const Color(0xFF3A3A3C)
                        : const Color(0xFFE5E5EA),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


class _CancelledBanner extends StatelessWidget {
  final bool isDark;
  const _CancelledBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD93838).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.cancel_outlined, color: Color(0xFFD93838), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'This booking has been cancelled. This ticket is no longer valid for travel.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFD93838),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _BoardingReminder extends StatelessWidget {
  final bool isDark;
  const _BoardingReminder({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1C1C1E)
            : kColorAccentGold.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kColorAccentGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: kColorAccentGold, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Please be at the platform at least 15 minutes before departure. Have this QR code ready for scanning.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : kColorPrimaryAction,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _BottomBar extends StatelessWidget {
  final bool isDark;
  final bool isBusy;
  final bool isUpcoming;
  final bool isCancelled;
  final Booking booking;
  final VoidCallback onShare;
  final VoidCallback onDownload;
  final VoidCallback onCancel;

  const _BottomBar({
    required this.isDark,
    required this.isBusy,
    required this.isUpcoming,
    required this.isCancelled,
    required this.booking,
    required this.onShare,
    required this.onDownload,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'trips.share'.tr(),
                  onTap: isBusy ? null : onShare,
                  isDark: isDark,
                  isLoading: isBusy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.download_outlined,
                  label: 'trips.download'.tr(),
                  onTap: isBusy ? null : onDownload,
                  isDark: isDark,
                  primary: true,
                ),
              ),
            ],
          ),

          if (isUpcoming && !isCancelled) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: isBusy ? null : onCancel,
              icon: const Icon(
                Icons.cancel_outlined,
                size: 16,
                color: Color(0xFFD93838),
              ),
              label: Text(
                'trips.cancel_booking'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD93838),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDark;
  final bool primary;
  final bool isLoading;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.primary = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = primary
        ? kColorPrimaryAction
        : (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF0F0F3));
    final fg = primary
        ? Colors.white
        : (isDark ? Colors.white : kColorPrimaryAction);

    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              )
            : Icon(icon, size: 18, color: fg),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: fg,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}
