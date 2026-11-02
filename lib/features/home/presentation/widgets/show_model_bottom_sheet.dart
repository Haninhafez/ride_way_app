import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/entities/station.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/search_cubit.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/cubit/search_state.dart';
Future<Station?> showModelBottomSheet(
  BuildContext context, {
  required bool isFrom,
}) async {
  return showModalBottomSheet<Station>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (bottomSheetContext) {
      return BlocProvider.value(
        value: context.read<SearchCubit>(),
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state.status == SearchStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.status == SearchStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Something went wrong',
                ),
              );
            }

            if (state.status == SearchStatus.loaded) {
              final stations = isFrom
                  ? state.availableStations
                  : context.read<SearchCubit>().getAvailableStations();

              if (stations.isEmpty) {
                return const Center(
                  child: Text('No stations found'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: stations.length,
                itemBuilder: (context, index) {
                  final station = stations[index];

                  final isSelected = isFrom
                      ? station.code == state.fromStation?.code
                      : station.code == state.toStation?.code;

                  return ListTile(
                    title: Text(station.name),
                    subtitle: Text(station.city),
                    trailing: isSelected
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      final cubit = context.read<SearchCubit>();

                      if (isFrom) {
                        cubit.selectFromStation(station);
                      } else {
                        cubit.updateDestination(station);
                      }

                      Navigator.pop(context, station);
                    },
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      );
    },
  );
}