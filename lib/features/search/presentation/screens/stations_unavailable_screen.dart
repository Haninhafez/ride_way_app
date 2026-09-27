import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/features/search/presentation/cubit/train_search_cubit.dart';
import 'package:ride_way_app/features/search_and_discovery/data/datasources/search_local_data_source.dart';
import 'package:ride_way_app/features/search_and_discovery/data/datasources/search_remote_data_source.dart';
import 'package:ride_way_app/features/search_and_discovery/data/repositories/search_repository_impl.dart';
import 'package:ride_way_app/features/search_and_discovery/domain/usecases/search_trains_usecase.dart';

class StationsUnavailableScreen extends StatelessWidget {
  const StationsUnavailableScreen({super.key});

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
        return TrainSearchCubit(searchTrainsUseCase: useCase);
      },
      child: const _StationsUnavailableView(),
    );
  }
}

class _StationsUnavailableView extends StatelessWidget {
  const _StationsUnavailableView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.signal_wifi_off_outlined,
                      size: 56,
                      color: Color(0xFFC0392B),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Stations unavailable",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: kColorPrimaryAction,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "We couldn't load the network timetable. Check your connection and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: kColorSubtitle,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<TrainSearchCubit>().retryLoading();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorPrimaryAction,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text(
                      "Try again",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
