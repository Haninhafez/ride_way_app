import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/themes/theme_data.dart';
import '../../domain/entities/ticket_share.dart';
import '../cubit/shared_ticket_cubit.dart';
import '../cubit/shared_ticket_state.dart';

class SharedTicketScreen extends StatefulWidget {
  final String token;
  const SharedTicketScreen({super.key, required this.token});

  @override
  State<SharedTicketScreen> createState() => _SharedTicketScreenState();
}

class _SharedTicketScreenState extends State<SharedTicketScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SharedTicketCubit>().loadShare(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F131A) : kColorBackground,
        elevation: 0,
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => context.pop(),
                color: isDark ? Colors.white : kColorPrimaryAction,
              )
            : null,
        title: Text(
          'trips.digital_ticket_title'.tr(),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : kColorPrimaryAction,
          ),
        ),
      ),
      body: BlocBuilder<SharedTicketCubit, SharedTicketState>(
        builder: (context, state) {
          return switch (state.status) {
            SharedTicketStatus.initial ||
            SharedTicketStatus.loading =>
              const Center(
                  child: CircularProgressIndicator(color: kColorPrimaryAction)),

            SharedTicketStatus.found =>
              _FoundBody(share: state.ticketShare!, isDark: isDark),

            SharedTicketStatus.notFound =>
              _StatusBody(
                icon: Icons.search_off_rounded,
                title: 'ticket.share_not_found'.tr(),
                subtitle: 'ticket.share_not_found_sub'.tr(),
                isDark: isDark,
              ),

            SharedTicketStatus.expired =>
              _StatusBody(
                icon: Icons.timer_off_outlined,
                title: 'ticket.share_expired'.tr(),
                subtitle: 'ticket.share_expired_sub'.tr(),
                isDark: isDark,
              ),

            SharedTicketStatus.revoked =>
              _StatusBody(
                icon: Icons.block_rounded,
                title: 'ticket.share_revoked'.tr(),
                subtitle: 'ticket.share_revoked_sub'.tr(),
                isDark: isDark,
              ),

            SharedTicketStatus.networkError =>
              _StatusBody(
                icon: Icons.wifi_off_rounded,
                title: 'ticket.share_network_error'.tr(),
                subtitle: state.errorMessage ?? '',
                isDark: isDark,
                retry: () => context
                    .read<SharedTicketCubit>()
                    .loadShare(widget.token),
              ),
          };
        },
      ),
    );
  }
}


class _FoundBody extends StatelessWidget {
  final TicketShare share;
  final bool isDark;
  const _FoundBody({required this.share, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final travelDate = DateFormat('EEE, d MMM yyyy')
        .format(DateTime.tryParse(share.travelDate) ?? DateTime.now());

    final isCancelled = share.bookingStatus == 'cancelled';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        children: [
          if (isCancelled) ...[
            _banner(
              color: const Color(0xFFD93838),
              icon: Icons.cancel_outlined,
              text: 'ticket.shared_cancelled'.tr(),
            ),
            const SizedBox(height: 16),
          ],

          Container(
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
                _SharedHeader(share: share),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _SharedRouteRow(share: share, isDark: isDark),
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
                          _meta('Date', travelDate, isDark),
                          _meta('Coach', 'C${share.coach}', isDark),
                          _meta('Seats', share.seatNumbers, isDark),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _meta('Passenger', share.maskedPassengerName, isDark),
                          _meta('Status', share.bookingStatus, isDark),
                          _meta('Payment', _paymentLabel(share.paymentStatus), isDark),
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
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFE5E5EA), width: 1.5),
                          ),
                          child: QrImageView(
                            data:
                                'https://YOUR_DOMAIN/ticket/${share.token}',
                            version: QrVersions.auto,
                            size: 160,
                            backgroundColor: Colors.white,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Colors.black,
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Colors.black,
                            ),
                            errorCorrectionLevel: QrErrorCorrectLevel.M,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ticket.shared_view_only'.tr(),
                        style: const TextStyle(
                            fontSize: 11, color: kColorSubtitle),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _GetRidewayBanner(isDark: isDark),
        ],
      ),
    );
  }

  Widget _meta(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: kColorSubtitle)),
        const SizedBox(height: 3),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : kColorPrimaryAction)),
      ],
    );
  }

  String _paymentLabel(String status) {
    switch (status) {
      case 'pay_at_station':
        return 'Pay at station';
      case 'paid':
        return 'Paid';
      default:
        return 'Pending';
    }
  }

  Widget _banner(
      {required Color color,
      required IconData icon,
      required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: TextStyle(fontSize: 13, color: color, height: 1.4))),
        ],
      ),
    );
  }
}


class _SharedHeader extends StatelessWidget {
  final TicketShare share;
  const _SharedHeader({required this.share});

  @override
  Widget build(BuildContext context) {
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
              const Icon(Icons.directions_train,
                  color: kColorAccentGold, size: 22),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(share.trainCode,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(share.trainName,
                      style: const TextStyle(
                          fontSize: 11, color: kColorSubtitle)),
                ],
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: kColorAccentGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kColorAccentGold),
            ),
            child: Text(
              share.bookingStatus == 'cancelled' ? 'Cancelled' : 'RideWay',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: share.bookingStatus == 'cancelled'
                      ? const Color(0xFFD93838)
                      : kColorAccentGold),
            ),
          ),
        ],
      ),
    );
  }
}


class _SharedRouteRow extends StatelessWidget {
  final TicketShare share;
  final bool isDark;
  const _SharedRouteRow({required this.share, required this.isDark});

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
                Text(share.originCode,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : kColorPrimaryAction,
                        height: 1.1)),
                Text(share.originName,
                    style: const TextStyle(
                        fontSize: 11, color: kColorSubtitle, height: 1.3)),
                const SizedBox(height: 4),
                Text(share.departureTime,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : kColorPrimaryAction)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                          color: kColorAccentGold, shape: BoxShape.circle)),
                  Container(width: 28, height: 1.5, color: kColorAccentGold),
                  const Icon(Icons.train, size: 18, color: kColorAccentGold),
                  Container(width: 28, height: 1.5, color: kColorAccentGold),
                  Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                          color: kColorAccentGold, shape: BoxShape.circle)),
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
                Text(share.destinationCode,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : kColorPrimaryAction,
                        height: 1.1)),
                Text(share.destinationName,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontSize: 11, color: kColorSubtitle, height: 1.3)),
                const SizedBox(height: 4),
                Text(share.arrivalTime,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : kColorPrimaryAction)),
              ],
            ),
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
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(12)),
              ),
            ),
            Container(
              width: 20,
              height: 24,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F131A) : kColorBackground,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(12)),
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


class _StatusBody extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback? retry;

  const _StatusBody({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: kColorSubtitle),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : kColorPrimaryAction,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 14, color: kColorSubtitle, height: 1.5),
              ),
            ],
            if (retry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: retry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorPrimaryAction,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: Text('common.retry'.tr(),
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class _GetRidewayBanner extends StatelessWidget {
  final bool isDark;
  const _GetRidewayBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA)),
      ),
      child: Column(
        children: [
          const Icon(Icons.directions_train_rounded,
              color: kColorAccentGold, size: 32),
          const SizedBox(height: 8),
          Text(
            'ticket.get_rideway_title'.tr(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : kColorPrimaryAction,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ticket.get_rideway_sub'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: kColorSubtitle),
          ),
        ],
      ),
    );
  }
}
