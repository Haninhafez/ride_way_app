import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/features/auth/presentation/widgets/primary_button.dart';
import 'package:ride_way_app/features/search/presentation/cubit/train_search_cubit.dart';
import 'package:ride_way_app/features/search/presentation/cubit/train_search_state.dart';
import 'package:ride_way_app/features/search_and_discovery/data/datasources/search_local_data_source.dart';
import 'package:ride_way_app/features/search_and_discovery/data/datasources/search_remote_data_source.dart';
import 'package:ride_way_app/features/search_and_discovery/data/repositories/search_repository_impl.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/entities/station.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/search_trains_usecase.dart';

class HomeSearchInvalid extends StatelessWidget {
  const HomeSearchInvalid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrainSearchCubit>(
      create: (_) {
        final remote = SearchRemoteDataSourceImpl();
        final local = SearchLocalDataSourceImpl();
        final repo = SearchRepositoryImpl(
          remoteDataSource: remote,
          localDataSource: local,
        );
        final useCase = SearchTrainsUseCase(repo);
        final cubit = TrainSearchCubit(searchTrainsUseCase: useCase);
        cubit.updateOrigin(
          const Station(stationCode: 'DMM', name: 'Dammam', city: 'Dammam'),
        );
        cubit.updateDestination(null);
        return cubit;
      },
      child: const _HomeSearchInvalidView(),
    );
  }
}

class _HomeSearchInvalidView extends StatelessWidget {
  const _HomeSearchInvalidView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFFBEFE3),
                        child: const Icon(
                          Icons.person,
                          color: kColorAccentGold,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Good morning, Nasser",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: kColorPrimaryAction,
                            ),
                          ),
                          Text(
                            "Find your next train",
                            style: TextStyle(
                              fontSize: 12,
                              color: kColorSubtitle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: kColorPrimaryAction,
                          size: 26,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: const Text(
                  "Where are you travelling today?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: kColorPrimaryAction,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF2F2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFF3D6D6),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3D6D6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFC0392B),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose a destination",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFFC0392B),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Pick an arrival station to search.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF922B21),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: _StationField(
                            label: "From",
                            code: "DMM",
                            name: "Dammam DMM",
                            isError: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            context.read<TrainSearchCubit>().swapStations();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: kColorBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kColorBorder),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.swap_horiz,
                                color: kColorAccentGold,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StationField(
                            label: "To",
                            code: null,
                            name: "Select station",
                            isError: true,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(
                          child: _DateField(
                            label: "Date",
                            value: "Fri, 14 Aug",
                            icon: Icons.calendar_today_outlined,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(child: _PassengerField()),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: "Search trains",
                onTap: () {
                  context.read<TrainSearchCubit>().validateAndSearch();
                },
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent searches",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: kColorPrimaryAction,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Clear",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kColorAccentGold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (ctx, i) {
                    final codes = i % 2 == 0 ? ["DMM", "RUH"] : ["JED", "MED"];
                    final names =
                        i % 2 == 0 ? ["Dammam", "Riyadh"] : ["Jeddah", "Medina"];
                    final dates = ["Aug 14", "Aug 12", "Aug 10", "Aug 5"];
                    return _RecentCard(
                      codes: codes,
                      names: names,
                      date: dates[i],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StationField extends StatelessWidget {
  const _StationField({
    required this.label,
    required this.code,
    required this.name,
    required this.isError,
    this.onTap,
  });

  final String label;
  final String? code;
  final String? name;
  final bool isError;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: kColorSubtitle,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isError ? const Color(0xFFC0392B) : kColorBorder,
              ),
              color: isError ? const Color(0xFFFDF2F2) : kColorBackground,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.location_on_outlined : Icons.train_outlined,
                  color:
                      isError ? const Color(0xFFC0392B) : kColorAccentGold,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        code ?? "",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isError
                              ? const Color(0xFFC0392B)
                              : kColorPrimaryAction,
                        ),
                      ),
                      Text(
                        name ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: isError
                              ? const Color(0xFFC0392B)
                              : kColorSubtitle,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: kColorSubtitle,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kColorBorder),
            color: kColorBackground,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: kColorAccentGold,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: kColorPrimaryAction,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PassengerField extends StatelessWidget {
  const _PassengerField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainSearchCubit, TrainSearchState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Passengers",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: kColorSubtitle,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kColorBorder),
                color: kColorBackground,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<TrainSearchCubit>().decrementPassengers();
                    },
                    icon: const Icon(Icons.remove, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        const Color(0x0D181818),
                      ),
                      foregroundColor:
                          const WidgetStatePropertyAll(kColorPrimaryAction),
                      shape: const WidgetStatePropertyAll(CircleBorder()),
                    ),
                  ),
                  Text(
                    state.passengerCount.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: kColorPrimaryAction,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<TrainSearchCubit>().incrementPassengers();
                    },
                    icon: const Icon(Icons.add, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        const Color(0x0D181818),
                      ),
                      foregroundColor:
                          const WidgetStatePropertyAll(kColorPrimaryAction),
                      shape: const WidgetStatePropertyAll(CircleBorder()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RecentCard extends StatelessWidget {
  const _RecentCard({
    required this.codes,
    required this.names,
    required this.date,
  });

  final List<String> codes;
  final List<String> names;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                codes[0],
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: kColorPrimaryAction,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward,
                size: 14,
                color: kColorAccentGold,
              ),
              const SizedBox(width: 6),
              Text(
                codes[1],
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: kColorPrimaryAction,
                ),
              ),
            ],
          ),
          Text(
            "${names[0]} → ${names[1]}",
            style: const TextStyle(
              fontSize: 11,
              color: kColorSubtitle,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFBEFE3),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: kColorAccentGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
