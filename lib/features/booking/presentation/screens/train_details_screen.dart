import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_way_app/core/widgets/button_changing_language.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../widgets/amenities_list.dart';
import '../widgets/route_timeline.dart';
import '../widgets/sticky_bottom_action_bar.dart';
import '../widgets/travel_class_card.dart';
import '../../../../core/themes/theme_data.dart';

class TrainDetailsScreen extends StatefulWidget {
  final String trainId;

  const TrainDetailsScreen({super.key, this.trainId = 'SE-200'});

  @override
  State<TrainDetailsScreen> createState() => _TrainDetailsScreenState();
}

class _TrainDetailsScreenState extends State<TrainDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<BookingCubit>();
    if (cubit.state.trainDetail == null) {
      cubit.loadTrainDetails(widget.trainId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final train = state.trainDetail;

        if (state.status == BookingStatus.loading && train == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('booking.train_details'.tr()),
              elevation: 0,
            ),
            body: const Center(
              child: CircularProgressIndicator(color: kColorPrimaryAction),
            ),
          );
        }

        if (train == null) {
          return Scaffold(
            appBar: AppBar(title: Text('booking.train_details'.tr())),
            body: const Center(child: Text('Unable to load train details.')),
          );
        }

        final selectedClass = state.selectedClass ?? train.classOptions.first;
        final totalCalc = selectedClass.price * state.passengerCount;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDark
                ? const Color(0xFF0F131A)
                : kColorBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () =>
                  context.canPop() ? context.pop() : context.go('/home'),
            ),
            title: Text(
              'booking.train_details'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : kColorPrimaryAction,
              ),
            ),
            actions: [ButtonChangingLanguage()],
          ),
          body: Column(
            children: [
              // Scrollable Content area
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header / Status Card
                      _buildHeaderCard(context, train, isDark),
                      const SizedBox(height: 20),

                      // Amenities List
                      AmenitiesList(amenities: train.amenities),
                      const SizedBox(height: 24),

                      // Route & Stops Section
                      RouteTimeline(stops: train.stops),
                      const SizedBox(height: 24),

                      // Class Selection Section ("Choose a class")
                      Text(
                        'booking.choose_class'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : kColorPrimaryAction,
                        ),
                      ),
                      const SizedBox(height: 14),

                      ...train.classOptions.map(
                        (cOption) => TravelClassCard(
                          travelClass: cOption,
                          isSelected: selectedClass.id == cOption.id,
                          onTap: () {
                            context.read<BookingCubit>().selectTravelClass(
                              cOption,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sticky Bottom Action Bar
              StickyBottomActionBar(
                title: 'SAR ${totalCalc.toStringAsFixed(0)}',
                subtitle:
                    '${selectedClass.title} · ${state.passengerCount} ${'booking.passengers'.tr()} (SAR ${selectedClass.price.toStringAsFixed(0)} × ${state.passengerCount})',
                primaryButtonText: 'booking.select_seats'.tr(),
                onPressed: () {
                  context.push('/seat-selection');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(BuildContext context, train, bool isDark) {
    return Container(
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
      ),
      child: Column(
        children: [
          // Top Row: Train code & Status pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: kColorPrimaryAction,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      train.code,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    train.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                ],
              ),
              // Status Pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: kColorSuccess.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 3,
                      backgroundColor: kColorSuccess,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'booking.on_time'.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kColorSuccess,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // Departure / Station / Arrival Layout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    train.departureTime,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    train.departureStationCode,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kColorSubtitle,
                    ),
                  ),
                ],
              ),

              // Train path line with duration
              Column(
                children: [
                  Text(
                    train.duration,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kColorSubtitle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 4,
                        backgroundColor: kColorAccentGold,
                      ),
                      Container(width: 60, height: 2, color: kColorAccentGold),
                      const Icon(
                        Icons.directions_train,
                        size: 18,
                        color: kColorAccentGold,
                      ),
                      Container(width: 60, height: 2, color: kColorAccentGold),
                      const CircleAvatar(
                        radius: 4,
                        backgroundColor: kColorAccentGold,
                      ),
                    ],
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    train.arrivalTime,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kColorPrimaryAction,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    train.arrivalStationCode,
                    style: const TextStyle(
                      fontSize: 14,
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
}
